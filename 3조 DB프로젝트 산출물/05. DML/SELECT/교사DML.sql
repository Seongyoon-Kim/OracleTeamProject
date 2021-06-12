--[교사]

----------------------------------------------
--T001 강의스케줄

/*

[메인] > [교사] > [강의 스케줄 조회]
1. [담당 강의 스케줄 조회]
- 해당 교사가 담당하고 있는 강의 스케줄을 출력한다.
- 과목번호
- 과정명
- 과정 시작날짜(년월일)
- 과정 종료날짜(년월일)
- 강의실이름
- 과목명
- 과목 시작날짜(년월일)
- 과목 종료날짜(년월일)
- 교재명
- 교육생 등록 인원
- 강의 진행 상태
*/

--
select 
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
                                            where tc.teacherseq = 1
                                            order by os.beginDate asc;
                                            
                                            


/*

1.1 [특정 과목 조회]
  - 특정 과목을 선택 시 해당 과정에 등록된 교육생 정보를 출력한다.
    - 특정 과목 번호
    - 특정 과목명
    - 교육생 이름
    - 전화번호
    - 등록일
    - 수료/중도탈락 여부
*/
                           
                        
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
            on os.openCourseSeq = oc.openCourseSeq
                    where os.openSubjectSeq = 3;
                    
                    
                    
-- 1.1 [특정 개설 과정 조회]
-- 1.1.1 [개설 과목 정보]
-- 개설 과목명
-- 개설과목기간(시작 년월일)
-- 개설과목기간(종료 년월일)
-- 개설 과목 교재명
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
        on t.teacherSeq = ps.teacherSeq
    where oc.openCourseSeq = 1;


---------------------------------------------------------------

--T002. 출결 관리 및 출결 조회

/*
[메인] > [교사] > [출결 관리 및 출결 조회]

1 [담당 과정 조회]
  - 자신이 담당하고 있는 과정 조회
    - 담당 교사이름
    - 과정명
    - 과정 고유 번호
    - 과정 시작기간(년월일)
    - 과정 종료기간(년월일)
    - 강의실
    - 강의 진행 상태

*/

--1번선생님이 담당하고 있는 과정 조회
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
                        on oc.classroomSeq = cr.classroomSeq
                            where t.teacherseq = 1;



/*
[메인] > [교사] > [출결 관리 및 출결 조회] > [담당 과정 조회]

1.1 [출결 현황 조회]
  - 출결 현황을 확인할 기간을 입력한다.
    - 교육생 고유 번호
    - 교육생 이름
    - 교육생 번호
    - 교육생 출결 현황

*/

-- 자신이 담당하고 있는 특정 강의(1번과정)의 모든 교육생의 5월달 출결현황
select 
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

/*
[메인] > [교사] > [출결 관리 및 출결 조회] > [담당 과정 조회] > [출결 현황 조회]

1.1.1. [특정 교육생 출결 현황 조회]
  - 확인할 교육생의 번호를 입력한다.
      - 교육생 번호
      - 교육생 이름
      - 교육생 전화번호
      - 교육생 출결 현황

*/


-- 자신이 담당하고 있는 특정 강의(1번과정)의 특정 교육생(61번)의 전체 출결현황 조회

select 
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

------------------------------------------------------------------------
--[교사]
-- T_003
-- 교사 시험 및 배점 관리
-- 1. [담당 개설 과정 조회]
-- 자신이 담당한 강의 목록을 출력한다.
-- 과정명(개설과정 -> 전체과정)
-- 개설과정 시작날짜(년월일) (개설과정)
-- 개설과정 종료날짜(년월일) (개설과정)
-- 강의실 (개설과목 -> 강의실)
-- 교육생 등록 인원(개설과정)

select oc.opencourseseq as 개설과정번호,
       tc.name as 과정명,
       oc.begindate as 개설과정시작날짜,
       oc.enddate as 개설과정종료날짜,
       cl.name as 강의실,
       oc.registercount as 교육생등록인원       
from tblopencourse oc
inner join tbltotalcourse tc
on oc.opencourseseq = tc.totalcourseseq
inner join tblclassroom cl
on oc.classroomseq = cl.classroomseq
inner join tblTeacher t
on oc.teacherSeq = t.teacherseq
    where t.teacherseq = 1;


