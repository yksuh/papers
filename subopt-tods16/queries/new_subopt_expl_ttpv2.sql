-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 06/29/15
-- Final Revision: 07/15/15
-- Description: Define tables/views for Tucson Timing Protocol Version 2 (TTPv2)

-- DBMSes used in our analysis
-- SOExpl_DMD: SOExpl_DBMS_Metadata
DROP TABLE SOExpl_Dmd CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_Dmd
(
	dbmsname	VARCHAR2(10) NULL PRIMARY KEY
);
INSERT INTO SOExpl_Dmd VALUES ('db2');
INSERT INTO SOExpl_Dmd VALUES ('oracle');
INSERT INTO SOExpl_Dmd VALUES ('pgsql');
INSERT INTO SOExpl_Dmd VALUES ('mysql');

-- DBMS and its query process used in our analysis
-- Note that postgres may use different names 
-- SOExpl_QMD: SOExpl_DBMS_Query_Process_Metadata
DROP TABLE SOExpl_Qmd CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_Qmd(
	dbmsname	VARCHAR2(10) REFERENCES SOExpl_Dmd(dbmsname) ON DELETE CASCADE,
	qprocname 	VARCHAR2(20) NOT NULL,
	PRIMARY KEY (dbmsname, qprocname)
);
INSERT INTO SOExpl_Qmd VALUES ('db2',    'db2sysc');
INSERT INTO SOExpl_Qmd VALUES ('db2',    'db2syscr');
INSERT INTO SOExpl_Qmd VALUES ('oracle', 'oracle');
-- we add the record below as symbolic name of 'postmaster'
INSERT INTO SOExpl_Qmd VALUES ('pgsql',  'postmaster');
--INSERT INTO SOExpl_Qmd VALUES ('pgsql',  'postgres');	
--INSERT INTO SOExpl_Qmd VALUES ('mysql',  'mysqld');
INSERT INTO SOExpl_Qmd VALUES ('mysql',  'mysqld_safe');

-- Utility Processes 
-- Note that db2 has utility processes with different names, while the other DBMSes - oracle, 
-- postgres, mysql - uses the same name for their utility 
-- process(es) as that of query process.
DROP TABLE SOExpl_Umd CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_Umd
(
	dbmsname 	VARCHAR2(10) REFERENCES SOExpl_Dmd(dbmsname) ON DELETE CASCADE,
	uprocname 	VARCHAR2(20) NOT NULL,
	PRIMARY KEY (dbmsname, uprocname)
);
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2sysc');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2dasstm');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2dasrrm');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2fm');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2fmd');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2fmcd');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2dascln');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2fmp');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2dasstml');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2set');
INSERT INTO SOExpl_Umd VALUES ('db2',    'db2bp');
INSERT INTO SOExpl_Umd VALUES ('mysql',  'mysqld');
INSERT INTO SOExpl_Umd VALUES ('oracle', 'oracle');

INSERT INTO SOExpl_Umd VALUES ('pgsql',  'postgres');

-- DBMS Processes 
-- SOExpl_DBMD: SOExpl_DBMS_process_Metadata
DROP TABLE SOExpl_DBmd CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_DBmd AS
	SELECT dbmsname,
		qprocname as dbprocname 	
	FROM (	-- query process
		SELECT * 
		FROM SOExpl_Qmd
		UNION
		-- utility process
		SELECT * 
		FROM SOExpl_Umd);
ALTER TABLE SOExpl_DBmd ADD PRIMARY KEY (dbmsname, dbprocname);
ALTER TABLE SOExpl_DBmd ADD FOREIGN KEY (dbmsname) REFERENCES SOExpl_Dmd(dbmsname) ON DELETE CASCADE;

-- Create a table for chosen labshelf (Get this from GUI)
DROP TABLE SOExpl_LabShelf CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_LabShelf AS
	SELECT '7.0' AS version, ---- version ---	
	'username' AS username, ---- username ---	
	'password' AS password, ---- password ---
	'connect_string' as connstr
	FROM Dual;
ALTER TABLE SOExpl_LabShelf ADD PRIMARY KEY (version);

-- Create a table for pk runs  (Get this from GUI)
DROP TABLE SOExpl_PK_Runs CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_PK_Runs AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	-- exploratory analysis with primary keys
	WHERE runid IN (439,438,796,897) 
	ORDER BY runid;
ALTER TABLE SOExpl_PK_Runs ADD PRIMARY KEY (runid);

-- Create a table for runs  (Get this from GUI)
DROP TABLE SOExpl_Runs CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_Runs AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	-- exploratory analysis
	WHERE runid IN (228,229,230,231,246,247,248,412) ---- run_id_list ---
	-- confirmatory analysis
	--WHERE runid IN (259,260,95,518) 
	--WHERE runid IN (259,260,95,518, 261,262,286,616, 288,287,422,658, 596,289,440,716, 
	--		  414,413,578,756, 416,556,636,776, 419,421,676,816, 436,437,681,857,
	--		  439,438,796,897,898,899) ---- run_id_list ---
	ORDER BY runid;
ALTER TABLE SOExpl_Runs ADD PRIMARY KEY (runid);

create table SOExpl_PKQueryParam as 
	select distinct t0.* 
	from azdblab_pkqueryparam t0, 
	     azdblab_experiment ex,
	     azdblab_experimentrun er
	where t0.experimentid = ex.experimentid and
	      ex.experimentid = er.experimentid and
	      er.runid = 439 and t0.querynumber < 100;
ALTER TABLE SOExpl_PKQueryParam ADD PRIMARY KEY (experimentid, querynumber, PARAMNAME);

select experimentid, count(querynumber)
from (select distinct experimentid, querynumber
	from SOExpl_PKQueryParam)
group by experimentid

-- Store the number of rows (step size) in a major step table/view
-- SOExpl_RowCount:  SOExpl_Row_Count
DROP TABLE SOExpl_RowCount CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_RowCount
(
	dbmsName	VARCHAR2(10),
	exprName	VARCHAR2(50),
	stepName	VARCHAR2(50),
	stepResultSize	NUMBER (10, 2),
        PRIMARY KEY (dbmsName, exprName, stepName) 
);

-- Get all query executions from the chosen labshelf for experiment-wide sanity checks
-- SOExpl_S0_AQE:  SOExpl_S0_All_Query_Executions
DROP TABLE SOExpl_S0_AQE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_AQE AS
	SELECT  c_labshelf.version,	    -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.cardinality AS card,  
		qe.ITERNUM as qenum,
		qe.queryexecutionid AS qeid,
		qp.planid,			-- for unique plan violation
		qe.runtime as measured_time	-- for eliminating timed out QEs
	FROM  SOExpl_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      SOExpl_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	 WHERE ex.experimentid=er.experimentid AND 
	       er.runid=c_run.runid AND 
               c_run.runid=q.runid AND
	       q.queryid=qe.queryid AND -- all QEs
               qe.queryexecutionid=qp.queryexecutionid AND -- all QPs
	       er.currentstage  ='Completed' AND
               er.percentage = 100
	UNION
	SELECT  c_labshelf.version,	    -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.cardinality AS card,  
		qe.ITERNUM as qenum,
		qe.queryexecutionid AS qeid,
		qp.planid,			-- for unique plan violation
		qe.runtime as measured_time	-- for eliminating timed out QEs
	FROM  SOExpl_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      SOExpl_PK_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	 WHERE ex.experimentid=er.experimentid AND 
	       er.runid=c_run.runid AND 
               c_run.runid=q.runid AND
	       q.QUERYNUMBER < 100 AND	-- the first 100 queries only chosen
	       q.queryid=qe.queryid AND -- all QEs
               qe.queryexecutionid=qp.queryexecutionid AND -- all QPs
	       er.currentstage  ='Completed' AND
               er.percentage = 100;
ALTER TABLE SOExpl_S0_AQE ADD PRIMARY KEY (qeid); 

-- QE statistics
-- Compute the total number of QEs by dbms, experiment, run
-- SOExpl_S0_QE: SOExpl_S0_Query_Executions
DROP VIEW SOExpl_S0_QE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_QE AS
	SELECT qe.dbms,
	       qe.experimentName,
	       qe.runid,
	       qe.querynum,
	       qe.card,
	       count(distinct qe.qeid) as numQEs
	FROM SOExpl_S0_AQE qe
	GROUP BY (qe.dbms, qe.experimentName,qe.runid,qe.querynum,qe.card);
ALTER VIEW SOExpl_S0_QE ADD PRIMARY KEY (runid,querynum,card) DISABLE;

-- Compute the total number of QEs by dbms
-- SOExpl_S0_DTQE: SOExpl_S0_DBMS_Total_Query_Executions
DROP VIEW SOExpl_S0_DTQE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_DTQE AS
	SELECT dbms,
	       sum(numQEs) AS totalQEs
	FROM SOExpl_S0_QE
	GROUP BY dbms;
ALTER VIEW SOExpl_S0_DTQE ADD PRIMARY KEY (dbms) DISABLE;

-- Get the total number of QEs across DBMes
-- SOExpl_S0_TQE: SOExpl_S0_DBMS_Total_Query_Executions
DROP VIEW SOExpl_S0_TQE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_TQE AS
	SELECT SUM(totalQEs) AS totalQEs
	FROM SOExpl_S0_DTQE;

-- Record the result size of SOExpl_S0_QE
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S0_QE';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S0_QE' as stepName,
	       count(qeid) as stepResultSize
	FROM SOExpl_S0_AQE
	GROUP BY dbms, experimentname;

-- Q@C statistics
-- Compute the total number of Q@Cs by dbms, experiment, run
-- SOExpl_S0_QatC: SOExpl_S0_QatC
DROP VIEW SOExpl_S0_QatC CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_QatC AS
	SELECT dbms, 
	       experimentName, 
	       runid,
               count(*) as numQatCs
	FROM (SELECT distinct 
			dbms, 
			experimentName, 
			runid, 
			querynum, 
			card 
		FROM SOExpl_S0_AQE) 
	GROUP by dbms, experimentName, runid;	
ALTER VIEW SOExpl_S0_QatC ADD PRIMARY KEY (dbms,experimentName,runid) DISABLE;

-- Record the result size of SOExpl_S0_QatC
DELETE FROM SOExpl_RowCount WHERE stepname = 'SOExpl_S0_QatC';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S0_QatC' as stepName,
	       numQatCs as stepResultSize
	FROM SOExpl_S0_QatC;

-- Roll up the number of Q@Cs by dbms
-- SOExpl_S0_DTQatC: SOExpl_S0_DBMS_Total_QatC
DROP VIEW SOExpl_S0_DTQatC CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_DTQatC AS
	SELECT dbms,
	       sum(numQatCs) AS totalQatCs
	FROM SOExpl_S0_QatC
	GROUP BY dbms;
ALTER VIEW SOExpl_S0_DTQatC ADD PRIMARY KEY (dbms) DISABLE;

-- Compute the total number of Q@Cs across DBMSes
-- SOExpl_S0_TQatC: SOExpl_S0_Total_QatC
DROP VIEW SOExpl_S0_TQatC CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_TQatC AS
	SELECT sum(totalQatCs) AS totalQatCs
	FROM SOExpl_S0_DTQatC;

-- Query statistics
-- Compute the total number of queries by dbms, experiment, run
DROP VIEW SOExpl_S0_Q CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_Q AS
	SELECT qe.dbms,
	       qe.experimentName,
	       qe.runid,
	       count(distinct qe.querynum) as numQs
	FROM SOExpl_S0_AQE qe
	GROUP BY (qe.dbms, qe.experimentName,qe.runid);
ALTER VIEW SOExpl_S0_Q ADD PRIMARY KEY (runid) DISABLE;

-- Record the result size of SOExpl_S0_Q
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S0_Q';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S0_Q' as stepName,
	       SUM(numQs) as stepResultSize
	FROM SOExpl_S0_Q
	GROUP BY dbms, experimentname;

-- Roll up the number of queries by dbms
-- SOExpl_S0_DTQ: SOExpl_S0_DBMS_Total_Query
DROP VIEW SOExpl_S0_DTQ CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_DTQ AS
	SELECT dbms,
	       sum(numQs) AS totalQs
	FROM SOExpl_S0_Q 
	GROUP BY dbms;
ALTER VIEW SOExpl_S0_DTQ ADD PRIMARY KEY (dbms) DISABLE;

-- Compute the total number of queries across DBMSes
-- SOExpl_S0_TQ: SOExpl_S0_Total_Query
DROP VIEW SOExpl_S0_TQ CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_TQ AS
	SELECT sum(totalQs) AS totalQs
	FROM SOExpl_S0_DTQ;

-- Table IX. Experiment-wide sanity checks
-- (1) Number of Missing Queries
-- Catch all missing queries per dbms per experiment
-- SOExpl_S0_MQ_PDE: SOExpl_S0_Missing_Queries_Per_DBMS_Per_Experiment
DROP VIEW SOExpl_S0_MQ_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_MQ_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       -- numMissingQueries = max query number - # of distinct query numbers
	       -- COALESCE because value may be NULL
	       COALESCE((t1.max_query_num+1)-t2.numQs, 0) as numMQPerRun 
	FROM (SELECT dbms, 
	             experimentname,
	             runid, 
		     max(querynum) AS max_query_num
 	      FROM (SELECT DISTINCT dbms, 
			       	    experimentname,
	       		       	    runid, 
        	     	       	    querynum 
      	       	    FROM SOExpl_S0_AQE)
	      GROUP BY dbms, experimentname, runid) t1,
	      SOExpl_S0_Q t2
	WHERE t1.runid = t2.runid;
ALTER VIEW SOExpl_S0_MQ_PDE ADD PRIMARY KEY (runid) DISABLE;

-- (2) Number of Unique Plan Violations
-- Catch unique plan violations per dbms per experiment
-- SOExpl_S0_UPV: SOExpl_S0_Unique_Plan_Violations_Per_DBMS_Per_Experiment 
DROP VIEW SOExpl_S0_UPV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S0_UPV_PDE AS -- Primary key is a (runid)
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(nUPViolations), 0) AS numUPVPerRun
	FROM  (SELECT dbms,
		      experimentname,
		      runid, 
	    	      querynum, 
		      card, 
		      COALESCE(count(qeid), 0) AS nUPViolations
	       FROM SOExpl_S0_AQE
	       GROUP BY dbms, experimentname, runid, querynum, card
	       HAVING count(DISTINCT planid) > 1)
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S0_UPV_PDE ADD PRIMARY KEY (runid) DISABLE;

-- Catch per-process measure violations per dbms per experiment
-- SOExpl_S0_PMV_PDE: SOExpl_S0_Per-process_Measure_Violation_Per_DBMS_Experiment 
DROP TABLE SOExpl_S0_PMV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_PMV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid,
	       COALESCE(count(qeid),0) as numPMVPerRun
	FROM 
	     (
		-- Check if any QE's per-process measure has not yet been parsed
		(SELECT dbms,
			experimentname,
			runid,
			qeid
		 FROM   SOExpl_S0_AQE
		 WHERE  measured_time  < 9999999
		 MINUS
		 SELECT t1.dbms,
			t1.experimentname,
			t1.runid,
			t1.qeid
		 --FROM SOExpl_S0_AQE t1
		 --WHERE t1.measured_time < 9999999 and t1.qeid IN
		 --	(SELECT distinct t2.queryexecutionid
		 --	 -- per-proc measures
		 --	 FROM AZDBLab_QueryExecutionProcs t2)
		 FROM SOExpl_S0_AQE t1,
		      AZDBLab_QueryExecutionProcs t2
		 WHERE t1.measured_time < 9999999 
		   and t1.qeid = t2.queryexecutionid
		 ) 
		 UNION
		 -- Check if any QE has missing overall measures
		 (SELECT t1.dbms,
			t1.experimentname,
			t1.runid,
			t1.qeid
		  FROM SOExpl_S0_AQE t1,
		       AZDBLab_QueryExecutionProcs t2
		  WHERE t1.measured_time < 9999999 
		    and t1.qeid = t2.queryexecutionid
		    and ((t2.process_id IS NULL) 
			OR (t2.PROCESS_NAME_STR IS NULL)
			OR (t2.MIN_FLT_CNT IS NULL)
			OR (t2.MAJ_FLT_CNT IS NULL)
			OR (t2.U_TKS IS NULL)
			OR (t2.S_TKS IS NULL)
			OR (t2.BLOCKIO_DELAY_TKS IS NULL)
			OR (t2.GUEST_TKS IS NULL)
			OR (t2.CGUEST_TKS IS NULL)
			OR (t2.READ_BYTES_CNT IS NULL)
			OR (t2.WRITE_BYTES_CNT IS NULL)
			OR (t2.READ_CHAR_CNT IS NULL)
			OR (t2.WRITE_CHAR_CNT IS NULL)
			OR (t2.READ_SYSCALLS_CNT IS NULL)
			OR (t2.WRITE_SYSCALLS_CNT IS NULL)
			OR (t2.IVCSW_CNT IS NULL)
			OR (t2.VCSW_CNT IS NULL))
		)
	   )
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S0_PMV_PDE ADD PRIMARY KEY (runid) DISABLE;

-- Catch overall measure violations per dbms per experiment
-- SOExpl_S0_OMV_PDE: SOExpl_S0_Overall_Measure_Violations_Per_DBMS_Experiment 
DROP TABLE SOExpl_S0_OMV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_OMV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid,
	       COALESCE(count(qeid),0) as numOMVPerRun
	FROM 
	     (
		-- Check if any QE's overall measure has not yet been parsed
		(SELECT dbms,
			experimentname,
			runid,
			qeid
		 FROM   SOExpl_S0_AQE
		 WHERE  measured_time  < 9999999
		 MINUS
		 SELECT dbms,
			experimentname,
			runid,
			qeid
		 FROM   SOExpl_S0_AQE qe,
			AZDBLab_QueryStatEvaluation t2 -- overall measures
		 WHERE qe.qeid = t2.queryexecutionid AND
		       qe.measured_time  < 9999999)
		UNION
		-- Check if any QE has missing overall measures
		(SELECT t1.dbms,
		        t1.experimentname,
		        t1.runid,
		        t1.qeid
		 FROM SOExpl_S0_AQE t1
		 WHERE t1.MEASURED_TIME < 9999999 and t1.qeid IN
			 (SELECT distinct t2.queryexecutionid
			  -- overall measures
			  FROM AZDBLab_QueryStatEvaluation t2 
			  WHERE  ((t2.OVR_U_TKS IS NULL)
			 	OR (t2.OVR_LU_TKS IS NULL)
				OR (t2.OVR_S_TKS IS NULL)
				OR (t2.OVR_IDLE_TKS IS NULL)
				OR (t2.OVR_IOWAIT_TKS IS NULL)
				OR (t2.OVR_IRQ_TKS IS NULL)
				OR (t2.OVR_SOFTIRQ_TKS IS NULL)
				OR (t2.OVR_STEAL_TKS IS NULL)
				OR (t2.OVR_GUEST_TKS IS NULL))
			 )
		)
	     )
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S0_OMV_PDE ADD PRIMARY KEY (runid) DISABLE;

-- (3) Number of Underlying Measure Violations
-- Compute underlying measure violations per dbms per experiment
-- Add up both per-process and overall measure violations per per dbms per experiment
-- SOExpl_S0_OMV_PDE: SOExpl_S0_Overall_Measure_Violations_Per_DBMS_Experiment 
DROP TABLE SOExpl_S0_UMV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_UMV_PDE AS
	SELECT pm.dbms,
	       pm.experimentname,
	       pm.runid,
	       SUM(pm.numPMVPerRun+om.numOMVPerRun) as numUMVPerRun
	FROM SOExpl_S0_PMV_PDE pm,
	     SOExpl_S0_OMV_PDE om
	WHERE pm.runid = om.runid
	GROUP BY pm.dbms, pm.experimentname, pm.runid;
ALTER TABLE SOExpl_S0_UMV_PDE ADD PRIMARY KEY (runid) DISABLE;

-- (4) Number of Derived Measure Violations
-- Catch derived measure violations per dbms per experiment
-- SOExpl_S0_DMV_PDE: SOExpl_S0_Derived_Measured_Violations_Per_DBMS_Experiment 
DROP TABLE SOExpl_S0_DMV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_DMV_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.totalQEs-t2.numQEwithOM as numDMVPerRun
	FROM (SELECT dbms,
		     experimentname,
		     runid,
	      	     COALESCE(count(qeid),0) as totalQEs -- by run
	      FROM SOExpl_S0_AQE aqe
	      GROUP BY dbms, experimentname, runid) t1,
	     (SELECT aqe.dbms,
		     aqe.experimentname,
		     aqe.runid,
	      	     COALESCE(count(aqe.qeid), 0) as numQEwithOM -- number of QEs with derived measures
	      FROM SOExpl_S0_AQE aqe,
		   AZDBLab_QueryStatEvaluation qse
	      WHERE aqe.measured_time < 9999999 
		and aqe.qeid = qse.queryexecutionid 
		-- overall measure data per QE	
		and qse.OVR_EPHEMERALPPROCS_CNT IS NULL 
	      GROUP BY dbms, experimentname, runid) t2
	WHERE t1.runid = t2.runid;
ALTER TABLE SOExpl_S0_DMV_PDE ADD PRIMARY KEY (runid);

-- (5) Number of Steal Time Violations
-- Catch steal time violations
-- SOExpl_S0_STV_PDE: SOExpl_S0_Steal_Time_Violations_Per_DBMS_Experiment 
DROP TABLE SOExpl_S0_STV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_STV_PDE AS			
	SELECT aqe.dbms,
	       aqe.experimentname,
	       aqe.runid,
      	       COALESCE(count(aqe.qeid),0) as numSTVPerRun
        FROM SOExpl_S0_AQE aqe,
	     AZDBLab_QueryStatEvaluation qse
        WHERE aqe.measured_time < 9999999 
	  and aqe.qeid = qse.queryexecutionid
 	  -- steal ticks > 0
	  and qse.OVR_STEAL_TKS > 0
        GROUP BY aqe.dbms, aqe.experimentname, aqe.runid; 
ALTER TABLE SOExpl_S0_STV_PDE ADD PRIMARY KEY (runid);

