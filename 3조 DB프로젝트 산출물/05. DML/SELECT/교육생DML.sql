--[교육생]

--S001 성적 조회

--교육생
--[메인] > [교육생] > [성적 조회] > [수강 과정 조회]
--교육생이 수강한 과정 출력 (where절)
-- 개인의 정보 출력 (개설과정 -> 수강신청 ->교육생)
-- 수강 과정명 출력 (개설과정 -> 전체과정)
-- 수강 과정기간 시작(년월일) 출력 (개설과정)
-- 수강 과정기간 종료(년월일) 출력 (개설과정)

select st.name as 교육생정보,
       tc.name as 수강과정,
       oc.begindate as 수강과정시작기간,
       oc.enddate as 수강과정종료기간
from tblopencourse oc
inner join tblenrollment en
on oc.opencourseseq = en.opencourseseq
inner join tblstudent st
on en.studentseq = st.studentseq
inner join tbltotalcourse tc
on oc.totalcourseseq = tc.totalcourseseq
where st.studentSeq = 61;


--1.1 [특정 수강 과정의 수강 과목 목록 조회]
-- 교육생이 수강 과정 및 수강 성적 점수 출력 (where절)
-- 수강 과정명 (개설과정 -> 전체과정)
-- 과목 명 출력 (개설과정 -> 개설과목 -> 전체과목)
-- 교사명 출력 (개설과정 -> 교사)
-- 과목 고유번호 출력 (개설과정 -> 개설과목)


select st.name as 수강생이름,
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
where st.studentseq = 5;


--1.1.1 과목별 배점 정보 출력 
-- 수강생 이름 (개설과정 -> 수강신청 -> 교육생)
-- 필기 배점 (개설과정 -> 개설과목 -> 시험)
-- 실기 배점 (개설과정 -> 개설과목 -> 시험)
-- 출결 배점 (개설과정 -> 개설과목 -> 시험)

select st.name as 수강생이름,
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
on os.opensubjectseq = tt.opensubjectseq
where st.studentseq = 5;


--1.1.1.1[ 과목별 성적 정보 출력]
        -- 수강생 이름 (개설과목 -> 개설과정 -> 수강신청 -> 교육생)
        -- 과목명 (개설과목 -> 전체과목)
        -- 필기 점수 (개설과목 -> 시험 -> 성적)
        -- 실기 점수 (개설과목 -> 시험 -> 성적)
        -- 출결 점수 (개설과목 -> 시험 -> 성적)
        -- 과목별 시험 날짜 출력 (개설과목 -> 시험)
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
        on ts.totalSubjectSeq = os.totalSubjectSeq
    where s.studentSeq = 90;

----------------------------------------------------
--S002 출결조회

--2. 출결 관리 및 출결 조회

/*

[메인] > [교육생] > [출결 관리 및 출결 조회] 

1. [수강 과정 조회] 
- 자신이 수강하고 있는 과정정보를 출력한다.
    - 교육생이름
    - 과정명
    - 과정시작날짜
    - 과정종료날짜
    - 교사명
    - 강의실명
*/

-- 61번 교육생이 수강하고 있는 과정정보 조회.
select
    s.name as 교육생이름,
    tc.name as 과정명,
    oc.begindate as 과정시작날짜,
    oc.enddate as 과정종료날짜,
    t.name as 교사명,
    cr.name as 강의실명
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
                                            where s.studentseq = 10;
           

/*

[메인] > [교육생] > [출결 관리 및 출결 조회] > [수강 과정 조회] 

 1.1 [출결 조회]
-자신이 현재 수강하고 있는 과정에 대한 자신의 출결현황 조회한다.
   - 과정번호 출력
   - 과정명 출력
   - 과정기간 출력
   - 출결날짜  
   - 출결 상황 출력

*/
--모세심교육생이 자신이 수강하고 있는 과정에 대한 자신의 출결상태 조회
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
                                                on a.studentseq = s.studentseq
                                                    where s.studentseq = 90;
/*
[메인] > [교육생] > [출결 관리 및 출결 조회] > [수강 과정 조회] > [출결 조회]

1.1.1  [월별 확인]
    - 자신의 월별 출결상태를 확인할 수 있다.
    - 확인할 기간 선택
        - 과정번호 출력 
        - 과정명 출력 
        - 출결일 출력 
        - 근태 상황 출력
*/
--모세심교육생이 자신이 수강하고 있는 과정에 대한 자신의 월별 출결상태 조회
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
   

