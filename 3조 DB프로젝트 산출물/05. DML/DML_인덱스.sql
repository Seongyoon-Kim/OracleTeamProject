-- DML_인덱스

-- [출결테이블의 데이터가 많고, 출결 테이블의 출결날짜를 사용하는 테이블이 많기 때문에 출결날짜 인덱스를 생성함.]
create index idx_tblAt_attendanceDate
    on tblAttendance(attendanceDate);
    
-- [취업현황에서 높은 연봉을 받는 교육생들을 좀 더 쉽게 찾아보기 위함.]
create index idx_tblemployment_Income on tblemployment(annualIncome);
select * from tblemployment where annualIncome > 3300;

-- [교육생 테이블의 데이터가 많고, 교육생 번호를 사용하는 테이블이 많기 때문에 교육생 번호 인덱스를 생성함.]