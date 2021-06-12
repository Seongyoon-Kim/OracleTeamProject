--[관리자]

-- M_001
-- [기초 정보 관리]
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


--------------------------------------------------------------------------------------------------------------------------            -- M_002              
-- 교사 계정 관리

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

-- 2. [교사 계정 추가]
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


-- 4. [교사 계정 삭제]
delete from tblPossibleSubject
    where teacherSeq = ;
    
delete from tblOpenCourse
    where teacherSeq = ;

delete from tblTeacher
    where teacherSeq = ;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- M_003
-- 개설 과정 관리

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
--M_004
-- 4. 개설 과목 관리
--[메인] > [관리자] > [개설 과목 관리]

--1. [개설 과목 조회]
    --1.1 [개설 과정 정보]
        -- 개설 과정명 (전체과정 -> 개설과정)
        -- 개설 과정기간(시작 년월일) (개설과정)
        -- 개설 과정기간(종료 년월일) (개설과정)
        -- 강의실 번호 (전체과정 -> 개설과정 -> 강의실)

select tc.name as 개설과정명,
        oc.begindate as 개설과정시작기간,
        oc.enddate as 개설과정종료기간,
        cr.classroomseq as 강의실고유번호
from tbltotalcourse tc
inner join tblopencourse oc
on tc.totalcourseseq = oc.totalcourseseq
inner join tblclassroom cr
on oc.classroomseq = cr.classroomseq
order by oc.opencourseseq;
    
        
--1.1.1 [특정 개설 과정 선택시 개설 과목 정보]
            -- 개설 과목명 (전체과정 -> 개설과정)
            -- 개설 과목기간(시작 년월일) (개설과정)
            -- 개설 과목기간(종료 년월일) (개설과정)
            -- 교재명 (전체과정 -> 개설과정 -> 개설과목 -> 전체과목 -> 사용교재 -> 전체교재)
            -- 교사명 (전체과정 -> 개설과정 -> 교사)
 
 select tc.name as 개설과목명,
        oc.begindate as 개설과목시작기간,
        oc.enddate as 개설과목종료기간,
        ab.name as 교재명,
        te.name as 교사명
           
 from tbltotalcourse tc
 inner join tblopencourse oc
 on tc.totalcourseseq = oc.totalcourseseq
 inner join tblopensubject os
 on oc.opencourseseq = os.opencourseseq
 inner join tbltotalsubject ts
 on os.totalsubjectseq = ts.totalsubjectseq
 inner join tblusedbook us
 on ts.totalsubjectseq = us.totalsubjectseq
 inner join tblallbook ab
 on us.allbookseq = ab.allbookseq
 inner join tblteacher te
 on oc.teacherseq = te.teacherseq
 where oc.opencourseseq = 1; --특정 개설과정이라서 번호에 따른 개설과목명
 
 
--tblsubject
--2. [개설 과목 추가]
    -- 개설 과목명
    -- 개설 과목기간(시작 년월일)
    -- 개설 과목기간(종료 년월일)
    -- 교재명

insert into tbltotalsubject (totalsubjectseq, name) 
            values (TOTALSUBJECTSEQ.nextval, '과목명');
            
insert into tblopensubject (tblopensubjectseq, begindate, enddate)
values (OPENSUBJECTSEQ.nextval, '20/09/08', '21/03/01');

insert into tblallbook (allbookseq, name, publisher, writer, price)
values (ALLBOOKSEQ.nextval, '예시', '예시', '예시', 25000);



    --tblsubject
--3. [개설 과목 수정]
    -- 개설 과목명
    -- 개설 과목기간(시작 년월일)
    -- 개설 과목기간(종료 년월일)
    -- 교재명


update tbltotalsubject set name = '예시1'
where totalsubject = 1;   --예시로 totalsubject 가 1인것의 이름을 수정한다

update tblopensubject set begindate = '20/77/77', enddate = '20/88/88'
where opensubject = 1;    --예시로 opensbject 가 1인것의 시작,종료날짜를 수정한다.

update tblallbook set name = '예시'
where allbookseq = 1; --tblallbook 의 책번호가 1인 이름을 에시로 바꾼다.



--4. [개설 과목 삭제]
    -- 선택한 개설 과목의 데이터를 모든 테이블에서 삭제한다


delete from tbltotalsubject where tbltotalsubject = 1;
-- tbltotalsubject 가 1인것을 삭제한다
delete from tblopensuubject where opensubjectseq = 1;
-- opensubjectseq 가 1인것을 삭제한다.
delete from tblallbook where allbookseq = 1;
-- allbookseq 가 1인것을 삭제한다.
---------------------------------------------------------------------------------------------------------------------------------

--M_005
-- 5. 교육생 관리
--[메인] > [관리자] > [교육생 관리]

--1. [전체 교육생 조회]
    -- 이름 (전체 교육생)
    -- 주민번호 뒷자리 (전체 교육생)
    -- 등록일 (전체 교육생)
    --지우기 예정(- 수강(신청) 횟수)