--1.1 [개설 과정의 개설과목 목록]
  -- 개설 과정 번호를 출력한다.
  -- 과목명을 출력한다. (개설과목 -> 전체과목)
  -- 과목 시작날짜(년월일) (개설과목)
  -- 과목 종료날짜(년월일) (개설과목)

select os.opencourseseq as 개설과정번호,
        ts.name as 과목명,
       os.begindate as 개설과목시작날짜,
       os.enddate as 개설과목종료날짜
from tblopensubject os
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq
where os.opencourseseq = 1; --개설 과정 번호 입력


-- 1.1.1 [배점 및 시험 정보 조회]
      -- 해당 과목의 배점 정보를 조회한다.  
      -- 시험 날짜 조회 (시험)
      -- 실기 배점 조회 (시험)
      -- 필기 배점 조회 (시험)
      -- 출결 배점 조회 (시험)
      -- 시험지 등록 여부 (시험 -> 시험지 등록여부)

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
on ts.totalsubjectseq = os.totalsubjectseq
where os.opensubjectseq = 1;

--1.1.2 [배점 및 시험 정보 등록]
      -- 해당 과목의 배점 정보를 등록한다.  
      -- 시험 날짜 등록
      -- 시험 문제 등록
      -- 실기 배점 등록
      -- 필기 배점 등록
      -- 출결 배점 등록

INSERT INTO tblTest 
VALUES(testSeq.nextval, 시험날짜, 필기배점, 실기, 출석, 개설과목고유번호, 시험지등록번호);


--1.1.3 [배점 및 시험 정보 수정]
      -- 해당 과목의 배점 정보를 수정한다.  
      -- 시험 날짜 수정
      -- 실기 배점 수정
      -- 필기 배점 수정
      -- 출결 배점 수정

update tbltest set
    testdate = '시험날짜', 
    handwritingdistribution = '필기배점',
    practicedistribution = '실기배점',
    attendancedistribution = '출결배점'
    where testseq = 1;  --수정하고 싶은 testseq가 있는가
    

-- 1.1.4 [배점 및 시험 정보 삭제]
      -- 해당 과목의 배점 정보를 삭제한다.  
      -- 시험 날짜 삭제
      -- 시험 문제 삭제
      -- 실기 배점 삭제
      -- 필기 배점 삭제
      -- 출결 배점 삭제

delete from tbltest 
where testseq = 1;
--시험고유번호 삭제시킬 번호


--1.1.5 [시험 문제 조회]
--해당 과목의 문제를 조회한다.
--시험 문제
--답
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
                        on ts.totalsubjectseq = os.totalsubjectseq
                            where os.openSubjectSeq = 1;


--  1.1.6 [시험 문제 등록]
--해당 과목의 문제를 등록한다.
--시험 문제
--답
INSERT INTO tblTestquestion 
VALUES(TESTQUESTIONSEQ.nextval, 시험문제, 답);

--   1.1.7 [시험 문제 수정]
--해당 과목의 문제를 수정한다.
--시험 문제
--답

update tbltestquestion set
    testquestion = '시험문제', 
    answer = '답'
where testquestionseq = 1;
--시험문제 1번을삭제할떄 사용


--   1.1.8 [시험 문제 삭제]
--해당 과목의 문제를 삭제한다
delete from tbltestquestion
where testestquestionseq = 1;
-- 시험문제1번을 삭제시킨다.


-----------------------------------------------------------------
--T004 성적 정보 관리

--교사 성적 관리
--1. [전체 개설 과정 조회]
-- 개설 과정 번호 (개설과정) 
-- 과정 명 (개설과정 -> 전체과정)
-- 개설 과정 시작 날짜 (개설 과정)
-- 개설 과정 종료 날짜 (개설 과정)
-- 강의실 번호 (개설과정 -> 강의실)
-- 강의 진행 상태 (개설과정 -> 강의실)

 select oc.opencourseseq as 개설과정번호,
        tc.name as 과정명,
        oc.begindate as 개설과정시작날짜,
        oc.enddate as 개설과정종료날짜,
        cl.classroomseq as 강의실번호,
        cl.condition as 강의진행상태
        
 from tblopencourse oc
 inner join tbltotalcourse tc
 on oc.totalcourseseq = tc.totalcourseseq
 inner join tblclassroom cl
 on oc.classroomseq = cl.classroomseq
    order by oc.opencourseseq;
 
 
 
  --1.1 [특정 개설 과정 조회]
      -- 개설 과정 번호
      -- 개설 과정명
      -- 개설 과목명 (개설과목 -> 전체과목)
      -- 개설 과목기간(시작 년월일) (개설과목)
      -- 개설 과목기간(종료 년월일) (개설과목)
      -- 개설 과목 교재명 (개설과목 -> 전체과목 -> 사용교재 -> 전체교재)
      -- 개설 과목 교사명 (개설과목 -> 개설과정 -> 교사명)

