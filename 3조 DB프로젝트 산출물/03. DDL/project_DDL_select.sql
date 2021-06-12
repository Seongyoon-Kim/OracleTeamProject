--[관리자]
select * from tblManager;
--[교사]
select * from tblTeacher;
--[교육생]
select * from tblStudent;
--[전체과정]
select * from tblTotalCourse;
--[강의실]
select * from tblClassroom;
--[전체과목]
select * from tblTotalSubject;
--[전체교재]
select * from tblAllBook;
--[출결]
select * from tblAttendance;
--[교사평가]
select * from tblteachersurvey;
--[개설과정]
select * from tblOpenCourse;
--[강의가능과목]
select * from tblPossibleSubject;
--[사용교재]
select * from tblUsedBook;
--[상담일지]
select * from tblCounselingDiary;
--[개설과목]
select * from tblOpenSubject;
--[강의스케줄]
select * from tblLectureSchedule;
--[강의평가]
select * from tblCourseSurvey;
--[시험지등록]
select * from tblRegistrationStatus;
--[시험]
select * from tblTest;
--[성적]
select * from tblScore;
--[시험문제]
select * from tblTestQuestion;
--[수강신청]
select * from tblEnrollment;
--[교육종료교육생]
select * from tblCompleteStudent;
--[취업현황]
select * from tblEmployment;
--[구인공고]
select * from tblJobPost;
--[자격증]
select * from tblLicense;


select 
    s.name as 교육생이름,
    s.enrolldate as 등록일,
    oc.opencourseseq as 과정번호,
    oc.begindate as 과정시작일,
    tc.name as 과정명,
    os.begindate as 개설과목시작날짜,
    ts.name as 과목명,
    tt.name as 교사명,
    te.testdate as 시험날짜,
    score.attendancescore,
    te.testseq
from tblStudent s
    inner join tblEnrollment e
        on s.studentseq = e.studentseq
            inner join tblOpenCourse oc
                on oc.opencourseseq = e.opencourseseq
                    inner join tbltotalcourse tc
                        on oc.totalcourseseq = tc.totalcourseseq
                            inner join tblopensubject os
                                on oc.opencourseseq = os.opencourseseq
                                    inner join tbltotalsubject ts
                                        on ts.totalsubjectseq = os.totalsubjectseq
                                            inner join tblteacher tt
                                                on tt.teacherseq = oc.teacherseq
                                                    inner join tblTest te
                                                        on te.opensubjectseq = os.opensubjectseq
                                                            inner join tblScore score
                                                                on score.testseq = te.testseq and e.enrollmentseq = score.enrollmentseq
                                                                    where oc.opencourseseq = 1;
                                                               
                                                            
select 
    tc.score,
    oc.opencourseseq
FROM tblenrollment e
    inner join tblOpenCourse oc
        on oc.opencourseseq = e.opencourseseq
            inner join tblOpenSubject os
                on os.openCourseSeq = oc.opencourseseq
                    inner join tblCourseSurvey tc
                        on tc.openSubjectSeq = os.opensubjectseq
                            where oc.opencourseseq = 3;

select 
    st.name,
    cs.surveyComment,
    cs.coursesurveyseq
from tblstudent st
    inner join tblenrollment en
    on st.studentseq = en.studentseq
    inner join tblcoursesurvey cs
    on en.enrollmentseq = cs.enrollmentseq;
    

select 
    t.name,
    ts.name
from tblOpenCourse oc
    inner join tblTeacher t
        on oc.teacherSeq = t.teacherseq
            inner join tblPossibleSubject ps
                on ps.teacherSeq = t.teacherseq
                    inner join tblTotalSubject ts
                        on ts.totalSubjectSeq = ps.totalsubjectseq;


select 
    t.name,
    ts.name
from tblTeacher t 
            inner join tblPossibleSubject ps
                on ps.teacherSeq = t.teacherseq
                    inner join tblTotalSubject ts
                        on ts.totalSubjectSeq = ps.totalsubjectseq;
    


