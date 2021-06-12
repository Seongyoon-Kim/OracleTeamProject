-- DML_함수

--익명으로 이름을 변경해주는 함수
 select name, fnanony(name) from tblstudent where studentseq = 1;

create or replace function fnAnony(
    fname varchar2
)return varchar2
is
begin
    return substr(fname, 1, 1) || 'OO';
end fnAnony;