select name as 교육생이름, ssn as 교육생주민번호뒷자리, enrolldate as 등록일
from tblstudent;


    --1.1 [특정 교육생 조회]
        -- 개설 과정명 (전체과정 -> 개설과정)
        -- 개설 과정기간(시작 년월일) (개설과정)
        -- 개설 과정기간(종료 년월일) (개설과정)
        -- 강의실 번호 (전체과정 -> 개설과정 -> 강의실)
        -- 수료 및 중도탈락 여부(전체과정 -> 개설과정 -> 수강신청 -> 교육생)
        -- 수료 및 중도탈락 날짜 (전체과정 -> 개설과정 -> 수강신청 -> 교육생)

select tc.name as 개설과정명,
        oc.begindate as 개설과정시작기간,
        oc.enddate as 개설과정종료시간,
        cl.classroomseq as 강의실번호,
        st.condition as 중도탈락여부,
        st.dropdate as 중도탈락날짜,
        st.name as 교육생이름
from tbltotalcourse tc
inner join tblopencourse oc
on tc.totalcourseseq = oc.totalcourseseq
inner join tblclassroom cl
on oc.classroomseq = cl.classroomseq
inner join tblenrollment en
on oc.opencourseseq = en.opencourseseq
inner join tblstudent st
on en.studentseq = st.studentseq
where st.name = '문선들';


--2. [교육생 추가]
    -- 이름
    -- 전화번호
    -- 주민번호 뒷자리 (*****)
    --수정예정?? 아니면 sysdate으로 넣기(- 등록일(자동입력))
    --아니면 수동입력으로 바꿔서 등록일 date로넣기??
    -- 생년월일
    -- 중도탈락 여부
    -- 중도탈락 날짜

insert into tblstudent (studentseq, name, phonenumber, ssn, enrolldate, 
birth, condition, dropdate) 
values (STUDENTSEQ.nextval, '예시', '010-5555-5555', 1086085, sysdate, 961111, '수료중', null);


--3. [교육생 수정]
    -- 이름
    -- 전화번호
    -- 주민번호 뒷자리 (*****)
    --수정예정?? 아니면 sysdate으로 넣기(- 등록일(자동입력))
    --아니면 수동입력으로 바꿔서 등록일 date로넣기??
    -- 생년월일
    -- 중도탈락 여부
    -- 중도탈락 날짜
    
update tblstdudent set name = '예시', phonenumber = '010-4444-4444', ssn = 9999999,
enrolldate = sysdate, birth = 888888, condition = '중도탈락', dropdate = '2020-11-11'
where name = '홍길동';
--홍길동이란 학생의 인적사항을 이렇게 바꿔준다.

--4. [교육생 삭제]
    -- 선택한 교육생의 데이터를 모든 테이블에서 삭제한다.

delete tblstudent where name = '예시';
-- 교육생 이름이 예시를 tblstudent에서 삭제한다.

---------------------------------------------------------------------------------------------------------------------------------

--M_006
--6. 시험 관리 및 성적 조회 - (관리자, 교사 별, 교육생)
--[메인] > [관리자] > [시험 관리 및 성적 관리] 

--1. [전체 과정 조회]
-- 전체 과정의 정보를 출력한다.

  -- 전체과정 고유 번호 (전체과정)
  -- 과정명 (전체과정)
  -- 과정 시작 날짜 (전체과정 -> 개설과정)
  -- 과정 종료 날짜 (전체과정 -> 개설과정)
  -- 강의실 번호 (전체과정 -> 개설과정 -> 강의실)
  
  
  --관리자 
 select tc.totalcourseseq as 전체과정고유번호,
         tc.name as 과정명,
         oc.begindate as 개설과정시작날짜,
         oc.enddate as 개설과정종료날짜,
         cr.classroomseq as 강의실고유번호,
         te.name as 선생님이름
  from tbltotalcourse tc
  inner join tblopencourse oc
  on tc.totalcourseseq = oc.totalcourseseq
  inner join tblteacher te
  on oc.teacherseq = te.teacherseq
  inner join tblclassroom cr
  on oc.classroomseq = cr.classroomseq;


--1.1 [특정 개설 과정] 
  -- 특정 개설 과정의 정보를 과목별로 출력한다.
    -- 개설과정 고유 번호 (개설과정)
    -- 과목명 (개설과정 -> 개설과목 -> 전체과목)
    -- 성적 등록 여부 (삭제예정)
    -- 시험 문제 파일 등록 여부 (개설과목 -> 시험지 등록여부)
    -- 필기 배점(개설과목 -> 시험)
    -- 실기 배점(개설과목 -> 시험)
    -- 뒤에 where 붙이기


-- 관리자
select oc.opencourseseq as 개설과정고유번호,
        tc.name as 과정명,
        ts.name as 과목명,
        rs.condition as 시험문제등록여부,
        tt.handwritingdistribution as 필기배점,
        tt.practicedistribution as 실기배점,
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

    
--2. [성적 조회- 과목별]
--2.1 [전체 개설 과정 조회]
  --전체 과정의 정보를 출력한다. 
  -- 전체과정 고유 번호 (전체과정)
  -- 전체과정명  (전체과정)
  -- 교사명 (개설과정 -> 교사)
  -- 개설과정 시작 날짜 (전체과정 -> 개설과정)
  -- 개설과정 종료 날짜 (전체과정 -> 개설과정)
  -- 강의실 번호 (전체과정 -> 개설과정 -> 강의실)
  
