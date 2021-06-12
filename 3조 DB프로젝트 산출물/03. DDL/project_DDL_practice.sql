-- 교육종료교육생과 취업현황, 수강신청, 교육생을 연결한 쿼리
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
                        
                        

-- 상담일지와 수강신청, 교육생을 연결한 쿼리          
select
    cd.counselingDiarySeq as "상담일지 고유번호",
    cd.counselingDate as 상담날짜,
    cd.content as 상담내용,
    oc.openCourseSeq as "개설과정 고유번호",
    oc.beginDate as 과정시작기간,
    oc.endDate as 과정종료기간,
    oc.registerCount as "교육생 등록인원",
    s.name as "교육생 이름",
    s.studentSeq "교육생 고유번호"
from tblCounselingDiary cd
    inner join tblEnrollment em
        on em.enrollmentSeq = cd.enrollmentSeq
            inner join tblStudent s
                on em.studentSeq = s.studentSeq
                    inner join tblOpenCourse oc
                        on oc.openCourseSeq = em.openCourseSeq;
                
                

-- 교사와 강의가능과목, 전체과목을 연결한 쿼리
select
    t.teacherSeq as 교사고유번호,
    t.name as 교사명,
    t.ssn as 주민번호,
    t.phoneNumber as 전화번호,
    t.condition as "현직/대기여부",
    ts.name as 과목명
from tblTeacher t
    inner join tblPossibleSubject ps
        on t.teacherSeq = ps.teacherSeq
            inner join tblTotalSubject ts
                on ps.totalSubjectSeq = ts.totalSubjectSeq;


-- 강의스케줄, 개설과목, 전체과목, 개설과정, 교사를 연결한 쿼리
select
    t.name as 교사명,
    ts.name as 과목명,
    ls.condition as 강의진행상태
from tblTeacher t
    inner join tblOpenCourse oc
        on oc.teacherSeq = t.teacherSeq
            inner join tblOpenSubject os
                on os.openCourseSeq = oc.openCourseSeq
                    inner join tblLectureSchedule ls
                        on ls.openSubjectSeq = os.openSubjectSeq
                            inner join tblTotalSubject ts
                                on os.totalSubjectSeq = ts.totalSubjectSeq;                                         

------------------------------------------------------------------------------------------------------------------
-- [기초 정보 관리]
-- M_001
-- [메인] > [관리자] > [기초 정보 관리]

-- 과정을 조회, 추가, 수정, 삭제할 수 있다.
-- 1.1. [전체과정 조회]
select * from tblTotalCourse;

-- 1.2. [전체과정 추가]
insert into tblTotalCourse (totalCourseSeq, name, period)
    values (totalCourseSeq.nextVal, '', '기간');
    
-- 1.3. [전체과정 수정]
update tblTotalCourse
    set name = '',
        period = '기간'
where totalCourseSeq = '전체과정 고유번호';

-- 1.4. [전체과정 삭제]
delete from tblOpenCourse
    where totalCourseSeq = '개설과정 고유번호';

delete from tblTotalCourse
    where totalCourseSeq = '전체과정 고유번호';


-- [기초정보관리]
-- 과목을 조회, 추가, 수정, 삭제할 수 있다.
-- 1.1. [전체과목 조회]
select * from tblTotalSubject;

-- 1.2. [전체과목 추가]
insert into tblTotalSubject (totalSubjectSeq, name)
    values (totalSubjectSeq.nextVal, '');
    
-- 1.3. [전체과목 수정]
update tblTotalSubject
    set name = ''
where totalSubjectSeq = '전체과목번호';

-- 1.4. [전체과목 삭제]
delete from tblPossibleSubject
    where totalSubjectSeq = '전체과목번호';
    
delete from tblUsedBook
    where totalSubjectSeq = '전체과목번호';
    
delete from tblOpenSubject
    where totalSubjectSeq = '전체과목번호';
    
delete from tblTotalSubject
    where totalSubjectSeq = '전체과목번호';


-- [기초 정보 관리]
-- 강의실을 조회, 추가, 수정, 삭제할 수 있다.

-- 1.1. [강의실 조회]
select * from tblClassroom;

-- 1.2. [강의실 추가]
insert into tblClassroom (classroomSeq, name, condition, limitCount)
    values (classroomSeq.nextVal, '', '', '수용인원');
    
-- 1.3. [강의실 수정]
update tblClassroom
    set name = '',
        condition = '',
        limitCount = '수용인원'
