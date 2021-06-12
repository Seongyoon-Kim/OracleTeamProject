--[관리자]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblManager (
     managerSeq number NOT NULL,        -- 관리자고유번호(PK)
     managerPW varchar2(15) NOT NULL    -- 관리자
 );
CREATE SEQUENCE managerSeq;

ALTER TABLE tblManager 
    ADD CONSTRAINT PK_TBLMANAGER PRIMARY KEY (managerSeq);

select * from tblManager;
    
--[교사]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblTeacher (
    teacherSeq number NOT NULL,             -- 교사고유번호(PK)
    name varchar2(15) NOT NULL,             -- 교사명
    ssn varchar2(15) NOT NULL,              -- 주민번호(뒷자리)
    phoneNumber varchar2(15) NOT NULL,      -- 전화번호
    condition varchar2(15) NOT NULL         -- 현직/대기여부
);

CREATE SEQUENCE teacherSeq;

ALTER TABLE tblTeacher
    ADD CONSTRAINT PK_TBLTEACHER PRIMARY KEY (teacherSeq);

ALTER TABLE tblTeacher 
    ADD CONSTRAINT CK_TBLTEACHER_SSN CHECK(length(ssn) = 7);

ALTER TABLE tblTeacher 
    ADD CONSTRAINT CK_TBLTEACHER_CONDITION CHECK(condition in ('현직', '대기'));

select * from tblTeacher;
    

--[교육생]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblStudent (
    studentSeq number NOT NULL,        -- 교육생고유번호 (PK)
    name varchar2(20) NOT NULL,        -- 교육생 이름
    phoneNumber varchar2(15) NULL,     -- 전화번호
    ssn varchar2(15) NOT NULL,         -- 주민번호(뒷자리)
    enrollDate date NOT NULL,          -- 등록일
    birth varchar2(20) NOT NULL,       -- 생년월일
    condition varchar2(15) NOT NULL,   -- 중도탈락 여부
    dropDate varchar2(20) NULL         -- 중도탈락날짜
);

CREATE SEQUENCE studentSeq;

ALTER TABLE tblStudent 
    ADD CONSTRAINT PK_TBLSTUDENT PRIMARY KEY (studentSeq);
    
ALTER TABLE tblStudent 
    ADD CONSTRAINT CK_TBLSTUDENT_SSN CHECK(length (ssn) = 7);

ALTER TABLE tblStudent 
    ADD CONSTRAINT CK_TBLSTUDENT_CONDITION CHECK(condition in('수료중', '중도탈락', '수료완료'));


select * from tblStudent;
        
        
--[전체과정]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblTotalCourse (
     totalCourseSeq number NOT NULL,     --전체과정 고유번호(PK)
     name varchar2(100) NOT NULL,        --과정명
     period number NOT NULL              --과정기간(5.5 0r 6 or 7)
);

CREATE SEQUENCE totalCourseSeq;

--PK_TBLTOTALCOURSE
ALTER TABLE tblTotalCourse 
    ADD CONSTRAINT PK_TBLTOTALCOURSE PRIMARY KEY (totalCourseSeq);

---CK_TBLTOTALCOURSE_PERIOD
ALTER TABLE tblTotalCourse 
    ADD CONSTRAINT CK_TBLTOTALCOURSE_PERIOD CHECK(period in (5.5, 6, 7));

select * from tblTotalCourse;


--[강의실]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblClassroom (
     classroomSeq number NOT NULL,      -- 강의실 고유번호(PK)
     name varchar2(15) NOT NULL,        -- 강의실 이름
     condition varchar2(15) NOT NULL,   -- 강의상태
     limitCount number NOT NULL         -- 수용인원
);

CREATE SEQUENCE classroomSeq;

ALTER TABLE tblClassroom 
    ADD CONSTRAINT PK_TBLCLASSROOM PRIMARY KEY (classroomSeq);
    
ALTER TABLE tblClassroom 
    ADD CONSTRAINT CK_TBLCLASSROOM_CONDITION CHECK(condition in ('강의중', '강의없음'));   

select * from tblClassroom;    

--[전체과목]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblTotalSubject (
    totalSubjectSeq number NOT NULL,    -- 전체과목번호(PK)
    name varchar2(100) NOT NULL         -- 과목명
);

CREATE SEQUENCE totalSubjectSeq;

