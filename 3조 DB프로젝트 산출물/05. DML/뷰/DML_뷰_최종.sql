--View

-- 과정명, 교사명, 과정시작날짜, 과정종료날짜 출력
create or replace view vwOpenCourse
as
select 
    tc.name as 과정명,
    t.name as 교사명,
    oc.begindate as 과정시작날짜,
    oc.enddate as 과정종료날짜
from tblOpenCourse oc
    inner join tbltotalcourse tc
        on oc.totalcourseseq = tc.totalcourseseq 
    inner join tblTeacher t
        on t.teacherSeq = oc.teacherSeq;

select * from vwOpenCourse;


--전체교육생이 수강하는 과정명 정보 출력(현재 교육생)
-- 교육생이름, 과정명, 과정시작날짜, 과정종료날짜 출력
create or replace view vwStudent_Course
as
select
    s.name as 교육생이름, 
    tc.name as 과정명,
    oc.opencourseseq as 과정번호,
    t.name as 교사명,
    oc.begindate as 과정시작날짜,
    oc.enddate as 과정종료날짜
from tblStudent s
    inner join tblEnrollment e
        on s.studentseq = e.enrollmentseq
    inner join tblOpenCourse oc
        on oc.opencourseseq = e.opencourseseq
    inner join tblTotalCourse tc
        on tc.totalcourseseq = oc.totalcourseseq
    inner join tblTeacher t
        on t.teacherseq = oc.teacherseq
    where oc.enddate > to_char(sysdate, 'yy-mm-dd');

select * from vwStudent_Course;



-- 교사
-- 자신이 담당하는 과정의 과목별 스케줄 출력(과의중, 강의예정)
create or replace view vwLectureschedule
as
select 
    t.name as 교사명,
    t.teacherseq as 교사번호,
    tc.name as 과정명,
    ts.name as 과목명,
    ls.condition as 과목진행상태
from tblOpenCourse oc
    inner join tblTeacher t
        on t.teacherseq = oc.teacherseq
    inner join tblTotalCourse tc
        on oc.totalCourseSeq = tc.totalCourseSeq
    inner join tblOpenSubject os
        on os.opencourseseq = oc.opencourseseq 
    inner join tblTotalSubject ts
        on ts.totalsubjectseq = os.totalsubjectseq
    inner join tblLectureSchedule ls
        on ls.opensubjectseq = os.opensubjectseq
    where oc.enddate > to_char(sysdate, 'yy-mm-dd');


select * from vwLectureschedule where 교사번호 = 1;


--교사고유번호, 교사명, 주민번호 뒷자리, 전화번호, 현직대기여부, 강의가능과목을
--원하는 교사 고유 번호를 입력하고 볼수있다.
create or replace view vwTeacherInfo as
select
    t.teacherSeq as "교사 고유 번호",
    t.name as 교사명,
    t.ssn as "주민번호 뒷자리",
    t.phoneNumber as 전화번호,
    t.condition as "현직/대기여부",
    listagg(ts.name, ', ')
    within group(order by t.teacherseq) as 강의가능과목
from tblTeacher t
    inner join tblPossibleSubject ps
        on t.teacherSeq = ps.teacherSeq
    inner join tblTotalSubject ts
        on ts.totalSubjectSeq = ps.totalSubjectSeq
    group by t.teacherSeq, t.name, t.ssn, t.phoneNumber, t.condition;
    
select * from vwteacherinfo where "교사 고유 번호" = 1;



-- 개설과정 고유번호, 개설과정명, 개설 과정기간, 강의실, 개설과목 등록여부, 교육생 등록인원을
-- 개설과정 고유번호로 입력하고 볼수 있다.
create or replace view vwOpenCourseInfo as 
select
    oc.openCourseSeq as "개설과정 고유번호",
    tc.name as "개설 과정명",
    tc.period as "개설 과정기간",
    cr.name as "강의실",
    oc.registrationStatus as "개설과목 등록여부",
    oc.registerCount as "교육생 등록인원"
