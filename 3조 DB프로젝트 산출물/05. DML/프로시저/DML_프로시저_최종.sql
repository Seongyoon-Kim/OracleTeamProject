-----------------------------------[관리자]--------------------------------------------

-- 1. 관리자 ID와 PW로 로그인 하는 프로시저
create or replace procedure procLoginManager
(
    pid in number,    --아이디
    ppw in number,     --비밀번호
    presult out number  --성공(1), 실패(0)
)
is
    vid number;
    vpw number;
    
begin

    select managerseq into vid from tblmanager where (managerseq = pid and managerpw = ppw);
    select managerpw into vpw from tblmanager where (managerseq = pid and managerpw = ppw);
    
    if vid > 0 then 
        presult := 1;
        dbms_output.put_line('로그인 성공');
      
    end if;
    
    exception when others then dbms_output.put_line('로그인 실패');
end procLoginManager;

-- 확인
declare
    presult number;
begin
    procLogin(관리자번호, 관리자ssn, presult);
end;




-- 2. 과정이 끝난 교육생을 교육종료교육생 테이블에 추가하는 프로시저
create or replace procedure proCompleteStudent
is
    cursor vcursor is select 
    e.enrollmentseq,
    s.condition,
    s.dropdate
from tblEnrollment e
    inner join tblStudent s
        on e.studentseq = s.studentseq
            inner join tblEnrollment e
                on s.studentseq = e.studentseq
                    inner join tblOpenCourse oc
                        on oc.opencourseseq = e.opencourseseq
                            where oc.endDate = to_char(sysdate, 'yy-mm-dd');
    vseq tblEnrollment.enrollmentseq%type;
    vcondition tblStudent.condition%type;
    vdropdate tblStudent.dropdate%type;
begin
    
    open vcursor;
        loop
            fetch vcursor into vseq,vcondition,vdropdate;
            exit when vcursor%notfound;
                
                if vcondition = '수료중' then
                    INSERT INTO tblCompleteStudent VALUES(completeStudentSeq.nextval, to_char(sysdate, 'yyyy-mm-dd'), '수료완료', vseq);
                elsif vcondition = '중도탈락' then
                    INSERT INTO tblCompleteStudent VALUES(completeStudentSeq.nextval, vdropdate, '중도탈락', vseq);
                end if;
        end loop;
    close vcursor;
    
end proCompleteStudent;

--확인
begin
    proCompleteStudent;
end;

delete from tblCompleteStudent where enrollmentSeq between 61 and 90;




-- 3. 수강중인 교육생의 당일 출결 업데이트하는 프로시저
create or replace procedure proMAttendance
is
    cursor vcursor is select studentseq from tblStudent where condition = '수료중';
    vseq tblStudent.studentSeq%type;
begin
    open vcursor;
        loop
            fetch vcursor into vseq;
            exit when vcursor%notfound;
                
                insert into tblAttendance(attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq)
                    values (attendanceSeq.nextVal, to_char(sysdate, 'yy-mm-dd'), null , null, '기타', vseq);
                
        end loop;
    close vcursor;
    
end;

--확인
begin
proMAttendance;
end;




-- 4. 월별로 교육생의 출결 조회하는 프로시저
create or replace procedure procAttendout(
    pid in varchar2
)
is
begin
    if to_char(sysdate, 'hh24:mi') > '17:50'  then -- 정상퇴실

        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi')
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
        
    elsif to_char(sysdate, 'hh24:mi') < '17:50' then -- 조퇴
    
        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi'),
            condition = '조퇴'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
            
    end if;
end procAttendout;

-- (확인)
commit;
begin
procAttendout(1);
end;




-- 5. 전체과정 추가하는 프로시저
create or replace procedure procTotalCourseI (
    pname tblTotalCourse.name%type,
    pperiod tblTotalCourse.period%type
)
is
begin

    insert into tblTotalCourse (totalCourseSeq, name, period)
        values (totalCourseSeq.nextVal, pname, pperiod);

end;

begin
    procTotalCourseI('아무거너', 5.5);
end;

select * from tblTotalCourse;
    



-- 6. 전체과정 수정하는 프로시저
create or replace procedure procTotalCourseU (
    ptotalCourseSeq tblTotalCourse.totalCourseSeq%type,
    pname tblTotalCourse.name%type,
    pperiod tblTotalCourse.period%type
)
is
begin

    update tblTotalCourse set
        
        name = pname,
        period = pperiod
        where totalCourseSeq = ptotalCourseSeq;

end;

begin
    procTotalCourse(1, '아무거나', 6);
end;
/

select * from tblTotalCourse;




-- 7. 전체과정 삭제하는 프로시저
create or replace procedure procTotalCourseD (

    ptotalCourseSeq tblTotalCourse.totalCourseSeq%type

)
is
begin
    
    delete from tblTotalCourse
        where totalCourseSeq = ptotalCourseSeq;
    
end;

begin
    procTotalCourseD(20);
end;


create or replace procedure procLectcureScheduleU
is
    cursor vcursor is 
        select 
            os.endDate,
            ls.condition
        from tblOpenSubject os
            inner join tblTotalSubject ts
                on ts.totalSubjectSeq = os.totalSubjectSeq
                    inner join tblLectureSchedule ls
                        on os.openSubjectSeq = ls.openSubjectSeq
                            where os.enddate = '2021-08-13';
                            --where os.enddate = to_char(sysdate, 'yy-mm-dd');
    vcondition tblLectureSchedule.condition%type;
    venddate tblOpenSubject.enddate%type;
begin
    open vcursor;
        loop
            fetch vcursor into venddate,vcondition;
            exit when vcursor%notfound;
                
              update tblLectureSchedule set
                condition = '강의종료' ;
        end loop;
    close vcursor;
    
end;

begin
    procLectcureScheduleU;
end;



create or replace procedure proCompleteStudent
is
    cursor vcursor is select 
    e.enrollmentseq,
    s.condition,
    s.dropdate