ALTER TABLE tblTotalSubject
    ADD CONSTRAINT PK_TBLTOTALSUBJECT PRIMARY KEY (totalSubjectSeq);   

select * from tblTotalSubject;        
    
--[전체교재]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblAllBook (
     allBookSeq number NOT NULL,    -- 전체교제고유번호(PK)
     name varchar2(100) NOT NULL,    -- 교재명
     publisher varchar(50) NULL,    -- 출판사
     writer varchar(50) NULL,       -- 저자
     price number NOT NULL          -- 가격
);

CREATE SEQUENCE allBookSeq;

ALTER TABLE tblAllBook 
    ADD CONSTRAINT PK_TBLALLBOOK PRIMARY KEY (allBookSeq);
    
select * from tblAllBook;        
        

--[출결]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblAttendance (
     attendanceSeq number NOT NULL,     -- 출결고유번호(PK)
     AttendanceDate date NOT NULL,      -- 날짜
     inTime varchar2(30) NULL,          -- 입실시간
     outTime varchar2(30) NULL,         -- 퇴실시간
     condition varchar2(15) NOT NULL,   -- 출결상태
     studentSeq number not null         -- 교육생고유번호(FK)
);

CREATE SEQUENCE attendanceSeq;

ALTER TABLE tblAttendance 
    ADD CONSTRAINT PK_TBLATTENDANCE PRIMARY KEY (attendanceSeq);

ALTER TABLE tblAttendance
    ADD CONSTRAINT PK_TBLATTENDANCE_CONDITION CHECK(condition in('정상','조퇴','지각','결석','병가','기타', '외출'));

ALTER TABLE tblAttendance
    ADD CONSTRAINT FK_TBLATTENDANCE_studentSeq FOREIGN KEY (studentSeq)
        REFERENCES tblStudent (studentSeq);


select * from tblAttendance;      

--[교사평가]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblTeacherSurvey (
     teacherSurveySeq number NOT NULL,  -- 교사평가고유번호(PK)
     studentComment varchar2(1000) NULL -- 느낀점
);

CREATE SEQUENCE teacherSurveySeq;

ALTER TABLE tblTeacherSurvey 
    ADD CONSTRAINT PK_TBLTEACHERSURVEY PRIMARY KEY (teacherSurveySeq);

select * from tblTeacherSurvey;      

--[개설과정]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblOpenCourse (
     openCourseSeq number NOT NULL,     -- 개설과정 고유번호(PK)
     beginDate date NOT NULL,           -- 과정시작기간
     endDate date NOT NULL,             -- 과정종료기간
     registerCount number NOT NULL,     -- 교육생 등록인원
     teacherSeq number NOT NULL,        -- 교사고유번호(FK)
     totalCourseSeq number NOT NULL,    -- 전체과정고유번호(FK)
     classroomSeq number NOT NULL,      -- 강의실 고유번호(FK)
     registrationStatus varchar2(15) not null --개설과목 등록여부
);

CREATE SEQUENCE openCourseSeq;

-- PK_TBLOPENCOURSE
ALTER TABLE tblOpenCourse 
    ADD CONSTRAINT PK_TBLOPENCOURSE PRIMARY KEY (openCourseSeq);

--FK_tblTeacher_TO_tblOpenCourse
ALTER TABLE tblOpenCourse 
    ADD CONSTRAINT FK_tblTeacher_TO_tblOpenCourse FOREIGN KEY (teacherSeq)
        REFERENCES tblTeacher (teacherSeq);

--FK_tblTotalCourse_TO_tblOpenCourse
ALTER TABLE tblOpenCourse 
    ADD CONSTRAINT FK_tblTotal_TO_tblOpen FOREIGN KEY (totalCourseSeq)
        REFERENCES tblTotalCourse (totalCourseSeq);

-- FK_tblClassroom_TO_tblOpenCourse
ALTER TABLE tblOpenCourse
    ADD CONSTRAINT FK_tblClassroom_TO_tblOpen FOREIGN KEY (classroomSeq)
        REFERENCES tblClassroom (classroomSeq);

ALTER TABLE tblOpenCourse 
    ADD CONSTRAINT CK_tblClassroom_regisStatus CHECK(registrationStatus in ('Y', 'N'));

select * from tblOpenCourse;  


