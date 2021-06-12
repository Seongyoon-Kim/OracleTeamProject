
-- 과정이 끝난 교육생 -> 교육종료교육생 테이블에 추가
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

set serveroutput on;



delete from tblCompleteStudent where enrollmentSeq between 61 and 90;


select * from tblCompleteStudent;




/*
교육생 로그인하기
*/

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
/

declare
    presult number;
begin
    procLogin(관리자id, 관리자pw, presult);
end;
/
--id : studentseq 1, pw : ssn 2716495



/*
교육생 로그인하기
*/

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
/

declare
    presult number;
begin
    procLogin(교육생번호, 교육생ssn, presult);
end;
/



/*
교사 로그인하기
*/

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
/

declare
    presult number;
begin
    procLogin(교사번호, 교사ssn, presult);
end;
/




INSERT INTO tblAttendance (attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq)
values (attendanceSeq.nextVal, '2021-03-02', '09:15', '17:51', '지각', 61);

/*교육생 입실찍기*/
create or replace procedure procAttendin(
    pid in varchar2
)
is
begin
    if to_char(sysdate, 'hh24:mi') > '09:10' then
        insert into tblAttendance(attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq)
        values (attendanceSeq.nextVal, to_char(sysdate, 'yy-mm-dd'), to_char(sysdate, 'hh24:mi') , null, '지각', pid);
    else
        insert into tblAttendance(attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq)
        values (attendanceSeq.nextVal, to_char(sysdate, 'yy-mm-dd'), to_char(sysdate, 'hh24:mi') , null, '정상', pid);
    end if;
end procAttendin;
/
--begin
--    procAttendin(1);
--end;
--/
--SELECT * FROM TBLATTENDANCE WHERE STUDENTSEQ = 1 AND ATTENDANCEDATE = TO_CHAR(SYSDATE, 'YY-mm-dd');

/*교육생 퇴실찍기*/
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
/
commit;
--begin
--procAttendout(1);
--end;

rollback;

--end;
--/
--SELECT * FROM TBLATTENDANCE WHERE STUDENTSEQ = 1 AND ATTENDANCEDATE = TO_CHAR(SYSDATE, 'YY-mm-dd');

/*교육생 결석찍기*/
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
/
commit;
--begin
--procAttendout(1);
--end;


--1. 당일 출결 업데이트(결석)- 관리자
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
                    values (attendanceSeq.nextVal, to_char(sysdate, 'yy-mm-dd'), null , null, '결석', vseq);
                
        end loop;
    close vcursor;
    
end;

begin
proMAttendance;
end;





--학생이
--1.입실/퇴실 찍기 -> update 


INSERT INTO tblAttendance (attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq)
values (attendanceSeq.nextVal, '2021-03-02', '09:15', '17:51', '지각', 61);

/*교육생 입실찍기*/
create or replace procedure procAttendin(
    pid in varchar2
)
is
begin
    if to_char(sysdate, 'hh24:mi') < '09:10'  then -- 정상입실

        update tblAttendance set
            inTime = to_char(sysdate, 'hh24:mi'),
            condition = '정상'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
        
    else
        update tblAttendance set
            inTime = to_char(sysdate, 'hh24:mi'),
            condition = '지각'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
    end if;
end procAttendin;


commit;
begin
procAttendin(1);
end;



SELECT * FROM TBLATTENDANCE WHERE STUDENTSEQ = 61 AND ATTENDANCEDATE = TO_CHAR(SYSDATE, 'YY-mm-dd');


/*교육생 퇴실찍기*/
create or replace procedure procAttendout(
    pid in varchar2
)
is
    vintime tblattendance.intime%type;
begin
    select intime into vintime from tblattendance where studentseq = pid and attendancedate = to_char(sysdate,'yy-mm-dd');
    if to_char(sysdate, 'hh24:mi') > '17:50' and vintime < '09:10' then -- 정상퇴실

        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi'),
            condition = '정상'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
        
    elsif to_char(sysdate, 'hh24:mi') < '17:50' then -- 조퇴
    
        update tblAttendance set
            outTime = to_char(sysdate, 'hh24:mi'),
            condition = '조퇴'
                where studentseq = pid and attendancedate = to_char(sysdate, 'yy-mm-dd');
            
    end if;
end procAttendout;

begin
procAttendout(1);
end;
----------------------
--교육생 외출찍기.
create or replace procedure procAttendgoout(--외출찍기
    pid in varchar2
)
is
begin
    insert into tblAttendance(attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq)
        values (attendanceSeq.nextVal, to_char(sysdate, 'yy-mm-dd'), null , null, '외출', pid);
end procAttendgoout;

begin
    procAttendgoout(61);
end;



-- 1.2. [전체과정 추가]    
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
    
-- 1.3. [전체과정 수정]
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

-- 1.4. [전체과정 삭제]
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

------------------
-- [자격증 정보]
-- 3. 수정


/*자격증 정보 수정 프로시저*/
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
/

begin
proctblLicenseU(1, 1, '정보관리');
end;
/


select * from tblLicense;
/


----------------------------

-- 구인공고 수정 프로시저
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
/

begin
proctblJobPostU(1, 2, '로레알');
end;
/

select * from tblJobPost;