from tblEnrollment e
    inner join tblStudent s
        on e.studentseq = s.studentseq
            inner join tblEnrollment e
                on s.studentseq = e.studentseq
                    inner join tblOpenCourse oc
                        on oc.opencourseseq = e.opencourseseq
                            where oc.endDate = to_char(sysdate, 'yy-mm-dd');
    vseq tblEnrollment.enrollmentseq%type;
    vcondition tblStudent.condition%type;
    vdropdate tblStudent.dropdate%type;
begin
    
    open vcursor;
        loop
            fetch vcursor into vseq,vcondition,vdropdate;
            exit when vcursor%notfound;
                
                if vcondition = '수료중' then
                    INSERT INTO tblCompleteStudent VALUES(completeStudentSeq.nextval, to_char(sysdate, 'yyyy-mm-dd'), '수료완료', vseq);
                elsif vcondition = '중도탈락' then
                    INSERT INTO tblCompleteStudent VALUES(completeStudentSeq.nextval, vdropdate, '중도탈락', vseq);
                end if;
        end loop;
    close vcursor;
    
end proCompleteStudent;

begin
    proCompleteStudent;
end;



-- 8. 수정하는 프로시저

-- 8.1. 교사 수정 프로시저
create or replace procedure procTeacherModify (
    pseq number,   --교사번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblteacher set name = pinput where teacherseq= pseq;
    elsif pnum = 2 then update tblteacher set ssn = pinput where teacherseq= pseq;
    elsif pnum = 3 then update tblteacher set phoneNumber = pinput where teacherseq= pseq;
    elsif pnum = 4 then update tblteacher set condition = pinput where teacherseq= pseq;
    end if;
end procTeacherModify;
-- 확인
begin
procTeacherModify(1, 1, '채제원');
end;


-- 8.2. 교육생 수정 프로시저
create or replace procedure procStudentModify (
    pseq number,   --교육생번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblStudent set name = pinput where studentseq= pseq;
    elsif pnum = 2 then update tblStudent set phoneNumber = pinput where studentseq= pseq;
    elsif pnum = 3 then update tblStudent set ssn = pinput where studentseq= pseq;
    elsif pnum = 4 then update tblStudent set enrollDate = pinput where studentseq= pseq;
    elsif pnum = 5 then update tblStudent set birth = pinput where studentseq= pseq;
    elsif pnum = 6 then update tblStudent set condition = pinput where studentseq= pseq;
    elsif pnum = 7 then update tblStudent set dropDate = pinput where studentseq= pseq;
    end if;
end procStudentModify;

-- 확인
begin
procStudentrModify(1, 1, '신보경');
end;



-- 8.3. 취업현황 수정 프로시저
create or replace procedure procEmploymentrModify (
    pseq number,   --취업현황번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblEmployment set companyName = pinput where employmentSeq= pseq;
    elsif pnum = 2 then update tblEmployment set annualIncome = pinput where employmentSeq= pseq;
    elsif pnum = 3 then update tblEmployment set area = pinput where employmentSeq= pseq;
    elsif pnum = 4 then update tblEmployment set completeStudentSeq = pinput where employmentSeq= pseq;
    end if;
end procEmploymentrModify;

-- 확인
begin
procEmploymentrModify(1, 1, '신보경');
end;



-- 8.4. 성적 수정 프로시저
create or replace procedure procScoreModify (
    pseq number,   --성적번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblScore set hasdwritingScore = pinput where scoreSeq= pseq;
    elsif pnum = 2 then update tblScore set practiceScore = pinput where scoreSeq= pseq;
    elsif pnum = 3 then update tblScore set attendanceScore = pinput where scoreSeq= pseq;
    elsif pnum = 4 then update tblScore set testSeq = pinput where scoreSeq= pseq;
    elsif pnum = 5 then update tblScore set enrollmentSeq = pinput where scoreSeq= pseq;
    end if;
end procScoreModify;

-- 확인
begin
procScoreModify(1, 1, 20);
end;



-- 8.5. 강의실 수정 프로시저
create or replace procedure procClassroomModify (
    pseq number,   --강의실번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblClassroom set name = pinput where classroomSeq= pseq;
    elsif pnum = 2 then update tblClassroom set condition = pinput where classroomSeq= pseq;
    elsif pnum = 3 then update tblClassroom set limitCount = pinput where classroomSeq= pseq;
    end if;
end procClassroomModify;

--(확인)
begin
procClassroomModify(1, 1, '강의실이름');
end;



-- 8.6. 개설과정 수정 프로시저
create or replace procedure procOpenSubModify (
    pseq number,   --개설과정번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblOpenSubject set beginDate = pinput where openSubjectSeq= pseq;
    elsif pnum = 2 then update tblOpenSubject set endDate = pinput where openSubjectSeq= pseq;
    elsif pnum = 3 then update tblOpenSubject set openCourseSeq = pinput where openSubjectSeq= pseq;
    elsif pnum = 4 then update tblOpenSubject set totalSubjectSeq = pinput where openSubjectSeq= pseq;
    elsif pnum = 5 then update tblOpenSubject set period = pinput where openSubjectSeq= pseq;
    end if;
end procOpenSubModify;

--(확인)
begin
procOpenSubModify(1, 1, '2020-01-01');
end;



-- 8.7. 전체과목 수정 프로시저
create or replace procedure procTotalSubModify (
    pseq number,   --전체과목번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblTotalSubject set name = pinput where totalSubjectSeq= pseq;
    end if;
end procTotalSubModify;

--(확인)
begin
procTotalSubModify(1, 1, '자바의 모든것');
end;



-- 8.8. 자격증 정보 수정 프로시저
create or replace procedure proctblLicenseU (
    pseq number,   --자격증고유번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblLicense set name = pinput where licenseSeq= pseq;
    elsif pnum = 2 then update tblLicense set licenseType = pinput where licenseSeq= pseq;
    elsif pnum = 3 then update tblLicense set testAgency = pinput where licenseSeq= pseq;
    elsif pnum = 4 then update tblLicense set round = pinput where licenseSeq= pseq;
    elsif pnum = 5 then update tblLicense set receptionFee = pinput where licenseSeq= pseq;
    elsif pnum = 6 then update tblLicense set writtenRegisterBegin = pinput where licenseSeq= pseq;
    elsif pnum = 7 then update tblLicense set writtenRegisterEnd = pinput where licenseSeq= pseq;
    elsif pnum = 8 then update tblLicense set writtenTestDate = pinput where licenseSeq= pseq;
    elsif pnum = 9 then update tblLicense set writtenResultDate = pinput where licenseSeq= pseq;
    elsif pnum = 10 then update tblLicense set practicalRegisterBegin = pinput where licenseSeq= pseq;
    elsif pnum = 11 then update tblLicense set practicalRegisterEnd = pinput where licenseSeq= pseq;
    elsif pnum = 12 then update tblLicense set practicalTestDate = pinput where licenseSeq= pseq;
    elsif pnum = 13 then update tblLicense set practicalResultDate = pinput where licenseSeq= pseq;
    end if;
end proctblLicenseU;

--(확인)
begin
proctblLicenseU(1, 1, '정보관리');
end;



-- 8.9. 전체교재 수정 프로시저
create or replace procedure procAllBookModify (
    pseq number,   --전체교재고유번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblAllBook set name = pinput where allBookSeq= pseq;
    elsif pnum = 2 then update tblAllBook set  publisher= pinput where allBookSeq= pseq;
    elsif pnum = 3 then update tblAllBook set writer = pinput where allBookSeq= pseq;
    elsif pnum = 4 then update tblAllBook set price = pinput where allBookSeq= pseq;

    end if;
end procAllBookModify;

--(확인)
begin
procAllBookModify(1, 1, '안녕하세요');
end;



-- 8.10. 구인공고 수정 프로시저
create or replace procedure proctblJobPostU (
    pseq number,   --구인공고고유번호
    pnum number,   --수정할 컬럼번호
    pinput varchar2 --입력받은 값
)
is
begin
    if pnum = 1 then update tblJobPost set recruitField = pinput where jobPostSeq= pseq;
    elsif pnum = 2 then update tblJobPost set companyName = pinput where jobPostSeq= pseq;
    elsif pnum = 3 then update tblJobPost set recruitBegin = pinput where jobPostSeq= pseq;
    elsif pnum = 4 then update tblJobPost set recruitEnd = pinput where jobPostSeq= pseq;
    elsif pnum = 5 then update tblJobPost set career = pinput where jobPostSeq= pseq;
    elsif pnum = 6 then update tblJobPost set educationLevel = pinput where jobPostSeq= pseq;
    elsif pnum = 7 then update tblJobPost set annualIncom = pinput where jobPostSeq= pseq;
    elsif pnum = 8 then update tblJobPost set workArea = pinput where jobPostSeq= pseq;
    elsif pnum = 9 then update tblJobPost set workTime = pinput where jobPostSeq= pseq;
    elsif pnum = 10 then update tblJobPost set selectionCount = pinput where jobPostSeq= pseq;
    end if;
end proctblJobPostU;

--(확인)
begin
proctblJobPostU(1, 2, '로레알');
end;





-- 9. 특정 교육생의 성적을 수정하는 프로시저
create or replace procedure procScoreU(
    sseq number,               -- 성적 수정할 교육생 번호
    subseq number,      -- 수정할 과목번호
    writingScore number,
    practice number,
    attendance number
)
is
    enrollSeq number; -- 수강신청번호
    tSeq number;
begin
    
    select
    e.enrollmentSeq, t.testseq into enrollSeq, tSeq
    from tblStudent s
    inner join tblEnrollment e
        on e.studentseq = s.studentseq
    inner join tblScore sc
        on sc.enrollmentseq = e.enrollmentseq
    inner join tblTest t
        on t.testSeq = sc.testSeq
    inner join tblOpenSubject os
        on os.opensubjectseq = t.opensubjectseq
    inner join tblTotalSubject  ts
        on ts.totalSubjectSeq = os.totalSubjectSeq
        where s.studentseq = sseq and os.opensubjectseq = subseq;
    
   update tblScore 
    set hasdwritingScore = writingScore,
        practiceScore = practice,
        attendanceScore = attendance
        where enrollmentSeq = enrollSeq and testSeq = tSeq;
    
end procScoreU;

--확인
begin 
--교육생번호, 개설과목번호, 필기,실기,출석점수
procScoreU(62,13, 25,10,15);
end;



10. 강의실에서 현재 진행되고있는 상태를 가져오는 프로시저

create or replace procedure procClassroomSub(
    pnum tblclassroom.classroomSeq%type
)
is
    cursor vcursor is 
    select 
    c.name,
    tc.name ,
    oc.beginDate ,
    oc.endDate,
    oc.registerCount,
    ts.name,
    t.name 
    from tblClassroom c
        inner join tblOpenCourse oc
            on c.classroomSeq = oc.classroomSeq
                inner join tblTotalCourse tc
                    on tc.totalCourseSeq = oc.totalCourseSeq 
                        inner join tblOpenSubject os
                            on os.openCourseSeq = oc.openCourseSeq
                                inner join tblTotalSubject ts
                                    on ts.totalSubjectSeq = os.totalSubjectSeq
                                        inner join tblTeacher t
                                            on t.teacherSeq = oc.teacherSeq
                                                 where c.classroomseq = pnum
                                                 and 
                                                 sysdate between oc.begindate and oc.enddate 
                                                 and 
                                                 sysdate between os.begindate and os.enddate;
   
   vclassname tblClassroom.name%type;
   vcoursename tblTotalCourse.name%type;
   vcoursebegin tblOpenCourse.beginDate%type;
   vcourseend tblOpenCourse.endDate%type;
   vregisterC tblOpenCourse.registerCount%type;
   vsubjectname tblTotalSubject.name%type;
   vteachername tblTeacher.name%type;
    
begin
        
        open vcursor;
            
            loop
            
                fetch vcursor into vclassname, vcoursename, vcoursebegin, vcourseend, vregisterC, vsubjectname,vteachername;
                exit when vcursor%notfound;
                
                dbms_output.put_line('강의실이름: ' || vclassname );
                dbms_output.put_line('과정이름: '|| vcoursename);
                dbms_output.put_line('과목명: ' ||vsubjectname );
                dbms_output.put_line('교사명:'||vteachername);
                dbms_output.put_line('과정등록교육생수: ' || vregisterC ||'명');

                
            end loop;
            
        close vcursor;
        
end procClassroomSub;
/

--완료
begin
    procClassroomSub(3);
end;




11. 해당교재의 정보를 가져오는 프로시저 

create or replace procedure procBookinform(
        pname tblAllbook.name%type
)
is 
    cursor vcursor is 
    select
    ab.name,
    ab.price,
    ab.publisher,
    ab.writer,
    ts.name,
    tc.name
    from tblAllBook ab
        inner join tblUsedBook ub
            on ab.allBookSeq = ub.allBookSeq
                inner join tblTotalSubject ts
                    on ts.totalSubjectSeq = ub.totalSubjectSeq
                        inner join tblOpenSubject os
                            on os.totalSubjectSeq = ts.totalSubjectSeq
                                inner join tblOpenCourse oc
                                    on oc.openCourseSeq = os.openCourseSeq
                                        inner join tblTotalCourse tc
                                            on tc.totalCourseSeq = oc.totalCourseSeq
                                                where ab.name = pname;
    
    vbookname tblAllBook.name%type;
    vbookprice tblAllBook.price%type;
    vbookpublisher tblAllBook.publisher%type;
    vbookwriter tblAllBook.writer%type;
    vsubname tblTotalSubject.name%type;
    vcoursename tblTotalCourse.name%type;



begin 
open vcursor;
            
            loop
            
                fetch vcursor into vbookname, vbookprice, vbookpublisher, vbookwriter, vsubname, vcoursename;
                exit when vcursor%notfound;
                
                dbms_output.put_line('교재 이름: ' || vbookname ||'    교재 가격: '|| vbookprice || '         교재 출판사: ' || vbookpublisher||'         교재저자: ' ||vbookwriter||'       해당교재과목명:'||vsubname||'       해당교재과정명:'||vcoursename);
            
            end loop;
            
        close vcursor;
        
end procBookinform;


-- 확인
begin
    procBookinform('Do it! 자바 프로그래밍 입문');
end;

----------------------------------------[교육생]----------------------------------------------

-- 1. 교육생 ID와 PW로 로그인하는 프로시저
create or replace procedure procLoginStudent
(
    pid in number,    --아이디
    ppw in number,     --비밀번호
    presult out number  --성공(1), 실패(0)
)
is
    vid number;
    vpw number;
    
begin

    select studentseq into vid from tblstudent where (studentseq = pid and ssn = ppw);
    select ssn into vpw from tblstudent where (studentseq = pid and ssn = ppw);
    
    if vid > 0 then 
        presult := 1;
        dbms_output.put_line('로그인 성공');
        
--    elsif  then
--        presult := 0;
--        dbms_output.put_line('로그인 실패');
    end if;
    
    exception when others then dbms_output.put_line('로그인 실패');
end procLoginStudent;

--확인
declare
    presult number;
begin
    procLogin(교육생id, 교육생pw, presult);
end;

--id : studentseq 1, pw : ssn 2716495




-- 2. 입실을 입력하는 프로시저
create or replace procedure procAttendin(
    pid in varchar2
)
is
begin
    if to_char(sysdate, 'hh24:mi') > '09:10' then
        update  tblAttendance set 
        inTime = to_char(sysdate, 'hh24:mi'),
        condition = '지각'
        where studentSeq =  pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
    else
        update  tblAttendance set 
        inTime = to_char(sysdate, 'hh24:mi'),
        condition = '정상'
        where studentSeq =  pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
    end if;
end procAttendin;


/
--begin
--    procAttendin(1);
--end;
--/
--SELECT * FROM TBLATTENDANCE WHERE STUDENTSEQ = 1 AND ATTENDANCEDATE = TO_CHAR(SYSDATE, 'YY-mm-dd');



-- 3. 퇴실을 입력하는 프로시저
create or replace procedure procAttendout(
    pid in varchar2
)
is
begin
    if to_char(sysdate, 'hh24:mi') > '17:50'  then -- 정상퇴실

        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi')
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
        
    elsif to_char(sysdate, 'hh24:mi') < '17:50' then -- 조퇴
    
        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi'),
            condition = '조퇴'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
            
    end if;
end procAttendout;
-- 확인
commit;
--begin
--procAttendout(1);
--end;

rollback;

--SELECT * FROM TBLATTENDANCE WHERE STUDENTSEQ = 1 AND ATTENDANCEDATE = TO_CHAR(SYSDATE, 'YY-mm-dd');



-- 4. 결석을 입력하는 프로시저
create or replace procedure procAttendout(
    pid in varchar2
)
is
begin
    if to_char(sysdate, 'hh24:mi') > '17:50'  then -- 정상퇴실

        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi')
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
        
    elsif to_char(sysdate, 'hh24:mi') < '17:50' then -- 조퇴
    
        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi'),
            condition = '조퇴'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
            
    end if;
end procAttendout;
--(확인)
commit;
begin
procAttendout(1);
end;


-- 5. 외출을 입력하는 프로시저
create or replace procedure procAttendgoout(
    pid in varchar2
)
is
begin
    insert into tblAttendance(attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq)
        values (attendanceSeq.nextVal, to_char(sysdate, 'yy-mm-dd'), null , null, '외출', pid);
end procAttendgoout;

--(확인)
begin
    procAttendgoout(61);
end;


-- 6.  특정 교육생의 수강 과정을 조회하는 프로시저
create or replace procedure procStudent (
    pnum tblstudent.studentseq%type
)
is
    vstudetnName tblStudent.name%type;
    vcourseName tblTotalCourse.name%type;
    vBeginDate tblOpenCourse.begindate%type;
    vEndDate tblOpenCourse.endDate%type;
begin

        select st.name as 교육생정보,
               tc.name as 수강과정,
               oc.begindate as 수강과정시작기간,
               oc.enddate as 수강과정종료기간
        into vstudetnName, vcourseName, vBeginDate, vEndDate from tblopencourse oc
            inner join tblenrollment en
                on oc.opencourseseq = en.opencourseseq
            inner join tblstudent st
                on en.studentseq = st.studentseq
            inner join tbltotalcourse tc
                on oc.totalcourseseq = tc.totalcourseseq
            where st.studentSeq = pnum;

        
        dbms_output.put_line('선택한 교육생: ' || vstudetnName || ' || ' || vcourseName || ' || ' || vbegindate || ' || ' || venddate);

end;

-- 확인
begin
    procStudent(61);
end;




7.  특정 과정의 과목 목록을 조회하는 프로시저
create or replace procedure pcSubjectCheck (
    pnum tblstudent.studentseq%type
)
is
    cursor vcursor is select st.name as 수강생이름,
                               tc.name as 과정명,
                               ts.name as 과목명,
                               te.name as 교사명,
                               os.opensubjectseq as 과목고유번호
                        from tblopencourse oc
                        inner join tbltotalcourse tc
                        on oc.totalcourseseq = tc.totalcourseseq
                        inner join tblopensubject os
                        on oc.opencourseseq = os.opencourseseq
                        inner join tbltotalsubject ts
                        on os.totalsubjectseq = ts.totalsubjectseq
                        inner join tblteacher te
                        on oc.teacherseq = te.teacherseq
                        inner join tblenrollment en
                        on oc.opencourseseq = en.opencourseseq
                        inner join tblstudent st
                        on en.studentseq = st.studentseq
                        where st.studentseq = pnum;
    vname1 tblstudent.name%type;
    vname2 tbltotalcourse.name%type;
    vname3 tbltotalsubject.name%type;
    vname4 tblteacher.name%type;
    vnum tblopensubject.opensubjectseq%type;
    
begin
        
        open vcursor;
            
            loop
            
                fetch vcursor into vname1, vname2, vname3, vname4, vnum;
                exit when vcursor%notfound;
                
                dbms_output.put_line('과목 목록: ' || vname1 || ' || ' || vname2 || ' || ' || vname3 || ' || ' || vname4 || ' || ' || vnum);
            
            end loop;
            
        close vcursor;
        
end pcSubjectCheck;
/

-- 확인
begin
    pcSubjectCheck(90);
end;
/



8. 과목별 배점 정보를 출력하는 프로시저
create or replace procedure procDistribution (
    pnum tblstudent.studentseq%type
)
is
    cursor vcursor is select * from vwDistribution where 수강번호 = pnum;
                            
    vrow vwDistribution%rowtype;

begin

    open vcursor;
        
        loop
        
            fetch vcursor into vrow;
            exit when vcursor%notfound;
            
            dbms_output.put_line('배점 정보: ' || vrow.수강생이름 || ' || ' || vrow.과목이름 || ' || ' || vrow.필기배점 || ' || ' || vrow.실기배점 || ' || ' || vrow.출결배점);
            
        end loop;
    
    close vcursor;

end procDistribution;
/

--확인
begin
    procDistribution(5);
end;



9. 과목별 성적 정보를 출력하는 프로시저
create or replace procedure procScore (
    pnum tblStudent.studentSeq%type
)
is
    cursor vcursor is select
                            s.name as 교육생이름,
                            ts.name as 과목명,
                            sc.hasdwritingscore as 필기점수,
                            sc.practicescore as 실기점수,
                            sc.attendanceScore as 출결점수,
                            t.testDate as 시험날짜
                        from tblStudent s
                            inner join tblEnrollment e
                                on e.studentseq = s.studentseq
                            inner join tblScore sc
                                on sc.enrollmentseq = e.enrollmentseq
                            inner join tblTest t
                                on t.testSeq = sc.testSeq
                            inner join tblOpenSubject os
                                on os.opensubjectseq = t.opensubjectseq
                            inner join tblTotalSubject  ts
                                on ts.totalSubjectSeq = os.totalSubjectSeq
                            where s.studentSeq = pnum;
    vrow vwScore%rowtype;
begin

    open vcursor;
    
        loop
        
            fetch vcursor into vrow;
            exit when vcursor%notfound;
            
            dbms_output.put_line('성적 정보: ' || vrow.교육생이름 || ' || ' || vrow.과목명 || ' || ' || vrow.필기점수 || ' || ' || vrow.실기점수 || ' || ' || vrow.출결점수 || ' || ' || vrow.시험날짜);
        
        end loop;
    
    close vcursor;

end procScore;




10. 출결 전체기간 조회 프로시저
create or replace procedure procAttendanceCheck (
    pnum tblStudent.studentSeq%type
)
is

    cursor vcursor is select
                            s.name as 교육생이름,
                            a.attendancedate as 날짜,
                            a.condition as 출결상태
                        from tblEnrollment e
                            inner join tblStudent s
                                on s.studentseq = e.studentseq
                                    inner join tblOpenCourse oc
                                        on oc.openCourseSeq = e.openCourseSeq
                                            inner join tblTotalCourse tc
                                                on tc.totalcourseseq = oc.totalcourseseq
                                                    inner join tblTeacher t
                                                        on oc.teacherseq = t.teacherseq
                                                            inner join tblClassroom cr
                                                                on cr.classroomSeq = oc.classroomSeq
                                                                    inner join tblAttendance a
                                                                        on a.studentseq = s.studentseq
                                                                            where s.studentseq = pnum;
    vrow vwAttendanceCheck%rowtype;

begin

    dbms_output.put_line('교육생이름   날짜    출결상태');

    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.교육생이름 || ' || ' || vrow.날짜 || ' || ' || vrow.출결상태);
    
    end loop;

end procAttendanceCheck;
/

-- 확인
begin
 procAttendanceCheck(70);
end;
/



----------------------------------------[교사]----------------------------------------------

-- 1. 교사ID와 PW로 로그인하는 프로시저
create or replace procedure procLoginManager
(
    pid in number,    --아이디
    ppw in number,     --비밀번호
    presult out number  --성공(1), 실패(0)
)
is
    vid number;
    vpw number;
    
begin

    select teacherseq into vid from tblteacher where (teacherseq = pid and ssn = ppw);
    select ssn into vpw from tblteacher where (teacherseq = pid and ssn = ppw);
    
    if vid > 0 then 
        presult := 1;
        dbms_output.put_line('로그인 성공');
      
    end if;
    
    exception when others then dbms_output.put_line('로그인 실패');
end procLoginManager;

-- 확인
declare
    presult number;
begin
    procLogin(교사번호, 교사ssn, presult);
end;







-- 2. 월별로 교육생의 출결 조회하는 프로시저
create or replace procedure procAttendout(
    pid in varchar2
)
is
begin
    if to_char(sysdate, 'hh24:mi') > '17:50'  then -- 정상퇴실

        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi')
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
        
    elsif to_char(sysdate, 'hh24:mi') < '17:50' then -- 조퇴
    
        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi'),
            condition = '조퇴'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
            
    end if;
end procAttendout;

-- (확인)
commit;
--begin
--procAttendout(1);
--end;




3.  특정 학생의 상담일지를 보여주는 프로시저
create or replace procedure pcCounselingDiarycheck(
    pnum tblstudent.studentseq%type
)
is
    cursor vcursor is select s.studentseq as "고유 교육생 번호",
                                         s.name as "교육생이름",
                                         t.name as "선생님이름",
                                         tc.name as "과정명",
                                         cd.counselingdate as "상담날짜",
                                         cd.content as "상담내용"
                       from tblopencourse oc
                        inner join tbltotalcourse tc
                        on oc.totalcourseseq = tc.totalcourseseq
                         inner join tblteacher t
                        on oc.teacherseq = t.teacherseq
                         inner join tblenrollment en
                        on oc.opencourseseq = en.opencourseseq
                         inner join tblCounselingDiary cd
                         on en.enrollmentSeq = cd.enrollmentseq
                          inner join tblstudent s
                         on en.studentSeq = s.studentSeq
                         where s.studentseq = pnum;
                         
    vname1 tblstudent.studentseq%type;
    vname2 tblstudent.name%type;
    vname3 tblteacher.name%type;
    vname4 tbltotalcourse.name%type;
    vname5 tblCounselingDiary.counselingdate%type;
    vname6 tblCounselingDiary.content%type;
    
begin
        
        open vcursor;
            
            loop
            
                fetch vcursor into vname1, vname2, vname3, vname4, vname5, vname6;
                exit when vcursor%notfound;
                
                dbms_output.put_line('교육생고유번호: ' || vname1 || ' || ' || vname2 || ' || ' || vname3 || ' || ' || vname4 || ' || ' || vname5|| ' || ' ||vname6);
            
            end loop;
            
        close vcursor;
        
end pcCounselingDiarycheck;
/

--확인
begin
    pcCounselingDiarycheck(40);
end;



4. 만족도 조사(교사평가) 조회화는 프로시저
create or replace procedure pccoursesurvey(
    pnum tblteacher.teacherseq%type
)
is
    cursor vcursor is select te.teacherseq as "고유 선생님 번호",
                                         st.name as "교육생이름",
                                         te.name as "선생님이름",
                                         cs.surveycomment as "평가내용",
                                         cs.score as "평가점수"
                                                        
                       from tblenrollment en
                       inner join tblstudent st
                       on en.studentseq = st.studentseq
                       inner join tblcoursesurvey cs
                       on en.enrollmentseq = cs.enrollmentseq
                       inner join tblopencourse oc
                       on en.opencourseseq = oc.opencourseseq
                       inner join tblteacher te
                       on oc.teacherseq = te.teacherseq
                       where te.teacherseq = pnum;
                         
    vname1 tblteacher.teacherseq%type;
    vname2 tblstudent.name%type;
    vname3 tblteacher.name%type;
    vname4 tblcoursesurvey.surveycomment%type;
    vname5 tblcoursesurvey.score%type;
    
begin
        
        open vcursor;
            
            loop
            
                fetch vcursor into vname1, vname2, vname3, vname4, vname5;
                exit when vcursor%notfound;
                
                dbms_output.put_line('교사고유번호: ' || vname1 || ' || ' || vname2 || ' || ' || vname3 || ' || ' || vname4 || ' || ' || vname5);
            
            end loop;
            
        close vcursor;
        
end pccoursesurvey;



--확인
begin
    pccoursesurvey(1);
end;




5. 학생이 자신이 듣는 개설과정의 교재를 파악하는 프로시저
create or replace procedure pcstudentbook(
    pnum tblstudent.studentseq%type
)
is
    cursor vcursor is select st.studentseq as "학생 고유번호",
                                         st.name as "교육생이름",
                                         te.name as "선생님이름",
                                         tc.name as "과정명",
                                         ts.name as "과목명",
                                         ab.name as "사용교재"
                                         
   from tblopencourse oc
   inner join tblenrollment en
   on oc.opencourseseq = en.opencourseseq
   inner join tblstudent st
   on en.studentseq = st.studentseq
   inner join tbltotalcourse tc
   on oc.totalcourseseq = tc.totalcourseseq
   inner join tblopensubject os
   on oc.opencourseseq = os.opencourseseq
   inner join tbltotalsubject ts
   on os.totalsubjectseq = ts.totalsubjectseq
   inner join tblusedbook ub
   on ts.totalsubjectseq = ub.totalsubjectseq
   inner join tblallbook ab
   on ub.allbookseq = ab.allbookseq
   inner join tblteacher te
   on oc.teacherseq = te.teacherseq
   where st.studentseq = pnum;
   
                       
                         
    vname1 tblstudent.studentseq%type;
    vname2 tblstudent.name%type;
    vname3 tblteacher.name%type;
    vname4 tbltotalcourse.name%type;
    vname5 tbltotalsubject.name%type;
    vname6 tblallbook.name%type;
    
begin
        
        open vcursor;
            
            loop
            
                fetch vcursor into vname1, vname2, vname3, vname4, vname5, vname6;
                exit when vcursor%notfound;
                
                dbms_output.put_line('학생번호: ' || vname1 || ' || ' || vname2 || ' || ' || vname3 || ' || ' || vname4 || ' || ' || vname5 || ' || ' || vname6);
            
            end loop;
            
        close vcursor;
        
end pcstudentbook;


--확인
begin
    pcstudentbook(10);
end;



6. 교사가 담당하고 있는 강의 스케줄을 출력하는 프로시저
create or replace procedure procScheduleCheck (
    pnum tblTeacher.teacherSeq%type -- 교사고유번호
)
is
    cursor vcursor is select * from vwScheduleCheck where 교사고유번호 = pnum;
    vrow vwScheduleCheck%rowtype;
begin
    
    dbms_output.put_line('과정명                                            과정시작기간  과정종료기간  강의실이름            과목명           과목시작날짜  과목종료날짜            교재명       교육생등록인원 강의진행상태');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.과정명 || ' || ' || vrow.과정시작기간 || ' || ' || vrow.과정종료기간 || ' || ' || vrow.강의실이름 || ' || ' || vrow.과목명 || ' || ' || vrow.과목시작날짜 || ' || ' || vrow.과목종료날짜 || ' || ' || vrow.교재명 || ' || ' || vrow."교육생 등록인원" || ' || ' || vrow.강의진행상태);
    
    end loop;

end procScheduleCheck;




7. 특정 과목을 선택하면 해당 과목에 등록된 교육생 정보를 출력하는 프로시저
create or replace procedure procSubjectCheck (
    pnum tblOpenSubject.openSubjectSeq%type -- 개설과목 고유번호
)
is
    cursor vcursor is select * from vwSubjectCheck where 특정과목번호 = pnum;
    vrow vwSubjectCheck%rowtype;
begin
    
    dbms_output.put_line('번호  이름        전화번호         등록일     수료여부');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.특정과목번호 || ' || ' || vrow.이름 || ' || ' || vrow.전화번호 || ' || ' || vrow.등록일 || ' || ' || vrow.수료여부);

    end loop;

end procSubjectCheck;
/

begin
    procSubjectCheck(3);
end;



8. 특정 개설 과정을 조회하는 프로시저
create or replace procedure procCourseCheck (
    pnum tblOpenCourse.openCourseSeq%type    -- 개설과정 고유번호
)
is
    cursor vcursor is select * from vwCourseCheck where 개설과정번호 = pnum;
    vrow vwCourseCheck%rowtype;
begin
    
    dbms_output.put_line('과정번호       개설과목명       과목시작날짜   과목종료날짜            교재명            교사명');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.개설과정번호 || ' || ' || vrow."개설 과목명" || ' || ' || vrow.과목시작날짜 || ' || ' || vrow.과목종료날짜 || ' || ' || vrow.교재명 || ' || ' || vrow.교사명);
    
    end loop;

end procCourseCheck;





9. 특정 선생님이 담당하고 있는 과정을 조회하는 프로시저
create or replace procedure procTeacherCourse (
    pnum tblTeacher.teacherSeq%type -- 교사고유번호
)
is
    cursor vcursor is select * from vwTeacherCourse where 교사고유번호 = pnum;
    vrow vwTeacherCourse%rowtype;
begin
    
    dbms_output.put_line('교사명  교사번호                 과정명                          과정번호 과정시작날짜 과정종료날짜 강의실명   강의상태');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.교사명 || ' || ' || vrow.교사고유번호 || ' || ' || vrow.과정명 || ' || ' || vrow.과정고유번호 || ' || ' || vrow.과정시작날짜 || ' || ' || vrow.과정종료날짜 || ' || ' || vrow.강의실명 || ' || ' || vrow.강의상태);
    
    end loop;
    
end procTeacherCourse;
/

begin
    procTeacherCourse(1);
end;


10. 교사가 담당하고 있는 특정 강의(과정)의 모든 교육생의 5월달 출결 현황을 조회하는 프로시저
create or replace procedure procStudentAttendanceCheck (
    pnum1 tblTeacher.teacherSeq%type,            -- 교사고유번호
    pnum2 tblTotalCourse.totalCourseSeq%type,    -- 과정고유번호
    pnum3 tblAttendance.attendanceDate%type,      -- 날짜
    pnum4 tblAttendance.attendanceDate%type       -- 날짜
    
)
is
    cursor vcursor is select 
                            t.name as 교사명,
                            tc.name as 과정명,
                            tc.totalcourseseq as 과정고유번호,
                            s.name as 교육생이름,
                            s.studentseq as 교육생고유번호,
                            a.attendancedate as 날짜,
                            a.condition as 출결상태
                        from tblOpenCourse oc
                            inner join tblTeacher t
                                on oc.teacherSeq = t.teacherseq
                                    inner join tblTotalCourse tc
                                        on oc.totalCourseSeq = tc.totalCourseSeq
                                            inner join tblClassroom cr
                                                on oc.classroomSeq = cr.classroomSeq
                                                    inner join tblEnrollment e
                                                        on e.openCourseSeq = oc.openCourseSeq
                                                            inner join tblStudent s
                                                                on s.studentSeq = e.studentSeq
                                                                    inner join tblAttendance a
                                                                        on a.studentSeq = s.studentSeq 
                                                                            where t.teacherseq = pnum1  --1번 선생님
                                                                                and tc.totalcourseseq = pnum2 -- 1번과정
                                                                                    and a.attendancedate between pnum3 and pnum4;
    
begin
    
    for vrow in vcursor loop
        
        dbms_output.put_line(vrow.교사명 || ' || ' || vrow.과정명 || ' || ' || vrow.과정고유번호 || ' || ' || vrow.교육생이름 || ' || ' || vrow.교육생고유번호 || ' || ' || vrow.날짜 || ' || ' || vrow.출결상태);
            
    end loop;
    
end procStudentAttendanceCheck;
/

begin
    procStudentAttendanceCheck(1, 1, '21-05-01', '21-05-31');
end;
/


11. 특정 교육생의 출결 현황을 조회하는 프로시저
create or replace procedure procOneStudentCheck (
    pnum1 tblTeacher.techerSeq%type,            -- 교사고유번호
    pnum2 tbltotalcourse.totalcourseseq%type,   -- 전체과정고유번호
    pnum3 tblStudent.studentseq%type            -- 학생고유번호
)
is
    cursor vcursor is select * from vwOneStudentCheck
        where 교사고유번호 = pnum1 and 과정고유번호 = pnum2 and 교육생고유번호 = pnum3;
    vrow vwOneStudentCheck%rowtype;
begin

    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.교사명 || ' || ' || vrow.과정명 || ' || ' || vrow.교육생이름 || ' || ' || vrow.교육생고유번호 || ' || ' || vrow.전화번호 || ' || ' || vrow.날짜 || ' || ' || vrow.출결상태);
    
    end loop;

end;




12. 개설 과정의 개설과목 목록을 출력하는 프로시저
create or replace procedure procSubjectOfCourse (
    pnum tblOpenSubject.openCourseSeq%type
)
is
    cursor vcursor is select * from vwSubjectOfCourse where 개설과정번호 = pnum;
    vrow vwSubjectOfCourse%rowtype;
begin

    dbms_output.put_line('과정번호      과목명            개설과목시작날짜   개설과목종료날짜');

    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.개설과정번호 || ' || ' || vrow.과목명 || ' || ' || vrow.개설과목시작날짜 || ' || ' || vrow.개설과목종료날짜);
    
    end loop;

end procSubjectOfCourse;
/

begin
    procSubjectOfCourse(1);
end;
/


13. 선택한 과목의 배점 정보를 조회하는 프로시저
create or replace procedure procSubjectDistribution (
    pnum tblOpenSubject.openSubjectSeq%type
)
is
    cursor vcursor is select * from vwSubjectDistribution;
    vrow vwSubjectDistribution%rowtype;
begin

    dbms_output.put_line('과목번호      과목명              시험날짜  필기배점 실기배점 출결배점 시험지등록여부');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.개설과목번호 || ' || ' || vrow.개설과목명 || ' || ' || vrow.시험날짜 || ' || ' || vrow.필기배점 || ' || ' || vrow.실기배점 || ' || ' || vrow.출결배점 || ' || ' || vrow.시험지등록여부);
    
    end loop;

end procSubjectDistribution;
/

begin
    procSubjectDistribution(1);
end;
/


14. 해당 과목의 배점 정보를 등록하는 프로시저입니다.]
create or replace procedure procInsertDistribution (
    pnum tbltest.testSeq%type,
    pnum1 tbltest.testdate%type,
    pnum2 tbltest.handwritingdistribution%type,
    pnum3 tbltest.practiceDistribution%type,
    pnum4 tbltest.attendancedistribution%type,
    pnum5 tbltest.openSubjectSeq%type,
    pnum6 tbltest.registrationStatusSeq%type
)
is
begin
    
    insert into tblTest (testSeq, testDate, handWritingDistribution, practiceDistribution, attendanceDistribution, openSubjectSeq, registrationStatusSeq)
        values (pnum, pnum1, pnum2, pnum3, pnum4, pnum5, pnum6);
    