-- (6) Number of Guest Time Violations
-- Catch guest time violations
-- SOExpl_S0_GTV_PDE: SOExpl_S0_Guest_Time_Violations_Per_DBMS_Experiment 
DROP TABLE SOExpl_S0_GTV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_GTV_PDE AS			
	SELECT aqe.dbms,
	       aqe.experimentname,
	       aqe.runid,
      	       COALESCE(count(qeid),0) as numGTVPerRun
        --FROM SOExpl_S0_AQE aqe
        --WHERE aqe.measured_time < 9999999 
	--  and aqe.qeid IN (
	--		SELECT qeid 
	--		FROM AZDBLab_QueryStatEvaluation 
	--		WHERE (OVR_GUEST_TKS > 0 -- overall guest
	--		--  OR OVR_GUEST_NICE_TKS > 0 -- overall guest nice
	--		)
	--		UNION	        
	--		SELECT distinct t2.queryexecutionid as qeid
	--		FROM AZDBLab_QueryExecutionProcs t2
	--		       -- per-process guest
	--		WHERE (t2.GUEST_TKS > 0 OR t2.CGUEST_TKS > 0)
	--	)
	FROM SOExpl_S0_AQE aqe,
	     AZDBLab_QueryStatEvaluation qse,
	     AZDBLab_QueryExecutionProcs qep	 
        WHERE aqe.measured_time < 9999999 
	  and aqe.qeid = qse.queryexecutionid
          and qse.queryexecutionid = qep.queryexecutionid
	  and (qse.OVR_GUEST_TKS > 0 -- overall guest 
	       --  OR OVR_GUEST_NICE_TKS > 0 -- overall guest nice
	      )
	  and (qep.GUEST_TKS > 0 OR qep.CGUEST_TKS > 0)
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S0_GTV_PDE ADD PRIMARY KEY (runid) DISABLE;

-- (7) Number of Other Query Process Violations
-- Count QEs having other query processes per DBMS per experiment
-- SOExpl_S0_OQPV: SOExpl_S0_Other_Query_Process_Violation 
DROP TABLE SOExpl_S0_OQPV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_OQPV_PDE AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) as OQPVPerRun
	FROM SOExpl_S0_AQE        qe,
	     AZDBLab_QueryExecutionProcs qeproc,
	     SOExpl_Qmd 		 qmd
	WHERE qe.qeid = qeproc.queryexecutionid 
	  AND qeproc.PROCESS_NAME_STR = qmd.qprocname  
	  AND qe.dbms <> qmd.dbmsname
	GROUP BY dbms, experimentName, runid;
ALTER TABLE SOExpl_S0_OQPV_PDE ADD PRIMARY KEY (runid); 

-- (8) Number of Other Utility (DBMS) Process Violations
-- Count QEs having other utility (dbms) processes per DBMS per experiment
-- SOExpl_S1_OUPV: SOExpl_S1_Other_Utility_Process_Violation 
DROP TABLE SOExpl_S0_OUPV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_OUPV_PDE AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) as OUPVPerRun
	FROM SOExpl_S0_AQE        qe,
	     AZDBLab_QueryExecutionProcs qeproc,
	     SOExpl_Umd	umd
	WHERE qe.qeid = qeproc.queryexecutionid 
	  AND qe.dbms <> umd.dbmsname
	  AND qeproc.PROCESS_NAME_STR = umd.uprocname
	GROUP BY dbms, experimentName, runid;
ALTER TABLE SOExpl_S0_OUPV_PDE ADD PRIMARY KEY (runid) DISABLE; 
	     
-- Check dirty runs failing experiment-wide sanity checks
-- SOExpl_S0_DR_PDE: SOExpl_S0_DirtyRuns_Per_DBMS_Experiment 
DROP TABLE SOExpl_S0_DR_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_DR_PDE AS
	-- Missing query violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_MQ_PDE
	WHERE numMQPerRun > 0
	UNION
	-- Unique plan violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_UPV_PDE
	WHERE numUPVPerRun > 0
	UNION
	-- Per-process measure violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_PMV_PDE
	WHERE numPMVPerRun > 0
	UNION
	-- Derived measure violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_DMV_PDE
	WHERE numDMVPerRun > 0
	UNION
	-- Overall measure violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_OMV_PDE
	WHERE numOMVPerRun > 0
	UNION
	-- Steal time violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_STV_PDE
	WHERE numSTVPerRun > 0
	UNION
	-- Guest time violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_GTV_PDE
	WHERE numGTVPerRun > 0
	UNION
	-- Other query process violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_OQPV_PDE
	WHERE OQPVPerRun > 0
	UNION
	-- Other utility process violations
	SELECT dbms,
	       experimentname,
	       runid
	FROM SOExpl_S0_OUPV_PDE
	WHERE OUPVPerRun > 0;
ALTER TABLE SOExpl_S0_DR_PDE ADD PRIMARY KEY (runid) DISABLE;

-- Converting to not-null columns on per-process measures
-- SOExpl_PM: SOExpl_not_nulliable_Per-process_Measure
DROP TABLE SOExpl_PM CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_PM(
	qeid 	NUMBER(10) NOT NULL,
	procid  NUMBER(10) NOT NULL,
	pp_id NUMBER(10) NOT NULL,
	PROCNAME VARCHAR2(32) NOT NULL,
	U_TKS NUMBER(10) NOT NULL,
	S_TKS NUMBER(10) NOT NULL,
	MAJ_FLT_CNT NUMBER(10) NOT NULL,
	BLOCKIO_DELAY_TKS NUMBER(10) NOT NULL,
	IVCSW_CNT NUMBER(10) NOT NULL,
	VCSW_CNT NUMBER(10) NOT NULL,
	READ_BYTES_CNT NUMBER(10) NOT NULL,
	READ_CHAR_CNT NUMBER(10) NOT NULL,
	READ_SYSCALLS_CNT NUMBER(10) NOT NULL,
	WRITE_BYTES_CNT NUMBER(10) NOT NULL,
	WRITE_CHAR_CNT NUMBER(10) NOT NULL,
	WRITE_SYSCALLS_CNT NUMBER(10) NOT NULL,
	GUEST_TKS NUMBER(10) NOT NULL,
	CGUEST_TKS NUMBER(10) NOT NULL,
	PRIMARY KEY (qeid, procid)
);

INSERT INTO SOExpl_PM (qeid, procid, pp_id, PROCNAME, U_TKS, S_TKS, MAJ_FLT_CNT, 
			 BLOCKIO_DELAY_TKS, IVCSW_CNT, VCSW_CNT, 
			 READ_BYTES_CNT, READ_CHAR_CNT, READ_SYSCALLS_CNT, 
			 WRITE_BYTES_CNT, WRITE_CHAR_CNT, WRITE_SYSCALLS_CNT,
			 GUEST_TKS, CGUEST_TKS)
	SELECT  pm.queryexecutionid,
		pm.process_id as procid,
		pm.PP_ID,
		pm.process_name_str as procname,
		pm.U_TKS,
		pm.S_TKS,
		pm.MAJ_FLT_CNT,
		pm.BLOCKIO_DELAY_TKS,
		pm.IVCSW_CNT,
		pm.VCSW_CNT,
		pm.READ_BYTES_CNT,
		pm.READ_CHAR_CNT,
		pm.READ_SYSCALLS_CNT,
		pm.WRITE_BYTES_CNT,
		pm.WRITE_CHAR_CNT,
		pm.WRITE_SYSCALLS_CNT,
		pm.GUEST_TKS,
		pm.CGUEST_TKS
	FROM AZDBLab_QueryExecutionProcs pm
	WHERE pm.queryexecutionid IN
		(SELECT t2.qeid 
		 FROM  SOExpl_S0_AQE t2
		 WHERE t2.measured_time < 9999999);
--94489527
-- Converting to not-null columns on overall measures
-- SOExpl_OM: SOExpl_not_nulliable_Overall_Measure
DROP TABLE SOExpl_OM CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_OM(
	 qeid NUMBER (10) NOT NULL PRIMARY KEY,
	 OVR_EPHEMERALPPROCS_CNT NUMBER (10) NOT NULL,
	 OVR_U_TKS NUMBER (10) NOT NULL,
	 OVR_LU_TKS NUMBER (10) NOT NULL,
	 OVR_S_TKS NUMBER (10) NOT NULL,
	 OVR_IDLE_TKS NUMBER (10) NOT NULL,
	 OVR_IOWAIT_TKS NUMBER (10) NOT NULL,
	 OVR_IRQ_TKS NUMBER (10) NOT NULL,
	 OVR_SOFTIRQ_TKS NUMBER (10) NOT NULL,
	 OVR_STEAL_TKS NUMBER (10) NOT NULL,
	 OVR_GUEST_TKS NUMBER (10) NOT NULL
);

INSERT INTO SOExpl_OM (qeid,OVR_EPHEMERALPPROCS_CNT, OVR_U_TKS, OVR_LU_TKS, 
			 OVR_S_TKS, OVR_IDLE_TKS, OVR_IOWAIT_TKS, OVR_IRQ_TKS, 
			 OVR_SOFTIRQ_TKS,  OVR_STEAL_TKS,  OVR_GUEST_TKS)
	SELECT om.queryexecutionid as qeid,
		om.OVR_EPHEMERALPPROCS_CNT,		
		om.OVR_U_TKS,
		om.OVR_LU_TKS,
		om.OVR_S_TKS,
		om.OVR_IDLE_TKS,
		om.OVR_IOWAIT_TKS,
		om.OVR_IRQ_TKS,
		om.OVR_SOFTIRQ_TKS,
		om.OVR_STEAL_TKS,
		om.OVR_GUEST_TKS
	FROM  SOExpl_S0_AQE qe,  
	      AZDBLab_QueryStatEvaluation om -- overall measure table     
	WHERE  qe.measured_time < 9999999  -- not selecting timed-out QEs
	   AND qe.qeid = om.queryexecutionid;
--551620
-- Collect all "clean" query executions with their overall measures and a chosen plan 
-- from chosen (clean) runs with no experiment-wide sanity check violations  
-- SOExpl_S0_CQE: SOExpl_S0_Valid_Query_Executions
DROP TABLE SOExpl_S0_CQE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S0_CQE AS
	SELECT  qe.*,
		om.OVR_EPHEMERALPPROCS_CNT,
		om.OVR_U_TKS,
		om.OVR_LU_TKS,
		om.OVR_S_TKS,
		om.OVR_IDLE_TKS,
		om.OVR_IOWAIT_TKS,
		om.OVR_IRQ_TKS,
		om.OVR_SOFTIRQ_TKS,
		om.OVR_STEAL_TKS,
		om.OVR_GUEST_TKS
	FROM  SOExpl_S0_AQE qe, 
	      SOExpl_OM om	--- not-nullable overall measure 
	 WHERE qe.qeid=om.qeid;
ALTER TABLE SOExpl_S0_CQE ADD PRIMARY KEY (qeid); 
--551507
-- Show per-process info per QE
-- SOExpl_API: SOExpl_All_Process_Info
DROP TABLE SOExpl_API CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_API AS
	SELECT qe.dbms,
	       qe.runid,
	       qe.card,
	       qe.querynum,
	       qe.qeid,	
	       pm.procid,
	       pm.pp_id,
	       pm.procname,
	       pm.U_TKS,
	       pm.S_TKS,
	       pm.MAJ_FLT_CNT,
	       pm.BLOCKIO_DELAY_TKS,
	       pm.IVCSW_CNT,
	       pm.VCSW_CNT,
	       pm.READ_BYTES_CNT,
	       pm.READ_CHAR_CNT,
	       pm.READ_SYSCALLS_CNT,
	       pm.WRITE_BYTES_CNT,
	       pm.WRITE_CHAR_CNT,
	       pm.WRITE_SYSCALLS_CNT,
	       pm.GUEST_TKS,
	       pm.CGUEST_TKS		
	FROM SOExpl_S0_CQE qe,
	     SOExpl_PM pm
	WHERE qe.qeid = pm.qeid;
ALTER TABLE SOExpl_API ADD PRIMARY KEY (qeid, procid); 
--  COUNT(*)
----------
--  94489527 
-- DBMS query process data
-- SOExpl_DBQP: SOExpl_DBMS_Query_Process
DROP VIEW SOExpl_DBQP CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_DBQP  AS
	SELECT *
	FROM SOExpl_API pi
	WHERE pi.procname IN (select dbprocname from SOExpl_DBmd);
ALTER VIEW SOExpl_DBQP ADD PRIMARY KEY (qeid, procid) DISABLE;

-- Extract the query parent process id of a query child process
-- SOExpl_RQP: SOExpl_Root_Query_Process
DROP TABLE SOExpl_RQP CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_RQP  AS
	SELECT dbp.qeid,
	       dbp.procid	    as qproc_id
	from SOExpl_DBQP dbp
	-- query proc should be born from root
	WHERE dbp.pp_id = 1;
ALTER TABLE SOExpl_RQP ADD PRIMARY KEY (qeid, qproc_id); 
--SELECT * from SOExpl_RQP order by qeid, qproc_id

-- Combine all candidate query processes' measures
-- (We consider some query processes with no child processes thus not participating in the rollup.)
-- SOExpl_RQPI: SOExpl_Root_Query_Process_Information
DROP TABLE SOExpl_RQPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_RQPI AS
	SELECT t0.*
	FROM
		(SELECT qp.qeid,
		    qp.qproc_id,
		    COALESCE(sum(qep.u_tks), 0) as U_TKS,
		    COALESCE(sum(qep.s_tks), 0) as S_TKS,
		    COALESCE(sum(qep.MAJ_FLT_CNT), 0) MAJ_FLT_CNT,
		    COALESCE(sum(qep.BLOCKIO_DELAY_TKS), 0) as BLOCKIO_DELAY_TKS, 
		    COALESCE(sum(qep.IVCSW_CNT), 0) as IVCSW_CNT, 
		    COALESCE(sum(qep.VCSW_CNT), 0) as VCSW_CNT, 
		    COALESCE(sum(qep.READ_BYTES_CNT), 0) as READ_BYTES_CNT, 
		    COALESCE(sum(qep.READ_CHAR_CNT), 0) as READ_CHAR_CNT, 
		    COALESCE(sum(qep.READ_SYSCALLS_CNT), 0) as READ_SYSCALLS_CNT, 
		    COALESCE(sum(qep.WRITE_BYTES_CNT), 0) as WRITE_BYTES_CNT, 
		    COALESCE(sum(qep.WRITE_CHAR_CNT), 0) as WRITE_CHAR_CNT, 
		    COALESCE(sum(qep.WRITE_SYSCALLS_CNT), 0) as WRITE_SYSCALLS_CNT, 
		    COALESCE(sum(qep.GUEST_TKS), 0) as GUEST_TKS,
		    COALESCE(SUM(qep.CGUEST_TKS), 0) AS CGUEST_TKS
		FROM
			SOExpl_RQP qp,  -- candidate query procs rooted from init proc
			SOExpl_DBQP qep  -- all dbms processes
		WHERE 
			-- query proc rows with child processes
		  (qp.qeid     = qep.qeid and qp.qproc_id = qep.pp_id)
			-- query proc rows without child processes 
		  OR  (qp.qeid = qep.qeid and qp.qproc_id = qep.procid and qep.pp_id = 1)
		GROUP BY ROLLUP (qp.qeid, qp.qproc_id)) t0
	WHERE (t0.qeid is not null) and (t0.qproc_id is not null)
	--WHERE ROWNUM = 1
	ORDER BY (U_TKS+S_TKS) desc;
ALTER TABLE SOExpl_RQPI ADD PRIMARY KEY (qeid, qproc_id);
--SELECT * from SOExpl_RQPI

-- Candiate DBMS query processes
-- SOExpl_CQP: SOExpl_Candidate_Query_Process
DROP TABLE SOExpl_CQP CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_CQP AS
	SELECT  dbp.runid, 
	 	dbp.querynum, 
	        dbp.card, 
		rqpi.qproc_id as dbmspid, 
       		SUM(rqpi.U_TKS+rqpi.S_TKS) q_total_tks
	FROM SOExpl_DBQP dbp, 
	     SOExpl_RQPI rqpi
	WHERE dbp.qeid = rqpi.qeid 
	and dbp.procid = rqpi.qproc_id
	GROUP BY runid, querynum, card, rqpi.qproc_id
	Having count(rqpi.qproc_id) = 10 -- 10 QEs
	ORDER BY runid ASC, querynum ASC, card DESC, rqpi.qproc_id ASC, q_total_tks DESC;
ALTER TABLE SOExpl_CQP ADD PRIMARY KEY (runid, querynum, card, dbmspid); 
--SELECT * from SOExpl_CQP

-- Identify a "QUERY" process at Q@C
-- SOExpl_FQP: SOExpl_Final_Query_Processes
DROP TABLE SOExpl_FQP CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_FQP AS -- Primary key is a Q@C: (runid, querynum, card)
	SELECT DISTINCT t1.runid, 
			t1.querynum, 
			t1.card, 
			min(t1.dbmspid) as querypid
	FROM SOExpl_CQP t1, 
	     (SELECT DISTINCT t3.runid,-- looking at a Q@C
		     t3.querynum,  
		     t3.card, 
		     MAX(t3.q_total_tks) AS maxtime 
	      FROM SOExpl_CQP t3 
	      GROUP BY t3.runid, t3.querynum, t3.card) t2 
	WHERE t1.runid = t2.runid AND 
	      t1.querynum = t2.querynum AND 
	      t1.card = t2.card AND 
	      t1.q_total_tks = t2.maxtime
	GROUP BY t1.runid, t1.querynum, t1.card;
ALTER TABLE SOExpl_FQP ADD PRIMARY KEY (runid, querynum, card); 
--SELECT * from SOExpl_FQP

-- New query process information
-- SOExpl_AEQPI: SOExpl_New_Query_Process_Information 
DROP TABLE SOExpl_AEQPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AEQPI AS -- Primary key is a (qeid)
	SELECT  t3.qeid, 
		t3.qproc_id as procid,
		t3.U_TKS, 
		t3.S_TKS, 
		t3.MAJ_FLT_CNT, 
	        t3.BLOCKIO_DELAY_TKS,
 		t3.IVCSW_CNT,
	        t3.VCSW_CNT,
	        t3.READ_BYTES_CNT,
	        t3.READ_CHAR_CNT,
	        t3.READ_SYSCALLS_CNT,
	        t3.WRITE_BYTES_CNT,
	        t3.WRITE_CHAR_CNT,	
		t3.WRITE_SYSCALLS_CNT,
	        t3.GUEST_TKS,
	        t3.CGUEST_TKS
	FROM SOExpl_FQP t1, 
	     SOExpl_DBQP t2,
	     SOExpl_RQPI t3
	WHERE t1.runid = t2.runid
	 and t1.querynum = t2.querynum 
	 and t1.card = t2.card 
	and t2.qeid = t3.qeid 
	and t1.querypid   = t3.qproc_id 
	and t2.procid = t3.qproc_id;
ALTER TABLE SOExpl_AEQPI ADD PRIMARY KEY (qeid); 
--select * from SOExpl_AEQPI order by qeid, qproc_id

-- Obtain query process information not existing in a query execution 
-- SOExpl_ANQPI: SOExpl_Unavailable_New_Utility_Process_Info
DROP TABLE SOExpl_ANQPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_ANQPI AS
	SELECT DISTINCT qeid, 
	       0 as procid,
	       0 AS U_TKS, 
	       0 AS S_TKS, 
	       0 AS MAJ_FLT_CNT,
	       0 AS BLOCKIO_DELAY_TKS,
	       0 AS IVCSW_CNT,
	       0 AS VCSW_CNT,
	       0 AS READ_BYTES_CNT,
	       0 AS READ_CHAR_CNT,
	       0 AS READ_SYSCALLS_CNT,
	       0 AS WRITE_BYTES_CNT,
	       0 AS WRITE_CHAR_CNT,	
	       0 AS WRITE_SYSCALLS_CNT,
	       0 AS GUEST_TKS,
	       0 AS CGUEST_TKS	
	FROM SOExpl_API 
	WHERE qeid NOT IN (SELECT qeid FROM SOExpl_AEQPI);
ALTER TABLE SOExpl_ANQPI ADD PRIMARY KEY (qeid); 

-- Obtain overall query process information per query execution by taking union of SOExpl_AEQPI and SOExpl_ANQPI
-- SOExpl_AQPI: SOExpl_All_Query_Process_Info
DROP TABLE SOExpl_AQPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AQPI AS
	SELECT * FROM SOExpl_AEQPI
	UNION
	SELECT * FROM SOExpl_ANQPI;
ALTER TABLE SOExpl_AQPI ADD PRIMARY KEY (qeid); 

-- Obtain utility processes
-- SOExpl_AEUP: SOExpl_Existing_Utility_Processes
DROP TABLE SOExpl_AEUP CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AEUP AS
	SELECT t3.qeid, 
	       t2.procid
	FROM SOExpl_FQP t1, 
	     SOExpl_DBQP t2,
	     SOExpl_RQPI t3
	WHERE t1.runid = t2.runid
	 and t1.querynum = t2.querynum 
	 and t1.card = t2.card 
	and t2.qeid = t3.qeid 
	-- not query process
	and t1.querypid <> t2.procid
	-- but dbms process = utility process
	and t1.querypid = t3.qproc_id;
ALTER TABLE SOExpl_AEUP ADD PRIMARY KEY (qeid, procid) DISABLE; 

-- Existing utility process information
-- SOExpl_AEUPI: SOExpl_Existing_Utility_Process_Information 
DROP TABLE SOExpl_AEUPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AEUPI AS -- Primary key is a (qeid, procid)
	SELECT 	dbproc.qeid, 
		SUM(dbproc.U_TKS) AS U_TKS,
		SUM(dbproc.S_TKS) AS S_TKS,
		SUM(dbproc.BLOCKIO_DELAY_TKS) AS BLOCKIO_DELAY_TKS,
		SUM(dbproc.IVCSW_CNT) AS IVCSW_CNT,
		SUM(dbproc.VCSW_CNT) AS VCSW_CNT,
		SUM(dbproc.READ_BYTES_CNT) AS READ_BYTES_CNT,
		SUM(dbproc.READ_CHAR_CNT) AS READ_CHAR_CNT,
		SUM(dbproc.READ_SYSCALLS_CNT) AS READ_SYSCALLS_CNT,
		SUM(dbproc.WRITE_BYTES_CNT) AS WRITE_BYTES_CNT,
		SUM(dbproc.WRITE_CHAR_CNT) AS WRITE_CHAR_CNT,
		SUM(dbproc.WRITE_SYSCALLS_CNT) AS WRITE_SYSCALLS_CNT,
		SUM(dbproc.MAJ_FLT_CNT) AS MAJ_FLT_CNT,
		SUM(dbproc.GUEST_TKS) AS GUEST_TKS,
		SUM(dbproc.CGUEST_TKS) AS CGUEST_TKS
	FROM SOExpl_AEUP up,
	     SOExpl_RQPI dbproc
	WHERE  up.qeid = dbproc.qeid 
	 and up.procid = dbproc.qproc_id
	GROUP BY dbproc.qeid;