--[강의가능과목]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblPossibleSubject (
    possibleSubjectSeq number NOT NULL,     -- 강의가능과목 고유번호(PK)
    totalSubjectSeq number NOT NULL,        -- 전체과목번호(FK)
    teacherSeq number NOT NULL              -- 교사고유번호(FK)
);

CREATE SEQUENCE possibleSubjectseq;

ALTER TABLE tblPossibleSubject
    ADD CONSTRAINT PK_TBLPOSSIBLESUBJECT PRIMARY KEY (possibleSubjectseq);

ALTER TABLE tblPossibleSubject
    ADD CONSTRAINT FK_tblTotalSub_tblPossible FOREIGN KEY (totalSubjectSeq)
        REFERENCES tblTotalSubject (totalSubjectSeq);
        
ALTER TABLE tblPossibleSubject
    ADD CONSTRAINT FK_tblTeacher_tblPossible FOREIGN KEY (teacherSeq)
        REFERENCES tblTeacher (teacherSeq);

select * from tblPossibleSubject;


--[사용교재]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblUsedBook (
     usedBookSeq number NOT NULL,       -- 사용교재고유번호(PK)
     totalSubjectSeq number NOT NULL,   -- 전체과목번호(FK)
     allBookSeq number NOT NULL         -- 전체교재고유번호(FK)
);

CREATE SEQUENCE usedBookSeq;

ALTER TABLE tblUsedBook 
    ADD CONSTRAINT PK_TBLUSEDBOOK PRIMARY KEY (usedBookSeq);

ALTER TABLE tblUsedBook 
    ADD CONSTRAINT FK_tblTotalSub_tblUsedBook FOREIGN KEY (totalSubjectSeq)
        REFERENCES tblTotalSubject (totalSubjectSeq);

ALTER TABLE tblUsedBook 
    ADD CONSTRAINT FK_tblAllBook_tblUsedBook FOREIGN KEY (allBookSeq)
        REFERENCES tblAllBook (allBookSeq);

select * from tblUsedBook;



--[개설과목]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblOpenSubject (
    openSubjectSeq number NOT NULL,         -- 개설과목 고유번호(PK)
    beginDate date NOT NULL,                -- 과목시작날짜
    endDate date NOT NULL,                  -- 과목종료날짜
    openCourseSeq number NOT NULL,          -- 개설과정 고유번호(FK)
    totalSubjectSeq number NOT NULL,        -- 전체과목번호(FK)
    period varchar2(20) NOT NULL            -- 과목기간
);  

CREATE SEQUENCE openSubjectSeq;

ALTER TABLE tblOpenSubject
    ADD CONSTRAINT PK_TBLOPENSUBJECT PRIMARY KEY (openSubjectSeq);

ALTER TABLE tblOpenSubject
    ADD CONSTRAINT FK_tblOpenC_tblOpenSub FOREIGN KEY (openCourseSeq)
        REFERENCES tblOpenCourse (openCourseSeq);

ALTER TABLE tblOpenSubject
    ADD CONSTRAINT FK_tblTotalSub_tblOpenSub FOREIGN KEY (totalSubjectSeq)
        REFERENCES tblTotalSubject (totalSubjectSeq);    

select * from tblOpenSubject;


--[강의스케줄]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblLectureSchedule (
     lectureScheduleSeq number NOT NULL,    -- 강의스케줄 고유번호(PK)
     condition varchar2(15) NOT NULL,       -- 강의진행상태 
     openSubjectSeq number NOT NULL         -- 개설과목고유번호(FK)
);

CREATE SEQUENCE lectureScheduleSeq;

ALTER TABLE tblLectureSchedule 
    ADD CONSTRAINT PK_TBLLECTURESCHEDULE PRIMARY KEY (lectureScheduleSeq);

ALTER TABLE tblLectureSchedule 
    ADD CONSTRAINT FK_tblOpenSub_tblSchedule FOREIGN KEY (openSubjectSeq)
        REFERENCES tblOpenSubject (openSubjectSeq);

ALTER TABLE tblLectureSchedule 
    ADD CONSTRAINT CK_tblSchedule_condition CHECK(condition in ('강의예정', '강의중', '강의종료'));

select * from tblLectureSchedule;


--[시험지등록여부]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblRegistrationStatus (
    registrationStatusSeq number NOT NULL,      -- 시험지등록번호(PK)
    registrationDate date NULL,                 -- 시험지등록날짜
    condition varchar2(15) NOT NULL,            -- 시험지등록여부
    openSubjectSeq number NOT NULL              -- 개설과목 고유번호(FK)
);

