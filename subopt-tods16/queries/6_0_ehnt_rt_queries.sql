-- Writer      : Young-Kyoon Suh
-- Date        : 02/18/13
-- Description : Define analysis queries to extract times taken to complete the exhaustive runs
-- labshelf 6.0

-- DBMSes used in our analysis. 
-- EHNT_RT_Analysis_Dmd_Ver1 : Exhaustive_RunTime_Analysis_DBMS_Metadata
DROP TABLE EHNT_RT_Analysis_Dmd_Ver1;
CREATE TABLE EHNT_RT_Analysis_Dmd_Ver1 	-- Primary key is a dbms.
(
	dbmsName	VARCHAR2(10) NOT NULL PRIMARY KEY, -- dbms name
	loadingHours	NUMBER (10, 3)  		   -- loading time
);
INSERT INTO EHNT_RT_Analysis_Dmd_Ver1 VALUES ('db2',    1.0);  
INSERT INTO EHNT_RT_Analysis_Dmd_Ver1 VALUES ('oracle', 0.53);    
INSERT INTO EHNT_RT_Analysis_Dmd_Ver1 VALUES ('pgsql',  0.1);     
INSERT INTO EHNT_RT_Analysis_Dmd_Ver1 VALUES ('mysql',  0.017);    
INSERT INTO EHNT_RT_Analysis_Dmd_Ver1 VALUES ('teradata',  0.2);  
INSERT INTO EHNT_RT_Analysis_Dmd_Ver1 VALUES ('sqlserver',  0.1); 

-- create a table for runs 
-- EHNT_RT_Chosen_Runs_Ver1 : Exhaustive_RunTime_Chosen_Runs
DROP TABLE EHNT_RT_Chosen_Runs_Ver1;
CREATE TABLE EHNT_RT_Chosen_Runs_Ver1 AS -- Primary key is runid.
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	WHERE runid IN (696,697,699,703) -- runs
	ORDER BY runid;
ALTER TABLE EHNT_RT_Chosen_Runs_Ver1 ADD PRIMARY KEY (runid);

-- Step 0 : Get the transaction time when each cardinality/query is done with its study
-- EHNT_RT_S0_Analysis_Ver1 : Exhaustive_RunTime_Step0_Analysis_Ver1
DROP VIEW EHNT_RT_S0_Analysis_Ver1;
CREATE VIEW EHNT_RT_S0_Analysis_Ver1 AS 	-- Primary key is a query execution: (qeid)
	SELECT er.DBMS as dbmsName,
	       ex.experimentname as exprName,
	       rl.runid,
	       ROW_NUMBER() OVER ( ORDER BY 1 ) AS rnum, 
	       rl.transactiontime as current_time,
	       rl.currentstage
	from azdblab_runlog rl, 
	     azdblab_experimentrun er, 
	     azdblab_experiment ex,
	     EHNT_RT_Chosen_Runs_Ver1 EHNT_RT_runs
	where EHNT_RT_runs.runid = rl.runid
	  and rl.runid = er.runid 
	  and er.experimentid = ex.experimentid
	  and ((ex.experimentname like '%wt%' and (rl.currentstage like 'Done with%' or rl.currentstage like '%Populating Variable Tables%')) or (ex.experimentname like '%op%' and (rl.currentstage like 'Analyzing Query%' or rl.currentstage like '%Done with the max table population%')))
	order by dbmsName, exprName, runid, current_time;
ALTER VIEW EHNT_RT_S0_Analysis_Ver1 ADD PRIMARY KEY (runid, rnum) DISABLE;