ALTER TABLE SOExpl_AEUPI ADD PRIMARY KEY (qeid);
--select * from SOExpl_AEUPI order by qeid

-- Obtain utility process information not existing in a query execution 
-- SOExpl_ANUPI: SOExpl_All_Non_existing_Utility_Process_Info
DROP VIEW SOExpl_ANUPI CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_ANUPI AS
	SELECT DISTINCT qeid, 
  	           	0 AS U_TKS, 
                   	0 AS S_TKS, 
			0 AS MAJ_FLT_CNT,
		   	0 AS BLOCKIO_DELAY_TKS,
			0 AS IVCSW_CNT,
			0 AS VCSW_CNT,
			0 AS READ_BYTES_CNT,
		   	0 AS READ_CHAR_CNT,
		   	0 AS READ_SYSCALLS_CNT,
	           	0 AS WRITE_BYTES_CNT,
		   	0 AS WRITE_CHAR_CNT,	
		   	0 AS WRITE_SYSCALLS_CNT,
	 	        0 AS GUEST_TKS,
	           	0 AS CGUEST_TKS	
	FROM SOExpl_API  
	WHERE qeid NOT IN (SELECT qeid FROM SOExpl_AEUPI);
ALTER VIEW SOExpl_ANUPI ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain overall utility dbms process information per query execution by taking union of SOExpl_AEUPI and SOExpl_ANUPI
-- SOExpl_AUPI: SOExpl_All_Utility_Process_Info
DROP TABLE SOExpl_AUPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AUPI AS
	SELECT * FROM SOExpl_AEUPI
	UNION
	SELECT * FROM SOExpl_ANUPI;
ALTER TABLE SOExpl_AUPI ADD PRIMARY KEY (qeid); 

-- parent-child process table
-- SOExpl_PPI: SOExpl_Parent_child_Process_Info
DROP TABLE SOExpl_PPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_PPI AS
	SELECT  qeid,
		pp_id,
		procid,
		procname
	FROM SOExpl_API;
ALTER TABLE SOExpl_PPI ADD PRIMARY KEY (qeid, procid);

-- Experiment processes
-- Locate experiment processes
-- SOExpl_EXP_P: SOExpl_EXP_Process
DROP TABLE SOExpl_Exp_P CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_Exp_P AS
	SELECT  api.qeid,
		api.pp_id,
		api.procid,
		api.procname
	FROM SOExpl_API api
	-- experiment process' names
	WHERE  (api.procname IN ('sudo', 'sshd', 'java', 'proc_monitor', 'bash')
	      OR api.procname like '%runexecutor_%');
ALTER TABLE SOExpl_Exp_P ADD PRIMARY KEY (qeid, procid);
-- Sum up the measures of experiment processes
-- SOExpl_EXP_PI: SOExpl_EXP_Process_Info
DROP TABLE SOExpl_EXP_PI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_EXP_PI AS
	SELECT  qeid,
		SUM(U_TKS) AS U_TKS,
		SUM(S_TKS) AS S_TKS,
		SUM(MAJ_FLT_CNT) AS MAJ_FLT_CNT,
		SUM(BLOCKIO_DELAY_TKS) AS BLOCKIO_DELAY_TKS,
		SUM(IVCSW_CNT) AS IVCSW_CNT,
		SUM(VCSW_CNT) AS VCSW_CNT,
		SUM(READ_BYTES_CNT) AS READ_BYTES_CNT,
		SUM(READ_CHAR_CNT) AS READ_CHAR_CNT,
		SUM(READ_SYSCALLS_CNT) AS READ_SYSCALLS_CNT,
		SUM(WRITE_BYTES_CNT) AS WRITE_BYTES_CNT,
		SUM(WRITE_CHAR_CNT) AS WRITE_CHAR_CNT,
		SUM(WRITE_SYSCALLS_CNT) AS WRITE_SYSCALLS_CNT,
		SUM(GUEST_TKS) AS GUEST_TKS,
		SUM(CGUEST_TKS) AS CGUEST_TKS
	FROM 
		-- get the rest of measures from the raw procs table
		(SELECT api.qeid,
			api.procid,
			api.U_TKS,
			api.S_TKS,
			api.MAJ_FLT_CNT,
			api.BLOCKIO_DELAY_TKS,
			api.IVCSW_CNT,
			api.VCSW_CNT,
			api.READ_BYTES_CNT,
			api.READ_CHAR_CNT,
			api.READ_SYSCALLS_CNT,
			api.WRITE_BYTES_CNT,
			api.WRITE_CHAR_CNT,
			api.WRITE_SYSCALLS_CNT,
			api.GUEST_TKS,
			api.CGUEST_TKS
		FROM SOExpl_API api
		WHERE (qeid, procid) IN (SELECT qeid, procid FROM SOExpl_Exp_P))
	GROUP BY qeid;     
ALTER TABLE SOExpl_EXP_PI ADD PRIMARY KEY (qeid);

-- DBMS process data
-- SOExpl_ADB_P: SOExpl_All_DBMS_Process
DROP VIEW SOExpl_ADB_P CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_ADB_P  AS
	SELECT qeid,
	       pp_id,
		procid,
		procname
	FROM SOExpl_API
	WHERE procname IN (select dbprocname from SOExpl_DBmd);
ALTER VIEW SOExpl_ADB_P ADD PRIMARY KEY (qeid, procid) DISABLE;

-- Obtain daemon processes
-- SOExpl_DAEM_P: SOExpl_DAEMon_Process
DROP TABLE SOExpl_DAEM_P CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_DAEM_P AS
	SELECT  *
	FROM SOExpl_PPI 
	MINUS
	SELECT *
	FROM SOExpl_EXP_P
	MINUS
	SELECT *
	FROM SOExpl_ADB_P;
ALTER TABLE SOExpl_DAEM_P ADD PRIMARY KEY (qeid, procid) DISABLE;

-- Obtain daemon process information existing in a query execution 
-- Note: will not consider qeids that do not have an utility dbms process
-- SOExpl_AEDPI: SOExpl_Existing_Daemon_Process_Info
DROP TABLE SOExpl_AEDPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AEDPI AS
	SELECT  qeid,
		SUM(U_TKS) AS U_TKS,
		SUM(S_TKS) AS S_TKS,
		SUM(MAJ_FLT_CNT) AS MAJ_FLT_CNT,
		SUM(BLOCKIO_DELAY_TKS) AS BLOCKIO_DELAY_TKS,
		SUM(IVCSW_CNT) AS IVCSW_CNT,
		SUM(VCSW_CNT) AS VCSW_CNT,
		SUM(READ_BYTES_CNT) AS READ_BYTES_CNT,
		SUM(READ_CHAR_CNT) AS READ_CHAR_CNT,
		SUM(READ_SYSCALLS_CNT) AS READ_SYSCALLS_CNT,
		SUM(WRITE_BYTES_CNT) AS WRITE_BYTES_CNT,
		SUM(WRITE_CHAR_CNT) AS WRITE_CHAR_CNT,
		SUM(WRITE_SYSCALLS_CNT) AS WRITE_SYSCALLS_CNT,
		SUM(GUEST_TKS) AS GUEST_TKS,
		SUM(CGUEST_TKS) AS CGUEST_TKS
	FROM 
		-- get the rest of measures from the raw procs table
		(SELECT api.qeid,
			api.procid,
			api.U_TKS,
			api.S_TKS,
			api.MAJ_FLT_CNT,
			api.BLOCKIO_DELAY_TKS,
			api.IVCSW_CNT,
			api.VCSW_CNT,
			api.READ_BYTES_CNT,
			api.READ_CHAR_CNT,
			api.READ_SYSCALLS_CNT,
			api.WRITE_BYTES_CNT,
			api.WRITE_CHAR_CNT,
			api.WRITE_SYSCALLS_CNT,
			api.GUEST_TKS,
			api.CGUEST_TKS
		FROM SOExpl_API api
		WHERE (qeid, procid) IN (SELECT qeid, procid FROM SOExpl_DAEM_P))
	GROUP BY qeid;	
ALTER TABLE SOExpl_AEDPI ADD PRIMARY KEY (qeid); 

-- Obtain daemon process information not existing in a query execution 
-- SOExpl_ANDPI: SOExpl_Non_existing_Daemon_Process_Info
DROP TABLE SOExpl_ANDPI CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_ANDPI AS
	SELECT DISTINCT qeid, 
  	           	0 AS U_TKS, 
                   	0 AS S_TKS, 
			0 AS MAJ_FLT_CNT,
		   	0 AS BLOCKIO_DELAY_TKS,
			0 AS IVCSW_CNT,
			0 AS VCSW_CNT,
			0 AS READ_BYTES_CNT,
		   	0 AS READ_CHAR_CNT,
		   	0 AS READ_SYSCALLS_CNT,
	           	0 AS WRITE_BYTES_CNT,
		   	0 AS WRITE_CHAR_CNT,	
		   	0 AS WRITE_SYSCALLS_CNT,
	 	        0 AS GUEST_TKS,
	           	0 AS CGUEST_TKS	
	FROM SOExpl_API api
	WHERE qeid NOT IN (SELECT qeid FROM SOExpl_AEDPI);
ALTER TABLE SOExpl_ANDPI ADD PRIMARY KEY (qeid); 

-- Obtain overall daemon dbms process information per query execution by taking union of SOExpl_AEDPI and SOExpl_ANDPI
-- Note: may have no daemon process
-- SOExpl_ADPI: SOExpl_Daemon_Process_Info
DROP VIEW SOExpl_ADPI CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_ADPI AS
	SELECT * FROM SOExpl_AEDPI
	UNION
	SELECT * FROM SOExpl_ANDPI;
ALTER VIEW SOExpl_ADPI ADD PRIMARY KEY (qeid) DISABLE; 

-- # of processe per QE
-- SOExpl_AQENProcs: SOExpl_All_QE's_Number_of_Processes
DROP TABLE SOExpl_AQENProcs CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AQENProcs AS
	SELECT qeid, 
	       count(procid) as numProcs
	FROM SOExpl_API pi
	GROUP BY qeid;
ALTER TABLE SOExpl_AQENProcs ADD PRIMARY KEY (qeid); 

-- Obtains detailed process information of a query process, a utility process(es), and a daemon process(es) per query execution
-- SOExpl_AQED : SOExpl_All_QueryExecution_Details
DROP TABLE SOExpl_AQED CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_AQED AS
	SELECT  qe.version,
                qe.experimentid,
	        qe.experimentname,
		qe.planid,
		qe.dbms,
		qe.qeid,
		qe.runid,
		qe.querynum,
		qe.card,
		qe.qenum,
		qe.measured_time,
		qe.OVR_U_TKS,
		qe.OVR_LU_TKS,
		qe.OVR_S_TKS,
		qe.OVR_IDLE_TKS,
		qe.OVR_IOWAIT_TKS,
		qe.OVR_STEAL_TKS,
		qe.OVR_GUEST_TKS,
		qe.OVR_IRQ_TKS,
		qe.OVR_SOFTIRQ_TKS,
		procs.numProcs,
		exproc.U_TKS as ep_U_TKS,
		exproc.S_TKS as ep_S_TKS,
		exproc.MAJ_FLT_CNT AS ep_MAJ_FLT_CNT,
		exproc.BLOCKIO_DELAY_TKS AS ep_BLOCKIO_DELAY_TKS,
		qproc.U_TKS AS qp_U_TKS,
		qproc.S_TKS AS qp_S_TKS,
		qproc.MAJ_FLT_CNT AS qp_MAJ_FLT_CNT,
		qproc.BLOCKIO_DELAY_TKS AS qp_BLOCKIO_DELAY_TKS,
		qproc.IVCSW_CNT AS qp_IVCSW_CNT,
		qproc.VCSW_CNT AS qp_VCSW_CNT,
		qproc.READ_BYTES_CNT AS qp_READ_BYTES_CNT,
		qproc.READ_CHAR_CNT AS qp_READ_CHAR_CNT,
		qproc.READ_SYSCALLS_CNT AS qp_READ_SYSCALLS_CNT,
		qproc.WRITE_BYTES_CNT AS qp_WRITE_BYTES_CNT,
		qproc.WRITE_CHAR_CNT AS qp_WRITE_CHAR_CNT,
		qproc.WRITE_SYSCALLS_CNT AS qp_WRITE_SYSCALLS_CNT,
		qproc.GUEST_TKS AS qp_gtks,
		qproc.CGUEST_TKS AS qp_cgtks,
		uproc.U_TKS AS up_U_TKS,
		uproc.S_TKS AS up_S_TKS,
		uproc.MAJ_FLT_CNT AS up_MAJ_FLT_CNT,
		uproc.BLOCKIO_DELAY_TKS AS up_BLOCKIO_DELAY_TKS,
		uproc.IVCSW_CNT AS up_IVCSW_CNT,
		uproc.VCSW_CNT AS up_VCSW_CNT,
		uproc.READ_BYTES_CNT AS up_READ_BYTES_CNT,
		uproc.READ_CHAR_CNT AS up_READ_CHAR_CNT,
		uproc.READ_SYSCALLS_CNT AS up_READ_SYSCALLS_CNT,
		uproc.WRITE_BYTES_CNT AS up_WRITE_BYTES_CNT,
		uproc.WRITE_CHAR_CNT AS up_WRITE_CHAR_CNT,
		uproc.WRITE_SYSCALLS_CNT AS up_WRITE_SYSCALLS_CNT,
		uproc.GUEST_TKS AS up_gtks,
		uproc.CGUEST_TKS AS up_cgtks,
		dproc.U_TKS AS dp_U_TKS,
		dproc.S_TKS AS dp_S_TKS,
		dproc.MAJ_FLT_CNT as dp_MAJ_FLT_CNT,
		dproc.BLOCKIO_DELAY_TKS AS dp_BLOCKIO_DELAY_TKS,
		dproc.IVCSW_CNT AS dp_IVCSW_CNT,
		dproc.VCSW_CNT AS dp_VCSW_CNT,
		dproc.READ_BYTES_CNT AS dp_READ_BYTES_CNT,
		dproc.READ_CHAR_CNT AS dp_READ_CHAR_CNT,
		dproc.READ_SYSCALLS_CNT AS dp_READ_SYSCALLS_CNT,
		dproc.WRITE_BYTES_CNT AS dp_WRITE_BYTES_CNT,
		dproc.WRITE_CHAR_CNT AS dp_WRITE_CHAR_CNT,
		dproc.WRITE_SYSCALLS_CNT AS dp_WRITE_SYSCALLS_CNT,
		dproc.GUEST_TKS AS dp_gtks,
		dproc.CGUEST_TKS AS dp_cgtks,
		(qproc.U_TKS+uproc.U_TKS+dproc.U_TKS) AS sum_U_TKS,
		(qproc.S_TKS+uproc.S_TKS+dproc.S_TKS) AS sum_S_TKS,
		(qproc.MAJ_FLT_CNT+uproc.MAJ_FLT_CNT+dproc.MAJ_FLT_CNT) AS sum_MAJ_FLT_CNT
	FROM	SOExpl_S0_CQE qe,  -- QE with overall measures
		SOExpl_EXP_PI exproc, -- experiment process measures
		SOExpl_AQPI qproc, -- query process measures
		SOExpl_AUPI uproc, -- util process measures
		SOExpl_ADPI dproc, -- daemon process measures
		SOExpl_AQENProcs procs -- total processes in this QE
	WHERE 	qe.qeid  = exproc.qeid
	    AND exproc.qeid = qproc.qeid
	    AND qproc.qeid = uproc.qeid
	    AND uproc.qeid = dproc.qeid
	    AND dproc.qeid = procs.qeid
	ORDER BY qe.qeid ASC;
ALTER TABLE SOExpl_AQED ADD PRIMARY KEY (qeid); 