-- 관리자
select
    tc.totalcourseseq as "전체과정 고유번호",
    tc.name as "전체 과정명",
    t.name as "교사명",
    oc.begindate as "개설과정 시작 날짜",
    oc.enddate as "개설과정 종료 날짜",
    cr.classroomseq as "강의실번호"
from tblopencourse oc
inner join tbltotalcourse tc
on oc.totalcourseseq = tc.totalcourseseq
inner join tblteacher t
on oc.teacherseq = t.teacherseq
inner join tblclassroom cr
on oc.classroomseq = cr.classroomseq;

 
--2.1.1 [특정 과정별 과목 조회]
    -- 전체 과목별 정보를 출력한다.
    -- 개설 과목명(개설과목)
    -- 개설 과목 고유번호 (개설과목)
    -- 개설 과목기간(시작 년월일) (개설과목)
    -- 개설 과목기간(종료 년월일) (개설과목)
   
    
--관리자
    select
    os.opensubjectseq as "개설과목고유번호",
    ts.name as "개설과목이름",
    os.begindate as "개설과목 시작날짜",
    os.enddate as "개설과목 종료날짜",
    te.name as "교사이름"
from tblopencourse oc
inner join tblopensubject os
on oc.opencourseseq = os.opencourseseq
inner join tbltotalsubject ts
on os.totalsubjectseq  = ts.totalsubjectseq
inner join tblteacher te
on oc.teacherseq = te.teacherseq;


