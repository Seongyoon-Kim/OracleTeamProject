-- DML_교사_트리거

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
---------------------------------------------------------------------------------------------------