-- Compute query times
-- Ticks/counts are to 2 decimal places. 
-- Times are to one decimal place. 
-- SOExpl_ACTQatC: SOExpl_All_Calculated_queryTime_QatC
DROP TABLE SOExpl_ACTQatC CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_ACTQatC AS
	SELECT  version,
	        experimentid, 
	        experimentname,
		dbms, 
		runid,
		querynum,
		card, 
		planid, 
		-- calculated query time stat
		MIN((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10) as min_calc_qt,
		MAX((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10) as max_calc_qt,
		ROUND(AVG((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10), 1) as avg_calc_qt,
		ROUND(MEDIAN((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10), 1) as med_calc_qt,
		ROUND(STDDEV((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10), 1) as std_calc_qt,
		-- measured time stat
		MIN(measured_time) as min_meas_time,
		MAX(measured_time) as max_meas_time,
		ROUND(AVG(measured_time),1) as avg_meas_time,
		ROUND(STDDEV(measured_time),1) as std_meas_time,
		ROUND(MEDIAN(measured_time),1) as med_meas_time,
		-- overall measure stat
		-- overall uticks
		MIN(OVR_U_TKS) AS MIN_OVR_U_TKS, 
		MAX(OVR_U_TKS) AS MAX_OVR_U_TKS, 
		ROUND(AVG(OVR_U_TKS),2) AS AVG_OVR_U_TKS, 
		ROUND(STDDEV(OVR_U_TKS),2) AS STD_OVR_U_TKS, 
		ROUND(MEDIAN(OVR_U_TKS),2) AS MED_OVR_U_TKS, 
		-- overall lowpriority uticks
		MIN(OVR_LU_TKS) AS MIN_OVR_LU_TKS, 
		MAX(OVR_LU_TKS) AS MAX_OVR_LU_TKS, 
		ROUND(AVG(OVR_LU_TKS),2) AS AVG_OVR_LU_TKS, 
		ROUND(STDDEV(OVR_LU_TKS),2) AS STD_OVR_LU_TKS, 
		ROUND(MEDIAN(OVR_LU_TKS),2) AS MED_OVR_LU_TKS, 
		-- overall sticks
		MIN(OVR_S_TKS) AS MIN_OVR_S_TKS, 
		MAX(OVR_S_TKS) AS MAX_OVR_S_TKS, 
		ROUND(AVG(OVR_S_TKS),2) AS AVG_OVR_S_TKS, 
		ROUND(STDDEV(OVR_S_TKS),2) AS STD_OVR_S_TKS, 
		ROUND(MEDIAN(OVR_S_TKS),2) AS MED_OVR_S_TKS, 
		-- IOWait ticks
		MIN(OVR_IOWAIT_TKS) as min_OVR_IOWAIT_TKS,
		MAX(OVR_IOWAIT_TKS) as max_OVR_IOWAIT_TKS,
		ROUND(AVG(OVR_IOWAIT_TKS),2) as avg_OVR_IOWAIT_TKS,
		ROUND(stddev(OVR_IOWAIT_TKS),2) as std_OVR_IOWAIT_TKS,
		ROUND(MEDIAN(OVR_IOWAIT_TKS),2) AS MED_OVR_IOWAIT_TKS, 
		-- overall idle ticks
		MIN(OVR_IDLE_TKS) AS MIN_OVR_IDLE_TKS, 
		MAX(OVR_IDLE_TKS) AS MAX_OVR_IDLE_TKS, 
		ROUND(AVG(OVR_IDLE_TKS),2) AS AVG_OVR_IDLE_TKS, 
		ROUND(STDDEV(OVR_IDLE_TKS),2) AS STD_OVR_IDLE_TKS, 
		ROUND(MEDIAN(OVR_IDLE_TKS),2) AS MED_OVR_IDLE_TKS, 
		-- overall steal ticks
		MIN(OVR_STEAL_TKS) AS MIN_OVR_STEAL_TKS, 
		MAX(OVR_STEAL_TKS) AS MAX_OVR_STEAL_TKS, 
		ROUND(AVG(OVR_STEAL_TKS),2) AS AVG_OVR_STEAL_TKS, 
		ROUND(STDDEV(OVR_STEAL_TKS),2) AS STD_OVR_STEAL_TKS, 
		ROUND(MEDIAN(OVR_STEAL_TKS),2) AS MED_OVR_STEAL_TKS, 
		-- overall guest ticks
		MIN(OVR_GUEST_TKS) AS MIN_OVR_GUEST_TKS, 
		MAX(OVR_GUEST_TKS) AS MAX_OVR_GUEST_TKS, 
		ROUND(AVG(OVR_GUEST_TKS),2) AS AVG_OVR_GUEST_TKS, 
		ROUND(STDDEV(OVR_GUEST_TKS),2) AS STD_OVR_GUEST_TKS, 
		ROUND(MEDIAN(OVR_GUEST_TKS),2) AS MED_OVR_GUEST_TKS, 
		-- overall IRQ ticks
		MIN(OVR_IRQ_TKS) AS MIN_OVR_IRQ_TKS, 
		MAX(OVR_IRQ_TKS) AS MAX_OVR_IRQ_TKS, 
		ROUND(AVG(OVR_IRQ_TKS),2) AS AVG_OVR_IRQ_TKS, 
		ROUND(STDDEV(OVR_IRQ_TKS),2) AS STD_OVR_IRQ_TKS, 
		ROUND(MEDIAN(OVR_IRQ_TKS),2) AS MED_OVR_IRQ_TKS, 
		-- overall SoftIRQ ticks
		MIN(OVR_SOFTIRQ_TKS) AS MIN_OVR_SOFTIRQ_TKS, 
		MAX(OVR_SOFTIRQ_TKS) AS MAX_OVR_SOFTIRQ_TKS, 
		ROUND(AVG(OVR_SOFTIRQ_TKS),2) AS AVG_OVR_SOFTIRQ_TKS, 
		ROUND(STDDEV(OVR_SOFTIRQ_TKS),2) AS STD_OVR_SOFTIRQ_TKS, 
		ROUND(MEDIAN(OVR_SOFTIRQ_TKS),2) AS MED_OVR_SOFTIRQ_TKS,
		-- proc count stats
		MIN(NUMPROCS) AS MIN_NUMPROCS, 
		MAX(NUMPROCS) AS MAX_NUMPROCS, 
		ROUND(AVG(NUMPROCS),2) AS AVG_NUMPROCS, 
		ROUND(STDDEV(NUMPROCS),2) AS STD_NUMPROCS, 
		ROUND(MEDIAN(NUMPROCS),2) AS MED_NUMPROCS,
		-- per-process measure stat
		-- query process measure stat
		-- query process uticks
		MIN(qp_U_TKS) as min_qp_U_TKS,
		MAX(qp_U_TKS) as max_qp_U_TKS,
		ROUND(AVG(qp_U_TKS),2) as avg_qp_U_TKS,
		ROUND(stddev(qp_U_TKS),2) as std_qp_U_TKS,
		ROUND(MEDIAN(qp_U_TKS), 2) as med_qp_U_TKS,
		-- query process sticks
		MIN(QP_S_TKS) AS MIN_QP_S_TKS, 
		MAX(QP_S_TKS) AS MAX_QP_S_TKS, 
		ROUND(AVG(QP_S_TKS),2) AS AVG_QP_S_TKS, 
		ROUND(STDDEV(QP_S_TKS),2) AS STD_QP_S_TKS, 
		ROUND(MEDIAN(QP_S_TKS),2) AS MED_QP_S_TKS, 
		-- query process major faults
		MIN(QP_MAJ_FLT_CNT) AS MIN_QP_MAJ_FLT_CNT, 
		MAX(QP_MAJ_FLT_CNT) AS MAX_QP_MAJ_FLT_CNT, 
		ROUND(AVG(QP_MAJ_FLT_CNT),2) AS AVG_QP_MAJ_FLT_CNT, 
		ROUND(STDDEV(QP_MAJ_FLT_CNT),2) AS STD_QP_MAJ_FLT_CNT, 
		ROUND(MEDIAN(QP_MAJ_FLT_CNT),2) AS MED_QP_MAJ_FLT_CNT, 
		-- query process block IO delay ticks
		MIN(QP_BLOCKIO_DELAY_TKS) AS MIN_QP_BLOCKIO_DELAY_TKS, 
		MAX(QP_BLOCKIO_DELAY_TKS) AS MAX_QP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(QP_BLOCKIO_DELAY_TKS),2) AS AVG_QP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(QP_BLOCKIO_DELAY_TKS),2) AS STD_QP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(QP_BLOCKIO_DELAY_TKS),2) AS MED_QP_BLOCKIO_DELAY_TKS, 
		-- query process involuntary context switches
		MIN(QP_IVCSW_CNT) AS MIN_QP_IVCSW_CNT, 
		MAX(QP_IVCSW_CNT) AS MAX_QP_IVCSW_CNT, 
		ROUND(AVG(QP_IVCSW_CNT),2) AS AVG_QP_IVCSW_CNT, 
		ROUND(STDDEV(QP_IVCSW_CNT),2) AS STD_QP_IVCSW_CNT, 
		ROUND(MEDIAN(QP_IVCSW_CNT),2) AS MED_QP_IVCSW_CNT, 
		-- query process volunatry context switches
		MIN(QP_VCSW_CNT) AS MIN_QP_VCSW_CNT, 
		MAX(QP_VCSW_CNT) AS MAX_QP_VCSW_CNT, 
		ROUND(AVG(QP_VCSW_CNT),2) AS AVG_QP_VCSW_CNT, 
		ROUND(STDDEV(QP_VCSW_CNT),2) AS STD_QP_VCSW_CNT, 
		ROUND(MEDIAN(QP_VCSW_CNT),2) AS MED_QP_VCSW_CNT,
		-- query process read bytes
		MIN(QP_READ_BYTES_CNT) AS MIN_QP_READ_BYTES_CNT, 
		MAX(QP_READ_BYTES_CNT) AS MAX_QP_READ_BYTES_CNT,	
		ROUND(AVG(QP_READ_BYTES_CNT),2) AS AVG_QP_READ_BYTES_CNT, 
		ROUND(STDDEV(QP_READ_BYTES_CNT),2) AS STD_QP_READ_BYTES_CNT, 
		ROUND(MEDIAN(QP_READ_BYTES_CNT),2) AS MED_QP_READ_BYTES_CNT, 
		-- query process read chars
		MIN(QP_READ_CHAR_CNT) AS MIN_QP_READ_CHAR_CNT, 
		MAX(QP_READ_CHAR_CNT) AS MAX_QP_READ_CHAR_CNT, 
		ROUND(AVG(QP_READ_CHAR_CNT),2) AS AVG_QP_READ_CHAR_CNT, 
		ROUND(STDDEV(QP_READ_CHAR_CNT),2) AS STD_QP_READ_CHAR_CNT, 
		ROUND(MEDIAN(QP_READ_CHAR_CNT),2) AS MED_QP_READ_CHAR_CNT, 
		-- query process read syscalls
		MIN(QP_READ_SYSCALLS_CNT) AS MIN_QP_READ_SYSCALLS_CNT, 
		MAX(QP_READ_SYSCALLS_CNT) AS MAX_QP_READ_SYSCALLS_CNT,	
		ROUND(AVG(QP_READ_SYSCALLS_CNT),2) AS AVG_QP_READ_SYSCALLS_CNT, 
		ROUND(STDDEV(QP_READ_SYSCALLS_CNT),2) AS STD_QP_READ_SYSCALLS_CNT, 
		ROUND(MEDIAN(QP_READ_SYSCALLS_CNT),2) AS MED_QP_READ_SYSCALLS_CNT, 
		-- query process write bytes
		MIN(QP_WRITE_BYTES_CNT) AS MIN_QP_WRITE_BYTES_CNT, 
		MAX(QP_WRITE_BYTES_CNT) AS MAX_QP_WRITE_BYTES_CNT, 
		ROUND(AVG(QP_WRITE_BYTES_CNT),2) AS AVG_QP_WRITE_BYTES_CNT, 
		ROUND(STDDEV(QP_WRITE_BYTES_CNT),2) AS STD_QP_WRITE_BYTES_CNT, 
		ROUND(MEDIAN(QP_WRITE_BYTES_CNT),2) AS MED_QP_WRITE_BYTES_CNT, 
		-- query process write chars
		MIN(QP_WRITE_CHAR_CNT) AS MIN_QP_WRITE_CHAR_CNT, 
		MAX(QP_WRITE_CHAR_CNT) AS MAX_QP_WRITE_CHAR_CNT, 
		ROUND(AVG(QP_WRITE_CHAR_CNT),2) AS AVG_QP_WRITE_CHAR_CNT, 
		ROUND(STDDEV(QP_WRITE_CHAR_CNT),2) AS STD_QP_WRITE_CHAR_CNT, 
		ROUND(MEDIAN(QP_WRITE_CHAR_CNT),2) AS MED_QP_WRITE_CHAR_CNT,
		-- query process write syscalls
		MIN(QP_WRITE_SYSCALLS_CNT) AS MIN_QP_WRITE_SYSCALLS_CNT, 
		MAX(QP_WRITE_SYSCALLS_CNT) AS MAX_QP_WRITE_SYSCALLS_CNT,	
		ROUND(AVG(QP_WRITE_SYSCALLS_CNT),2) AS AVG_QP_WRITE_SYSCALLS_CNT, 
		ROUND(STDDEV(QP_WRITE_SYSCALLS_CNT),2) AS STD_QP_WRITE_SYSCALLS_CNT, 
		ROUND(MEDIAN(QP_WRITE_SYSCALLS_CNT),2) AS MED_QP_WRITE_SYSCALLS_CNT, 
		-- query process guest ticks
		MIN(QP_GTKS) AS MIN_QP_GTKS, 
		MAX(QP_GTKS) AS MAX_QP_GTKS, 
		ROUND(AVG(QP_GTKS),2) AS AVG_QP_GTKS, 
		ROUND(STDDEV(QP_GTKS),2) AS STD_QP_GTKS, 
		ROUND(MEDIAN(QP_GTKS),2) AS MED_QP_GTKS, 
		-- query process cguest ticks
		MIN(QP_CGTKS) AS MIN_QP_CGTKS, 
		MAX(QP_CGTKS) AS MAX_QP_CGTKS, 
		ROUND(AVG(QP_CGTKS),2) AS AVG_QP_CGTKS, 
		ROUND(STDDEV(QP_CGTKS),2) AS STD_QP_CGTKS, 
		ROUND(MEDIAN(QP_CGTKS),2) AS MED_QP_CGTKS,
 		-- utility process measure stat
		-- utility processes' uticks
		MIN(UP_U_TKS) AS MIN_UP_U_TKS, 
		MAX(UP_U_TKS) AS MAX_UP_U_TKS, 
		ROUND(AVG(UP_U_TKS),2) AS AVG_UP_U_TKS, 
		ROUND(STDDEV(UP_U_TKS),2) AS STD_UP_U_TKS, 
		ROUND(MEDIAN(UP_U_TKS),2) AS MED_UP_U_TKS,
		-- utility processes' sticks
		MIN(UP_S_TKS) AS MIN_UP_S_TKS, 
		MAX(UP_S_TKS) AS MAX_UP_S_TKS, 
		ROUND(AVG(UP_S_TKS),2) AS AVG_UP_S_TKS, 
		ROUND(STDDEV(UP_S_TKS),2) AS STD_UP_S_TKS, 
		ROUND(MEDIAN(UP_S_TKS),2) AS MED_UP_S_TKS, 
		-- utility processes' major faults
		MIN(up_MAJ_FLT_CNT) as min_up_MAJ_FLT_CNT,
		MAX(up_MAJ_FLT_CNT) as max_up_MAJ_FLT_CNT, 
		ROUND(AVG(up_MAJ_FLT_CNT),2) as avg_up_MAJ_FLT_CNT, 
		ROUND(stddev(up_MAJ_FLT_CNT),2) as std_up_MAJ_FLT_CNT,
		ROUND(MEDIAN(up_MAJ_FLT_CNT), 2) as med_up_MAJ_FLT_CNT,
		-- utility processes' block IO delay ticks
		MIN(UP_BLOCKIO_DELAY_TKS) AS MIN_UP_BLOCKIO_DELAY_TKS, 
		MAX(UP_BLOCKIO_DELAY_TKS) AS MAX_UP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(UP_BLOCKIO_DELAY_TKS),2) AS AVG_UP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(UP_BLOCKIO_DELAY_TKS),2) AS STD_UP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(UP_BLOCKIO_DELAY_TKS),2) AS MED_UP_BLOCKIO_DELAY_TKS,
		-- utility processes' involunatry context switches
		MIN(UP_IVCSW_CNT) AS MIN_UP_IVCSW_CNT, 
		MAX(UP_IVCSW_CNT) AS MAX_UP_IVCSW_CNT, 
		ROUND(AVG(UP_IVCSW_CNT),2) AS AVG_UP_IVCSW_CNT, 
		ROUND(STDDEV(UP_IVCSW_CNT),2) AS STD_UP_IVCSW_CNT, 
		ROUND(MEDIAN(UP_IVCSW_CNT),2) AS MED_UP_IVCSW_CNT, 
		-- utility processes' volunatry context switches
		MIN(UP_VCSW_CNT) AS MIN_UP_VCSW_CNT, 
		MAX(UP_VCSW_CNT) AS MAX_UP_VCSW_CNT, 
		ROUND(AVG(UP_VCSW_CNT),2) AS AVG_UP_VCSW_CNT, 
		ROUND(STDDEV(UP_VCSW_CNT),2) AS STD_UP_VCSW_CNT, 
		ROUND(MEDIAN(UP_VCSW_CNT),2) AS MED_UP_VCSW_CNT, 
		-- utility processes' read bytes
		MIN(UP_READ_BYTES_CNT) AS MIN_UP_READ_BYTES_CNT, 
		MAX(UP_READ_BYTES_CNT) AS MAX_UP_READ_BYTES_CNT, 
		ROUND(AVG(UP_READ_BYTES_CNT),2) AS AVG_UP_READ_BYTES_CNT, 
		ROUND(STDDEV(UP_READ_BYTES_CNT),2) AS STD_UP_READ_BYTES_CNT, 
		ROUND(MEDIAN(UP_READ_BYTES_CNT),2) AS MED_UP_READ_BYTES_CNT, 
		-- utility processes' read chars
		MIN(UP_READ_CHAR_CNT) AS MIN_UP_READ_CHAR_CNT, 
		MAX(UP_READ_CHAR_CNT) AS MAX_UP_READ_CHAR_CNT, 
		ROUND(AVG(UP_READ_CHAR_CNT),2) AS AVG_UP_READ_CHAR_CNT, 
		ROUND(STDDEV(UP_READ_CHAR_CNT),2) AS STD_UP_READ_CHAR_CNT, 
		ROUND(MEDIAN(UP_READ_CHAR_CNT),2) AS MED_UP_READ_CHAR_CNT,
		-- utility processes' read syscalls
		MIN(UP_READ_SYSCALLS_CNT) AS MIN_UP_READ_SYSCALLS_CNT, 
		MAX(UP_READ_SYSCALLS_CNT) AS MAX_UP_READ_SYSCALLS_CNT,	
		ROUND(AVG(UP_READ_SYSCALLS_CNT),2) AS AVG_UP_READ_SYSCALLS_CNT, 
		ROUND(STDDEV(UP_READ_SYSCALLS_CNT),2) AS STD_UP_READ_SYSCALLS_CNT, 
		ROUND(MEDIAN(UP_READ_SYSCALLS_CNT),2) AS MED_UP_READ_SYSCALLS_CNT, 
		-- utility processes' write bytes
		MIN(UP_WRITE_BYTES_CNT) AS MIN_UP_WRITE_BYTES_CNT, 
		MAX(UP_WRITE_BYTES_CNT) AS MAX_UP_WRITE_BYTES_CNT, 
		ROUND(AVG(UP_WRITE_BYTES_CNT),2) AS AVG_UP_WRITE_BYTES_CNT, 
		ROUND(STDDEV(UP_WRITE_BYTES_CNT),2) AS STD_UP_WRITE_BYTES_CNT, 
		ROUND(MEDIAN(UP_WRITE_BYTES_CNT),2) AS MED_UP_WRITE_BYTES_CNT, 
		-- utility processes' write chars
		MIN(UP_WRITE_CHAR_CNT) AS MIN_UP_WRITE_CHAR_CNT, 
		MAX(UP_WRITE_CHAR_CNT) AS MAX_UP_WRITE_CHAR_CNT, 
		ROUND(AVG(UP_WRITE_CHAR_CNT),2) AS AVG_UP_WRITE_CHAR_CNT, 
		ROUND(STDDEV(UP_WRITE_CHAR_CNT),2) AS STD_UP_WRITE_CHAR_CNT, 
		ROUND(MEDIAN(UP_WRITE_CHAR_CNT),2) AS MED_UP_WRITE_CHAR_CNT, 
		-- utility processes' write syscalls
		MIN(UP_WRITE_SYSCALLS_CNT) AS MIN_UP_WRITE_SYSCALLS_CNT, 
		MAX(UP_WRITE_SYSCALLS_CNT) AS MAX_UP_WRITE_SYSCALLS_CNT,	
		ROUND(AVG(UP_WRITE_SYSCALLS_CNT),2) AS AVG_UP_WRITE_SYSCALLS_CNT, 
		ROUND(STDDEV(UP_WRITE_SYSCALLS_CNT),2) AS STD_UP_WRITE_SYSCALLS_CNT, 
		ROUND(MEDIAN(UP_WRITE_SYSCALLS_CNT),2) AS MED_UP_WRITE_SYSCALLS_CNT, 
		-- utility processes' guest ticks
		MIN(UP_GTKS) AS MIN_UP_GTKS, 
		MAX(UP_GTKS) AS MAX_UP_GTKS, 
		ROUND(AVG(UP_GTKS),2) AS AVG_UP_GTKS, 
		ROUND(STDDEV(UP_GTKS),2) AS STD_UP_GTKS, 
		ROUND(MEDIAN(UP_GTKS),2) AS MED_UP_GTKS, 
		-- utility processes' cguest ticks
		MIN(UP_CGTKS) AS MIN_UP_CGTKS, 
		MAX(UP_CGTKS) AS MAX_UP_CGTKS, 
		ROUND(AVG(UP_CGTKS),2) AS AVG_UP_CGTKS, 
		ROUND(STDDEV(UP_CGTKS),2) AS STD_UP_CGTKS, 
		ROUND(MEDIAN(UP_CGTKS),2) AS MED_UP_CGTKS, 
		-- daemon processes' measure stat
		-- daemon processes' uticks
		MIN(DP_U_TKS) AS MIN_DP_U_TKS, 
		MAX(DP_U_TKS) AS MAX_DP_U_TKS, 
		ROUND(AVG(DP_U_TKS),2) AS AVG_DP_U_TKS, 
		ROUND(STDDEV(DP_U_TKS),2) AS STD_DP_U_TKS, 
		ROUND(MEDIAN(DP_U_TKS),2) AS MED_DP_U_TKS, 
		-- daemon processes' sticks
		MIN(DP_S_TKS) AS MIN_DP_S_TKS, 
		MAX(DP_S_TKS) AS MAX_DP_S_TKS, 
		ROUND(AVG(DP_S_TKS),2) AS AVG_DP_S_TKS, 
		ROUND(STDDEV(DP_S_TKS),2) AS STD_DP_S_TKS, 
		ROUND(MEDIAN(DP_S_TKS),2) AS MED_DP_S_TKS, 
		-- daemon processes' major faults
		MIN(dp_MAJ_FLT_CNT) as min_dp_MAJ_FLT_CNT,
		MAX(dp_MAJ_FLT_CNT) as max_dp_MAJ_FLT_CNT,
		ROUND(AVG(dp_MAJ_FLT_CNT),2) as avg_dp_MAJ_FLT_CNT,
		ROUND(stddev(dp_MAJ_FLT_CNT),2) as std_dp_MAJ_FLT_CNT,
		ROUND(MEDIAN(dp_MAJ_FLT_CNT), 2) as med_dp_MAJ_FLT_CNT,
		-- daemon processes' block IO delay ticks
		MIN(DP_BLOCKIO_DELAY_TKS) AS MIN_DP_BLOCKIO_DELAY_TKS, 
		MAX(DP_BLOCKIO_DELAY_TKS) AS MAX_DP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(DP_BLOCKIO_DELAY_TKS),2) AS AVG_DP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(DP_BLOCKIO_DELAY_TKS),2) AS STD_DP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(DP_BLOCKIO_DELAY_TKS),2) AS MED_DP_BLOCKIO_DELAY_TKS,
		-- daemon processes' involunatry context switches
		MIN(DP_IVCSW_CNT) AS MIN_DP_IVCSW_CNT, 
		MAX(DP_IVCSW_CNT) AS MAX_DP_IVCSW_CNT, 
		ROUND(AVG(DP_IVCSW_CNT),2) AS AVG_DP_IVCSW_CNT, 
		ROUND(STDDEV(DP_IVCSW_CNT),2) AS STD_DP_IVCSW_CNT, 
		ROUND(MEDIAN(DP_IVCSW_CNT),2) AS MED_DP_IVCSW_CNT, 
		-- daemon processes' volunatry context switches
		MIN(DP_VCSW_CNT) AS MIN_DP_VCSW_CNT, 
		MAX(DP_VCSW_CNT) AS MAX_DP_VCSW_CNT, 
		ROUND(AVG(DP_VCSW_CNT),2) AS AVG_DP_VCSW_CNT, 
		ROUND(STDDEV(DP_VCSW_CNT),2) AS STD_DP_VCSW_CNT, 
		ROUND(MEDIAN(DP_VCSW_CNT),2) AS MED_DP_VCSW_CNT, 
		-- daemon processes' read bytes
		MIN(DP_READ_BYTES_CNT) AS MIN_DP_READ_BYTES_CNT, 
		MAX(DP_READ_BYTES_CNT) AS MAX_DP_READ_BYTES_CNT, 
		ROUND(AVG(DP_READ_BYTES_CNT),2) AS AVG_DP_READ_BYTES_CNT, 
		ROUND(STDDEV(DP_READ_BYTES_CNT),2) AS STD_DP_READ_BYTES_CNT, 
		ROUND(MEDIAN(DP_READ_BYTES_CNT),2) AS MED_DP_READ_BYTES_CNT, 
		-- daemon processes' read chars
		MIN(DP_READ_CHAR_CNT) AS MIN_DP_READ_CHAR_CNT, 
		MAX(DP_READ_CHAR_CNT) AS MAX_DP_READ_CHAR_CNT, 
		ROUND(AVG(DP_READ_CHAR_CNT),2) AS AVG_DP_READ_CHAR_CNT, 
		ROUND(STDDEV(DP_READ_CHAR_CNT),2) AS STD_DP_READ_CHAR_CNT, 
		ROUND(MEDIAN(DP_READ_CHAR_CNT),2) AS MED_DP_READ_CHAR_CNT, 
		-- daemon processes' read syscalls
		MIN(DP_READ_SYSCALLS_CNT) AS MIN_DP_READ_SYSCALLS_CNT, 
		MAX(DP_READ_SYSCALLS_CNT) AS MAX_DP_READ_SYSCALLS_CNT,	
		ROUND(AVG(DP_READ_SYSCALLS_CNT),2) AS AVG_DP_READ_SYSCALLS_CNT, 
		ROUND(STDDEV(DP_READ_SYSCALLS_CNT),2) AS STD_DP_READ_SYSCALLS_CNT, 
		ROUND(MEDIAN(DP_READ_SYSCALLS_CNT),2) AS MED_DP_READ_SYSCALLS_CNT,
		-- daemon processes' write bytes
		MIN(DP_WRITE_BYTES_CNT) AS MIN_DP_WRITE_BYTES_CNT, 
		MAX(DP_WRITE_BYTES_CNT) AS MAX_DP_WRITE_BYTES_CNT, 
		ROUND(AVG(DP_WRITE_BYTES_CNT),2) AS AVG_DP_WRITE_BYTES_CNT, 
		ROUND(STDDEV(DP_WRITE_BYTES_CNT),2) AS STD_DP_WRITE_BYTES_CNT, 
		ROUND(MEDIAN(DP_WRITE_BYTES_CNT),2) AS MED_DP_WRITE_BYTES_CNT, 
		-- daemon processes' write chars
		MIN(DP_WRITE_CHAR_CNT) AS MIN_DP_WRITE_CHAR_CNT, 
		MAX(DP_WRITE_CHAR_CNT) AS MAX_DP_WRITE_CHAR_CNT, 
		ROUND(AVG(DP_WRITE_CHAR_CNT),2) AS AVG_DP_WRITE_CHAR_CNT, 
		ROUND(STDDEV(DP_WRITE_CHAR_CNT),2) AS STD_DP_WRITE_CHAR_CNT, 
		ROUND(MEDIAN(DP_WRITE_CHAR_CNT),2) AS MED_DP_WRITE_CHAR_CNT,
		-- daemon processes' write syscalls
		MIN(DP_WRITE_SYSCALLS_CNT) AS MIN_DP_WRITE_SYSCALLS_CNT, 
		MAX(DP_WRITE_SYSCALLS_CNT) AS MAX_DP_WRITE_SYSCALLS_CNT,	
		ROUND(AVG(DP_WRITE_SYSCALLS_CNT),2) AS AVG_DP_WRITE_SYSCALLS_CNT, 
		ROUND(STDDEV(DP_WRITE_SYSCALLS_CNT),2) AS STD_DP_WRITE_SYSCALLS_CNT, 
		ROUND(MEDIAN(DP_WRITE_SYSCALLS_CNT),2) AS MED_DP_WRITE_SYSCALLS_CNT, 
		-- daemon processes' guest ticks
		MIN(DP_GTKS) AS MIN_DP_GTKS, 
		MAX(DP_GTKS) AS MAX_DP_GTKS, 
		ROUND(AVG(DP_GTKS),2) AS AVG_DP_GTKS, 
		ROUND(STDDEV(DP_GTKS),2) AS STD_DP_GTKS, 
		ROUND(MEDIAN(DP_GTKS),2) AS MED_DP_GTKS, 
		-- daemon processes' cguest ticks
		MIN(DP_CGTKS) AS MIN_DP_CGTKS, 
		MAX(DP_CGTKS) AS MAX_DP_CGTKS, 
		ROUND(AVG(DP_CGTKS),2) AS AVG_DP_CGTKS, 
		ROUND(STDDEV(DP_CGTKS),2) AS STD_DP_CGTKS, 
		ROUND(MEDIAN(DP_CGTKS),2) AS MED_DP_CGTKS, 
		-- experiment process' u tks
		MIN(ep_U_TKS) as min_ep_U_TKS,
		MAX(ep_U_TKS) as max_ep_U_TKS,
		ROUND(AVG(ep_U_TKS),2) as avg_ep_U_TKS,
		ROUND(stddev(ep_U_TKS),2) as std_ep_U_TKS,
		ROUND(MEDIAN(ep_U_TKS), 2) as med_ep_U_TKS,
		-- experiment process' s tks
		MIN(EP_S_TKS) AS MIN_EP_S_TKS, 
		MAX(EP_S_TKS) AS MAX_EP_S_TKS, 
		ROUND(AVG(EP_S_TKS),2) AS AVG_EP_S_TKS, 
		ROUND(STDDEV(EP_S_TKS),2) AS STD_EP_S_TKS, 
		ROUND(MEDIAN(EP_S_TKS),2) AS MED_EP_S_TKS, 
		-- experiment process' maj flts
		MIN(EP_MAJ_FLT_CNT) AS MIN_EP_MAJ_FLT_CNT, 
		MAX(EP_MAJ_FLT_CNT) AS MAX_EP_MAJ_FLT_CNT, 
		ROUND(AVG(EP_MAJ_FLT_CNT),2) AS AVG_EP_MAJ_FLT_CNT, 
		ROUND(STDDEV(EP_MAJ_FLT_CNT),2) AS STD_EP_MAJ_FLT_CNT, 
		ROUND(MEDIAN(EP_MAJ_FLT_CNT),2) AS MED_EP_MAJ_FLT_CNT, 
		-- experiment process' block IO delay ticks
		MIN(EP_BLOCKIO_DELAY_TKS) AS MIN_EP_BLOCKIO_DELAY_TKS, 
		MAX(EP_BLOCKIO_DELAY_TKS) AS MAX_EP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(EP_BLOCKIO_DELAY_TKS),2) AS AVG_EP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(EP_BLOCKIO_DELAY_TKS),2) AS STD_EP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(EP_BLOCKIO_DELAY_TKS),2) AS MED_EP_BLOCKIO_DELAY_TKS, 
		-- stats on the sum of per-process uticks
		MIN(SUM_U_TKS) AS MIN_SUM_U_TKS, 
		MAX(SUM_U_TKS) AS MAX_SUM_U_TKS, 
		ROUND(AVG(SUM_U_TKS),2) AS AVG_SUM_U_TKS, 
		ROUND(STDDEV(SUM_U_TKS),2) AS STD_SUM_U_TKS, 
		ROUND(MEDIAN(SUM_U_TKS),2) AS MED_SUM_U_TKS, 
		-- stats on the sum of per-process sticks
		MIN(SUM_S_TKS) AS MIN_SUM_S_TKS, 
		MAX(SUM_S_TKS) AS MAX_SUM_S_TKS, 
		ROUND(AVG(SUM_S_TKS),2) AS AVG_SUM_S_TKS, 
		ROUND(STDDEV(SUM_S_TKS),2) AS STD_SUM_S_TKS, 
		ROUND(MEDIAN(SUM_S_TKS),2) AS MED_SUM_S_TKS, 
		-- stats on the sum of per-process major faults
		MIN(SUM_MAJ_FLT_CNT) AS MIN_SUM_MAJ_FLT_CNT, 
		MAX(SUM_MAJ_FLT_CNT) AS MAX_SUM_MAJ_FLT_CNT, 
		ROUND(AVG(SUM_MAJ_FLT_CNT),2) AS AVG_SUM_MAJ_FLT_CNT, 
		ROUND(STDDEV(SUM_MAJ_FLT_CNT),2) AS STD_SUM_MAJ_FLT_CNT, 
		ROUND(MEDIAN(SUM_MAJ_FLT_CNT),2) AS MED_SUM_MAJ_FLT_CNT
	FROM SOExpl_AQED qed
	GROUP BY qed.version, qed.experimentid, qed.experimentname, qed.dbms, qed.runid, qed.querynum, qed.card, qed.planid;
