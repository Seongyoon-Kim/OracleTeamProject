--[함수]

-- [성별 구분 함수]---------------------------------------------------------
create or replace function fnGender(
    pssn varchar2
)return varchar2
is
begin
    return case
                when substr(pssn, 1, 1) = '1' then '남자'
                when substr(pssn, 1, 1) = '2' then '여자'
           end;
end fnGender;


--2. 출석 + 필기 + 실기 총 점수 출력(함수)
create or replace function fnTotalScore(
    stSeq number,
    suSeq number    
)return number
is
    writing number;
    practice number;
    attendance number;
    sresult number;
begin
    select
        sc.hasdwritingscore,
        sc.practicescore,
        sc.attendanceScore into writing, practice, attendance
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
        where os.opensubjectseq = suSeq and s.studentseq = stSeq;
        
        sresult := writing + practice + attendance;
        
        return sresult;
    
end fnTotalScore;


select
    s.name as 이름,
    fnTotalScore(s.studentSeq, 13) as 총점수
from tblStudent s where fnTotalScore(s.studentSeq, 13) is not null;


--[익명으로 이름을 변경해주는 함수]---------------------------------------------------------
 select name, fnanony(name) from tblstudent where studentseq = 1;

create or replace function fnAnony(
    fname varchar2
)return varchar2
is
begin
    return substr(fname, 1, 1) || 'OO';
end fnAnony;



select
    tc.name as 과정명,
    oc.beginDate as 과정시작기간,
    cr.name as 강의실이름,
    oc.registerCount as 교육생등록인원,
    cr.limitCount as 수용인원
from tblOpenCourse oc
    inner join tblClassroom cr
        on cr.classroomSeq = oc.classroomSeq
            inner join tblTotalCourse tc
                on tc.totalCourseSeq = oc.totalCourseSeq;



--[생년월일별로 연령대를 출력하는 함수 ]---------------------------------------------------------
/
create or replace function fnAge(
    pbirth varchar2 
) return varchar2 
is
begin

    return case  
        when substr((to_char(sysdate,'yyyy') - substr(pbirth,1,4)) ,1,1) = '1' then  '10대' 
        when substr((to_char(sysdate,'yyyy') - substr(pbirth,1,4)) ,1,1) = '2' then  '20대' 
        when substr((to_char(sysdate,'yyyy') - substr(pbirth,1,4)) ,1,1) = '3' then  '30대' 
        when substr((to_char(sysdate,'yyyy') - substr(pbirth,1,4)) ,1,1) = '4' then  '40대' 
        when substr((to_char(sysdate,'yyyy') - substr(pbirth,1,4)) ,1,1) = '5' then  '50대' 
    end;
end fnAge;
/


select name, fnAge(birth) from tblStudent;