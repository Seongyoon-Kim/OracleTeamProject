-- DML_인덱스
-- [출결테이블의 데이터가 많고, 출결 테이블의 출결날짜를 사용하는 테이블이 많기 때문에 출결날짜 인덱스를 생성함.]
create index idx_tblAt_attendanceDate
    on tblAttendance(attendanceDate);