ALTER TABLE SOExpl_ACTQatC ADD PRIMARY KEY (runid, querynum, card); 

-- Record the result size of SOExpl_ACTQatC
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_ACTQatC';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_ACTQatC' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_ACTQatC
	GROUP BY dbms, experimentname;

-- true rollup query
--SELECT qproc_id pid, sum(cticks)
--FROM (    
--	SELECT process_id,
--               pp_id,
--               (U_TKS+S_TKS) as cticks,
--               CONNECT_BY_ROOT process_id qproc_id
--        FROM azdblab_queryexecutionprocs 
--	where queryexecutionid = 553282
--	 and  process_name_str like 'db2%'
--      	CONNECT BY PRIOR process_id = pp_id)
--GROUP BY qproc_id
--ORDER BY qproc_id ASC

-- SOExpl_ACTQ: SOExpl_All_Calculated_Time_Queries
DROP TABLE SOExpl_ACTQ CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_ACTQ AS
	SELECT  dbms, 
		experimentname,
		runid,
		querynum
	FROM SOExpl_ACTQatC
	GROUP BY dbms, experimentname, runid, querynum;
ALTER TABLE SOExpl_ACTQ ADD PRIMARY KEY (runid, querynum); 
-- Record the result size of SOExpl_ACTQ
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_ACTQ';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_ACTQ' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_ACTQ
	GROUP BY dbms, experimentname;

-- Collect all Q@Cs having the same plan for raw data
-- SOExpl_ASPQatC: SOExpl_New_Same_Plan_QatC
DROP TABLE SOExpl_ASPQatC CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_ASPQatC AS
	SELECT p1.*, 
	       p2.card as card2, 
	       p2.med_calc_qt as med_calc_qt2,
	       p2.std_calc_qt as std_calc_qt2
	FROM SOExpl_ACTQatC p1, 		
	     SOExpl_ACTQatC p2 
	WHERE p1.runid    = p2.runid    AND
	      p1.querynum = p2.querynum AND
	      p1.planid   = p2.planid   AND
	      p1.card < p2.card
	ORDER BY p1.runid, p1.querynum, p1.card, p2.card;
ALTER TABLE SOExpl_ASPQatC ADD PRIMARY KEY (runid, querynum, card, card2); 

-- Record the result size of SOExpl_ASPQatC
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_ASPQatC';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_ASPQatC' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_ASPQatC
	GROUP BY dbms, experimentname;

-- Table X. Query execution sanity checks

-- 1st Ephemeral Process Violation
-- Count ephemeral process violations per dbms per experiment
-- SOExpl_S1_EPV_PDE : SOExpl_S1_Ephemeral_Process_Violations 
DROP VIEW SOExpl_S1_EPV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_EPV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       qeid
	FROM SOExpl_S0_CQE 
	WHERE OVR_EPHEMERALPPROCS_CNT > 0;
ALTER VIEW SOExpl_S1_EPV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW SOExpl_S1_EPV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_EPV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0)  AS EphProcViolsPerRun
	FROM SOExpl_S1_EPV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_EPV ADD PRIMARY KEY (runid) DISABLE; 

-- 2nd DBMS Time Violations
-- Count DBMS (query+utility) Time Violations per dbms per experiment
-- SOExpl_S1_DTV_PDE : SOExpl_S1_DBMS_Time_Violations 
DROP VIEW SOExpl_S1_DTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_DTV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       qeid
	FROM SOExpl_AQED
	WHERE (qp_U_TKS+up_U_TKS+qp_S_TKS+up_S_TKS+qp_BLOCKIO_DELAY_TKS+up_BLOCKIO_DELAY_TKS) < (dp_U_TKS+dp_S_TKS+dp_BLOCKIO_DELAY_TKS);
ALTER VIEW SOExpl_S1_DTV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW SOExpl_S1_DTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_DTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0)  AS DBMSTimeViolsPerRun
	FROM SOExpl_S1_DTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_DTV ADD PRIMARY KEY (runid) DISABLE; 

-- 3rd Zero Query Time violations
-- Count zero "Query Time" violations per dbms per experiment: querytime = 0
-- SOExpl_S1_ZQTV_PDE: SOExpl_S1_DBMS_Time_Violations 
DROP VIEW SOExpl_S1_ZQTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_ZQTV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       qeid
	FROM  SOExpl_AQED
	WHERE (qp_U_TKS+qp_S_TKS+qp_BLOCKIO_DELAY_TKS) = 0;
ALTER VIEW SOExpl_S1_ZQTV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW SOExpl_S1_ZQTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_ZQTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0)  AS ZeroQTimeViolsPerRun
	FROM  SOExpl_S1_ZQTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_ZQTV ADD PRIMARY KEY (runid) DISABLE; 

-- 4th Query Time violations
-- Count "Query Time" violations per dbms per experiment
-- SOExpl_S1_QTV_PDE : SOExpl_S1_DBMS_Time_Violations 
DROP VIEW SOExpl_S1_QTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_QTV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       qeid
	FROM  SOExpl_AQED -- all query execution details
	-- original
	--WHERE (qp_U_TKS+qp_S_TKS+qp_BLOCKIO_DELAY_TKS) > CEIL(measured_time/10)
	-- proposed
	WHERE (qp_U_TKS+qp_S_TKS+qp_BLOCKIO_DELAY_TKS) > CEIL(measured_time/10)+1
	;
ALTER VIEW SOExpl_S1_QTV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW SOExpl_S1_QTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_QTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0)  AS QueryTimeViolsPerRun
	FROM  SOExpl_S1_QTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_QTV ADD PRIMARY KEY (runid) DISABLE; 

-- 5th Query (Process) Tick Violations
-- Count QEs that has a query process' Ticks plus 1 less than query process' u ticks
-- SOExpl_S1_QPTV: SOExpl_Query_Tick_Violation_Per_DBMS_Per_Experiment 
DROP TABLE SOExpl_S1_QPTV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_QPTV_PDE AS
	SELECT  t1.dbms,
		t1.experimentName,
		t1.runId,
		t1.qeid
	FROM SOExpl_AQED t1
	WHERE (OVR_U_TKS+OVR_LU_TKS+1) < (qp_U_TKS);
ALTER TABLE SOExpl_S1_QPTV_PDE ADD PRIMARY KEY (qeid);
DROP VIEW SOExpl_S1_QPTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_QPTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0) AS QPTViolsPerRun
	FROM SOExpl_S1_QPTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_QPTV ADD PRIMARY KEY (runid) DISABLE; 

-- 6th Overall Computation Time Violations
-- Count QEs that has sum of comp. time across processes greater than measured time
-- SOExpl_S1_OCTV: SOExpl_Overall_Computation_Time_Violation_Per_DBMS_Per_Experiment 
DROP VIEW SOExpl_S1_OCTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_OCTV_PDE AS
	SELECT  dbms,
		experimentName,
		runId,
		qeid
	FROM SOExpl_AQED t1
	WHERE (OVR_U_TKS+OVR_LU_TKS+OVR_S_TKS) > CEIL(measured_time/10); 
ALTER VIEW SOExpl_S1_OCTV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW SOExpl_S1_OCTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_OCTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0) AS OCTViolsPerRun
	FROM SOExpl_S1_OCTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_OCTV ADD PRIMARY KEY (runid) DISABLE; 

-- 7th Computation Time Violations
-- Count QEs that has sum of comp. time across processes greater than measured time
-- SOExpl_S1_CTV_PDE: SOExpl_S1_Computation_Time_Violation_Per_DBMS_Per_Experiment 
DROP VIEW SOExpl_S1_CTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_CTV_PDE AS
	SELECT  dbms,
		experimentName,
		runId,
		qeid
	FROM SOExpl_AQED t1
	WHERE (qp_S_TKS+up_S_TKS+dp_S_TKS+qp_U_TKS+up_U_TKS+dp_U_TKS) > CEIL(measured_time/10)+10
	;  
ALTER VIEW SOExpl_S1_CTV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW SOExpl_S1_CTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_CTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0) AS CTViolsPerRun
	FROM SOExpl_S1_CTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_CTV ADD PRIMARY KEY (runid) DISABLE; 
--select sum(CTViolsPerRun) from SOExpl_S1_CTV

-- Compute max_blkio_delay_TKS per QE
-- SOExpl_MaxIO_PQE: SOExpl_MaxIO_Per_QE
DROP TABLE SOExpl_MaxIO_PQE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_MaxIO_PQE AS
	SELECT qeid,
	      max(BLOCKIO_DELAY_TKS) as max_blkio_delay_TKS
	FROM SOExpl_API
	GROUP BY qeid;
ALTER TABLE SOExpl_MaxIO_PQE ADD PRIMARY KEY (qeid) DISABLE; 

-- 8th Blockio Delay Time Violations
-- Count QEs that has max blockio delay ticks across processes greater than measured time
-- SOExpl_S1_BDTV_PDE: SOExpl_S1_BlockIO_Delay_Time_Violation_Per_DBMS_Per_Experiment 
DROP TABLE SOExpl_S1_BDTV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_BDTV_PDE AS
	SELECT  t0.dbms,
		t0.experimentName,
		t0.runId,
		t0.qeid
	FROM SOExpl_AQED t0,
	     SOExpl_MaxIO_PQE t1
	WHERE t0.qeid = t1.qeid 
	  AND max_blkio_delay_TKS > CEIL(measured_time/10);
ALTER TABLE SOExpl_S1_BDTV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP TABLE SOExpl_S1_BDTV CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_BDTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0) AS BDTViolsPerRun
	FROM SOExpl_S1_BDTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S1_BDTV ADD PRIMARY KEY (runid); 

-- 9th IOWait Time Violations
-- Count QEs that has greater overall IOWait than blockio delay ticks of a query process
-- SOExpl_S1_IOTV_PDE: SOExpl_S1_IOWait_Time_Violation_Per_DBMS_Per_Experiment 
DROP VIEW SOExpl_S1_IOWTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_IOWTV_PDE AS
	SELECT  t0.dbms,
		t0.experimentName,
		t0.runId,
		t0.qeid
	FROM SOExpl_AQED t0
	WHERE OVR_IOWAIT_TKS > qp_BLOCKIO_DELAY_TKS;	
ALTER VIEW SOExpl_S1_IOWTV_PDE ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW SOExpl_S1_IOWTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_IOWTV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0) AS IOWTViolsPerRun
	FROM SOExpl_S1_IOWTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_IOWTV ADD PRIMARY KEY (runid) DISABLE; 

-- 10th CSw violations
-- Count QEs that has CSws greater than three standard deviations from average CSw on a query process
-- SOExpl_S1_CSV_PDE: SOExpl_S1_Context_Switches_Violation_Per_DBMS_Per_Experiment 
DROP TABLE SOExpl_S1_CSV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_CSV_PDE AS
	SELECT  t0.dbms,
		t0.experimentName,
		t0.runId,
		t0.qeid
	FROM SOExpl_AQED t0,
	     (SELECT runid,
		     querynum,
		     card, 
		     round(avg(qp_IVCSW_CNT+qp_VCSW_CNT),1) as avgQueryCSws,
		     round(stddev(qp_IVCSW_CNT+qp_VCSW_CNT),2) as stdQueryCSws
	      FROM SOExpl_AQED
	      GROUP BY runid, querynum, card) t1
	WHERE t0.runid = t1.runId 
	 AND  t0.querynum = t1.querynum
         AND  t0.card = t1.card  
	 AND (t0.qp_IVCSW_CNT+t0.qp_VCSW_CNT) > t1.avgQueryCSws+3*(t1.stdQueryCSws); 
ALTER TABLE SOExpl_S1_CSV_PDE ADD PRIMARY KEY (qeid); 
DROP TABLE SOExpl_S1_CSV CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_CSV AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0) AS CSViolsPerRun
	FROM SOExpl_S1_CSV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S1_CSV ADD PRIMARY KEY (runid); 

-- 11th Ambiguous query process violations
-- Count QEs having query process' computation time less than that of utility 
-- process per DBMS per experiment
-- SOExpl_S1_AQPV_PDE: SOExpl_S1_Ambiguous_Query_Process_Violation_Per_DBMS_Per_Experiment 
DROP TABLE SOExpl_S1_AQPV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_AQPV_PDE AS
	SELECT DISTINCT
	       qe.dbms, 
	       qe.experimentName,
	       qe.runid,
	       qe.qeid
	FROM  SOExpl_AQED qe,     -- query execution
	      SOExpl_AEUPI  uprocinfo -- utilitiy process info details
	WHERE qe.qeid	    = uprocinfo.qeid -- match utility proc info
	  --- query process' computation time < utility process' computation time
  	  AND (qp_U_TKS+qp_S_TKS) < (uprocinfo.U_TKS+uprocinfo.S_TKS);
ALTER TABLE SOExpl_S1_AQPV_PDE ADD PRIMARY KEY (qeid); 
DROP TABLE SOExpl_S1_AQPV CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_AQPV AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) AS AmbigQProcViolsPerRun
	FROM SOExpl_S1_AQPV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S1_AQPV ADD PRIMARY KEY (runid);  

-- 12th No query process violations
-- Count QEs having no query process per DBMS per experiment
-- SOExpl_S1_NQPV_PDE: SOExpl_S1_No_Query_Process_Violation_Per_DBMS_Per_Experiment 
DROP TABLE SOExpl_S1_NQPV_PDE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_NQPV_PDE AS
	SELECT dbms, 
	       experimentName,
	       runid,
               t0.qeid
	FROM SOExpl_S0_CQE t0, -- all qe info 
	     SOExpl_ANQPI  t1  -- qe info with no query process
	WHERE t0.qeid = t1.qeid;
ALTER TABLE SOExpl_S1_NQPV_PDE ADD PRIMARY KEY (qeid); 
DROP TABLE SOExpl_S1_NQPV CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_NQPV AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) AS NoQPViolsPerRun
	FROM SOExpl_S1_NQPV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S1_NQPV ADD PRIMARY KEY (runid); 
	
-- 13th Timed out QE violations
-- Count QEs that encountered time-out per DBMS per experiment
-- SOExpl_S1_TQEV : SOExpl_Step1_TimedOut_Query_Execution_Violations
DROP VIEW SOExpl_S1_TQEV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_TQEV_PDE AS
	SELECT dbms, 
	       experimentName,
	       runid,
               qeid
	FROM SOExpl_S0_AQE
	-- timeout
	WHERE measured_time = 9999999;
ALTER VIEW SOExpl_S1_TQEV_PDE ADD PRIMARY KEY (qeid) DISABLE;
DROP TABLE SOExpl_S1_TQEV CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_TQEV AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) AS TimedOutQEViolsPerRun
	FROM SOExpl_S1_TQEV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER TABLE SOExpl_S1_TQEV ADD PRIMARY KEY (runid);

-- Table XI. Q@C sanity checks

-- (1) Excessive query computation time violations
-- SOExpl_S1_EQCTV_PDE: SOExpl_Step1_Excessive_Query_Computation_Time_Variation_Per_DBMS_Per_Experiment 
DROP VIEW SOExpl_S1_EQCTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_EQCTV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid,
	       querynum,
	       card
	FROM SOExpl_AQED
	WHERE measured_time < 9999999 -- timeout
	-- querytime: qp_U_TKS+qp_S_TKS
	HAVING TRUNC(STDDEV(qp_U_TKS+qp_S_TKS), 0) > CEIL(0.2 * AVG(qp_U_TKS+qp_S_TKS))
	GROUP BY dbms, experimentname, runid, querynum, card;
ALTER VIEW SOExpl_S1_EQCTV_PDE ADD PRIMARY KEY (runid, querynum, card) DISABLE; 
-- Count # of a pair of Q@Cs per dbms/experiment at this Analysis
DROP VIEW SOExpl_S1_EQCTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_EQCTV AS
	SELECT dbms, 
	       experimentname,
	       runid, 
	       COALESCE(count(card), 0) AS ExcQCTViolsPerRun
	FROM SOExpl_S1_EQCTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_EQCTV ADD PRIMARY KEY (runid) DISABLE; 
-- Count # of excessive query computation time violations
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S1_EQCTV';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S1_EQCTV' as stepName,
	       SUM(ExcQCTViolsPerRun) as stepResultSize
	FROM SOExpl_S1_EQCTV
	GROUP BY dbms, experimentname;

-- (2) Possible query result cache violations
-- SOExpl_S1_PQRCV_PDE: SOExpl_Step1_Excessive_Query_Computation_Time_Variation_Per_DBMS_Per_Experiment 
DROP VIEW SOExpl_S1_PQRCV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_PQRCV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid,
	       querynum,
	       card
	FROM SOExpl_AQED
	WHERE measured_time < 9999999 
	AND qenum = 1 -- first QE
	AND (qp_U_TKS+qp_S_TKS) > 10 * (SELECT STDDEV(qp_U_TKS+qp_S_TKS) from SOExpl_AQED);
