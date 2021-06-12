-- DML_교사_프로시저

-- [교사가 담당하고 있는 강의 스케줄을 출력하는 프로시저입니다.]
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
/

begin
    procScheduleCheck(1);
end;
/


-- [교사가 담당하고 있는 강의 스케줄을 출력하는 뷰입니다.]
create or replace view vwScheduleCheck
as
select
tc.teacherSeq as 교사고유번호,
tc.name as "과정명",
oc.beginDate as "과정시작기간",
oc.endDate as "과정종료기간",
cr.name as "강의실이름",
ts.name as "과목명",
os.beginDate as "과목시작날짜",
os.endDate as "과목종료날짜",
ab.name as "교재명",
oc.registercount as "교육생 등록인원",
ls.condition as "강의진행상태"


from tblTotalSubject ts 
    inner join tblUsedBook ub
        on ts.totalSubjectSeq = ub.totalSubjectSeq
            inner join tblAllBook ab
            on ub.allBookSeq = ab.allBookSeq
                 inner join tblOpenSubject os
                 on os.totalSubjectSeq = ts.totalSubjectSeq
                     inner join tblOpenCourse oc
                     on oc.openCourseSeq = os.openCourseSeq
                         inner join tblTotalCourse tc
                         on  tc.totalCourseSeq = oc.totalCourseSeq
                            inner join tblClassroom cr
                            on oc.classroomSeq = cr.classroomSeq
                                inner join tblLectureSchedule ls
                                    on ls.openSubjectSeq = os.openSubjectSeq
                                        inner join tblTeacher tc
                                        on tc.teacherseq = oc.teacherseq
                                            order by os.beginDate asc;


---------------------------------------------------------------------------------------------------------
-- [특정 과목을 선택하면 해당 과목에 등록된 교육생 정보를 출력하는 프로시저입니다.]
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
/
-- [특정 과목을 선택하면 해당 과목에 등록된 교육생 정보를 출력하는 뷰입니다.]
create or replace view vwSubjectCheck
as
select
os.openSubjectSeq as 특정과목번호,
st.name as "이름",
st.phonenumber as "전화번호",
st.enrollDate as "등록일",
st.condition as "수료여부"

from tblStudent st
    inner join tblEnrollment em
    on st.studentSeq = em.studentSeq
        inner join tblOpenCourse oc
        on oc.openCourseSeq = em.openCourseSeq
            inner join tblOpenSubject os
            on os.openCourseSeq = oc.openCourseSeq;
            
---------------------------------------------------------------------------------------------
-- [특정 개설 과정을 조회하는 프로시저입니다.]
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
/

begin
    procCourseCheck(1);
end;
/

-- [특정 개설 과정을 조회하는 뷰입니다.]
create or replace view vwCourseCheck
as
select
    oc.openCourseSeq as 개설과정번호,
    ts.name as "개설 과목명",
    os.beginDate as 과목시작날짜,
    os.endDate as 과목종료날짜,
    ab.name as "교재명",
    t.name as 교사명
from tblTotalCourse tc
    inner join tblOpenCourse oc
        on oc.totalCourseSeq = tc.totalCourseSeq
    inner join tblClassroom cr
        on oc.classroomSeq = cr.classroomSeq
    inner join tblOpenSubject os
        on os.openCourseSeq = oc.openCourseSeq
    inner join tblTotalSubject ts
        on ts.totalSubjectSeq = os.totalSubjectSeq
    inner join tblUsedBook ub
        on ub.totalSubjectSeq = ts.totalSubjectSeq
    inner join tblAllBook ab
        on ab.allBookSeq = ub.allBookSeq
    inner join tblPossibleSubject ps
        on ts.totalSubjectSeq = ps.totalSubjectSeq
    inner join tblTeacher t
        on t.teacherSeq = ps.teacherSeq;
        
-----------------------------------------------------------------------------------------------------
-- [특정 선생님이 담당하고 있는 과정을 조회하는 프로시저입니다.]
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
/

-- [특정 선생님이 담당하고 있는 과정을 조회하는 뷰입니다.]
create or replace view vwTeacherCourse
as
select 
    t.name as 교사명,
    t.teacherSeq as 교사고유번호,
    tc.name as 과정명,
    tc.totalcourseseq as 과정고유번호,
    oc.begindate as 과정시작날짜,
    oc.enddate as 과정종료날짜,
    cr.name as 강의실명,
    case
        when oc.enddate < to_char(sysdate, 'yy-mm-dd') then '강의종료'
        when oc.begindate > to_char(sysdate, 'yy-mm-dd') then '강의예정'
        else '강의중'
    end as 강의상태