CREATE SEQUENCE registrationStatusSeq;   

ALTER TABLE tblRegistrationStatus
    ADD CONSTRAINT PK_TBLREGISTSTATUS PRIMARY KEY (registrationStatusSeq);

ALTER TABLE tblRegistrationStatus 
    ADD CONSTRAINT CK_TBLREGISTATUS_CONDITION CHECK(condition in ('등록','미등록'));   

ALTER TABLE tblRegistrationStatus
    ADD CONSTRAINT FK_tblOpenSub_tblRegiStatus FOREIGN KEY (openSubjectSeq)
        REFERENCES tblOpenSubject (openSubjectSeq);

select * from tblRegistrationStatus;


--[시험]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblTest (                             
     testSeq number NOT NULL,               -- 시험고유번호(PK)
     testDate date NULL,                    -- 시험 날짜
     handwritingDistribution number NULL,   -- 필기 배점
     practiceDistribution number NULL,      -- 실기 배점
     attendanceDistribution number NULL,    -- 출석배점
     openSubjectSeq number NOT NULL,        -- 개설과목 고유번호(FK)
     registrationStatusSeq number NOT NULL  -- 시험지 등록 번호(FK)
);

CREATE SEQUENCE testSeq;

--PK_TBLTEST
ALTER TABLE tblTest 
    ADD CONSTRAINT PK_TBLTEST PRIMARY KEY (testSeq);

--FK_tblOpenSubject_TO_tblTest
ALTER TABLE tblTest 
    ADD CONSTRAINT FK_tblOpenSub_tblTest FOREIGN KEY (openSubjectSeq)
        REFERENCES tblOpenSubject (openSubjectSeq);

--FK_tblRegistrationStatus_TO_tblTest
ALTER TABLE tblTest 
    ADD CONSTRAINT FK_tblRegiStatus_tblTest FOREIGN KEY (registrationStatusSeq)
        REFERENCES tblRegistrationStatus (registrationStatusSeq);

--CK_TBLTEST_ATTENDANCEDISTRIBUTION
ALTER TABLE tblTest 
    ADD CONSTRAINT CK_TBLTEST_ATTENDANCEDIS CHECK (attendanceDistribution >= 20);
    
--CK_TBLTEST_DISTRIBUTION
ALTER TABLE tblTest 
    ADD CONSTRAINT CK_TBLTEST_DISTRIBUTION CHECK (attendanceDistribution + practiceDistribution + handwritingDistribution = 100);

select * from tblTest;



--[시험문제]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblTestQuestion (
     testQuestionSeq number NOT NULL,           -- 시험문제 고유번호(PK)
     testQusetion varchar2(1000) NULL,          -- 시험문제
     answer varchar2(1000) NULL,                -- 답
     registrationStatusSeq number NOT NULL      -- 시험지등록번호(FK)
);

CREATE SEQUENCE testQuestionSeq;
    
ALTER TABLE tblTestQuestion
    ADD CONSTRAINT PK_TBLTESTQUESTION PRIMARY KEY (testQuestionSeq);


ALTER TABLE tblTestQuestion
    ADD CONSTRAINT FK_tblRegiStatus_tblQuestion FOREIGN KEY (registrationStatusSeq)
        REFERENCES tblRegistrationStatus (registrationStatusSeq);    

select * from tblTestQuestion;


--[수강신청]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblEnrollment (
     enrollmentSeq number NOT NULL,         -- 수강신청고유번호(PK)
     teacherSurveySeq number NOT NULL,      -- 교사평가고유번호(FK)
     openCourseSeq number NOT NULL,         -- 개설과정고유번호(FK)
     studentSeq number NOT NULL             -- 교육생고유번호(FK)
);

CREATE SEQUENCE enrollmentSeq;

ALTER TABLE tblEnrollment 
    ADD CONSTRAINT PK_TBLENROLLMENT PRIMARY KEY (enrollmentSeq);

ALTER TABLE tblEnrollment 
    ADD CONSTRAINT FK_tblTSurvey_tblEnrollment FOREIGN KEY (teacherSurveySeq)
        REFERENCES tblTeacherSurvey (teacherSurveySeq);