ALTER VIEW SOExpl_S1_PQRCV_PDE ADD PRIMARY KEY (runid, querynum, card) DISABLE; 
-- Count # of a pair of Q@Cs per dbms/experiment at this Analysis
DROP VIEW SOExpl_S1_PQRCV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1_PQRCV AS
	SELECT dbms, 
	       experimentname,
	       runid, 
	       COALESCE(count(card), 0) AS PQRCViolsPerRun
	FROM SOExpl_S1_PQRCV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S1_PQRCV ADD PRIMARY KEY (runid) DISABLE; 

-- Count # of possible query result cache violations
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S1_PQRCV';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S1_PQRCV' as stepName,
	       SUM(PQRCViolsPerRun) as stepResultSize
	FROM SOExpl_S1_PQRCV
	GROUP BY dbms, experimentname;

-- (3) Tests monotonicity by the strict condition of using plain median calculated time
-- SOExpl_ATSM: SOExpl_All_Test_Strict_Monotonicity
DROP TABLE SOExpl_ATSM CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_ATSM AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM SOExpl_ASPQatC
	WHERE med_calc_qt > med_calc_qt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE SOExpl_ATSM ADD PRIMARY KEY (runid, querynum, card, card2); 
-- Count # of a pair of Q@Cs per dbms/experiment at this Analysis
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_ATSM';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_ATSM' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_ATSM
	GROUP BY dbms, experimentname;

-- (4) Tests monotonicity by the relaxed condition of using half std dev of calculated time
-- SOExpl_ATRM: SOExpl_All_Test_Relaxed_Monotonicity
DROP TABLE SOExpl_ATRM CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_ATRM AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM SOExpl_ASPQatC
	WHERE med_calc_qt-0.5*std_calc_qt > med_calc_qt2+0.5*std_calc_qt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE SOExpl_ATRM ADD PRIMARY KEY (runid, querynum, card, card2); 
-- Count # of a pair of Q@Cs per dbms/experiment at this Analysis
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_ATRM';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_ATRM' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_ATRM
	GROUP BY dbms, experimentname;

-- Show sanity check violation results across runs
-- SOExpl_Step1_SC : SOExpl_Step1_Sanity_Check
DROP VIEW SOExpl_S1 CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S1 AS -- This has only one record.
	SELECT DISTINCT EphProcViols,
		        DBMSTimeViols,
		        ZeroQueryViols,
		        QueryTimeViols,
			QPTViols,
			OCTViolations,
			CTViolations,
			BDTViolations,
			IOWTViolations,
			CSViolations,
		        AmbigQueryProcViols,
			NoQueryProcViols,
		        TimedOutQEViols,
			ExcQCTViols,
		        PQRCViols,
		        totalQs,
		        totalQatCs,
		        totalQEs
	FROM 
	     (SELECT COALESCE(SUM(EphProcViolsPerRun), 0) AS EphProcViols
	      FROM SOExpl_S1_EPV),
	     (SELECT COALESCE(SUM(DBMSTimeViolsPerRun), 0) AS DBMSTimeViols
	      FROM SOExpl_S1_DTV),
	     (SELECT COALESCE(SUM(ZeroQTimeViolsPerRun), 0) AS ZeroQueryViols
	      FROM SOExpl_S1_ZQTV),
	     (SELECT COALESCE(SUM(QueryTimeViolsPerRun), 0) AS QueryTimeViols
	      FROM SOExpl_S1_QTV),
	     (SELECT COALESCE(SUM(QPTViolsPerRun), 0) AS QPTViols
	      FROM SOExpl_S1_QPTV),
 	     (SELECT COALESCE(SUM(OCTViolsPerRun), 0) AS OCTViolations
	      FROM SOExpl_S1_OCTV),
	     (SELECT COALESCE(SUM(CTViolsPerRun), 0) AS CTViolations
	      FROM SOExpl_S1_CTV),
 	     (SELECT COALESCE(SUM(BDTViolsPerRun), 0) AS BDTViolations
	      FROM SOExpl_S1_BDTV),
	     (SELECT COALESCE(SUM(IOWTViolsPerRun), 0) AS IOWTViolations
	      FROM SOExpl_S1_IOWTV),
	     (SELECT COALESCE(SUM(CSViolsPerRun), 0) AS CSViolations
	      FROM SOExpl_S1_CSV),
	     (SELECT COALESCE(SUM(AmbigQProcViolsPerRun), 0) AS AmbigQueryProcViols
              FROM SOExpl_S1_AQPV),
	     (SELECT COALESCE(SUM(NoQPViolsPerRun), 0) AS NoQueryProcViols
              FROM SOExpl_S1_NQPV),
	     (SELECT COALESCE(SUM(TimedOutQEViolsPerRun), 0) AS TimedOutQEViols
              FROM SOExpl_S1_TQEV),
	     (SELECT COALESCE(SUM(ExcQCTViolsPerRun), 0) AS ExcQCTViols
              FROM SOExpl_S1_EQCTV),
	     (SELECT COALESCE(SUM(PQRCViolsPerRun), 0) AS PQRCViols
              FROM SOExpl_S1_PQRCV),
	     SOExpl_S0_TQ,
	     SOExpl_S0_TQatC,
	     SOExpl_S0_TQE;

-- Step 2: Drop selected query Executions failing to pass saniy checks
DROP TABLE SOExpl_S1_FQE CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S1_FQE AS
	-- (1) Ephemeral process violations
	SELECT dbms,
	       experimentname,
	       qeid
	FROM SOExpl_S1_EPV_PDE
	UNION
	-- (2) DBMS time violations
	SELECT dbms,
	       experimentname,
	       qeid
	FROM SOExpl_S1_DTV_PDE
	UNION
	-- (3) Zero query time violation
	SELECT dbms,
	       experimentname,
	       qeid 
	FROM  SOExpl_S1_ZQTV_PDE
	UNION
	-- (4) Query time violation
	SELECT dbms,
	       experimentname,
	       qeid
	FROM  SOExpl_S1_QTV_PDE
	UNION  
	-- (5) Query Process Tick violations
	SELECT  dbms,
		experimentName,
		qeid
	FROM SOExpl_S1_QPTV_PDE
	UNION
	-- (6) Overall computation violations
	SELECT  dbms,
		experimentName,
		qeid
	FROM SOExpl_S1_OCTV_PDE
	UNION
	-- (7) Computation time violations
	SELECT  dbms,
		experimentName,
		qeid
	FROM SOExpl_S1_CTV_PDE
	UNION
	-- (8) Blockio delay time violations
	SELECT  dbms,
		experimentName,
		qeid
	FROM SOExpl_S1_BDTV_PDE
	UNION
	-- (9) IOWait time violations 
	SELECT  dbms,
		experimentName,
		qeid
	FROM SOExpl_S1_IOWTV_PDE
	UNION
	-- (10) CSw violations
	SELECT  dbms,
		experimentName,
		qeid
	FROM SOExpl_S1_CSV_PDE
	UNION
	-- (11) Abiguous query process violations
	SELECT  dbms,
		experimentName,
		qeid
	FROM SOExpl_S1_AQPV_PDE
	UNION
	-- (12) No query process violations
	SELECT dbms,
	       experimentName,
	       qeid
	FROM SOExpl_S1_NQPV_PDE
	UNION
	-- (13) Timed out QE violations
	SELECT dbms,
	       experimentName,
	       qeid
	FROM SOExpl_S1_TQEV_PDE;
ALTER TABLE SOExpl_S1_FQE ADD PRIMARY KEY (qeid);
DELETE FROM SOExpl_RowCount WHERE stepname = 'SOExpl_S1_FQE';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S1_FQE' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S1_FQE
	GROUP BY dbms, experimentname;
--select count(qeid) from SOExpl_s1_fqe

-- Drop QEs failing to pass saniy checks
-- SOExpl_S2: SOExpl_Step2
DROP TABLE SOExpl_S2 CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S2 AS
	SELECT t0.*
	FROM SOExpl_AQED  t0
	WHERE qeid NOT IN (SELECT qeid FROM SOExpl_S1_FQE);
ALTER TABLE SOExpl_S2 ADD PRIMARY KEY (qeid) DISABLE;
-- Record the result size of SOExpl_S2
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S2';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S2' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S2
	GROUP BY dbms, experimentname;

-- Step 3: Drop selected Q@Cs 
-- Step 3-0: Convert to the current Q@Cs from remaining query executions
DROP TABLE SOExpl_S3_0 CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S3_0 AS
	SELECT dbms,
	       experimentName,
	       runid,
	       querynum,
	       card, 	    
               AVG(measured_time) as average_measured_time,
	       COUNT(*) as num_executions
	FROM SOExpl_S2
	GROUP BY dbms, experimentName, runid, querynum, card;
ALTER TABLE SOExpl_S3_0 ADD PRIMARY KEY (runid, querynum, card); 
-- Record the result size of SOExpl_S3_0
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S3_0';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S3_0' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S3_0
	GROUP BY dbms, experimentname;

-- Step 3-(i): Drop Q@Cs failing to pass step 1-(iv)
-- SOExpl_S3_I: SOExpl_Step3_I
DROP VIEW SOExpl_S3_I CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S3_I AS
	SELECT *
	FROM SOExpl_S3_0
	WHERE (runid, querynum, card) NOT IN 
					-- Q@Cs failing step 1-(iv)
					(SELECT runid, querynum, card
					 -- Table XI (1)
					 FROM SOExpl_S1_EQCTV_PDE
					 UNION
					 SELECT runid, querynum, card
					 -- Table XI (2)
					 FROM SOExpl_S1_PQRCV_PDE);
ALTER VIEW SOExpl_S3_I ADD PRIMARY KEY (runid, querynum, card) DISABLE;
-- Record the result size of SOExpl_S3_I
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S3_I';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S3_I' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S3_I
	GROUP BY dbms, experimentname;

-- Step 3-(ii) : drop any Q@C for which the identified query process does not appear in every query execution for that Q@C 
-- SOExpl_S3_II: SOExpl_Step3_II
DROP TABLE SOExpl_S3_II CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S3_II AS
	SELECT t1.*
	FROM SOExpl_S3_I t1
	WHERE (runid, querynum, card) NOT IN (
				 -- a Q@C with its QEs not having an identified query process for that Q@C
				 SELECT DISTINCT runid, querynum, card
        	                 FROM (
				      SELECT t1.qeid, t1.runid, t1.querynum, t1.card
			  	      FROM SOExpl_S2 t1,    -- Remaining QEs
				           SOExpl_ANQPI t2  -- QEs with no query process
				      WHERE t1.qeid = t2.qeid)
				);
ALTER TABLE SOExpl_S3_II ADD PRIMARY KEY (runid, querynum, card);
-- Record the result size of SOExpl_S3_II
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S3_II';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S3_II' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S3_II
	GROUP BY dbms, experimentname;

-- Step 3-(iii) : drop any Q@C  whose measured time across remaining query executions of 2 or less ticks
-- SOExpl_S3_III: SOExpl_Step3_III
DROP VIEW SOExpl_S3_III CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S3_III AS
	SELECT *
	FROM SOExpl_S3_II
	WHERE average_measured_time > 20;
ALTER VIEW SOExpl_S3_III ADD PRIMARY KEY (runid, querynum, card) DISABLE;
-- Record the result size of SOExpl_S3_III
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S3_III';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S3_III' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S3_III
	GROUP BY dbms, experimentname;

-- Step 3-(iv): drop Q@Cs less than 6 executions
-- SOExpl_S3_IV: SOExpl_Step3_IV
DROP TABLE SOExpl_S3_IV CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S3_IV AS
	SELECT *
	FROM SOExpl_S3_III
	WHERE num_executions >= 6;
ALTER TABLE SOExpl_S3_IV ADD PRIMARY KEY (runid, querynum, card) DISABLE;
-- Record the result size of SOExpl_S3_IV
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S3_IV';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S3_IV' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S3_IV
	GROUP BY dbms, experimentname;

-- Step 4 : Calculate query time
-- Obtains detailed process information of a query process, a utility process(es), and a daemon process(es) per query execution

-- SOExpl_QED: SOExpl_QueryExecution_Details
DROP TABLE SOExpl_QED CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_QED AS
	SELECT DISTINCT
		aqed.*
	FROM	SOExpl_S3_IV qatc, -- remaining Q@Cs
		SOExpl_S2 qe,	   -- remaining QEs
		SOExpl_AQED aqed    -- precomputed all QE details
	WHERE 	qatc.runid     = qe.runid
	    AND	qatc.querynum  = qe.querynum
	    AND	qatc.card      = qe.card
	    AND	qe.qeid        = aqed.qeid
	ORDER BY aqed.qeid ASC;
ALTER TABLE SOExpl_QED ADD PRIMARY KEY (qeid);
-- Record the result size of SOExpl_QED
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_QED';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_QED' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_QED
	GROUP BY dbms, experimentname;