/*
1.1.2. [날짜별 확인]
  - 자신의 특정 날짜의 출결상태를 확인할 수 있다..
  - 조회할 시작기간 입력(년/월/일)
  - 과정번호 출력 
  - 과정명 출력 
  - 출결일 출력 
  - 근태 상황 출력

*/
--모세심교육생이 자신이 수강하고 있는 과정에 대한 자신의 특정날짜에(2021-05-06) 대한 출결상태 조회
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
                                                on a.studentseq = s.studentseq
                                                    where s.studentseq = 61
                                                        and a.attendancedate = '21-05-06';




/*

[메인] > [교육생] > [출결 관리 및 출결 조회] > [수강 과정 조회] 

1.2[출결 체크(입력)]
 - 당일 출퇴근 시간을 입력한다.  
*/

-- 입실체크(당일)-- 퇴실시간은 null, 출결상태는 기타 
INSERT INTO tblAttendance (attendanceSeq, AttendanceDate, inTime, outTime, condition, studentSeq) values (attendanceSeq.nextVal, to_char(sysdate,'yy-mm-dd'), to_char(sysdate, 'hh24:mi'), null, '기타', 61);
delete from tblAttendance where attendanceseq = 2072; 

--퇴실체크(당일)
update tblAttendance set
    outTime =  to_char(sysdate, 'hh24:mi')
        where AttendanceDate = to_char(sysdate, 'yy-mm-dd')
            and studentseq = 61
            and condition = '기타';

select * from tblAttendance where AttendanceDate = to_char(sysdate, 'yy-mm-dd') and studentSeq =  61;

--------------------------------------------------------

--S_003 구인공고 조회

/*
[메인] > [교육생] > [구인공고 조회] 

1. [전체 구인공고 조회]
- 구인공고 목록 출력한다.
    - 공고번호
    - 회사명
    - 채용분야
    - 채용 시작 날짜
    - 채용 종료 날짜
*/
-- 전체 구인공고목록 조회
select 
    jobpostseq as 공고번호,
    companyname as 회사명,
    recruitfield as 채용분야,
    recruitbegin as 채용시작날짜,
    recruitend as 채용종료날짜
from tblJobPost;
/*
[메인] > [교육생] > [구인공고 조회] > [전체 구인공고 조회]

1.1. [특정 구인공고 조회]
  - 특정 구인공고 정보 출력한다.
    - 회사명
    - 채용분야
    - 경력
    - 학력
    - 연봉
    - 근무지역
    - 근무일시
    - 전형절차 수
*/
select 
    companyname as 회사명,
    recruitfield as 채용분야,
    career as 경력,
    educationlevel as 학력,
    annualincom as 연봉,
    workarea as 근무지역,
    worktime as 근무일시,
    selectioncount as 전형수
from tblJobPost
    where jobpostseq = 1;

-----------------------------------------------------------

--S_004. 자격증 일정 조회

/*
[메인] > [교육생] > [자격증 일정 조회]

1. [전체 자격증 목록 조회]
- 전체 자격증 목록을 출력한다.
    - 자격증 고유번호
    - 자격증 명
    - 자격 종류
    - 시행기관
*/

select * from tblLicense;

--전체 자격증 목록 출력한다.
select 
    licenseSeq as 자격증고유번호,
    name as 자격증명,
    licenseType as 자격종류,
    testAgency as 시행기관    
from tblLicense;


/*
[메인] > [교육생] > [자격증 일정 조회] > [전체 자격증 목록 조회]

1.1 [특정 자격증 정보]
    - 특정 자격증 정보를 출력한다.
        - 자격증 고유번호
        - 자격명
        - 시행기관
        - 회차
        - 접수비
        - 필기시험 원서접수 시작날짜
        - 필기시험 원서접수 종료날짜
        - 필기시험 날짜
        - 필기시험 합격자발표 날짜
        - 응시자격 서류제출 시작날짜
        - 응시자격 서류제출 종료날짜
        - 실기시험 원서접수 시작날짜
        - 실기시험 원서접수 종료날짜
        - 실기시험 날짜
        - 합격자발표 날짜

*/
--특정자격증(1번)에 대한 상세 정보 출력
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
from tblLicense
    where licenseSeq = 1;

------------------------------------------------------------------


--------------------------[교육생, 취업현황]-----------------------------------
-- S_005 취업현황조회