where classroomSeq = '강의실 고유번호';

-- 1.4. [강의실 삭제]
delete from tblOpenCourse
    where classroomSeq = '강의실 고유번호';

delete from tblClassroom
    where classroomSeq = '강의실 고유번호';
    



-- [기초 정보 관리]
-- 과목의 교재를 조회, 추가, 수정, 삭제할 수 있다.

-- 1.1. [전체 교재 조회]
select * from tblAllBook;

-- 1.2. [전체 교재 추가]
insert into tblAllBook (allBookSeq, name, publisher, writer, price)
    values (allBookSeq.nextVal, '', '', '', '가격');
    
-- 1.3. [전체 교재 수정]
update tblAllBook
    set name = '',
        publisher = '',
        writer = '',
        price = '가격'
where allBookSeq = '전체교재 고유번호';

-- 1.4. [전체 교재 삭제]
delete from tblUsedBook
    where allBookSeq = '전체교재 고유번호';

delete from tblAllBook
    where allBookSeq = '전체교재 고유번호';

--------------------------------------------------------------------------------------------------------------------------                              
-- 교사 계정 관리
-- M_002
-- [메인] > [관리자] > [교사 계정 관리]

-- 1. [교사 계정 조회]
-- 교사 정보 출력 시 전체 교사 명단을 출력한다.
-- 교사 고유번호
-- 교사명
-- 주민번호 뒷자리
-- 전화번호
-- 강의 가능 과목
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
    
    
-- 1.1. [특정 교사 조회]
-- 특정 교사 조회 시 상세정보를 출력한다.
-- 교사 고유 번호
-- 교사명
-- 과정명
-- 개설 과목명
-- 개설 과목 시작날짜(년월일)
-- 개설 과목 종료날짜(년월일)
-- 개설 과정 시작날짜(년월일)
-- 개설 과정 종료날짜(년월일)
-- 교재명
-- 강의실
-- 강의진행여부(강의예정, 강의중, 강의종료)
select
    t.teacherSeq as 교사고유번호,
    t.name as 교사명,
    oc.openCourseSeq as 개설과정고유번호,
    tc.name as 과정명,
    ts.name as 개설과목명,
    os.beginDate as "개설과목 시작날짜",
    os.endDate as "개설과목 종료날짜",
    oc.beginDate as "개설과정 시작날짜",
    oc.endDate as "개설과정 종료날짜",
    ab.name as 교재명,
    cr.name as 강의실이름,
    ls.condition as 강의진행여부
from tblTeacher t
    inner join tblOpenCourse oc
        on oc.teacherSeq = t.teacherSeq
    inner join tblTotalCourse tc
        on tc.totalCourseSeq = oc.totalCourseSeq
    inner join tblOpenSubject os
        on os.openCourseSeq = oc.openCourseSeq
    inner join tblTotalSubject ts
        on ts.totalSubjectSeq = os.totalSubjectSeq
    inner join tblUsedBook ub
        on ub.totalSubjectSeq = ts.totalSubjectSeq
    inner join tblAllBook ab
        on ab.allBookSeq = ub.allBookSeq
    inner join tblClassroom cr
        on cr.classroomSeq = oc.classroomSeq
    inner join tblLectureSchedule ls
        on ls.openSubjectSeq = os.openSubjectSeq
    where t.teacherSeq = 1
        order by oc.openCourseSeq;

-- 2. [교사 계정 추가] (헷갈리는 부분!!!!!)
-- 교사 계정 정보를 추가한다.
-- 교사 고유 번호
-- 교사명
-- 주민번호 뒷자리
-- 전화번호
-- 강의 가능 과목
-- 현직/대기여부
insert into tblTeacher (teacherSeq, name, ssn, phoneNumber, condition)
    values (teacherSeq.nextVal, '', '', '', '');

insert into tblPossibleSubject (possibleSubjectSeq, totalSubjectSeq, teacherSeq)
    values (possibleSubjectSeq.nextVal, '전체과목번호', '교사고유번호');
    
    
-- 3. [교사 계정 수정]
-- 교사 계정 정보를 수정한다.
-- 교사 고유번호
-- 교사명
-- 주민번호 뒷자리
-- 전화번호
-- 강의가능과목
-- 현직/대기여부

update tblTeacher
    set name = '',
        ssn = '',
        phoneNumber = '',
        condition = ''
where teacherSeq = '교사고유번호';

