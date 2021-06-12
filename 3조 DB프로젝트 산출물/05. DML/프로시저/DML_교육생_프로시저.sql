-- DML_교육생_프로시저

--S001 성적 조회
-- 특정 교육생의 수강 과정을 조회하는 프로시저입니다.
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
/


begin
    procStudent(61);
end;
/


--------------------------------------------------------------------------------------
-- [특정 과정의 과목 목록을 조회하는 프로시저]
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


begin
    pcSubjectCheck(90);
end;
/

-------------------------------------------------------------------------------------------------------------------


-- [과목별 배점 정보를 출력하는 프로시저]
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

begin
    procDistribution(5);
end;
/


-- [과목별 배점 정보를 출력하는 뷰]
create or replace view vwDistribution
as
select
    os.opensubjectseq as 수강번호,
    st.name as 수강생이름,
    ts.name as 과목이름,
    tt.handwritingdistribution as 필기배점,
    tt.practicedistribution as 실기배점,
    tt.attendanceDistribution as 출결배점       
from tblopencourse oc
    inner join tblenrollment en
        on oc.opencourseseq = en.opencourseseq
    inner join tblstudent st
        on en.studentseq = st.studentseq
    inner join tblopensubject os
        on oc.opencourseseq = os.opencourseseq
    inner join tbltotalsubject ts
        on os.totalsubjectseq = ts.totalsubjectseq
    inner join tbltest tt
        on os.opensubjectseq = tt.opensubjectseq;
        
--------------------------------------------------------------------------------

-- [과목별 성적 정보를 출력하는 프로시저]
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
/


-- [과목별 성적 정보를 출력하는 뷰]
create or replace view vwScore
as
select
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
        on ts.totalSubjectSeq = os.totalSubjectSeq;
        
        

begin
 procScore(1);
end;
/

-----------------------------------------------------------------------------------------------------
-- [출결 조회 전체기간]
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

begin
 procAttendanceCheck(70);
end;
/


-- [출결 조회 전체기간 뷰]
create or replace view vwAttendanceCheck
as
select
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
                                                on a.studentseq = s.studentseq;


------------------------------------------------------------------------------------------------
-- [월별로 출결을 조회하는 프로시저입니다.]
create or replace procedure procAttendanceCheckMonth (
    pnum1 tblstudent.studentseq%type,
    pnum2 tblattendance.attendancedate%type,
    pnum3 tblattendance.attendancedate%type
)
is
    cursor vcursor is select
                            oc.openCourseSeq as 과정번호,
                            tc.name as 과정명,
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
                                                                            where s.studentseq = pnum1 and a.attendancedate between pnum2 and pnum3;
    vrow vwAttendanceCheckMonth%rowtype;
                                                                            
begin
    
    dbms_output.put_line('과정번호               과정명                           교육생이름    날짜   출결상태');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.과정번호 || ' || ' || vrow.과정명 || ' || ' || vrow.교육생이름 || ' || ' || vrow.날짜 || ' || ' || vrow.출결상태);
    
    end loop;

end procAttendanceCheckMonth;
/

begin
    procAttendanceCheckMonth(61, '21-05-01', '21-05-31');
end;
/

-- [월별로 출결을 조회하는 뷰입니다.]
create or replace view vwAttendanceCheckMonth
as
select
    oc.openCourseSeq as 과정번호,
    tc.name as 과정명,
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
                                                    where s.studentseq = 61 and a.attendancedate between '21-05-01' and '21-05-31';
                                                    
                                                    
                                                    

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- [날짜별로 출결을 조회하는 프로시저입니다.]
create or replace procedure procAttendanceCheckDay (
    pnum1 tblStudent.studentSeq%type,
    pnum2 tblAttendance.attendanceDate%type
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
                                                                            where s.studentseq = 61
                                                                                and a.attendancedate = '21-05-06';
    vrow vwAttendanceCheckDay%rowtype;

begin

    dbms_output.put_line('교육생이름    날짜    출결상태');

    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.교육생이름 || ' || ' || vrow.날짜 || ' || ' || vrow.출결상태);
    
    end loop;