/*
[메인] > [교육생] > [취업 현황 조회] > [전체 과정 조회]
- 전체 과정의 목록을 출력한다.
    - 과정 고유번호
    - 교육생 정원
    - 과정명
    - 과정 시작 날짜
    - 과정 종료 날짜
*/

select
    oc.openCourseSeq as "개설과정 고유번호",       --개설과정고유번호
    oc.registercount as "교육생정원" ,             --교육생정원
    tc.name as "과정명",                           --과정명
    oc.begindate as "과정시작날짜",                --과정시작날짜
    oc.enddate as "과정종료날짜"                    --과정종료날짜
     
from tblOpenCourse oc
    inner join tblTotalCourse tc
        on oc.totalCourseSeq = tc.totalCourseSeq;
        
        
/*
[메인] > [관리자] > [취업 현황 관리] > [전체 과정 조회] > [특정 과정 조회]
- 특정 과정을 수강했던 교육생 목록을 출력한다.
    - 교육생 이름
    - 회사 이름
    - 분야
    - 연봉
    - 근무지역
*/
select
    substr(st.name, 1,1) || 'OO' as "교육생 이름",            --교육생 이름
    em.companyname as "회사 이름",       --회사 이름
    em.annualincome as "연봉",          --연봉
    em.area as "근무지역"                --근무지역
from tblOpenCourse oc
    inner join tblTotalCourse tc
        on oc.totalCourseSeq = tc.totalCourseSeq
            inner join tblEnrollment en
                on en.opencourseseq = oc.opencourseseq
                inner join tblStudent st
                    on en.studentSeq = st.studentSeq
                        inner join tblCompleteStudent cs
                            on en.enrollmentSeq = cs.enrollmentSeq
                                inner join tblEmployment em
                                    on em.completeStudentSeq = cs.completeStudentSeq
                                        where oc.openCourseSeq = 1; -- 선택한 과정 번호 넣기
                                        
     


--------------------------[교육생, 만족도 조사]-----------------------------------  

--S006만족도 조사
/*
[메인] > [교육생] > [만족도 조사]

1. [강의 평가]
    - 수료한 모든 과목의 목록을 출력한다.
        - 과목명
        - 과목 기간(시작 년월일)
        - 과목 기간(종료 년월일)
*/
select
    os.opensubjectseq as "개설과목고유번호",
    ts.name as "개설과목이름",
    os.begindate as "개설과목 시작날짜",
    os.enddate as "개설과목 종료날짜"
from tblopencourse oc
    inner join tblopensubject os
    on oc.opencourseseq = os.opencourseseq
        inner join tbltotalsubject ts
        on os.totalsubjectseq  = ts.totalsubjectseq
            where oc.opencourseseq = 1; --개설과정고유번호 입력
            
/*
[메인] > [교육생] > [만족도 조사]

1.1. [강의 평가] >[특정 과목 선택]
            - 평가 내용을 입력한다.
            - 만족도(점수)를 입력한다.
*/
--INSERT INTO tblCourseSurvey VALUES(courseSurveySeq.nextVal, '평가내용', 평가점수, 개설과목 고유번호, 수강신청고유번호);


/*
[메인] > [교육생] > [만족도 조사]
2. [교사 평가]
    - 과정명 출력
    - 과정 기간(시작 년월일) 출력
    - 과정 기간(종료 년월일) 출력
    - 교사명 출력
    - 느낀점
*/
select
    oc.opencourseseq as "개설과정 고유번호",
    tc.name as "과정명",
    oc.begindate as "과정 시작 날짜",
    oc.enddate as "과정 종료 날짜"
from tblopencourse oc
    inner join tbltotalcourse tc
    on oc.totalcourseseq = tc.totalcourseseq;

update tblTeacherSurvey set
    teacherSurveySeq = 교사평가고유번호,
    studentComment = '느낀점',
where teacherSurveySeq = 1; --해당 교사평가고유번호 입력



-- 교육생이름, 선생님이름, 평가내용, 평가점수

select
    s.studentSeq,
    s.name,
    t.name,
    cs.surveycomment,
    cs.score
from tblStudent s
    inner join tblEnrollment e
        on e.studentSeq = s.studentseq
    inner join tblOpenCourse oc
        on oc.openCourseSeq = e.opencourseseq
    inner join tblTeacher t
        on t.teacherSeq = oc.teacherSeq
    inner join tblCourseSurvey cs
        on cs.enrollmentseq = e.enrollmentseq;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
