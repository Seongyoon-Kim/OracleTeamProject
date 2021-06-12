-- [해당 과목의 배점 정보를 등록하면 그 사실을 알려주는 트리거입니다.]
create or replace trigger trgSubjectDistribution
    after
    insert
    on tblTest
    for each row
begin

    dbms_output.put_line('추가트리거 발생: ' || to_char(sysdate, 'hh24:mi:ss'));
    dbms_output.put_line('새로 추가된 시험번호: ' || :new.testSeq);
    dbms_output.put_line('새로 추가된 시험날짜: ' || :new.testDate);
    dbms_output.put_line('새로 추가된 필기배점: ' || :new.handWritingDistribution);
    dbms_output.put_line('새로 추가된 실기배점: ' || :new.practiceDistribution);
    dbms_output.put_line('새로 추가된 출석배점: ' || :new.AttendanceDistribution);
    dbms_output.put_line('새로 추가된 개설과목: ' || :new.openSubjectSeq);
    dbms_output.put_line('새로 추가된 시험지등록번호: ' || :new.registrationStatusSeq);

end;
/
select * from tblTest;
--------------------------------------------------------------------------------------------------
-- [해당 과목의 배점 정보를 수정하면 그 사실을 알려주는 트리거입니다.]
create or replace trigger trgUpdateDistribution
    after
    update
    on tblTest
    for each row
begin

    dbms_output.put_line('수정트리거 발생: ' || to_char(sysdate, 'hh24:mi:ss'));
    dbms_output.put_line('수정 전 배점 정보: ' || :old.testdate || ' || ' || :old.handWritingDistribution || ' || ' || :old.practiceDistribution || ' || ' || :old.attendanceDistribution || ' || ' || :old.openSubjectSeq);
    dbms_output.put_line('수정 후 배점 정보: ' || :new.testdate || ' || ' || :new.handWritingDistribution || ' || ' || :new.practiceDistribution || ' || ' || :new.attendanceDistribution || ' || ' || :new.openSubjectSeq);

end;
/
select * from tbltest;


--------------------------------------------------------------------------------------------------
-- [종료교육생 삭제하는 트리거]
create or replace trigger trgDeleteComStudent
    before 
    delete on tblCompleteStudent
    for each row 
begin 
    dbms_output.put_line('교육종료교육생삭제 트리거 발생');
    --수강신청에서 삭제 
    delete from tblEmployment e where e.completeStudentSeq = :old.completeStudentSeq;

end;

--------------------------------------------------------------------------------------------------
--[이상출결을 입력하는 트리거 입니다.]
create or replace trigger trgEditAttendance
    after
    update on tblattendance
    for each row
begin
    if :new.condition in ('지각', '조퇴', '외출') then
    insert into AttendenceCheck values (attendenceSeq.nextVal, :new.studentseq, :new.attendancedate, :new.condition);
end;



--------------------------------------------------------------------------------------------------
--[출결배점이 20점 미만일때 delete 시켜주는 트리거입니다.]
create or replace trigger trgTest 
    after  
    insert 
    on tblTest -- 시험 테이블에서 insert된 후에...
declare 
    vnum number;
    vresult number;
    
begin

    select testseq into vnum from tblTest where testseq = (select max(testSeq) from tblTest);

    select attendanceDistribution into vresult from tblTest where testSeq = vnum;
    
    if vresult < 20 then
        dbms_output.put_line('출결점수가 20점 미만이면 안됩니다.');
        
        delete from tblTest where testSeq = vnum;
        
    end if;
    
exception
    when others then
          dbms_output.put_line('실패');      

end trgTest;



--------------------------------------------------------------------------------------------------
--[기본 출력 결석 입력 트리거]
create or replace trigger trgEditAttendance
    before
    insert on tblattendance 
declare
    regdate varchar2(20);
begin
    select max(to_char(attendancedate, 'yy-mm-dd')) into regdate from tblattendance;
        
    if regdate <> to_char(sysdate, 'yy-mm-dd') then
    update tblattendance set
        condition = '결석'
            where condition = '기타' 
            and 
            regdate <> to_char(sysdate, 'yy-mm-dd') and attendancedate = regdate;
   end if;
end;
