
-- 한 줄 주석

/* 
 * 범위주석
 * 
 * */

-- 11G 버전 이전의 문법을 사용 가능하도록 함
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- CTRL + ENTER : 선택한 SQL 수행


-- 사용자 계정 생성
CREATE USER workbook IDENTIFIED BY workbook;


-- 사용자 계정에 권한 부여
GRANT RESOURCE, CONNECT TO workbook;

-- 객체가 생성될 수 있는 공간 할당량 지정
ALTER USER workbook DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;