from tblOpenCourse oc
    inner join tblTeacher t
        on oc.teacherSeq = t.teacherseq
            inner join tblTotalCourse tc
                on oc.totalCourseSeq = tc.totalCourseSeq
                    inner join tblClassroom cr
                        on oc.classroomSeq = cr.classroomSeq;

------------------------------------------------------------------------------------------------
-- [교사가 담당하고 있는 특정 강의(과정)의 모든 교육생의 5월달 출결 현황을 조회하는 프로시저입니다.]
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

-- [교사가 담당하고 있는 특정 강의(과정)의 모든 교육생의 5월달 출결 현황을 조회하는 뷰입니다.]
create or replace view vwStudentAttendanceCheck
as
select 
    t.teacherseq as 교사고유번호,
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
                                                    where t.teacherseq = 1  --1번 선생님
                                                        and tc.totalcourseseq = 1 -- 1번과정
                                                            and a.attendancedate between '21-05-01' and '21-05-31';
                                                            

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- [특정 교육생의 출결 현황을 조회하는 프로시저입니다.]
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
/

-- [특정 교육생의 출결 현황을 조회하는 뷰입니다.]
create or replace view vwOneStudentCheck
as
select
    t.teacherSeq as 교사고유번호,
    tc.totalcourseseq as  과정고유번호,
    t.name as 교사명,
    tc.name as 과정명,
    s.name as 교육생이름,
    s.studentseq as 교육생고유번호,
    s.phonenumber as 전화번호,
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
                                                    where t.teacherseq = 1  --1번 선생님
                                                        and tc.totalcourseseq = 1 -- 1번과정
                                                            and s.studentseq = 61;
                                                            
-----------------------------------------------------------------------------------------------------------------
-- [개설 과정의 개설과목 목록을 출력하는 프로시저입니다.]
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

-- [개설 과정의 개설과목 목록을 출력하는 뷰입니다.]
create or replace view vwSubjectOfCourse
as
select os.opencourseseq as 개설과정번호,
        ts.name as 과목명,
       os.begindate as 개설과목시작날짜,
       os.enddate as 개설과목종료날짜
from tblopensubject os
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq;

---------------------------------------------------------------

-- [선택한 과목의 배점 정보를 조회하는 프로시저입니다.]
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

-- [선택한 과목의 배점 정보를 조회하는 뷰입니다.]
create or replace view vwSubjectDistribution
as
select os.opensubjectseq as 개설과목번호,
        ts.name as 개설과목명,
        tt.testdate as 시험날짜,
       tt.handwritingdistribution as 필기배점,
       tt.practicedistribution as 실기배점,
       tt.attendancedistribution as 출결배점,
       rs.condition as 시험지등록여부
from tbltest tt
inner join tblregistrationstatus rs
on tt.registrationstatusseq = rs.registrationstatusseq
inner join tblopensubject os
on tt.opensubjectseq = os.opensubjectseq
inner join tblTotalSubject ts
on ts.totalsubjectseq = os.totalsubjectseq;

-------------------------------------------------------------------------

-- [해당 과목의 배점 정보를 등록하는 프로시저입니다.]
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

select * from tblTest;

----------------------------------------------------------------------------------------------------

-- [해당 과목의 배점 정보를 수정하는 프로시저입니다.]
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

-------------------------------------------------------------------------------------------------------------------

-- [해당 과목의 문제를 조회하는 프로시저입니다.]
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
/

-- [해당 과목의 문제를 조회하는 뷰입니다.]
create or replace view vwSubjectQuestion
as
select
    ts.name as 개설과목명,
    os.opensubjectseq as 개설과목번호,
    tq.testQusetion as 시험문제,
    tq.answer as 정답
from tbltestquestion tq
    inner join tblRegistrationStatus rs
        on rs.registrationStatusSeq = tq.registrationstatusseq
            inner join tblOpenSubject os
                on os.opensubjectseq = rs.opensubjectseq
                    inner join tblTotalSubject ts
                        on ts.totalsubjectseq = os.totalsubjectseq;




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