select
    oc.opencourseseq as 개설과정번호,
    tc.name as 개설과정명,
    ts.name as 과목명,
    os.begindate as 개설과목시작기간,
    os.enddate as 개설과목종료기간,
    ab.name as 과목교재명,
    te.name as 교사명
from tblopensubject os
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq
inner join tblusedbook ub
on ts.totalsubjectseq = ub.totalsubjectseq
inner join tblallbook ab
on ub.allbookseq = ab.allbookseq
inner join tblopencourse oc
on os.opencourseseq = oc.opencourseseq
inner join tblteacher te
on oc.teacherseq = te.teacherseq
inner join tblTotalCourse tc
on tc.totalCourseSeq = oc.totalcourseseq
    where oc.opencourseseq = 1;



--1.1.1 [강의를 마친 과목의 목록] 
-- 과정명 (개설과정 -> 전체과정)
-- 과정 시작날짜 (개설과정)
-- 과정 종료날짜 (개설과정)
-- 강의실 (개설과정 -> 강의실)
-- 개설 과목 번호(개설과정 -> 개설과목)
-- 과목명 (개설과목 -> 개설과목 _> 전체과목)
-- 과목 시작날짜 (개설과정 -> 개설과목)
-- 과목 종료날짜 (개설과정 -> 개설과목)
-- 교재명 ( 개설과정 -> 개설과목 -> 전체과목 -> 사용교재 -> 전체교재)
-- 출결 배점 (개설과정 -> 개설과목 -> 시험)
-- 필기 배점 (개설과정 -> 개설과목 -> 시험)
-- 실기 배점 (개설과정 -> 개설과목 -> 시험)

select
    ls.condition as 강의진행상태,
    tc.name as 과정명,
    oc.begindate as 과정시작날짜,
    oc.enddate as 과정종료날짜,
    cl.classroomseq as 강의실번호,
    ts.name as 과목명,
    os.begindate as 과목시작날짜,
    os.enddate as 과목종료날짜,
    ab.name as 교재명,
    te.attendancedistribution as 출결배점,
    te.handwritingdistribution as 필기배점,
    te.practicedistribution as 실기배점
        
from tblopencourse oc
inner join tbltotalcourse tc
on oc.totalcourseseq = tc.totalcourseseq
inner join tblclassroom cl
on oc.classroomseq = cl.classroomseq
inner join tblopensubject os
on oc.opencourseseq = os.opencourseseq
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq
inner join tblusedbook ub
on ts.totalsubjectseq = ub.totalsubjectseq
inner join tblallbook ab
on ub.allbookseq = ab.allbookseq
inner join tbltest te
on os.opensubjectseq = te.opensubjectseq
inner join tblLectureSchedule ls
on ls.opensubjectseq = os.opensubjectseq
    where ls.condition = '강의종료';