--2.1.1.1 [특정 개설 과목 조회] (
     -- 전체 교육생 정보 출력 (교육생)
     -- 교육생 이름 (교육생)
     -- 교육생 번호 (교육생)
     -- 과목명
     -- 필기점수
     -- 실기점수
     -- 출석점수

--2.1.1.1.1 [교육생 개인별 성적 조회]
-- 교육생 개인별 시험정보를 출력한다

-- 교육생 이름 (개설과정 -> 수강신청 ->교육생)
       -- 주민번호 뒷자리 (개설과정 -> 수강신청 ->교육생)
       -- 과정명 (개설과정 -> 전체과정)
       -- 과정 시작 날짜 (개설과정)
       -- 과정 종료 날짜 (개설과정)
       -- 강의실명 (개설과정 -> 강의실)
       -- 과목명 (개설과정 -> 개설과목 -> 전체과목)
       -- 과목기간(시작,종료) (개설과정 -> 개설과목)
       -- 교사명 (개설과정 -> 교사)
       -- 필기점수 (개설과정 -> 개설과목 -> 시험)
       -- 실기점수 (개설과정 -> 개설과목 -> 시험)

--관리자
select st.name as 학생이름,
       st.ssn as 학생주민번호뒷자리,
       te.name as 교사명,
       tc.name as 과정명,
       oc.begindate as 과정시작날짜,
       oc.enddate as 과정종료날짜,
       cl.name as 강의실명,
       ts.name as 과목명,
       os.begindate as 과목시작날짜,
       os.enddate as 과목종료날짜,
       tt.handwritingdistribution as 필기점수,
       tt.practicedistribution as 실기점수
       
from tblopencourse oc
inner join tblenrollment en
on oc.opencourseseq = en.opencourseseq
inner join tblstudent st
on en.studentseq = st.studentseq
inner join tbltotalcourse tc
on oc.totalcourseseq = tc.totalcourseseq
inner join tblteacher te
on oc.teacherseq = te.teacherseq
inner join tblclassroom cl
on oc.classroomseq = cl.classroomseq
inner join tblopensubject os
on oc.opencourseseq = os.opencourseseq
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq
inner join tbltest tt
on os.opensubjectseq = tt.opensubjectseq;



       -- 교육생 이름 (개설과정 -> 수강신청 ->교육생)
       -- 주민번호 뒷자리 (개설과정 -> 수강신청 ->교육생)
       -- 과정명 (개설과정 -> 전체과정)
       -- 과정 시작 날짜 (개설과정)
       -- 과정 종료 날짜 (개설과정)
       -- 강의실명 (개설과정 -> 강의실)
       -- 과목명 (개설과정 -> 개설과목 -> 전체과목)
       -- 과목기간(시작,종료) (개설과정 -> 개설과목)
       -- 교사명 (개설과정 -> 교사)
       -- 필기점수 (개설과정 -> 개설과목 -> 시험)
       -- 실기점수 (개설과정 -> 개설과목 -> 시험)


--3. [성적조회 – 개인별] ??
   -- 전체 교육생 정보 출력
   -- 교육생 이름
   -- 교육생 번호
   -- 주민번호 뒷자리

--관리자만  
select st.name, st.phonenumber, st.ssn
from tblstudent st;
   
   
--3.1 [교육생 개인별 성적 조회]
     -- 교육생 개인별 시험정보를 출력한다
     -- 교육생 이름
     -- 주민번호 뒷자리
     -- 과정명
     -- 과정 시작 날짜
     -- 과정 종료 날짜
     -- 강의실명
     -- 과목명
     -- 과목기간
     -- 교사명
     -- 필기점수
     -- 실기출력

--관리자
select st.name as 학생이름,
       st.ssn as 학생주민번호뒷자리,
       te.name as 교사명,
       tc.name as 과정명,
       oc.begindate as 과정시작날짜,
       oc.enddate as 과정종료날짜,
       cl.name as 강의실명,
       ts.name as 과목명,
       os.begindate as 과목시작날짜,
       os.enddate as 과목종료날짜,
       tt.handwritingdistribution as 필기점수,
       tt.practicedistribution as 실기점수
       
from tblopencourse oc
inner join tblenrollment en
on oc.opencourseseq = en.opencourseseq
inner join tblstudent st
on en.studentseq = st.studentseq
inner join tbltotalcourse tc
on oc.totalcourseseq = tc.totalcourseseq
inner join tblteacher te
on oc.teacherseq = te.teacherseq
inner join tblclassroom cl
on oc.classroomseq = cl.classroomseq
inner join tblopensubject os
on oc.opencourseseq = os.opencourseseq
inner join tbltotalsubject ts
on os.totalsubjectseq = ts.totalsubjectseq
inner join tbltest tt
on os.opensubjectseq = tt.opensubjectseq
order by st.studentseq;


---------------------------------------------------------------------------------------------------------------------------------

--M_007. 출결 관리 및 출결 조회
/*
[메인] > [관리자] > [출결 관리 및 출결 조회]

1. [전체 개설 과정]
  - 개설된 모든 과정의 정보를 출력한다.
    - 개설 과정 고유 번호
    - 과정명을 출력한다.
    - 과정 시작 날짜
    - 과정 종료 날짜
    - 강의실
    - 교사
    - 교육생등록인원
    - 개설과목등록여부

*/

select
    oc.openCourseSeq as 개설과정고유번호,
    tc.name as 과정명,
    oc.begindate as 과정시작날짜,
    oc.enddate as 과정종료날짜,
    cr.name as 강의실명,
    t.name as 교사명,
    oc.registercount as 교육생등록인원,    
    oc.registrationstatus as 개설과목등록여부
from tblOpenCourse oc
    inner join tblTotalCourse tc
        on oc.totalCourseSeq = tc.totalCourseSeq
            inner join tblClassroom cr
                on cr.classroomSeq = oc.classroomSeq
                    inner join tblTeacher t
                        on oc.teacherSeq = t.teacherSeq;

/*

[메인] > [관리자] > [출결 관리 및 출결 조회] > [전체 개설 과정]

1.1 [특정 개설 과정의 전체 교육생]
  - 전체 교육생의 정보를 출력한다.
    - 교육생 고유 번호
    - 교육생 이름
    - 교육생 주민번호 뒷자리
    - 교육생 전화번호
    - 교육생 등록일

*/
--전체개설과정을 듣는 전체교육생정보 조회
select
    tc.name as 개설과정명,
    s.studentseq as 교육생고유번호,
    s.name as 교육생이름,
    s.ssn as 주민번호뒷자리,
    s.phonenumber as 전화번호,
    s.enrolldate as 등록일
from tblEnrollment e
    inner join tblOpenCourse oc
        on oc.openCourseSeq = e.openCourseSeq
            inner join tblTotalCourse tc
                on tc.totalcourseseq = oc.totalcourseseq
                    inner join tblStudent s
                        on s.studentSeq = e.studentSeq;

--특정개설과정 > 전체교육생정보
--3번 개설과정을 듣는 전체 교육생 정보 조회
select
    tc.name as 개설과정명, 
    s.studentseq as 교육생고유번호,
    s.name as 교육생이름,
    s.ssn as 주민번호뒷자리,
    s.phonenumber as 전화번호,
    s.enrolldate as 등록일
from tblEnrollment e
    inner join tblOpenCourse oc
        on oc.openCourseSeq = e.openCourseSeq
            inner join tblTotalCourse tc
                on tc.totalcourseseq = oc.totalcourseseq
                    inner join tblStudent s
                        on s.studentSeq = e.studentSeq
                            where oc.openCourseSeq = 3; -- 3번 개설과정

/*
[메인] > [관리자] > [출결 관리 및 출결 조회] > [전체 개설 과정] > [특정 개설 과정의 전체 교육생]

1.1.1 [특정 개설 과정의 특정 교육생 조회]
    - 특정 교육생의 전체 기간의 정보를 출력한다. 
      - 날짜
      - 근태 상태
*/
-- 특정 개설과정(3과정)을 듣는 특정 교육생(61번) 출결 조회
select
    tc.name as 개설과정명,
    s.name as 교육생이름,
    a.attendancedate as 출석날짜,
    a.condition as 근태상태
from tblEnrollment e
    inner join tblOpenCourse oc
        on oc.openCourseSeq = e.openCourseSeq
            inner join tblTotalCourse tc
                on tc.totalcourseseq = oc.totalcourseseq
                    inner join tblStudent s
                        on s.studentSeq = e.studentSeq
                            inner join tblAttendance a
                                on a.studentseq = s.studentseq
                                    where oc.openCourseSeq = 3 and s.studentseq = 61; -- 3번 개설과정
/*
[메인] > [관리자] > [출결 관리 및 출결 조회] > [전체 개설 과정] 
    > [특정 개설 과정의 전체 교육생] > [특정 개설 과정의 특정 교육생 조회]

1.1.1.1 [기간 검색]
      - 특정 교육생의 특정 기간의 출결 정보를 출력한다.
        - 날짜
        - 근태 상태
*/
-- 특정 개설과정(3과정)을 듣는 특정 교육생(61번)의 5월 달 출결 조회
select
    tc.name as 개설과정명,                
    s.name as 교육생이름,
    a.attendancedate as 출석날짜,
    a.condition as 근태상태
from tblEnrollment e
    inner join tblOpenCourse oc
        on oc.openCourseSeq = e.openCourseSeq
            inner join tblTotalCourse tc
                on tc.totalcourseseq = oc.totalcourseseq
                    inner join tblStudent s
                        on s.studentSeq = e.studentSeq
                            inner join tblAttendance a
                                on a.studentseq = s.studentseq
                                    where oc.openCourseSeq = 3 
                                        and s.studentseq = 61 
                                        and a.attendancedate between '21/05/01' and '21/05/31'; -- 3번 개설과정


/*
[메인] > [관리자] > [출결 관리 및 출결 조회] > [전체 개설 과정] 
    > [특정 개설 과정의 전체 교육생] > [특정 개설 과정의 특정 교육생 조회]
    
1.1.1.2 [날짜 검색]
      - 특정 교육생의 특정 날짜의 출결 정보를 출력한다.
        - 날짜
        - 입실시간
        - 퇴실시간
        - 근태 상태
*/
-- 특정 개설과정(3과정)을 듣는 특정 교육생(61번)의 특정날짜 출결 조회
select
    tc.name as 개설과정명,                
    s.name as 교육생이름,
    a.attendancedate as 출석날짜,
    a.intime as 입실시간,
    a.outtime as 퇴실시간,
    a.condition as 근태상태
from tblEnrollment e
    inner join tblOpenCourse oc
        on oc.openCourseSeq = e.openCourseSeq
            inner join tblTotalCourse tc
                on tc.totalcourseseq = oc.totalcourseseq
                    inner join tblStudent s
                        on s.studentSeq = e.studentSeq
                            inner join tblAttendance a
                                on a.studentseq = s.studentseq
                                    where oc.openCourseSeq = 3  -- 3번 개설과정
                                        and s.studentseq = 61   -- 교육생 고유번호 61번
                                        and a.attendancedate = '21-06-01'; -- 특정 날짜


/*
[메인] > [관리자] > [출결 관리 및 출결 조회] > [전체 개설 과정] 
    > [특정 개설 과정의 전체 교육생] > [특정 개설 과정의 특정 교육생 조회] > [날짜검색]
    
1.1.1.2.1 [출결 관리]
- 특정교육생의 특정날짜의 출결 정보를 수정, 추가, 삭제할 수 있다.
    - 출결 고유번호
    - 교육생 고유번호
    - 날짜
    - 입실/퇴실 시간
    - 근태상태

*/

select
    tc.name as 개설과정명,
    s.name as 교육생이름,
    a.attendancedate as 출석날짜,
    a.intime as 입실시간,
    a.outtime as 퇴실시간,
    a.condition as 근태상태
from tblEnrollment e
    inner join tblOpenCourse oc
        on oc.openCourseSeq = e.openCourseSeq
            inner join tblTotalCourse tc
                on tc.totalcourseseq = oc.totalcourseseq
                    inner join tblStudent s
                        on s.studentSeq = e.studentSeq
                            inner join tblAttendance a
                                on a.studentseq = s.studentseq
                                    where oc.openCourseSeq = 3 
                                        and s.studentseq = 61 
                                        and a.attendancedate = to_char(sysdate, 'yy-mm-dd'); -- 3번 개설과정


/*
[메인] > [관리자] > [출결 관리 및 출결 조회] > [전체 개설 과정] 
    > [특정 개설 과정의 전체 교육생] > [특정 개설 과정의 특정 교육생 조회] > [날짜검색] > [출결 관리]
-수정

update tblAttendance set
    AttendanceDate = 출결날짜, 
    inTime = 입실시간,
    outTime = 퇴실시간,
    condition = 근태상태
        where studentSeq = 학생고유번호;
*/
-- 특정교육생의 출결상태 수정 > 교육생의 입퇴실 시간을 확인하고 출결상태를 수정해준다.(당일)
select * from tblAttendance where AttendanceDate = to_char(sysdate, 'yy-mm-dd') and studentseq = 61 and condition = '기타';

update tblAttendance set
    condition = '정상'
        where AttendanceDate = to_char(sysdate, 'yy-mm-dd')
            and studentseq = 61
            and condition = '기타';

            
/*
[메인] > [관리자] > [출결 관리 및 출결 조회] > [전체 개설 과정] 
    > [특정 개설 과정의 전체 교육생] > [특정 개설 과정의 특정 교육생 조회] > [날짜검색] > [출결 관리]

-삭제

*/
--delete from tblAttendance where attendaceSeq = 출결고유번호;

delete from tblAttendance where studentSeq = 61 and atattendancedate = to_char(sysdate, 'yy-mm-dd');

---------------------------------------------------------------------------------------------------------
--M_008. 구인공고 관리(조회)

/*
[메인] > [관리자] > [구인공고 관리] 

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
[메인] > [관리자] > [구인공고 관리] > [전체 구인공고 조회]

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
--특정 구인공고(1번)에 대한 상세정보 출력한다
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

/*
[메인] > [관리자] > [구인공고 관리] > [전체 구인공고 조회] > [특정 구인공고 조회]

  1.2 [특정 구인공고 수정]
      - 특정 구인 공고 정보 수정한다.
        - 회사명
        - 채용분야
        - 채용 시작 날짜
        - 채용 종료 날짜
        - 경력
        - 학력
        - 연봉
        - 근무지역

*/
--특정 구인공고(1번)에 대한 상세정보 수정한다
/*
update tblJobPost set
    companyName = '회사명',
    recruitField = '분야',
    recruitBegin = '채용시작날짜',
    recruitEnd = '채용 종료날짜',
    career = '경력',
    educationLevel = '학력',
    annualIncom = 연봉,
    workArea = '근무지'
    where j.jobpostseq = 1;
*/
update tblJobPost set
    companyName = '로지올'
   where jobpostseq = 1;
 
/*
[메인] > [관리자] > [구인공고 관리] > [전체 구인공고 조회] > [특정 구인공고 조회]

1.3 [특정 구인공고 삭제]
      - 특정 구인 공고 정보 삭제한다.
- 해당 구인공고 정보는 테이블에서 제거된다.

*/
delete from tblJobPost where jobpostseq = 17;

   
 /*
[메인] > [관리자] > [구인공고 관리]
 
 2 [구인공고 추가]
    - 구인공고 정보 입력한다.
- 공고번호
        - 회사명
        - 채용분야
        - 채용 시작 날짜
        - 채용 종료 날짜
        - 경력
        - 학력
        - 연봉
        - 근무지역
        - 근무일시
        - 전형절차 수

 */
--구인공고 추가
-- 구인공고고유번호, 분야, 회사명, 채용시작날짜, 채용종료날짜, 경력, 학력, 연봉, 근무지역, 근무일시, 전형수
INSERT INTO tblJobPost (jobPostSeq, recruitField, companyName, recruitBegin, recruitEnd, career, educationLevel, annualIncom, workArea, workTime, selectionCount) values (jobPostSeq.nextVal, 'IT', '쌍용', '2021/06/03', '2021/06/30', '신입', '대졸/전문대졸', '면접시 협의', '서울', '판교', '3');
----------------------------------------------------------------------------------------------------

--M00_9. 자격증 일정관리

/*
[메인] > [관리자] > [자격증 일정 관리]

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
[메인] > [관리자] > [자격증 일정 관리] > [전체 자격증 목록 조회]

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

/*
[메인] > [관리자] > [자격증 일정 관리] > [전체 자격증 목록 조회] > [특정 자격증 정보]

 1.1.1. [자격증 정보 수정]
  - 특정 자격증을 선택한다.
  - 변경할 내용 입력
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

update tblLicense set
    name = '자격증명',
    licenseType = '자격종류',
    --..
    where j.jobpostseq = 1;
*/

    
update tblLicense set
    name = '정보관리기술사',
    licenseType = '국가기술자격'
    --..
    where licenseSeq = 1;


/*
[메인] > [관리자] > [자격증 일정 관리]

2. [자격증 목록 추가]
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
-- 자격증 추가
INSERT INTO tblLicense (licenseSeq, name, licenseType, testAgency, round, receptionFee, writtenRegisterBegin, writtenRegisterEnd, writtenTestDate, writtenResultDate, practicalRegisterBegin, practicalRegisterEnd, practicalTestDate, practicalResultDate) values (licenseSeq.nextVal, '정보관리기술사', '국가기술자격', '한국산업인력공단', '125회', '67800', '2021/07/06', '2021/07/09', '2021/07/31', '2021/09/10', '2021/09/13', '2021/09/16', '2021/10/16 ~ 2021/10/26', '2021/11/12');


/*
[메인] > [관리자] > [자격증 일정 관리] > [전체 자격증 목록 조회] > [특정 자격증 정보]

3. [자격증 정보 삭제]
- 선택한 자격증의 데이터를 모든 테이블에서 삭제한다.

*/
-- 특정 자격증 정보 삭제
delete from tblLicense where licenseSeq = 1;

-------------------------------------------------------------------------------------------




--------------------------[관리자, 취업현황]-----------------------------------
--M010_취업현황
/*
[메인] > [관리자] > [취업 현황 관리] > [전체 과정 조회]
- 전체 과정의 목록을 출력한다.
    - 과정 고유번호
    - 교육생 정원
    - 과정명
    - 과정 시작 날짜
    - 과정 종료 날짜
*/

select
    oc.openCourseSeq as "개설과정 고유번호",       --개설과정고유번호
    oc.registercount as "교육생등록인원" ,         --교육생등록인원
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
    cs.completeStudentSeq as "종료교육생고유번호",
    st.name as "교육생 이름",            --교육생 이름
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

/*
[메인] > [관리자] > [취업 현황 관리] > [전체 과정 조회] > [특정 과정 조회] > [취업 현황 추가]
- 특정 과정을 수강했던 교육생 목록을 추가한다.
    - 회사 이름
    - 분야
    - 연봉
    - 근무지역
    - 교육종료교육생고유번호
*/
--INSERT INTO tblemployment (employmentSeq, companyName, annualincome, area, completestudentseq) VALUES (employmentSeq.nextval,'회사이름','연봉','근무지역', 교육종료교육생고유번호);


/*
[메인] > [관리자] > [취업 현황 관리] > [전체 과정 조회] > [특정 과정 조회] > [취업 현황 수정]
- 특정 과정을 수강했던 교육생 목록을 수정한다.
    - 회사 이름
    - 분야
    - 연봉
    - 근무지역
    - 교육종료교육생고유번호
*/
--update tblemployment set
--    companyName = '회사이름', 
--    annualincome = '연봉', 
--    area = '근무지역'
--where completestudentseq = 교육종료교육생 번호;


/*
[메인] > [관리자] > [취업 현황 관리] > [전체 과정 조회] > [특정 과정 조회] > [취업 현황 삭제]
- 선택한 특정 교육생의 취업 현황 데이터를 모든 테이블에서 삭제한다.
    - 회사 이름
    - 분야
    - 연봉
    - 근무지역
*/
--delete from tblemployment where completestudentseq = 교육종료교육생 번호;


                                        
--------------------------[관리자, 상담일지]-----------------------------------      
--M_011 상담일지
/*
[메인] > [관리자] > [상담일지] 

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
[메인] > [관리자] > [상담일지] 
1.1. [전체 개설과정 조회] > [특정 개설 과정 별 교육생 조회]
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






--------------------------[관리자, 만족도 조사]-----------------------------------  
--M012_만족도조사
/*
[메인] > [관리자] > [만족도 조사 결과 조회]

1. [전체 개설 과정 조회 - 강의평가]
    - 개설 과정 고유 번호
    - 개설 과정 이름
    - 개설 과정 시작 날짜
    - 개설 과정 종료 날짜
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
[메인] > [관리자] > [만족도 조사 결과 조회]

1.1 [전체 개설 과정 조회 - 강의평가] > [특정 개설 과정 조회]
        - 개설 과목 이름
        - 개설 과목 기간(시작 년월일)
        - 개설 과목 기간(종료 년월일)
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
[메인] > [관리자] > [만족도 조사 결과 조회]

1.1.1. [전체 개설 과정 조회 - 강의평가] > [특정 개설 과정 조회] > [특정 과목 조회]
            - 강의평가 고유번호
            - 과목 이름
            - 교육생이름
            - 평가 내용
            - 만족도(점수) -> 만족도(점수) 전체 평균
*/
select
    cs.coursesurveyseq as "강의평가 고유번호",
    ts.name as "개설과목이름",
    s.name as "교육생이름",
    cs.surveycomment as "평가내용",
    cs.score as "점수"
    
from tblenrollment en
    inner join tblstudent s
    on en.studentseq = s.studentseq
        inner join tblcoursesurvey cs
        on en.enrollmentseq = cs.enrollmentseq
            inner join tblopensubject os
            on cs.opensubjectseq = os.opensubjectseq
                inner join tbltotalsubject ts
                on os.totalsubjectseq = ts.totalsubjectseq
                    where os.opensubjectseq = 1; --개설과목고유번호 입력


/*
[메인] > [관리자] > [만족도 조사 결과 조회]

1.1.1.1. [전체 개설 과정 조회 - 강의평가] > [특정 개설 과정 조회] > [특정 과목 조회] > [특정 과목 삭제]
          - 선택한 특정 과목의 데이터를 모든 테이블에서 삭제한다.
*/
delete from tblcoursesurvey where coursesurveyseq = 1; --강의평가고유번호 입력


/*
[메인] > [관리자] > [만족도 조사 결과 조회]

2. [전체 개설 과정 조회 - 교사평가]
    - 개설 과정 고유 번호
    - 개설 과정 이름
    - 개설 과정 시작 날짜
    - 개설 과정 종료 날짜
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
[메인] > [관리자] > [만족도 조사 결과 조회]

2.1. [전체 개설 과정 조회 - 교사평가] > [특정 개설 과정 조회]
        - 개설 과정 이름
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

/*
[메인] > [관리자] > [만족도 조사 결과 조회]

2.1.1 [전체 개설 과정 조회 - 교사평가] > [특정 개설 과정 조회] > [특정 교사평가 삭제]
          - 선택한 특정 교사평가 데이터를 모든 테이블에서 삭제한다.  
*/
delete from tblteachersurvey where teachersurveyseq = 1; --특정교사평가 고유번호를 입력한다.

----------------------------------------------------
--M013 교육종료교육생

--[메인] > [관리자] > [교육 종료 교육생 관리]


--1.[기간 선택]
-- - 과정명 ( 과정
-- - 과정종료날짜

--조회

select
    tc.totalcourseseq as 과정고유번호, 
    tc.name as 과정명,
    oc.endDate as 종료날짜
from tblOpenCourse oc
    inner join tblTotalCourse tc
        on tc.totalCourseSeq = oc.totalCourseSeq
    where oc.endDate < to_char(sysdate, 'yy-mm-dd');




select 
    tc.name as "해당과정",
    oc.endDate as "과정종료날짜",
    st.studentseq as "고유번호",
    st.name as "이름",
    st.birth as "생년월일",
    st.phoneNumber as "전화번호",
    cs.completeDate as "수료날짜",
    cs.condition as "수료여부"
from tblstudent st
    inner join tblenrollment en
        on st.studentseq = en.studentseq
            inner join tblcompletestudent cs
                on cs.enrollmentseq = en.enrollmentseq
                    inner join tblOpenCourse oc
                    on en.openCourseSeq = oc.openCourseSeq
                        inner join tblTotalCourse tc
                        on tc.totalCourseSeq = oc.totalCourseSeq
                    where st.condition in ('수료완료','중도탈락') and tc.totalCourseSeq =1 ;                    
                    
                
                
-- 추가
--            values (studentSeq.nextVal, 변소윤, '2159972', '010-8703-1213', '2020-09-01', '수료완료','null');
--INSERT INTO tblStudent (studentSeq, name, ssn, phoneNumber, condition) 

--고유번호, 수료날짜, 수료상태, 수강신청고유번호


 
update tblstudent set 
    condition = '수료완료'
        where studentSeq = 추가할 학생의 고유번호;
       
        --프로시저로 도전

INSERT INTO tblCompleteStudent(completeStudentSeq, completeDate, condition, enrollmentSeq)
            VALUES(completeStudentSeq.nextval, '2020-08-26', '수료완료', 30);                   
            
           

-- 수정
update tblCompleteStudent set
    completeDate = '원하는데이터', 
    condition = '원하는데이터'
        where completeStudentSeq = 종료된학생고유번호;



--삭제 - 취업현황 교육종료교육생..

delete from tblCompleteStudent where studentSeq = 삭제할 학생의 고유번호;
delete from tblEmployment where studentSeq = 삭제할 학생의 고유번호;



--2. 과정추가 
--    
--  - 교육 종료 과정입력
--     - 과정명
--     - 과정 종료 날짜

INSERT INTO tblTotalCourse(totalCourseSeq, name, period)
            VALUES(totalCourseSeq.nextval, '과정명', '과정기간');
        

INSERT INTO tblOpenCourse(openCourseSeq, beginDate, endDate, registerCount, teacherSeq,totalCourseSeq,classroomSeq)
            VALUES(openCourseSeq.nextval, '과정시작기간', '과정종료기간','교육생등록인원',teacherSeq,totalCourseSeq,classroomSeq);

----------------------------------------------------------------
--M014 교재관리

 /*
 [메인] > [관리자] > [교재관리]
1. 교재관리
 전체 교재 목록 조회.
- 교재 고유번호
- 교재명
- 출판사
- 저자
- 가격
*/

select 
    allBookSeq as "교재고유번호",
    name as "교재명",
    publisher as "출판사",
    writer as "저자",
    price as "가격"
from tblAllBook;


/*
1.1 [사용교재 선택]
  - 전체 교재 중 사용할 교재 선택.
- 교재 고유번호
- 교재명
- 출판사
- 저자
- 가격
- 과목명
*/


select 
    ab.allBookSeq as "교재고유번호",
    ab.name as "교재명",
    ab.publisher as "출판사",
    ab.writer as "저자",
    ab.price as "가격",
    ts.name as "과목명"
from tblAllBook ab
    inner join tblUsedBook ub
     on ub.allbookseq = ab.allbookseq
        inner join tblTotalSubject ts
        on ts.totalsubjectseq = ub.totalsubjectseq
            where ts.totalSubjectSeq = 1;
        
        
/*
1.2 [교재 추가]
-   추가할 교재 입력
- 교재 고유번호
- 교재명
- 출판사
- 저자
- 가격

*/

INSERT INTO tblAllBook(allBookSeq, name, publisher, writer,price)
            VALUES(allBookSeq.nextval, '책이름', '출판사', '저자','가격');
        

              
INSERT INTO tblUsedBook(usedBookSeq, totalSubjectSeq, allBookSeq)
            VALUES(usedBookSeq.nextval, totalSubjectSeq, allBookSeq);
          -- 전체 교재에 추가하고 이 작업 실행 
          -- 필요한 과목으로 totalSubjectSeq 설정 



/*   1.4 [교재 수정]
-   수정할 교재내용 입력
- 교재 고유번호
- 교재명
- 출판사
- 저자
- 가격
*/


update tblAllBook set
    name = '원하는데이터', 
    publisher = '원하는데이터',
    writer = '원하는데이터',
    price  = '원하는데이터'
        where allBookSeq = 원하는 교재 고유번호;