--  COUNT(*)
----------
--    503668
--select experimentid, dbms, runid, count(querynum) from (select distinct experimentid, dbms, runid, querynum from soexpl_s4_ctqatc) group by experimentid, dbms, runid
-- Calculated query times
-- Ticks/counts are to 2 decimal places. 
-- Times are to one decimal place. 
-- SOExpl_S4_CTQatC: SOExpl_Step4_Calculated_Time_QatC
DROP TABLE SOExpl_S4_CTQatC CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S4_CTQatC AS
	SELECT  version,
	        experimentid, 
	        experimentname,
		dbms, 
		runid,
		querynum,
		card, 
		planid, 
		-- # of retained QEs
		count(qenum) as num_retained_qes,
		-- calculated query time stat
		MIN((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10) as min_calc_qt,
		MAX((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10) as max_calc_qt,
		ROUND(AVG((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10), 1) as avg_calc_qt,
		ROUND(MEDIAN((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10), 1) as med_calc_qt,
		ROUND(STDDEV((qp_U_TKS+qp_S_TKS+(qp_BLOCKIO_DELAY_TKS-0.5*OVR_IOWAIT_TKS))*10), 1) as std_calc_qt,
		-- measured time stat
		MIN(measured_time) as min_meas_time,
		MAX(measured_time) as max_meas_time,
		ROUND(AVG(measured_time),1) as avg_meas_time,
		ROUND(STDDEV(measured_time),1) as std_meas_time,
		ROUND(MEDIAN(measured_time),1) as med_meas_time,
		-- overall measure stat
		-- overall uticks
		MIN(OVR_U_TKS) AS MIN_OVR_U_TKS, 
		MAX(OVR_U_TKS) AS MAX_OVR_U_TKS, 
		ROUND(AVG(OVR_U_TKS),2) AS AVG_OVR_U_TKS, 
		ROUND(STDDEV(OVR_U_TKS),2) AS STD_OVR_U_TKS, 
		ROUND(MEDIAN(OVR_U_TKS),2) AS MED_OVR_U_TKS, 
		-- overall lowpriority uticks
		MIN(OVR_LU_TKS) AS MIN_OVR_LU_TKS, 
		MAX(OVR_LU_TKS) AS MAX_OVR_LU_TKS, 
		ROUND(AVG(OVR_LU_TKS),2) AS AVG_OVR_LU_TKS, 
		ROUND(STDDEV(OVR_LU_TKS),2) AS STD_OVR_LU_TKS, 
		ROUND(MEDIAN(OVR_LU_TKS),2) AS MED_OVR_LU_TKS, 
		-- overall sticks
		MIN(OVR_S_TKS) AS MIN_OVR_S_TKS, 
		MAX(OVR_S_TKS) AS MAX_OVR_S_TKS, 
		ROUND(AVG(OVR_S_TKS),2) AS AVG_OVR_S_TKS, 
		ROUND(STDDEV(OVR_S_TKS),2) AS STD_OVR_S_TKS, 
		ROUND(MEDIAN(OVR_S_TKS),2) AS MED_OVR_S_TKS, 
		-- IOWait ticks
		MIN(OVR_IOWAIT_TKS) as min_OVR_IOWAIT_TKS,
		MAX(OVR_IOWAIT_TKS) as max_OVR_IOWAIT_TKS,
		ROUND(AVG(OVR_IOWAIT_TKS),2) as avg_OVR_IOWAIT_TKS,
		ROUND(stddev(OVR_IOWAIT_TKS),2) as std_OVR_IOWAIT_TKS,
		ROUND(MEDIAN(OVR_IOWAIT_TKS),2) AS MED_OVR_IOWAIT_TKS, 
		-- overall idle ticks
		MIN(OVR_IDLE_TKS) AS MIN_OVR_IDLE_TKS, 
		MAX(OVR_IDLE_TKS) AS MAX_OVR_IDLE_TKS, 
		ROUND(AVG(OVR_IDLE_TKS),2) AS AVG_OVR_IDLE_TKS, 
		ROUND(STDDEV(OVR_IDLE_TKS),2) AS STD_OVR_IDLE_TKS, 
		ROUND(MEDIAN(OVR_IDLE_TKS),2) AS MED_OVR_IDLE_TKS, 
		-- overall steal ticks
		MIN(OVR_STEAL_TKS) AS MIN_OVR_STEAL_TKS, 
		MAX(OVR_STEAL_TKS) AS MAX_OVR_STEAL_TKS, 
		ROUND(AVG(OVR_STEAL_TKS),2) AS AVG_OVR_STEAL_TKS, 
		ROUND(STDDEV(OVR_STEAL_TKS),2) AS STD_OVR_STEAL_TKS, 
		ROUND(MEDIAN(OVR_STEAL_TKS),2) AS MED_OVR_STEAL_TKS, 
		-- overall guest ticks
		MIN(OVR_GUEST_TKS) AS MIN_OVR_GUEST_TKS, 
		MAX(OVR_GUEST_TKS) AS MAX_OVR_GUEST_TKS, 
		ROUND(AVG(OVR_GUEST_TKS),2) AS AVG_OVR_GUEST_TKS, 
		ROUND(STDDEV(OVR_GUEST_TKS),2) AS STD_OVR_GUEST_TKS, 
		ROUND(MEDIAN(OVR_GUEST_TKS),2) AS MED_OVR_GUEST_TKS, 
		-- overall IRQ ticks
		MIN(OVR_IRQ_TKS) AS MIN_OVR_IRQ_TKS, 
		MAX(OVR_IRQ_TKS) AS MAX_OVR_IRQ_TKS, 
		ROUND(AVG(OVR_IRQ_TKS),2) AS AVG_OVR_IRQ_TKS, 
		ROUND(STDDEV(OVR_IRQ_TKS),2) AS STD_OVR_IRQ_TKS, 
		ROUND(MEDIAN(OVR_IRQ_TKS),2) AS MED_OVR_IRQ_TKS, 
		-- overall SoftIRQ ticks
		MIN(OVR_SOFTIRQ_TKS) AS MIN_OVR_SOFTIRQ_TKS, 
		MAX(OVR_SOFTIRQ_TKS) AS MAX_OVR_SOFTIRQ_TKS, 
		ROUND(AVG(OVR_SOFTIRQ_TKS),2) AS AVG_OVR_SOFTIRQ_TKS, 
		ROUND(STDDEV(OVR_SOFTIRQ_TKS),2) AS STD_OVR_SOFTIRQ_TKS, 
		ROUND(MEDIAN(OVR_SOFTIRQ_TKS),2) AS MED_OVR_SOFTIRQ_TKS,
		-- proc count stats
		MIN(NUMPROCS) AS MIN_NUMPROCS, 
		MAX(NUMPROCS) AS MAX_NUMPROCS, 
		ROUND(AVG(NUMPROCS),2) AS AVG_NUMPROCS, 
		ROUND(STDDEV(NUMPROCS),2) AS STD_NUMPROCS, 
		ROUND(MEDIAN(NUMPROCS),2) AS MED_NUMPROCS,
		-- per-process measure stat
		-- query process measure stat
		-- query process uticks
		MIN(qp_U_TKS) as min_qp_U_TKS,
		MAX(qp_U_TKS) as max_qp_U_TKS,
		ROUND(AVG(qp_U_TKS),2) as avg_qp_U_TKS,
		ROUND(stddev(qp_U_TKS),2) as std_qp_U_TKS,
		ROUND(MEDIAN(qp_U_TKS), 2) as med_qp_U_TKS,
		-- query process sticks
		MIN(QP_S_TKS) AS MIN_QP_S_TKS, 
		MAX(QP_S_TKS) AS MAX_QP_S_TKS, 
		ROUND(AVG(QP_S_TKS),2) AS AVG_QP_S_TKS, 
		ROUND(STDDEV(QP_S_TKS),2) AS STD_QP_S_TKS, 
		ROUND(MEDIAN(QP_S_TKS),2) AS MED_QP_S_TKS, 
		-- query process major faults
		MIN(QP_MAJ_FLT_CNT) AS MIN_QP_MAJ_FLT_CNT, 
		MAX(QP_MAJ_FLT_CNT) AS MAX_QP_MAJ_FLT_CNT, 
		ROUND(AVG(QP_MAJ_FLT_CNT),2) AS AVG_QP_MAJ_FLT_CNT, 
		ROUND(STDDEV(QP_MAJ_FLT_CNT),2) AS STD_QP_MAJ_FLT_CNT, 
		ROUND(MEDIAN(QP_MAJ_FLT_CNT),2) AS MED_QP_MAJ_FLT_CNT, 
		-- query process block IO delay ticks
		MIN(QP_BLOCKIO_DELAY_TKS) AS MIN_QP_BLOCKIO_DELAY_TKS, 
		MAX(QP_BLOCKIO_DELAY_TKS) AS MAX_QP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(QP_BLOCKIO_DELAY_TKS),2) AS AVG_QP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(QP_BLOCKIO_DELAY_TKS),2) AS STD_QP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(QP_BLOCKIO_DELAY_TKS),2) AS MED_QP_BLOCKIO_DELAY_TKS, 
		-- query process involuntary context switches
		MIN(QP_IVCSW_CNT) AS MIN_QP_IVCSW_CNT, 
		MAX(QP_IVCSW_CNT) AS MAX_QP_IVCSW_CNT, 
		ROUND(AVG(QP_IVCSW_CNT),2) AS AVG_QP_IVCSW_CNT, 
		ROUND(STDDEV(QP_IVCSW_CNT),2) AS STD_QP_IVCSW_CNT, 
		ROUND(MEDIAN(QP_IVCSW_CNT),2) AS MED_QP_IVCSW_CNT, 
		-- query process volunatry context switches
		MIN(QP_VCSW_CNT) AS MIN_QP_VCSW_CNT, 
		MAX(QP_VCSW_CNT) AS MAX_QP_VCSW_CNT, 
		ROUND(AVG(QP_VCSW_CNT),2) AS AVG_QP_VCSW_CNT, 
		ROUND(STDDEV(QP_VCSW_CNT),2) AS STD_QP_VCSW_CNT, 
		ROUND(MEDIAN(QP_VCSW_CNT),2) AS MED_QP_VCSW_CNT,
		-- query process read bytes
		MIN(QP_READ_BYTES_CNT) AS MIN_QP_READ_BYTES_CNT, 
		MAX(QP_READ_BYTES_CNT) AS MAX_QP_READ_BYTES_CNT,	
		ROUND(AVG(QP_READ_BYTES_CNT),2) AS AVG_QP_READ_BYTES_CNT, 
		ROUND(STDDEV(QP_READ_BYTES_CNT),2) AS STD_QP_READ_BYTES_CNT, 
		ROUND(MEDIAN(QP_READ_BYTES_CNT),2) AS MED_QP_READ_BYTES_CNT, 
		-- query process read chars
		MIN(QP_READ_CHAR_CNT) AS MIN_QP_READ_CHAR_CNT, 
		MAX(QP_READ_CHAR_CNT) AS MAX_QP_READ_CHAR_CNT, 
		ROUND(AVG(QP_READ_CHAR_CNT),2) AS AVG_QP_READ_CHAR_CNT, 
		ROUND(STDDEV(QP_READ_CHAR_CNT),2) AS STD_QP_READ_CHAR_CNT, 
		ROUND(MEDIAN(QP_READ_CHAR_CNT),2) AS MED_QP_READ_CHAR_CNT, 
		-- query process read syscalls
		MIN(QP_READ_SYSCALLS_CNT) AS MIN_QP_READ_SYSCALLS_CNT, 
		MAX(QP_READ_SYSCALLS_CNT) AS MAX_QP_READ_SYSCALLS_CNT,	
		ROUND(AVG(QP_READ_SYSCALLS_CNT),2) AS AVG_QP_READ_SYSCALLS_CNT, 
		ROUND(STDDEV(QP_READ_SYSCALLS_CNT),2) AS STD_QP_READ_SYSCALLS_CNT, 
		ROUND(MEDIAN(QP_READ_SYSCALLS_CNT),2) AS MED_QP_READ_SYSCALLS_CNT, 
		-- query process write bytes
		MIN(QP_WRITE_BYTES_CNT) AS MIN_QP_WRITE_BYTES_CNT, 
		MAX(QP_WRITE_BYTES_CNT) AS MAX_QP_WRITE_BYTES_CNT, 
		ROUND(AVG(QP_WRITE_BYTES_CNT),2) AS AVG_QP_WRITE_BYTES_CNT, 
		ROUND(STDDEV(QP_WRITE_BYTES_CNT),2) AS STD_QP_WRITE_BYTES_CNT, 
		ROUND(MEDIAN(QP_WRITE_BYTES_CNT),2) AS MED_QP_WRITE_BYTES_CNT, 
		-- query process write chars
		MIN(QP_WRITE_CHAR_CNT) AS MIN_QP_WRITE_CHAR_CNT, 
		MAX(QP_WRITE_CHAR_CNT) AS MAX_QP_WRITE_CHAR_CNT, 
		ROUND(AVG(QP_WRITE_CHAR_CNT),2) AS AVG_QP_WRITE_CHAR_CNT, 
		ROUND(STDDEV(QP_WRITE_CHAR_CNT),2) AS STD_QP_WRITE_CHAR_CNT, 
		ROUND(MEDIAN(QP_WRITE_CHAR_CNT),2) AS MED_QP_WRITE_CHAR_CNT,
		-- query process write syscalls
		MIN(QP_WRITE_SYSCALLS_CNT) AS MIN_QP_WRITE_SYSCALLS_CNT, 
		MAX(QP_WRITE_SYSCALLS_CNT) AS MAX_QP_WRITE_SYSCALLS_CNT,	
		ROUND(AVG(QP_WRITE_SYSCALLS_CNT),2) AS AVG_QP_WRITE_SYSCALLS_CNT, 
		ROUND(STDDEV(QP_WRITE_SYSCALLS_CNT),2) AS STD_QP_WRITE_SYSCALLS_CNT, 
		ROUND(MEDIAN(QP_WRITE_SYSCALLS_CNT),2) AS MED_QP_WRITE_SYSCALLS_CNT, 
		-- query process guest ticks
		MIN(QP_GTKS) AS MIN_QP_GTKS, 
		MAX(QP_GTKS) AS MAX_QP_GTKS, 
		ROUND(AVG(QP_GTKS),2) AS AVG_QP_GTKS, 
		ROUND(STDDEV(QP_GTKS),2) AS STD_QP_GTKS, 
		ROUND(MEDIAN(QP_GTKS),2) AS MED_QP_GTKS, 
		-- query process cguest ticks
		MIN(QP_CGTKS) AS MIN_QP_CGTKS, 
		MAX(QP_CGTKS) AS MAX_QP_CGTKS, 
		ROUND(AVG(QP_CGTKS),2) AS AVG_QP_CGTKS, 
		ROUND(STDDEV(QP_CGTKS),2) AS STD_QP_CGTKS, 
		ROUND(MEDIAN(QP_CGTKS),2) AS MED_QP_CGTKS,
 		-- utility process measure stat
		-- utility processes' uticks
		MIN(UP_U_TKS) AS MIN_UP_U_TKS, 
		MAX(UP_U_TKS) AS MAX_UP_U_TKS, 
		ROUND(AVG(UP_U_TKS),2) AS AVG_UP_U_TKS, 
		ROUND(STDDEV(UP_U_TKS),2) AS STD_UP_U_TKS, 
		ROUND(MEDIAN(UP_U_TKS),2) AS MED_UP_U_TKS,
		-- utility processes' sticks
		MIN(UP_S_TKS) AS MIN_UP_S_TKS, 
		MAX(UP_S_TKS) AS MAX_UP_S_TKS, 
		ROUND(AVG(UP_S_TKS),2) AS AVG_UP_S_TKS, 
		ROUND(STDDEV(UP_S_TKS),2) AS STD_UP_S_TKS, 
		ROUND(MEDIAN(UP_S_TKS),2) AS MED_UP_S_TKS, 
		-- utility processes' major faults
		MIN(up_MAJ_FLT_CNT) as min_up_MAJ_FLT_CNT,
		MAX(up_MAJ_FLT_CNT) as max_up_MAJ_FLT_CNT, 
		ROUND(AVG(up_MAJ_FLT_CNT),2) as avg_up_MAJ_FLT_CNT, 
		ROUND(stddev(up_MAJ_FLT_CNT),2) as std_up_MAJ_FLT_CNT,
		ROUND(MEDIAN(up_MAJ_FLT_CNT), 2) as med_up_MAJ_FLT_CNT,
		-- utility processes' block IO delay ticks
		MIN(UP_BLOCKIO_DELAY_TKS) AS MIN_UP_BLOCKIO_DELAY_TKS, 
		MAX(UP_BLOCKIO_DELAY_TKS) AS MAX_UP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(UP_BLOCKIO_DELAY_TKS),2) AS AVG_UP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(UP_BLOCKIO_DELAY_TKS),2) AS STD_UP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(UP_BLOCKIO_DELAY_TKS),2) AS MED_UP_BLOCKIO_DELAY_TKS,
		-- utility processes' involunatry context switches
		MIN(UP_IVCSW_CNT) AS MIN_UP_IVCSW_CNT, 
		MAX(UP_IVCSW_CNT) AS MAX_UP_IVCSW_CNT, 
		ROUND(AVG(UP_IVCSW_CNT),2) AS AVG_UP_IVCSW_CNT, 
		ROUND(STDDEV(UP_IVCSW_CNT),2) AS STD_UP_IVCSW_CNT, 
		ROUND(MEDIAN(UP_IVCSW_CNT),2) AS MED_UP_IVCSW_CNT, 
		-- utility processes' volunatry context switches
		MIN(UP_VCSW_CNT) AS MIN_UP_VCSW_CNT, 
		MAX(UP_VCSW_CNT) AS MAX_UP_VCSW_CNT, 
		ROUND(AVG(UP_VCSW_CNT),2) AS AVG_UP_VCSW_CNT, 
		ROUND(STDDEV(UP_VCSW_CNT),2) AS STD_UP_VCSW_CNT, 
		ROUND(MEDIAN(UP_VCSW_CNT),2) AS MED_UP_VCSW_CNT, 
		-- utility processes' read bytes
		MIN(UP_READ_BYTES_CNT) AS MIN_UP_READ_BYTES_CNT, 
		MAX(UP_READ_BYTES_CNT) AS MAX_UP_READ_BYTES_CNT, 
		ROUND(AVG(UP_READ_BYTES_CNT),2) AS AVG_UP_READ_BYTES_CNT, 
		ROUND(STDDEV(UP_READ_BYTES_CNT),2) AS STD_UP_READ_BYTES_CNT, 
		ROUND(MEDIAN(UP_READ_BYTES_CNT),2) AS MED_UP_READ_BYTES_CNT, 
		-- utility processes' read chars
		MIN(UP_READ_CHAR_CNT) AS MIN_UP_READ_CHAR_CNT, 
		MAX(UP_READ_CHAR_CNT) AS MAX_UP_READ_CHAR_CNT, 
		ROUND(AVG(UP_READ_CHAR_CNT),2) AS AVG_UP_READ_CHAR_CNT, 
		ROUND(STDDEV(UP_READ_CHAR_CNT),2) AS STD_UP_READ_CHAR_CNT, 
		ROUND(MEDIAN(UP_READ_CHAR_CNT),2) AS MED_UP_READ_CHAR_CNT,
		-- utility processes' read syscalls
		MIN(UP_READ_SYSCALLS_CNT) AS MIN_UP_READ_SYSCALLS_CNT, 
		MAX(UP_READ_SYSCALLS_CNT) AS MAX_UP_READ_SYSCALLS_CNT,	
		ROUND(AVG(UP_READ_SYSCALLS_CNT),2) AS AVG_UP_READ_SYSCALLS_CNT, 
		ROUND(STDDEV(UP_READ_SYSCALLS_CNT),2) AS STD_UP_READ_SYSCALLS_CNT, 
		ROUND(MEDIAN(UP_READ_SYSCALLS_CNT),2) AS MED_UP_READ_SYSCALLS_CNT, 
		-- utility processes' write bytes
		MIN(UP_WRITE_BYTES_CNT) AS MIN_UP_WRITE_BYTES_CNT, 
		MAX(UP_WRITE_BYTES_CNT) AS MAX_UP_WRITE_BYTES_CNT, 
		ROUND(AVG(UP_WRITE_BYTES_CNT),2) AS AVG_UP_WRITE_BYTES_CNT, 
		ROUND(STDDEV(UP_WRITE_BYTES_CNT),2) AS STD_UP_WRITE_BYTES_CNT, 
		ROUND(MEDIAN(UP_WRITE_BYTES_CNT),2) AS MED_UP_WRITE_BYTES_CNT, 
		-- utility processes' write chars
		MIN(UP_WRITE_CHAR_CNT) AS MIN_UP_WRITE_CHAR_CNT, 
		MAX(UP_WRITE_CHAR_CNT) AS MAX_UP_WRITE_CHAR_CNT, 
		ROUND(AVG(UP_WRITE_CHAR_CNT),2) AS AVG_UP_WRITE_CHAR_CNT, 
		ROUND(STDDEV(UP_WRITE_CHAR_CNT),2) AS STD_UP_WRITE_CHAR_CNT, 
		ROUND(MEDIAN(UP_WRITE_CHAR_CNT),2) AS MED_UP_WRITE_CHAR_CNT, 
		-- utility processes' write syscalls
		MIN(UP_WRITE_SYSCALLS_CNT) AS MIN_UP_WRITE_SYSCALLS_CNT, 
		MAX(UP_WRITE_SYSCALLS_CNT) AS MAX_UP_WRITE_SYSCALLS_CNT,	
		ROUND(AVG(UP_WRITE_SYSCALLS_CNT),2) AS AVG_UP_WRITE_SYSCALLS_CNT, 
		ROUND(STDDEV(UP_WRITE_SYSCALLS_CNT),2) AS STD_UP_WRITE_SYSCALLS_CNT, 
		ROUND(MEDIAN(UP_WRITE_SYSCALLS_CNT),2) AS MED_UP_WRITE_SYSCALLS_CNT, 
		-- utility processes' guest ticks
		MIN(UP_GTKS) AS MIN_UP_GTKS, 
		MAX(UP_GTKS) AS MAX_UP_GTKS, 
		ROUND(AVG(UP_GTKS),2) AS AVG_UP_GTKS, 
		ROUND(STDDEV(UP_GTKS),2) AS STD_UP_GTKS, 
		ROUND(MEDIAN(UP_GTKS),2) AS MED_UP_GTKS, 
		-- utility processes' cguest ticks
		MIN(UP_CGTKS) AS MIN_UP_CGTKS, 
		MAX(UP_CGTKS) AS MAX_UP_CGTKS, 
		ROUND(AVG(UP_CGTKS),2) AS AVG_UP_CGTKS, 
		ROUND(STDDEV(UP_CGTKS),2) AS STD_UP_CGTKS, 
		ROUND(MEDIAN(UP_CGTKS),2) AS MED_UP_CGTKS, 
		-- daemon processes' measure stat
		-- daemon processes' uticks
		MIN(DP_U_TKS) AS MIN_DP_U_TKS, 
		MAX(DP_U_TKS) AS MAX_DP_U_TKS, 
		ROUND(AVG(DP_U_TKS),2) AS AVG_DP_U_TKS, 
		ROUND(STDDEV(DP_U_TKS),2) AS STD_DP_U_TKS, 
		ROUND(MEDIAN(DP_U_TKS),2) AS MED_DP_U_TKS, 
		-- daemon processes' sticks
		MIN(DP_S_TKS) AS MIN_DP_S_TKS, 
		MAX(DP_S_TKS) AS MAX_DP_S_TKS, 
		ROUND(AVG(DP_S_TKS),2) AS AVG_DP_S_TKS, 
		ROUND(STDDEV(DP_S_TKS),2) AS STD_DP_S_TKS, 
		ROUND(MEDIAN(DP_S_TKS),2) AS MED_DP_S_TKS, 
		-- daemon processes' major faults
		MIN(dp_MAJ_FLT_CNT) as min_dp_MAJ_FLT_CNT,
		MAX(dp_MAJ_FLT_CNT) as max_dp_MAJ_FLT_CNT,
		ROUND(AVG(dp_MAJ_FLT_CNT),2) as avg_dp_MAJ_FLT_CNT,
		ROUND(stddev(dp_MAJ_FLT_CNT),2) as std_dp_MAJ_FLT_CNT,
		ROUND(MEDIAN(dp_MAJ_FLT_CNT), 2) as med_dp_MAJ_FLT_CNT,
		-- daemon processes' block IO delay ticks
		MIN(DP_BLOCKIO_DELAY_TKS) AS MIN_DP_BLOCKIO_DELAY_TKS, 
		MAX(DP_BLOCKIO_DELAY_TKS) AS MAX_DP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(DP_BLOCKIO_DELAY_TKS),2) AS AVG_DP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(DP_BLOCKIO_DELAY_TKS),2) AS STD_DP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(DP_BLOCKIO_DELAY_TKS),2) AS MED_DP_BLOCKIO_DELAY_TKS,
		-- daemon processes' involunatry context switches
		MIN(DP_IVCSW_CNT) AS MIN_DP_IVCSW_CNT, 
		MAX(DP_IVCSW_CNT) AS MAX_DP_IVCSW_CNT, 
		ROUND(AVG(DP_IVCSW_CNT),2) AS AVG_DP_IVCSW_CNT, 
		ROUND(STDDEV(DP_IVCSW_CNT),2) AS STD_DP_IVCSW_CNT, 
		ROUND(MEDIAN(DP_IVCSW_CNT),2) AS MED_DP_IVCSW_CNT, 
		-- daemon processes' volunatry context switches
		MIN(DP_VCSW_CNT) AS MIN_DP_VCSW_CNT, 
		MAX(DP_VCSW_CNT) AS MAX_DP_VCSW_CNT, 
		ROUND(AVG(DP_VCSW_CNT),2) AS AVG_DP_VCSW_CNT, 
		ROUND(STDDEV(DP_VCSW_CNT),2) AS STD_DP_VCSW_CNT, 
		ROUND(MEDIAN(DP_VCSW_CNT),2) AS MED_DP_VCSW_CNT, 
		-- daemon processes' read bytes
		MIN(DP_READ_BYTES_CNT) AS MIN_DP_READ_BYTES_CNT, 
		MAX(DP_READ_BYTES_CNT) AS MAX_DP_READ_BYTES_CNT, 
		ROUND(AVG(DP_READ_BYTES_CNT),2) AS AVG_DP_READ_BYTES_CNT, 
		ROUND(STDDEV(DP_READ_BYTES_CNT),2) AS STD_DP_READ_BYTES_CNT, 
		ROUND(MEDIAN(DP_READ_BYTES_CNT),2) AS MED_DP_READ_BYTES_CNT, 
		-- daemon processes' read chars
		MIN(DP_READ_CHAR_CNT) AS MIN_DP_READ_CHAR_CNT, 
		MAX(DP_READ_CHAR_CNT) AS MAX_DP_READ_CHAR_CNT, 
		ROUND(AVG(DP_READ_CHAR_CNT),2) AS AVG_DP_READ_CHAR_CNT, 
		ROUND(STDDEV(DP_READ_CHAR_CNT),2) AS STD_DP_READ_CHAR_CNT, 
		ROUND(MEDIAN(DP_READ_CHAR_CNT),2) AS MED_DP_READ_CHAR_CNT, 
		-- daemon processes' read syscalls
		MIN(DP_READ_SYSCALLS_CNT) AS MIN_DP_READ_SYSCALLS_CNT, 
		MAX(DP_READ_SYSCALLS_CNT) AS MAX_DP_READ_SYSCALLS_CNT,	
		ROUND(AVG(DP_READ_SYSCALLS_CNT),2) AS AVG_DP_READ_SYSCALLS_CNT, 
		ROUND(STDDEV(DP_READ_SYSCALLS_CNT),2) AS STD_DP_READ_SYSCALLS_CNT, 
		ROUND(MEDIAN(DP_READ_SYSCALLS_CNT),2) AS MED_DP_READ_SYSCALLS_CNT,
		-- daemon processes' write bytes
		MIN(DP_WRITE_BYTES_CNT) AS MIN_DP_WRITE_BYTES_CNT, 
		MAX(DP_WRITE_BYTES_CNT) AS MAX_DP_WRITE_BYTES_CNT, 
		ROUND(AVG(DP_WRITE_BYTES_CNT),2) AS AVG_DP_WRITE_BYTES_CNT, 
		ROUND(STDDEV(DP_WRITE_BYTES_CNT),2) AS STD_DP_WRITE_BYTES_CNT, 
		ROUND(MEDIAN(DP_WRITE_BYTES_CNT),2) AS MED_DP_WRITE_BYTES_CNT, 
		-- daemon processes' write chars
		MIN(DP_WRITE_CHAR_CNT) AS MIN_DP_WRITE_CHAR_CNT, 
		MAX(DP_WRITE_CHAR_CNT) AS MAX_DP_WRITE_CHAR_CNT, 
		ROUND(AVG(DP_WRITE_CHAR_CNT),2) AS AVG_DP_WRITE_CHAR_CNT, 
		ROUND(STDDEV(DP_WRITE_CHAR_CNT),2) AS STD_DP_WRITE_CHAR_CNT, 
		ROUND(MEDIAN(DP_WRITE_CHAR_CNT),2) AS MED_DP_WRITE_CHAR_CNT,
		-- daemon processes' write syscalls
		MIN(DP_WRITE_SYSCALLS_CNT) AS MIN_DP_WRITE_SYSCALLS_CNT, 
		MAX(DP_WRITE_SYSCALLS_CNT) AS MAX_DP_WRITE_SYSCALLS_CNT,	
		ROUND(AVG(DP_WRITE_SYSCALLS_CNT),2) AS AVG_DP_WRITE_SYSCALLS_CNT, 
		ROUND(STDDEV(DP_WRITE_SYSCALLS_CNT),2) AS STD_DP_WRITE_SYSCALLS_CNT, 
		ROUND(MEDIAN(DP_WRITE_SYSCALLS_CNT),2) AS MED_DP_WRITE_SYSCALLS_CNT, 
		-- daemon processes' guest ticks
		MIN(DP_GTKS) AS MIN_DP_GTKS, 
		MAX(DP_GTKS) AS MAX_DP_GTKS, 
		ROUND(AVG(DP_GTKS),2) AS AVG_DP_GTKS, 
		ROUND(STDDEV(DP_GTKS),2) AS STD_DP_GTKS, 
		ROUND(MEDIAN(DP_GTKS),2) AS MED_DP_GTKS, 
		-- daemon processes' cguest ticks
		MIN(DP_CGTKS) AS MIN_DP_CGTKS, 
		MAX(DP_CGTKS) AS MAX_DP_CGTKS, 
		ROUND(AVG(DP_CGTKS),2) AS AVG_DP_CGTKS, 
		ROUND(STDDEV(DP_CGTKS),2) AS STD_DP_CGTKS, 
		ROUND(MEDIAN(DP_CGTKS),2) AS MED_DP_CGTKS, 
		--experiment processes
		-- experiment process' u tks
		MIN(ep_U_TKS) as min_ep_U_TKS,
		MAX(ep_U_TKS) as max_ep_U_TKS,
		ROUND(AVG(ep_U_TKS),2) as avg_ep_U_TKS,
		ROUND(stddev(ep_U_TKS),2) as std_ep_U_TKS,
		ROUND(MEDIAN(ep_U_TKS), 2) as med_ep_U_TKS,
		-- experiment process' s tks
		MIN(EP_S_TKS) AS MIN_EP_S_TKS, 
		MAX(EP_S_TKS) AS MAX_EP_S_TKS, 
		ROUND(AVG(EP_S_TKS),2) AS AVG_EP_S_TKS, 
		ROUND(STDDEV(EP_S_TKS),2) AS STD_EP_S_TKS, 
		ROUND(MEDIAN(EP_S_TKS),2) AS MED_EP_S_TKS, 
		-- experiment process' maj flts
		MIN(EP_MAJ_FLT_CNT) AS MIN_EP_MAJ_FLT_CNT, 
		MAX(EP_MAJ_FLT_CNT) AS MAX_EP_MAJ_FLT_CNT, 
		ROUND(AVG(EP_MAJ_FLT_CNT),2) AS AVG_EP_MAJ_FLT_CNT, 
		ROUND(STDDEV(EP_MAJ_FLT_CNT),2) AS STD_EP_MAJ_FLT_CNT, 
		ROUND(MEDIAN(EP_MAJ_FLT_CNT),2) AS MED_EP_MAJ_FLT_CNT, 
		-- experiment process' block IO delay ticks
		MIN(EP_BLOCKIO_DELAY_TKS) AS MIN_EP_BLOCKIO_DELAY_TKS, 
		MAX(EP_BLOCKIO_DELAY_TKS) AS MAX_EP_BLOCKIO_DELAY_TKS, 
		ROUND(AVG(EP_BLOCKIO_DELAY_TKS),2) AS AVG_EP_BLOCKIO_DELAY_TKS, 
		ROUND(STDDEV(EP_BLOCKIO_DELAY_TKS),2) AS STD_EP_BLOCKIO_DELAY_TKS, 
		ROUND(MEDIAN(EP_BLOCKIO_DELAY_TKS),2) AS MED_EP_BLOCKIO_DELAY_TKS, 
		-- stats on the sum of per-process uticks
		MIN(SUM_U_TKS) AS MIN_SUM_U_TKS, 
		MAX(SUM_U_TKS) AS MAX_SUM_U_TKS, 
		ROUND(AVG(SUM_U_TKS),2) AS AVG_SUM_U_TKS, 
		ROUND(STDDEV(SUM_U_TKS),2) AS STD_SUM_U_TKS, 
		ROUND(MEDIAN(SUM_U_TKS),2) AS MED_SUM_U_TKS, 
		-- stats on the sum of per-process sticks
		MIN(SUM_S_TKS) AS MIN_SUM_S_TKS, 
		MAX(SUM_S_TKS) AS MAX_SUM_S_TKS, 
		ROUND(AVG(SUM_S_TKS),2) AS AVG_SUM_S_TKS, 
		ROUND(STDDEV(SUM_S_TKS),2) AS STD_SUM_S_TKS, 
		ROUND(MEDIAN(SUM_S_TKS),2) AS MED_SUM_S_TKS, 
		-- stats on the sum of per-process major faults
		MIN(SUM_MAJ_FLT_CNT) AS MIN_SUM_MAJ_FLT_CNT, 
		MAX(SUM_MAJ_FLT_CNT) AS MAX_SUM_MAJ_FLT_CNT, 
		ROUND(AVG(SUM_MAJ_FLT_CNT),2) AS AVG_SUM_MAJ_FLT_CNT, 
		ROUND(STDDEV(SUM_MAJ_FLT_CNT),2) AS STD_SUM_MAJ_FLT_CNT, 
		ROUND(MEDIAN(SUM_MAJ_FLT_CNT),2) AS MED_SUM_MAJ_FLT_CNT
	FROM SOExpl_QED qed -- remaining QEDs
	GROUP BY qed.version, qed.experimentid, qed.experimentname, qed.dbms, qed.runid, qed.querynum, qed.card, qed.planid;
