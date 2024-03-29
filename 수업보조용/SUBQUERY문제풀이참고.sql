--------------------------------------------------------------------------------
-- 서브쿼리 실습문제 --

-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외)
--    사번, 사원명, 전화번호, 고용일, 부서명
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE 
                   WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';



-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의 
--    사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.
SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE
                WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000);

               
               

-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
--    사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
NATURAL JOIN JOB -- 자연 조인 (컬럼명, 데이터 타입 일치하는 두 컬럼을 연결)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE
                               WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철'; 




-- 4. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회하시오
--    사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) 
     = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE
        WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000  );
       

       
       
-- 5. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
--    사번, 이름, 부서코드, 사수번호, 주민번호, 고용일     
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE                  
WHERE (DEPT_CODE, MANAGER_ID)
    = (SELECT DEPT_CODE, MANAGER_ID 
       FROM EMPLOYEE
       WHERE SUBSTR(EMP_NO,1,2) = '77'
       AND SUBSTR(EMP_NO,8,1) = '2'); -- 전지연

      
      
      

-- 6. 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회.
SELECT DEPT_CODE, EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'),JOB_NAME, HIRE_DATE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE HIRE_DATE IN (SELECT MIN(HIRE_DATE) 
                        FROM EMPLOYEE
                        WHERE ENT_YN != 'Y'
                        GROUP BY DEPT_CODE)
-- AND ENT_YN != 'Y' -- 여기서 사용할 조건이 아님
ORDER BY HIRE_DATE;
-- 부서별로 그룹을 묶을때 퇴사한 직원을 이때 제외해야 함
-- 부서별로 가장빠른입사자를 구했을때 D8부서는 이태림임.(이태림 퇴사함)
-- 문제점 : 부서별로 가장빠른입사자 구해놓고, 메인쿼리에서 퇴사자 제외해버리면
-- D8부서는 퇴사자인 이태림이 가장빠른입사자이기 때문에 제외되고, 
-- 전체 부서중에서 D8부서가 제외되어버림.
--> 부서별 가장빠른입사자 구할 때 퇴사한 직원 뺀 상태에서 그룹으로 묶으면
--> D8부서의 가장빠른입사자는 이태림제외 후 전형돈이 됨.



-- 7. 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호


SELECT EMP_ID, EMP_NAME, JOB_NAME,
    FLOOR (MONTHS_BETWEEN(SYSDATE, TO_DATE( SUBSTR(EMP_NO, 1, 6), 'RRMMDD') ) / 12) "만 나이",
    TO_CHAR(  SALARY * (1 + NVL(BONUS, 0))  * 12 , 'L999,999,999') "보너스 포함 연봉"
FROM EMPLOYEE E1 
NATURAL JOIN JOB
WHERE EMP_NO IN (SELECT MAX(EMP_NO) FROM EMPLOYEE GROUP BY JOB_CODE)
ORDER BY "만 나이" DESC;