update tblPossibleSubject
    set totalSubjectSeq = '전체과목번호',
        techaerSeq = '교사고유번호'
where teacherSeq = '교사고유번호' 
    and possibleSubjectSeq = '강의가능과목 고유번호';


-- 4. [교사 계정 삭제]
delete from tblPossibleSubject
    where teacherSeq = ;
    
delete from tblOpenCourse
    where teacherSeq = ;

delete from tblTeacher
    where teacherSeq = ;


-------------------------------------------------------------------------------------------------------------------------------------------------
-- 개설 과정 관리
-- M_003
-- [메인] > [관리자] > [개설 과정 관리]

-- 1. [개설 과정 조회]
-- 개설 과정 조회 시 전체 개설 과정 목록을 출력한다.
-- 개설 과정 고유 번호
-- 개설 과정명
-- 개설 과정기간
-- 강의실 번호
-- 개설 과목 등록 여부
-- 교육생 등록 인원
select * from tblOpenCourse;
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
    inner join tblOpenSubject os
        on os.openCourseSeq = oc.openCourseSeq
    inner join tblTotalSubject ts
        on ts.totalSubjectSeq = os.totalSubjectSeq
    inner join tblUsedBook ub
        on ub.totalSubjectSeq = ts.totalSubjectSeq
    inner join tblAllBook ab
        on ab.allBookSeq = ub.allBookSeq
    inner join tblTeacher t
        on oc.teacherSeq = t.teacherSeq
    where oc.openCourseSeq = 1;
                                                                    


-- 1.1.1.1 [개설 과목 신규 등록]
-- 개설 과목명
-- 개설 과목기간(시작 년월일)
-- 개설 과목기간(시작 년월일)
-- 개설 과목 교재명
-- 개설 과목 교사명
insert into tblTotalSubject (totalSubjectSeq, name)
    values (totalSubjectSeq.nextVal, '');
insert into tblOpenSubject (openSubjectSeq, beginDate, endDate, openCourseSeq, totalSubjectSeq, period)
    values (openSubjectSeq.nextVal, '', '', 숫자, 숫자, 숫자);
insert into tblAllBook (allBookSeq, name, publisher, writer, price)
    values (allBookSeq.nextVal, '', '', '', 숫자);
insert into tblUsedBook (usedBookSeq, totalSubjectSeq, allBookSeq)
    values (usedBookSeq.nextVal, 숫자, 숫자);

-- 1.1.2. [교육생 정보]
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
        on tc.totalCourseSeq = oc.totalCourseSeq
    where oc.openCourseSeq = 1;
    
    
-- 2. [개설 과정 추가]
-- 개설 과정 고유번호
-- 개설 과정명
-- 개설 과정기간(시작 년월일)
-- 개설 과정기간(종료 년월일)
-- 강의실 번호

insert into tblTotalCourse (totalCourseSeq, name, period)
    values (totalCourseSeq.nextVal, '', 숫자);
insert into tblOpenCourse (openCourseSeq, beginDate, endDate, registerCount, teacherSeq, totalCourseSeq, classroomSeq)
    values (openCourseSeq.nextVal, '', '', 숫자, 숫자, 숫자, 숫자);
    
    
-- 3. [개설 과정 수정]
-- 전체 개설 과정 목록을 출력한 뒤, 특정 개설 과정을 선택하여 수정한다.
-- 3.1. [특정 개설 과정 수정]
-- 개설 과정명
-- 개설 과정 기간(시작 년월일)
-- 개설 과정 기간(종료 년월일)
-- 강의실 번호(이름?)
-- 개설 과목 등록 여부
-- 교육생 등록 인원
-- 개설 과정 수료 여부

update tblTotalCourse
    set name  = ''
where totalCourseSeq = '수정하고 싶은 전체 과정 고유번호';

update tblOpenCourse
    set beginDate = '',
        endDate = '',
        registerCount = 숫자
where openCourseSeq = '수정하고 싶은 개설 과정 고유 번호';

-- 4. [개설 과정 삭제]
-- 선택한 개설 과정의 데이터를 모든 테이블에서 삭제한다.
delete from tblOpenSubject
    where openCourseSeq = '삭제하고 싶은 개설과정 고유번호';
    
delete from tblEnrollment
    where openCourseSeq = '삭제하고 싶은 개설과정 고유번호';
    
delete from tblOpenCourse
    where openCourseSeq = '삭제하고 싶은 개설과정 고유번호';

---------------------------------------------------------------------------------------------------------------------------------




























    