ALTER TABLE SOExpl_S4_CTQatC ADD PRIMARY KEY (runid, querynum, card); 
-- Record the result size of SOExpl_S4_CTQatC
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S4_CTQatC';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S4_CTQatC' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S4_CTQatC
	GROUP BY dbms, experimentname;
--  COUNT(*)
----------
--     53098
-- Compute the total # of retained queries in SOExpl_S4_CTQatC
-- SOExpl_S4_TQ: SOExpl_Step4_Total_retained_Queries
DROP TABLE SOExpl_S4_TQ CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S4_TQ AS
	SELECT  distinct 
		version,
		experimentid, 
		experimentname,
		dbms, 
		runid,
		querynum
	FROM SOExpl_S4_CTQatC;
ALTER TABLE SOExpl_S4_TQ ADD PRIMARY KEY (runid, querynum); 
-- select sum(stepResultSize) from SOExpl_RowCount where stepName = 'SOExpl_S4_TQ'
-- Record the result size of SOExpl_S4_TQ
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S4_TQ';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S4_TQ' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_S4_TQ
	GROUP BY dbms, experimentname;
DROP VIEW SOExpl_S5_EQCTV_PDE CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S5_EQCTV_PDE AS
	SELECT dbms,
	       experimentname,
	       runid,
	       querynum,
	       card
	FROM SOExpl_QED
	WHERE measured_time < 9999999
	-- querytime: qp_U_TKS+qp_S_TKS
	HAVING TRUNC(STDDEV(qp_U_TKS+qp_S_TKS), 0) > CEIL(0.2 * AVG(qp_U_TKS+qp_S_TKS))
	GROUP BY dbms, experimentname, runid, querynum, card;
ALTER VIEW SOExpl_S5_EQCTV_PDE ADD PRIMARY KEY (runid, querynum, card) DISABLE; 

-- Rolls up Q@Cs by runs
DROP VIEW SOExpl_S5_EQCTV CASCADE CONSTRAINTS;
CREATE VIEW SOExpl_S5_EQCTV AS
	SELECT dbms, 
	       experimentname,
	       runid, 
	       COALESCE(count(card), 0) AS ExcQCTViolsPerRun
	FROM SOExpl_S5_EQCTV_PDE
	GROUP BY dbms, experimentname, runid;
ALTER VIEW SOExpl_S5_EQCTV ADD PRIMARY KEY (runid) DISABLE; 

--- Count # of excessive query computation time violations
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S5_EQCTV';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S5_EQCTV' as stepName,
	       SUM(ExcQCTViolsPerRun) as stepResultSize
	FROM SOExpl_S5_EQCTV
	GROUP BY dbms, experimentname;

-- Count how many measures are not varying across DBMSes for the entire experiment
-- SOExpl_S5_NVM: SOExpl_Step5_Non-Varying Measures
DROP TABLE SOExpl_S5_NVMV CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_NVMV AS
	(
	-- # of total measures: 9 (overall) + 14 (query) + 14 (utility) + 14 (daemon) = 51 measures
	-- # of total model-relevant measures: 4 (overall) + 11 (query) + 11 (utility) + 11 (daemon) = 37 measures  
	-- overall measure
	select 'OVR_U_TKS' as measure_name  -- overall u ticks
	from SOExpl_QED
	having  
	(max(OVR_U_TKS)-min(OVR_U_TKS) = 0)
	UNION
	select 'OVR_S_TKS' as measure_name -- overall s ticks
	from SOExpl_QED
	having  
	(max(OVR_S_TKS)-min(OVR_S_TKS) = 0)
	UNION
	select 'OVR_IOWAIT_TKS' as measure_name -- overall iowait ticks
	from SOExpl_QED
	having  
	(max(OVR_IOWAIT_TKS)-min(OVR_IOWAIT_TKS) = 0)
	UNION
	select 'OVR_SOFTIRQ_TKS' as measure_name -- overall softirq ticks
	from SOExpl_QED
	having  
	(max(OVR_SOFTIRQ_TKS)-min(OVR_SOFTIRQ_TKS) = 0)
	UNION
	-- per-process measure
	-- query process measure
	select 'QP_U_TKS' as measure_name  -- query process u ticks
	from SOExpl_QED
	having  
	(max(QP_U_TKS)-min(QP_U_TKS) = 0)
	UNION
	select 'QP_S_TKS' as measure_name  -- query process s ticks
	from SOExpl_QED
	having  
	(max(QP_S_TKS)-min(QP_S_TKS) = 0)
	UNION
	select 'QP_BLOCKIO_DELAY_TKS' as measure_name  -- query process blockio delay tks
	from SOExpl_QED
	having  
	(max(QP_BLOCKIO_DELAY_TKS)-min(QP_BLOCKIO_DELAY_TKS) = 0)
	UNION
	select 'QP_IVCSW_CNT' as measure_name  -- query process involuntary context switch counts
	from SOExpl_QED
	having  
	(max(QP_IVCSW_CNT)-min(QP_IVCSW_CNT) = 0)
	UNION
	select 'QP_VCSW_CNT' as measure_name  -- query process voluntary context switch counts
	from SOExpl_QED
	having  
	(max(QP_VCSW_CNT)-min(QP_VCSW_CNT) = 0)
	UNION
	select 'QP_READ_BYTES_CNT' as measure_name  -- query process read bytes counts
	from SOExpl_QED
	having  
	(max(QP_READ_BYTES_CNT)-min(QP_READ_BYTES_CNT) = 0)
	UNION
	select 'QP_READ_CHAR_CNT' as measure_name  -- query process read chars counts
	from SOExpl_QED
	having  
	(max(QP_READ_CHAR_CNT)-min(QP_READ_CHAR_CNT) = 0)
	UNION
	select 'QP_READ_SYSCALLS_CNT' as measure_name  -- query process read syscalls counts
	from SOExpl_QED
	having  
	(max(QP_READ_SYSCALLS_CNT)-min(QP_READ_SYSCALLS_CNT) = 0)
	UNION
	select 'QP_WRITE_BYTES_CNT' as measure_name  -- query process write bytes counts
	from SOExpl_QED
	having  
	(max(QP_WRITE_BYTES_CNT)-min(QP_WRITE_BYTES_CNT) = 0)
	UNION
	select 'QP_WRITE_CHAR_CNT' as measure_name  -- query process write chars counts
	from SOExpl_QED
	having  
	(max(QP_WRITE_CHAR_CNT)-min(QP_WRITE_CHAR_CNT) = 0)
	UNION
	select 'QP_WRITE_SYSCALLS_CNT' as measure_name  -- query process write syscalls counts
	from SOExpl_QED
	having  
	(max(QP_WRITE_SYSCALLS_CNT)-min(QP_WRITE_SYSCALLS_CNT) = 0)
	UNION
	-- utility process
	select 'UP_U_TKS' as measure_name  -- utility process u ticks
	from SOExpl_QED
	having  
	(max(UP_U_TKS)-min(UP_U_TKS) = 0)
	UNION
	select 'UP_S_TKS' as measure_name  -- utility process s ticks
	from SOExpl_QED
	having  
	(max(UP_S_TKS)-min(UP_S_TKS) = 0)
	UNION
	select 'UP_BLOCKIO_DELAY_TKS' as measure_name  -- utility process blockio delay tks
	from SOExpl_QED
	having  
	(max(UP_BLOCKIO_DELAY_TKS)-min(UP_BLOCKIO_DELAY_TKS) = 0)
	UNION
	select 'UP_IVCSW_CNT' as measure_name  -- utility process involuntary context switch counts
	from SOExpl_QED
	having  
	(max(UP_IVCSW_CNT)-min(UP_IVCSW_CNT) = 0)
	UNION
	select 'UP_VCSW_CNT' as measure_name  -- utility process voluntary context switch counts
	from SOExpl_QED
	having  
	(max(UP_VCSW_CNT)-min(UP_VCSW_CNT) = 0)
	UNION
	select 'UP_READ_BYTES_CNT' as measure_name  -- utility process read bytes counts
	from SOExpl_QED
	having  
	(max(UP_READ_BYTES_CNT)-min(UP_READ_BYTES_CNT) = 0)
	UNION
	select 'UP_READ_CHAR_CNT' as measure_name  -- utility process read chars counts
	from SOExpl_QED
	having  
	(max(UP_READ_CHAR_CNT)-min(UP_READ_CHAR_CNT) = 0)
	UNION
	select 'UP_READ_SYSCALLS_CNT' as measure_name  -- utility process read syscalls counts
	from SOExpl_QED
	having  
	(max(UP_READ_SYSCALLS_CNT)-min(UP_READ_SYSCALLS_CNT) = 0)
	UNION
	select 'UP_WRITE_BYTES_CNT' as measure_name  -- utility process write bytes counts
	from SOExpl_QED
	having  
	(max(UP_WRITE_BYTES_CNT)-min(UP_WRITE_BYTES_CNT) = 0)
	UNION
	select 'UP_WRITE_CHAR_CNT' as measure_name  -- utility process write chars counts
	from SOExpl_QED
	having  
	(max(UP_WRITE_CHAR_CNT)-min(UP_WRITE_CHAR_CNT) = 0)
	UNION
	select 'UP_WRITE_SYSCALLS_CNT' as measure_name  -- utility process write syscalls counts
	from SOExpl_QED
	having  
	(max(UP_WRITE_SYSCALLS_CNT)-min(UP_WRITE_SYSCALLS_CNT) = 0)
	UNION
	-- daemon process
	select 'DP_U_TKS' as measure_name  -- daemon process u ticks
	from SOExpl_QED
	having  
	(max(DP_U_TKS)-min(DP_U_TKS) = 0)
	UNION
	select 'DP_S_TKS' as measure_name  -- daemon process s ticks
	from SOExpl_QED
	having  
	(max(DP_S_TKS)-min(DP_S_TKS) = 0)
	UNION
	select 'DP_BLOCKIO_DELAY_TKS' as measure_name  -- daemon process blockio delay tks
	from SOExpl_QED
	having  
	(max(DP_BLOCKIO_DELAY_TKS)-min(DP_BLOCKIO_DELAY_TKS) = 0)
	UNION
	select 'DP_IVCSW_CNT' as measure_name  -- daemon process involuntary context switch counts
	from SOExpl_QED
	having  
	(max(DP_IVCSW_CNT)-min(DP_IVCSW_CNT) = 0)
	UNION
	select 'DP_VCSW_CNT' as measure_name  -- daemon process voluntary context switch counts
	from SOExpl_QED
	having  
	(max(DP_VCSW_CNT)-min(DP_VCSW_CNT) = 0)
	UNION
	select 'DP_READ_BYTES_CNT' as measure_name  -- daemon process read bytes counts
	from SOExpl_QED
	having  
	(max(DP_READ_BYTES_CNT)-min(DP_READ_BYTES_CNT) = 0)
	UNION
	select 'DP_READ_CHAR_CNT' as measure_name  -- daemon process read chars counts
	from SOExpl_QED
	having  
	(max(DP_READ_CHAR_CNT)-min(DP_READ_CHAR_CNT) = 0)
	UNION
	select 'DP_READ_SYSCALLS_CNT' as measure_name  -- daemon process read syscalls counts
	from SOExpl_QED
	having  
	(max(DP_READ_SYSCALLS_CNT)-min(DP_READ_SYSCALLS_CNT) = 0)
	UNION
	select 'DP_WRITE_BYTES_CNT' as measure_name  -- daemon process write bytes counts
	from SOExpl_QED
	having  
	(max(DP_WRITE_BYTES_CNT)-min(DP_WRITE_BYTES_CNT) = 0)
	UNION
	select 'DP_WRITE_CHAR_CNT' as measure_name  -- daemon process write chars counts
	from SOExpl_QED
	having  
	(max(DP_WRITE_CHAR_CNT)-min(DP_WRITE_CHAR_CNT) = 0)
	UNION
	select 'DP_WRITE_SYSCALLS_CNT' as measure_name  -- daemon process write syscalls counts
	from SOExpl_QED
	having  
	(max(DP_WRITE_SYSCALLS_CNT)-min(DP_WRITE_SYSCALLS_CNT) = 0)
	);
ALTER TABLE SOExpl_S5_NVMV ADD PRIMARY KEY (measure_name);
select * from SOExpl_S5_NVMV;
-- Record the result size of SOExpl_S5_NVMV
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S5_NVMV';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT 'all' as dbmsName, 
	       'all' as exprName,
	       'SOExpl_S5_NVMV' as stepName,
	       COALESCE(count(*),0) as stepResultSize
	FROM SOExpl_S5_NVMV;
--select * from SOExpl_rowcount where stepname='SOExpl_S5_NVMV';


-- Collect all Q@Cs having the same plan
-- SOExpl_SPQatC: SOExpl_Same_Plan_QatC
DROP TABLE SOExpl_SPQatC CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_SPQatC AS
	SELECT p1.*, 
	       p2.card as card2, 
	       p2.med_calc_qt as med_calc_qt2,
	       p2.std_calc_qt as std_calc_qt2
	FROM SOExpl_S4_CTQatC p1, 		
	     SOExpl_S4_CTQatC p2 
	WHERE p1.runid    = p2.runid    AND
	      p1.querynum = p2.querynum AND
	      p1.planid   = p2.planid   AND
	      p1.card < p2.card
	ORDER BY p1.runid, p1.querynum, p1.card, p2.card;
ALTER TABLE SOExpl_SPQatC ADD PRIMARY KEY (runid, querynum, card, card2);
-- Record the result size of SOExpl_SPQatC
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_SPQatC';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_SPQatC' as stepName,
	       COUNT(*) as stepResultSize
	FROM SOExpl_SPQatC
	GROUP BY dbms, experimentname;
-- select sum(stepResultSize) from SOExpl_RowCount where stepName = 'SOExpl_SPQatC'
-- select sum(stepResultSize) from SOExpl_RowCount where stepName = 'SOExpl_S5_TSM'
-- select sum(stepResultSize) from SOExpl_RowCount where stepName = 'SOExpl_S5_TRM'
-- Test strict monotonicity using median calculated query time
-- SOExpl_S5_TSM: SOExpl_S5_Test_Strict_Monotonicity
DROP TABLE SOExpl_S5_TSM CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_TSM AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM SOExpl_SPQatC
	WHERE med_calc_qt > med_calc_qt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE SOExpl_S5_TSM ADD PRIMARY KEY (runid, querynum, card, card2); 

-- Record the result size of SOExpl_S5_TSM
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S5_TSM';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S5_TSM' as stepName,
	       COALESCE(count(*),0) as stepResultSize
	FROM SOExpl_S5_TSM
	GROUP BY dbms, experimentname;

-- Tests relaxed monotonicity using half standard deviation of calculated time
-- SOExpl_S5_Test_RM: SOExpl_S5_Test_Relaxed_Monotonicity
DROP TABLE SOExpl_S5_TRM CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_TRM AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM SOExpl_SPQatC
	WHERE med_calc_qt-0.5*std_calc_qt > med_calc_qt2+0.5*std_calc_qt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE SOExpl_S5_TRM ADD PRIMARY KEY (runid, querynum, card, card2); 

-- Record the result size of SOExpl_S5_TRM
DELETE FROM SOExpl_RowCount where stepname ='SOExpl_S5_TRM';
INSERT INTO SOExpl_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'SOExpl_S5_TRM' as stepName,
	       COALESCE(COUNT(*), 0) as stepResultSize
	FROM SOExpl_S5_TRM
	GROUP BY dbms, experimentname;

-- Collect dropped Q@Cs 
-- SOExpl_S5_Dropped_QatC: SOExpl_S5_Dropped_QatC
DROP TABLE SOExpl_S5_Dropped_QatC CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_Dropped_QatC AS
	 SELECT t1.runid,
		t1.querynum,
		t1.card
	 FROM SOExpl_ACTQatC t1
	 MINUS
	 SELECT t2.runid,
		t2.querynum,
		t2.card
	 FROM SOExpl_S4_CTQatC t2;
ALTER TABLE SOExpl_S5_Dropped_QatC ADD PRIMARY KEY (runid, querynum, card) DISABLE;
	
-- Compute Average measured time and calculated query time across the Q@Cs dropped 
-- SOExpl_S5_Dropped_QatC: SOExpl_S5_Dropped_QatC
DROP TABLE SOExpl_S5_DQatC_Stat CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_DQatC_Stat AS
	 SELECT avg(med_meas_time) as dropped_avg_meas_t,
		avg(med_calc_qt)   as dropped_avg_calc_qt
	 FROM
		(SELECT org.* 
	  	 FROM SOExpl_ACTQatC org, SOExpl_S5_Dropped_QatC dropped
		 WHERE  org.runid   = dropped.runid 
	            AND org.querynum = dropped.querynum 
	 	    AND org.card     = dropped.card);
select * from SOExpl_S5_DQatC_Stat;

-- Compute Average measured time and calculated query time across the retained Q@Cs
-- SOExpl_S5_Dropped_QatC: SOExpl_S5_Dropped_QatC
DROP TABLE SOExpl_S5_RQatC_Stat CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_RQatC_Stat AS
	 SELECT avg(med_meas_time) as retained_avg_meas_t,
		avg(med_calc_qt)   as retained_avg_calc_qt
	 FROM SOExpl_S4_CTQatC;
select * from SOExpl_S5_RQatC_Stat;

-- Compute the relative difference of measured time and calculated query time in dropped and retained Q@Cs
-- SOExpl_S5_Dropped_QatC: SOExpl_S5_Dropped_QatC
DROP TABLE SOExpl_S5_RD CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_RD AS
	SELECT abs(retained_avg_meas_t-retained_avg_calc_qt)/retained_avg_meas_t as mt_relative_diff,
	       abs(dropped_avg_meas_t-dropped_avg_calc_qt)/dropped_avg_meas_t as cqt_relative_diff
	FROM SOExpl_S5_DQatC_Stat, 
	     SOExpl_S5_RQatC_Stat;
select * from SOExpl_S5_RD;
	
-- Do t-test between the median of measure times and calculated times of dropped Q@Cs and retained Q@Cs
-- t-test: checks difference in distribution
-- SOExpl_S5_TTEST : SOExpl_T-test_on_Measured_and_Calculated_Times
DROP TABLE SOExpl_S5_TTEST CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_S5_TTEST AS
	SELECT STATS_T_TEST_INDEP(dropped, med_meas_time) two_sided_p_value1,
	       STATS_T_TEST_INDEP(dropped, med_calc_qt)   two_sided_p_value2
	FROM
		(SELECT org.*,
		       (CASE
			    WHEN (dropped.runid) IS NOT NULL THEN 0 -- dropped
			    ELSE 1 -- retained
			END ) dropped
		FROM
			SOExpl_ACTQatC org 
			LEFT OUTER JOIN 
		      	SOExpl_S5_Dropped_QatC dropped on
			org.runid    = dropped.runid 
		    and org.querynum = dropped.querynum 
		    and org.card     = dropped.card);
select * from SOExpl_S5_TTEST;

SELECT count(*) as queries -- queries 
FROM (SELECT distinct runid, querynum
     FROM SOExpl_S0_AQE);

   QUERIES
----------
      1200

SELECT count(*) as qatcs -- QatCs 
FROM (SELECT distinct runid, querynum, card
     FROM SOExpl_S0_AQE);

     QATCS
----------
     12575

SELECT count(*) as qes -- qes 
FROM (SELECT qeid
     FROM SOExpl_S0_AQE);

       QES
----------
    125535