end procAttendanceCheckDay;
/

begin
    procAttendanceCheckDay(61, '21-05-06');
end;
/


-- [날짜별로 출결을 조회하는 뷰입니다.]
create or replace view vwAttendanceCheckDay
as
select
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
                                                on a.studentseq = s.studentseq;

-------------------------------------------------------------------------------------------------------
-- [특정 구인공고를 조회하는 프로시저입니다.]
create or replace procedure procJobPostCheck (
    pnum tblJobpost.jobpostSeq%type
)
is
    cursor vcursor is select * from vwJobPostCheck where 번호 = pnum;
    vrow vwJobPostCheck%rowtype;
begin
    
    dbms_output.put_line('회사명  채용분야  경력      학력            연봉     근무지역    근무일시     전형수');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.회사명 || ' || ' || vrow.채용분야 || ' || ' || vrow.경력 || ' || ' || vrow.학력 || ' || ' ||  vrow.연봉 || ' || ' || vrow.근무지역 ||  ' || ' || vrow.근무일시 || ' || ' || vrow.전형수);
    
    end loop;

end procJobPostCheck;
/

begin
    procJobPostCheck(1);
end;
/


-- [구인공고를 조회하는 뷰입니다.]
create or replace view vwJobPostCheck
as
select 
    jobpostSeq as 번호,
    companyname as 회사명,
    recruitfield as 채용분야,
    career as 경력,
    educationlevel as 학력,
    annualincom as 연봉,
    workarea as 근무지역,
    worktime as 근무일시,
    selectioncount as 전형수
from tblJobPost;

---------------------------------------------------------------
-- [특정 자격증 정보를 출력하는 프로시저입니다.]
create or replace procedure procLicenseCheck (
    pnum tblLicense.licenseSeq%type
)
is
    cursor vcursor is select * from vwLicenseCheck where 자격증고유번호 = pnum;
    vrow vwLicenseCheck%rowtype;
begin
    
    dbms_output.put_line('  자격증명           자격종류          시행기관        회차     접수비   필기접수시작일  필기접수종료일 필기시험날짜 필기합격자발표일 실기접수시작일 실기원서종료일           실기시험날짜        실기합격자발표일');
    
    for vrow in vcursor loop
    
        dbms_output.put_line(vrow.자격증명 || ' || ' || vrow.자격종류 || ' || ' || vrow.시행기관 || ' || ' || vrow.회차 || ' || ' || vrow.접수비 || ' || ' || vrow.필기접수시작일 || ' || ' || vrow.필기접수종료일 || ' || ' || vrow.필기시험날짜 || ' || ' || vrow.필기합격자발표일 || ' || ' || vrow.실기접수시작일 || ' || ' || vrow.실기원서종료일 || ' || ' || vrow.실기시험날짜 || ' || ' || vrow.실기합격자발표일);
    
    end loop;

end procLicenseCheck;
/

begin
    procLicenseCheck(1);
end;
/


-- [특정 자격증 정보를 출력하는 뷰입니다.]
create or replace view vwLicenseCheck
as
select 
    licenseSeq as 자격증고유번호,
    name as 자격증명,
    licenseType as 자격종류,
    testAgency as 시행기관,
    round as 회차,
    receptionfee as 접수비,
    writtenregisterbegin as 필기접수시작일,
    writtenregisterend as 필기접수종료일,
    writtentestdate as 필기시험날짜,
    writtenresultdate as 필기합격자발표일,
    practicalRegisterBegin as 실기접수시작일,
    practicalRegisterEnd as 실기원서종료일,
    practicalTestDate as 실기시험날짜,
    practicalResultDate as 실기합격자발표일
from tblLicense;


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