from tblTotalCourse tc
    inner join tblOpenCourse oc
        on oc.totalCourseSeq = tc.totalCourseSeq
    inner join tblClassroom cr
        on cr.classroomSeq = oc.classroomSeq;
                
select * from vwOpenCourseInfo where "개설과정 고유번호" = 1;



-- 개설과정번호, 개설과목명, 과목시작날짜, 과목종료날짜, 교재명, 교사명을
-- 개설과목명으로 입력하고 볼수 있다.
create or replace view vwOpenSubjectInfo as 
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
    inner join tblOpenSubject os
        on os.openCourseSeq = oc.openCourseSeq
    inner join tblTotalSubject ts
        on ts.totalSubjectSeq = os.totalSubjectSeq
    inner join tblUsedBook ub
        on ub.totalSubjectSeq = ts.totalSubjectSeq
    inner join tblAllBook ab
        on ab.allBookSeq = ub.allBookSeq
    inner join tblTeacher t
        on oc.teacherSeq = t.teacherSeq;
    

select * from vwOpenSubjectinfo where "개설 과목명" = 'JAVA 객체 지향 프로그래밍';


-- 교육생 이름, 주민번호 뒷자리, 전화번호, 등록일, 수료/중도탈락여부, 과정명을
-- 교육생 이름으로 입력하고 볼수 있다.
create or replace view vwStudentInfo as 
select
    s.name as "교육생 이름",
    s.ssn as "주민번호 뒷자리",
    s.phoneNumber as 전화번호,
    s.enrollDate as 등록일,
    s.condition as "수료/중도탈락여부",
    tc.name as 과정명
from tblStudent s
    inner join tblEnrollment e
        on s.studentSeq = e.studentSeq
    inner join tblOpenCourse oc
        on e.openCourseSeq = oc.openCourseSeq
    inner join tblTotalCourse tc
        on tc.totalCourseSeq = oc.totalCourseSeq;

select * from vwstudentinfo where "교육생 이름" = '현예규';



-- 개설과정고유번호, 과정명, 과목명, 시험문제등록여부, 필기배점, 실기배점, 교사명을
-- 과목명 이름으로 입력하고 볼수 있다.
create or replace view vwtestdistributionInfo as 
select oc.opencourseseq as 개설과정고유번호,
        tc.name as 과정명,
        ts.name as 과목명,
        rs.condition as 시험문제등록여부,
        tt.handwritingdistribution as 필기배점,
        tt.practicedistribution as 실기배점,
        tt.attendanceDistribution as 출석배점,
        te.name as 교사이름
from tblopencourse oc
    inner join tblopensubject os
        on oc.opencourseseq = os.opencourseseq
    inner join tbltotalsubject ts
        on os.totalsubjectseq = ts.totalsubjectseq
    inner join tblregistrationstatus rs
        on os.opensubjectseq = rs.opensubjectseq
    inner join tbltest tt
        on os.opensubjectseq = tt.opensubjectseq
    inner join tblteacher te
        on oc.teacherseq = te.teacherseq
    inner join tbltotalcourse tc
        on oc.totalcourseseq = tc.totalcourseseq;

select * from vwtestdistributioninfo where 과목명 = 'JAVA 객체 지향 프로그래밍';


--학생이름, 학생주민번호뒷자리, 교사명, 과정명, 과정시작날짜, 과정종료날짜,
--강의실명, 과목명, 과목시작날짜, 과목종료날짜, 필기배점, 실기배점, 출결배점,
--필기점수, 실기점수, 출결점수
create or replace view vwScoreInfo as 
select
    s.name as 교육생이름,
    ts.name as 과목명,
    t.handwritingDistribution as 필기배점,
    sc.hasdwritingscore as 필기점수,
    t.practiceDistribution as 실기배점,
    sc.practicescore as 실기점수,
    t.attendanceDistribution as 출석배점,
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
        
select * from vwScoreInfo where 교육생이름 = '모세심';


-- [과목별 배점 정보를 출력하는 뷰]
create or replace view vwDistribution
as
select
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

-----------------------------


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