--1.1.1.1 [특정 과목] (어떤 과목인지?)
   -- 전체 교육생 목록 (수강생)
     -- 교육생 이름 (수강생
     -- 교육생 핸드폰 번호 (수강생)
     -- 수료/중도탈락 (수강생)
select  ts.name,
        st.name, 
        st.phonenumber, 
        st.condition
from tblopencourse oc
inner join tblopensubject os
on oc.opencourseseq = os.opencourseseq
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq
inner join tblenrollment en
on oc.opencourseseq = en.opencourseseq
inner join tblstudent st
on en.studentseq = st.studentseq
where os.opensubjectseq = 1;

--1.1.1.1.1 [특정 교육생 성적 조회]
              -- 과정명
              -- 과목명
              -- 출결
              -- 필기
              -- 실기
              
select
    st.studentseq as 교육생번호,
    st.name as 교육생명,
    tc.name as 과정명,
    ts.name as 과목명,
    sc.attendancescore as 출석점수,
    sc.hasdwritingscore as 필기점수,
    sc.practicescore as 실기점수
        
from tblstudent st
inner join tblenrollment en
on st.studentseq = en.studentseq
inner join tblscore sc
on en.enrollmentseq = sc.enrollmentseq
inner join tblopencourse oc
on en.opencourseseq = oc.opencourseseq
inner join tbltotalcourse tc
on oc.totalcourseseq = tc.totalcourseseq
inner join tblopensubject os
on oc.opencourseseq = os.opencourseseq
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq
where st.studentseq = 10;


--1.1.1.1.2 [특정 교육생 성적 입력]
              -- 과정명
              -- 과목명
              -- 출결
              -- 필기
              -- 실기
              
insert into tbltotalcourse (totalcourseseq, name) 
            values (TOTALSUBJECTSEQ.nextval, '과정명');
insert into tbltotalsubject (totalsubjectseq, name, period) 
            values (TOTALSUBJECTSEQ.nextval, '과목명', '5.5');
insert into tblscore (scoreseq, hasdwritingscore, practicescore, attendancescore, testseq, enrollmentseq)
            values (SCORESEQ.nextval, 0, 0, 0, 1, 1);


--1.1.1.1.3 [특정 교육생 성적 수정]
              -- 과정명
              -- 과목명
              -- 출결
              -- 필기
              -- 실기
update tbltotalcourse set name = '예시1'
where totalcourse = 1;   --예시로 totalcourse 가 1인것의 이름을 수정한다
update tbltotalsubject set name = '예시1'
where totalsubject = 1;   --예시로 totalcourse 가 1인것의 이름을 수정한다
update tblscore set hasdwritingscore = 0
where hasdwritingscore = 20; --예시로 hasdwritingscore가 20인것을 0으로 수정한다.
update tblscore set practicescore = 0
where practicescore = 20; --예시로 practicescore가 20인것을 0으로 수정한다.
update tblscore set attendancescore = 0
where attendancescore = 20; --예시로 attendancescore가 20인것을 0으로 수정한다.

--1.1.1.1.4 [특정 교육생 성적 삭제]
              -- 과정명
              -- 과목명
              -- 출결
              -- 필기
              -- 실기
              
delete tblstudent where name = '예시';
-- 교육생 이름이 예시를 tblstudent에서 삭제한다.

----------------------------------------------------------------------

--T005 상담일지


--------------------------[교사, 상담일지]-----------------------------------   

/*
[메인] > [교사] > [상담일지] 

1. [전체 개설과정 조회]
- 전체 과정의 정보를 출력한다.
  - 과정 고유 번호
  - 과정명
  - 교사명
  - 과정 시작 날짜
  - 과정 종료 날짜
  - 강의실명
*/
select
    oc.opencourseseq as "개설과정 고유번호",
    tc.name as "과정명",
    t.name as "교사명",
    oc.begindate as "과정 시작 날짜",
    oc.enddate as "과정 종료 날짜",
    cr.name as "강의실명"
from tblopencourse oc
    inner join tbltotalcourse tc
    on oc.totalcourseseq = tc.totalcourseseq
        inner join tblteacher t
        on oc.teacherseq = t.teacherseq
            inner join tblclassroom cr
            on oc.classroomseq = cr.classroomseq;
            
/*
[메인] > [교사] > [상담일지] 

1.1. [전체 개설과정 조회] >  [특정 개설과정 별 교육생 조회]
- 전체 교육생의 정보를 출력한다.
  - 고유 교육생 번호
  - 교육생 이름
  - 과정명
  - 교사명
  - 상담 날짜
  - 상담 내용

*/            
            
select
    s.studentseq as "고유 교육생 번호",
    s.name as "교육생이름",
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
                        where oc.opencourseseq = 1; --특정 개설과정 고유번호 입력


/*
[메인] > [교사] > [상담일지] 

1.1.1. [전체 개설과정 조회] >  [특정 개설과정 별 교육생 조회] > [특정 교육생 상담일지 추가]
    - 특정 교육생의 상담일지 추가한다. 
      - 상담 날짜
      - 상담 내용
*/         

--INSERT INTO tblCounselingDiary(counselingDiarySeq, counselingDate, content, enrollmentSeq) VALUES(counselingDiarySeq.nextval, '상담날짜', '상담내용', 수강신청고유번호);


/*
1.1.2. [전체 개설과정 조회] >  [특정 개설과정 별 교육생 조회] > [특정 교육생 상담일지 수정]
    - 특정 교육생의 상담일지 수정한다. 
      - 상담 날짜
      - 상담 내용
*/
update tblcounselingdiary set
    counselingDate = '상담날짜',
    content = '상담내용'
where counselingDiarySeq = 1; -- 수정하고 싶은 상담일지교유번호 입력 or 교육생번호


/*
[메인] > [교사] > [상담일지] 

1.1.1. [전체 개설과정 조회] >  [특정 개설과정 별 교육생 조회] > [특정 교육생 상담일지 삭제]
    - 선택한 특정 교육생의 상담 일지를 모든 테이블에서 삭제한다.
*/ 
delete from tblcounselingdiary where counselingDiarySeq = 1; -- 수정하고 싶은 상담일지교유번호 입력



--------------------------[교사, 만족도 조사]-----------------------------------  
--T006 만족도조사
/*
[메인] > [교사] > [만족도 조사 결과 조회]

1. [전체 개설 과정 조회 - 강의평가]
    - 개설 과정 고유 번호
    - 개설 과정 이름
    - 개설 과정 시작날짜
    - 개설 과정 종료날짜
*/
select
    oc.opencourseseq as "개설과정 고유번호",
    tc.name as "과정명",
    oc.begindate as "과정 시작 날짜",
    oc.enddate as "과정 종료 날짜"
from tblopencourse oc
    inner join tbltotalcourse tc
    on oc.totalcourseseq = tc.totalcourseseq;
    
    
/*
[메인] > [교사] > [만족도 조사 결과 조회]

1.1. [전체 개설 과정 조회 - 강의평가] > [특정 개설 과정 조회]
        - 개설과목고유번호
        - 개설 과목 이름
        - 개설 과목 시작날짜
        - 개설 과목 종료날짜
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
[메인] > [교사] > [만족도 조사 결과 조회]

1.1.1. [전체 개설 과정 조회 - 강의평가] > [특정 개설 과정 조회] > [특정 과목 조회]
            - 과목 이름
            - 평가 내용
            - 만족도(점수) -> 만족도(점수) 전체 평균
*/
select
    oc.opencourseseq as 과정번호,
    os.opensubjectseq as 과목번호,
    ts.name as 과목이름,
    cs.surveycomment as 평가내용,
    cs.score as 평가점수
from tblOpenSubject os
    inner join tblCourseSurvey cs
        on cs.openSubjectSeq = os.openSubjectSeq
    inner join tblTotalSubject ts
        on ts.totalSubjectSeq = os.totalSubjectSeq
    inner join tblOpenCourse oc
        on oc.openCourseSeq = os.openCourseSeq
    where os.openSubjectSeq = 1;
                    
                    
/*
[메인] > [교사] > [만족도 조사 결과 조회]
2. [전체 개설 과정 조회 - 교사평가]
    - 개설 과정 고유 번호
    - 개설 과정 이름
    - 개설 과정 시작날짜
    - 개설 과정 종료날짜

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
[메인] > [교사] > [만족도 조사 결과 조회]
2.1. [전체 개설 과정 조회 - 교사평가] > [특정 개설 과정 조회]
        - 개설 과목 이름
        - 개설 과목 시작날짜
        - 개설 과목 종료날짜
        - 느낀점

*/
select 
    tc.name as "개설 과정 이름",
    ts.teachersurveyseq as "교사평가 고유번호",
    ts.studentcomment as "느낀점"
    
from tblenrollment en
    inner join tblteachersurvey ts
    on en.teachersurveyseq = ts.teachersurveyseq
        inner join tblopencourse oc
        on en.opencourseseq = oc.opencourseseq
            inner join tbltotalcourse tc
            on oc.totalcourseseq = tc.totalcourseseq
                    where oc.opencourseseq = 1; -- 특정 개설과정 입력

