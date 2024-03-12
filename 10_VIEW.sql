/*
 * VIEW
 * - SELECT문의 실행 결과(RESULT SET)를 화면 저장하는 객체
 * - 논리적 가상 테이블 
 * --> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있지는 않음.
 * 
 * ** VIEW 사용 목적 **
 * 1) 복잡한 SELECT문을 쉽게 재사용하기 위해서 사용.
 * 2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리함.
 * 
 * **** VIEW 사용 시 주의사항 ****
 * 1) 가상 테이블(실제 테이블X) --> ALTER 구문 사용 불가
 * 2) VIEW를 이용한 DML(INSERT/UPDATE/DELETE)이
 *    가능한 경우도 있지만
 * 		많은 제약이 따르기 때문에 SELECT 용도로 사용 하는 것을 권장.
 * 
 * 
 * [VIEW 생성 방법]
 * CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름
 * AS SUBQUERY(만들고 싶은 뷰 모양의 SUBQUERY)
 * [WITH CHECK OPTION]
 * [WITH READ ONLY];
 * 
 * -- 1) OR REPLACE : 기존에 동일한 뷰이름이 존재하는 경우 덮어쓰고, 
 * 										존재하지 않으면 새로 생성.
 * 
 * -- 2) FORCE | NOFORCE
 * 	 			FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
 * 				NOFORCE : 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성(기본값)
 * 
 * -- 3) WITH CHECK OPTION : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함.
 * 
 * -- 4) WITH READ ONLY : 뷰에 대해 조회만 가능(DML 수행 불가)
 * 
 * 
 * */

-- 사번, 이름, 부서명, 직급명 조회 결과를 저장하는 VIEW 생성
CREATE VIEW V_EMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
	FROM EMPLOYEE
	JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	JOIN JOB USING(JOB_CODE);

-- ORA-01031: 권한이 불충분합니다
-- 1) SYS 관리자 계정 접속
-- 2) ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 3) GRANT CREATE VIEW TO kh_이니셜;
-- 4) 권한 부여 받은 kh 계정으로 접속하여 위 VIEW 생성구문 다시 실행

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

GRANT CREATE VIEW TO kh_cmh;



-- 생성된 VIEW를 이용하여 조회
SELECT * FROM V_EMP;


-------------------------------------------------------------


-- OR REPLACE 확인 + 별칭 등록
CREATE OR REPLACE VIEW V_EMP
AS SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 부서명, JOB_NAME 직급명
	FROM EMPLOYEE
	JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	JOIN JOB USING(JOB_CODE);


-- ORA-00955: 기존의 객체가 이름을 사용하고 있습니다. --> 이름중복
-- OR REPLACE 추가 후 실행 --> 성공
--> 기존 V_EMP를 새로운 VIEW 로 덮어쓰기


SELECT * FROM V_EMP;


---------------------------------------------------------------

-- * VIEW를 이용한 DML 확인 *

-- 테이블 복사
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY2;


-- 복사한 테이블을 이용해서 VIEW 생성
CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;


-- 뷰 생성 확인
SELECT * FROM V_DCOPY2;



-- 뷰를 이용한 INSERT 
INSERT INTO V_DCOPY2 VALUES('D0', 'L3'); -- 1행이 삽입되었음


-- 삽입 확인
SELECT * FROM V_DCOPY2; -- VIEW에 'D0'가 삽입된걸 확인함
--> 가상의 테이블인 VIEW에 데이터 삽입이 가능한걸까? NO

-- 원본 테이블 확인
SELECT * FROM DEPT_COPY2; -- 'D0',	NULL,	'L3'
--> VIEW 에 삽입한 내용이 원본 테이블에 존재함.
--> VIEW를 이용한 DML 구문이 원본에 영향을 미친다!


-- VIEW의 본래 목적인 보여지는 것(조회)이라는 용도에 맞게 사용하는게 좋다
--> WITH READ ONLY 옵션 사용
CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2
WITH READ ONLY; -- 읽기 전용 VIEW 생성(SELECT만 가능)


INSERT INTO V_DCOPY2 VALUES('D0', 'L3');
-- ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.


SELECT * FROM V_DCOPY2;




