select
    cs.completeStudentSeq as "고유번호",
    cs.completeDate as "수료(중도탈락)날짜",
    cs.condition as "수료/중도탈락",
    e.companyName as 회사명,
    e.annualIncome as 연봉,
    e.area as 근무지,
    s.name as 교육생이름
from tblCompleteStudent cs
    inner join tblEmployment e
        on cs.completeStudentSeq = e.completeStudentSeq
            inner join tblEnrollment em
                on cs.enrollmentSeq = em.enrollmentSeq
                    inner join tblStudent s
                        on s.studentSeq = em.studentSeq;
                        
                        
                        
                        
-- 상담일지와 수강신청, 교육생을 연결한 테이블              
select
    cd.counselingDiarySeq as "상담일지 고유번호",
    cd.counselingDate as 상담날짜,
    cd.content as 상담내용,
    em.openCourseSeq as "개설과정 고유번호",
    em.beginDate as 과정시작기간,
    em.endDate as 과정종료기간,
    -- as "교육생 등록인원",
    s.name as "교육생 이름"
from tblCounselingDiary cd
    inner join tblEnrollment em
        on em.enrollmentSeq = cd.enrollmentSeq
            inner join tblStudent s
                on em.studentSeq = s.studentSeq;                        


-- 교육생 -> 취업현황

select st.name,
        em.companyname
from tblstudent st
    inner join tblenrollment en
    on st.studentseq = en.studentseq
    inner join tblcompletestudent cs
    on en.enrollmentseq = cs.enrollmentseq
    inner join tblemployment em
    on cs.completestudentseq = em.completestudentseq;
                        
select st.name,
        ls.condition
from tblstudent st
    inner join tblenrollment en
    on st.studentseq = en.studentseq
    inner join tblcoursesurvey cs
    on en.enrollmentseq = cs.enrollmentseq
    inner join tblopensubject os
    on cs.opensubjectseq = os.opensubjectseq
    inner join tbllectureschedule ls
    on os.opensubjectseq = ls.opensubjectseq;                        

select ts.name,
       ab.name
from tblopencourse oc
    inner join tblopensubject os
    on oc.opencourseseq = os.opencourseseq
    inner join tbltotalsubject ts
    on os.totalsubjectseq = ts.totalsubjectseq
    inner join tblusedbook ub
    on ts.totalsubjectseq = ub.totalsubjectseq
    inner join tblallbook ab
    on ub.allbookseq = ab.allbookseq;



-- 상담일지와 수강신청, 교육생을 연결한 쿼리          
select
    cd.counselingDiarySeq as "상담일지 고유번호",
    cd.counselingDate as 상담날짜,
    cd.content as 상담내용,
    oc.openCourseSeq as "개설과정 고유번호",
    oc.beginDate as 과정시작기간,
    oc.endDate as 과정종료기간,
    oc.registerCount as "교육생 등록인원",
    s.name as "교육생 이름"
from tblCounselingDiary cd
    inner join tblEnrollment em
        on em.enrollmentSeq = cd.enrollmentSeq
            inner join tblStudent s
                on em.studentSeq = s.studentSeq
                    inner join tblOpenCourse oc
                        on oc.openCourseSeq = em.openCourseSeq;
                        
select st.name,
        ab.name
from tblstudent st
    inner join tblenrollment en
    on st.studentseq = en.studentseq
    inner join tblcoursesurvey cs
    on en.enrollmentseq = cs.enrollmentseq
    inner join tblopensubject os
    on cs.opensubjectseq = os.opensubjectseq
    inner join tbltotalsubject ts
    on os.totalsubjectseq = ts.totalsubjectseq
    inner join tblusedbook ub
    on ts.totalsubjectseq = ub.totalsubjectseq
    inner join tblallbook ab
    on ub.allbookseq = ab.allbookseq; 