ALTER TABLE tblEnrollment 
    ADD CONSTRAINT FK_tblOpenCourse_tblEnrollment FOREIGN KEY (openCourseSeq)
        REFERENCES tblOpenCourse (openCourseSeq);

ALTER TABLE tblEnrollment 
    ADD CONSTRAINT FK_tblStudent_TO_tblEnrollment FOREIGN KEY (studentSeq)
        REFERENCES tblStudent (studentSeq);

select * from tblEnrollment;

--[상담일지]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblCounselingDiary (
     counselingDiarySeq number NOT NULL, -- 상담일지고유번호(PK)
     counselingDate date NULL,           -- 상담날짜
     content varchar2(1000) NULL,        -- 상담내용
      enrollmentSeq number not null        -- 수강신청고유번호(FK)
);

CREATE SEQUENCE counselingDiarySeq;

ALTER TABLE tblCounselingDiary 
    ADD CONSTRAINT PK_TBLCOUNSELINGDIARY PRIMARY KEY (counselingDiarySeq);

ALTER TABLE tblCounselingDiary 
    ADD CONSTRAINT tblEnrollment_Diary FOREIGN KEY (enrollmentSeq)
        REFERENCES tblEnrollment (enrollmentSeq);

select * from tblCounselingDiary;

--[강의평가]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblCourseSurvey (
     courseSurveySeq number NOT NULL,   -- 강의평가 고유번호(PK)
     surveyComment varchar2(1000) NULL, -- 평가 내용
     score number NULL,                 -- 평가 점수
     openSubjectSeq number NOT NULL,     -- 개설과목 고유번호(FK)
     enrollmentSeq number not null      --수강신청고유번호(FK)
);

CREATE SEQUENCE courseSurveySeq;

--PK_TBLCORSESURVEY
ALTER TABLE tblCourseSurvey 
    ADD CONSTRAINT PK_TBLCORSESURVEY PRIMARY KEY (courseSurveySeq);

--CK_TBLCORSESURVEY_SCORE
ALTER TABLE tblCourseSurvey 
    ADD CONSTRAINT CK_TBLCOURSESURVEY_SCORE CHECK(score between 1 and 10);

-- FK_tblOpenSubject_TO_tblCorseSurvey    
ALTER TABLE tblCourseSurvey 
    ADD CONSTRAINT FK_tblOpenSub_tblCourseSurvey FOREIGN KEY (openSubjectSeq)
        REFERENCES tblOpenSubject (openSubjectSeq);

ALTER TABLE tblCourseSurvey 
    ADD CONSTRAINT tblEnrollment_tblCSurvey FOREIGN KEY (enrollmentSeq)
        REFERENCES tblEnrollment (enrollmentSeq);

select * from tblCourseSurvey;

--[성적]--------------------------------------------------------------------------------------------------------------
CREATE TABLE tblScore (
     scoreSeq number NOT NULL,      -- 성적고유번호(PK)
     hasdwritingScore number NULL,  -- 필기점수
     practiceScore number NULL,     -- 실기점수
     attendanceScore number NULL,   -- 출결점수
     testSeq number NOT NULL,        -- 시험고유번호(FK)
     enrollmentSeq number not null -- 수강신청고유번호(FK)
);

CREATE SEQUENCE scoreSeq;

ALTER TABLE tblScore 
    ADD CONSTRAINT PK_TBLSCORE PRIMARY KEY (scoreSeq);

ALTER TABLE tblScore 
    ADD CONSTRAINT FK_tblTest_TO_tblScore FOREIGN KEY (testSeq)
        REFERENCES tblTest (testSeq);
         
ALTER TABLE tblScore 
    ADD CONSTRAINT tblEnrollment_Score FOREIGN KEY (enrollmentSeq)
        REFERENCES tblEnrollment (enrollmentSeq);

select * from tblScore;

--[교육종료교육생]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblCompleteStudent (
     completeStudentSeq number NOT NULL,    -- 교육종료교육생고유번호(PK)
     completeDate varchar2(20) NOT NULL,    -- 수료날짜(중도탈락날짜)
     condition varchar2(15) NOT NULL,       -- 수료/중도탈락
     enrollmentSeq number NOT NULL          -- 수강신청고유번호(FK)
);

CREATE SEQUENCE completeStudentSeq;

ALTER TABLE tblCompleteStudent 
    ADD CONSTRAINT PK_TBLCOMPLETESTUDENT PRIMARY KEY (completeStudentSeq);