end procInsertDistribution;
/

begin
    procInsertDistribution(testSeq.nextVal, sysdate, 30, 40, 30, 52, 52);
end;
/


15. 해당 과목의 배점 정보를 수정하는 프로시저
create or replace procedure procUpdateDistribution (
    pnum1 tbltest.testdate%type,                    -- 시험날짜
    pnum2 tbltest.handwritingdistribution%type,     -- 필기배점
    pnum3 tbltest.practicedistribution%type,        -- 실기배점
    pnum4 tbltest.attendancedistribution%type,      -- 출결배점
    pnum5 tbltest.testseq%type                      -- 시험고유번호
)
is
begin

    update tbltest set
        testdate = pnum1,
        handwritingdistribution = pnum2,
        practicedistribution = pnum3,
        attendancedistribution = pnum4
    where testseq = pnum5;

end procUpdateDistribution;
/

begin
    procUpdateDistribution(sysdate, 30, 40, 30, 1);
end;
/

select * from tbltest;




16. 해당 과목의 문제를 조회하는 프로시저
create or replace procedure procSubjectQuestion (
    pnum tblOpenSubject.openSubjectSeq%type
)
is
    cursor vcursor is select * from vwSubjectQuestion where 개설과목번호 = pnum;
    vrow vwSubjectQuestion%rowtype;
begin
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.개설과목명 || ' || ' || vrow.개설과목번호 || ' || ' || vrow.시험문제 || ' || ' || vrow.정답);
    
    end loop;
    
end;