-- Step 1 : Get the time to complete each cardinality/query using an "interval" between tasks
-- EHNT_RT_S1_Analysis_Ver1 : Exhaustive_RunTime_Step1_Analysis_Ver1
DROP VIEW EHNT_RT_S1_Analysis_Ver1;
CREATE VIEW EHNT_RT_S1_Analysis_Ver1 AS 
	SELECT t1.dbmsName,
               t1.exprName,
	       t1.runid,
	       t1.currentstage,
	       t1.current_time-t0.current_time as diff
	FROM EHNT_RT_S0_Analysis_Ver1 t0,
	     EHNT_RT_S0_Analysis_Ver1 t1
	WHERE t0.runid = t1.runid 
	and t1.rnum >= 1
	and t1.rnum-1 = t0.rnum 
	and ((t1.exprName like '%wt%' and t1.currentstage like 'Done with%') or (t1.exprName like '%op%' and t1.currentstage like '%Analyzing Query%'))
	order by t1.runid, t1.rnum asc;
ALTER VIEW EHNT_RT_S1_Analysis_Ver1 ADD PRIMARY KEY (runid, currentstage) DISABLE;

-- Step 2 : Convert the interval to days/hours/minutes/seconds
-- EHNT_RT_S2_Analysis_Ver1 : Exhaustive_RunTime_Step2_Analysis_Ver1
DROP VIEW EHNT_RT_S2_Analysis_Ver1;
CREATE VIEW EHNT_RT_S2_Analysis_Ver1 AS 
	select  t2.dbmsName,
                t2.exprName,
                t2.runid,
	        t2.currentstage,
	        extract( day from t2.diff ) days,
	        extract( hour from t2.diff ) hours,
	        extract( minute from t2.diff ) minutes,
	        extract( second from t2.diff ) seconds
	from EHNT_RT_S1_Analysis_Ver1 t2;
ALTER VIEW EHNT_RT_S2_Analysis_Ver1 ADD PRIMARY KEY (runid, currentstage) DISABLE;

-- Step 3 : Translate the interval/times as hours
-- EHNT_RT_S3_Analysis_Ver1 : Exhaustive_RunTime_Step3_Analysis_Ver1
DROP VIEW EHNT_RT_S3_Analysis_Ver1;
CREATE VIEW EHNT_RT_S3_Analysis_Ver1 AS 
	SELECT t0.dbmsName,
	       t0.exprName,
               t0.runid,
	       --sum(days),
	       --sum(hours),
	       --sum(minutes),
	       --sum(seconds),
	       ((sum(days)*24)+sum(hours)+(sum(minutes)+round(sum(seconds)/60, 2))/60) as hours
	FROM EHNT_RT_S2_Analysis_Ver1 t0
	group by t0.dbmsName, t0.exprName, t0.runid;
ALTER VIEW EHNT_RT_S3_Analysis_Ver1 ADD PRIMARY KEY (runid) DISABLE;
--select * from EHNT_RT_S3_Analysis_Ver1;

-- Step 4 : Add the loading time per DBMS to the hours
-- EHNT_RT_S4_Analysis_Ver1 : Exhaustive_RunTime_Step4_Analysis_Ver1
DROP VIEW EHNT_RT_S4_Analysis_Ver1;
CREATE VIEW EHNT_RT_S4_Analysis_Ver1 AS 
	SELECT t0.dbmsName,
	       t1.exprName as orgExprName,
	       substr(t1.exprName,0,2) as exprName,
               runid,
	       hours+t0.loadingHours as hours
	FROM EHNT_RT_Analysis_Dmd_Ver1 t0,
	     EHNT_RT_S3_Analysis_Ver1 t1
        WHERE t0.dbmsName = t1.dbmsName;
ALTER VIEW EHNT_RT_S4_Analysis_Ver1 ADD PRIMARY KEY (runid) DISABLE;
-- view run hours per DBMS per run
SELECT * FROM EHNT_RT_S4_Analysis_Ver1; 

SELECT round(sum(hours),0)
FROM EHNT_RT_S4_Analysis_Ver1;

ROUND(SUM(HOURS),0)
-------------------
		28

-- view run hours per DBMS
SELECT dbmsName, 
       exprName,
       sum(hours) 
FROM EHNT_RT_S4_Analysis_Ver1 
GROUP BY dbmsName, exprName;