ALTER TABLE tblCompleteStudent 
    ADD CONSTRAINT CK_TBLCOMPLETES_CONDITION CHECK(condition in ('중도탈락', '수료완료'));
    
ALTER TABLE tblCompleteStudent 
    ADD CONSTRAINT FK_TBLCOMPLETES_enrollmentSeq FOREIGN KEY (enrollmentSeq)
        REFERENCES tblEnrollment (enrollmentSeq);

select * from tblCompleteStudent;

--[취업현황]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblEmployment (
     employmentSeq number NOT NULL,         -- 취업현황고유번호(PK)
     companyName varchar2(100) NULL,         -- 회사명
     annualIncome varchar2(50) NULL,              -- 연봉
     area varchar2(100) NULL,                -- 근무지
     completeStudentSeq number NOT NULL     -- 교육종료교육생고유번호(FK)
);

CREATE SEQUENCE employmentSeq;

ALTER TABLE tblEmployment 
    ADD CONSTRAINT PK_TBLEMPLOYMENT PRIMARY KEY (employmentSeq);

ALTER TABLE tblEmployment 
    ADD CONSTRAINT FK_tblCompleteS_tblEmployment FOREIGN KEY (completeStudentSeq)
        REFERENCES tblCompleteStudent (completeStudentSeq);

select * from tblEmployment;

--[구인공고]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblJobPost (
     jobPostSeq number NOT NULL,            -- 구인공고 고유번호(PK)
     recruitField varchar2(40) NOT NULL,    -- 채용분야
     companyName varchar2(50) NOT NULL,     -- 회사명
     recruitBegin varchar2(30) NOT NULL,    -- 채용시작날짜
     recruitEnd varchar2(30) NOT NULL,      -- 채용종료날짜
     career varchar2(20) NOT NULL,          -- 경력
     educationLevel varchar2(50) NOT NULL,  -- 학력
     annualIncom varchar2(30) NOT NULL,     -- 연봉
     workArea varchar2(20) NOT NULL,        -- 근무지역
     workTime varchar2(20) NOT NULL,        -- 근무시간
     selectionCount number NOT NULL         -- 전형수
);

CREATE SEQUENCE jobPostSeq;

ALTER TABLE tblJobPost 
    ADD CONSTRAINT PK_TBLJOBPOST PRIMARY KEY (jobPostSeq);

ALTER TABLE tblJobPost
    ADD CONSTRAINT CK_TBLJOBPOST_EDUCATIONLEVEL CHECK(educationLevel in('고졸', '대졸', '전문대졸', '제한 없음', '대졸/전문대졸'));

select * from tblJobPost;

--[자격증]--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblLicense (
     licenseSeq number NOT NULL,            -- 자격증고유번호(PK)
     name varchar2(50) NOT NULL,            -- 자격명
     licenseType varchar2(30) NOT NULL,     -- 자격증 종류
     testAgency varchar2(30) NOT NULL,      -- 시험기관
     round varchar2(15) NOT NULL,           -- 회차
     receptionFee number NOT NULL,          -- 접수비
     writtenRegisterBegin varchar2(30) NOT NULL,    -- 필기시험 원서접수 시작날짜
     writtenRegisterEnd varchar2(30) NOT NULL,      -- 필기시험 원서접수 종료날짜
     writtenTestDate varchar2(30) NOT NULL,         -- 필기시험 날짜
     writtenResultDate varchar2(30) NOT NULL,       -- 필기시험 합격자 발표 시작날짜
     practicalRegisterBegin varchar2(30) NOT NULL,  -- 실기시험 원서접수 시작날짜
     practicalRegisterEnd varchar2(30) NOT NULL,    -- 실기시험 원서접수 종료날짜
     practicalTestDate varchar2(30) NOT NULL,       -- 실기시험 날짜
     practicalResultDate varchar2(30) NOT NULL      -- 실기시험 합격자발표 날짜
);

CREATE SEQUENCE licenseSeq;

ALTER TABLE tblLicense
    ADD CONSTRAINT PK_TBLLICENSE PRIMARY KEY (licenseSeq);

ALTER TABLE tblLicense 
    ADD CONSTRAINT CK_TBLLICENSE_LICENSETYPE CHECK(licenseType in('국가기술자격', '국가전문자격','민간자격'));
    
select * from tblLicense;