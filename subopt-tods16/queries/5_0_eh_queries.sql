-- Writer      : Young-Kyoon Suh
-- Date        : 02/05/13
-- Description : Define analysis queries for the exhaustive data
-- labshelf 5.19

-- DBMSes used in our analysis. We use regression coefficient.
-- EH_Analysis_Dmd_Ver1 : Exhaustive_Analysis_DBMS_Metadata
DROP TABLE EH_Analysis_Dmd_Ver1;
CREATE TABLE EH_Analysis_Dmd_Ver1 	-- Primary key is a dbms.
(
	dbmsname	VARCHAR2(10) NOT NULL PRIMARY KEY, -- dbms name
	coef 		NUMBER (10, 3)  		   -- regression coefficient
);
INSERT INTO EH_Analysis_Dmd_Ver1 VALUES ('db2',    0);
INSERT INTO EH_Analysis_Dmd_Ver1 VALUES ('oracle', 1.916);
INSERT INTO EH_Analysis_Dmd_Ver1 VALUES ('pgsql',  0.259);
--INSERT INTO EH_Analysis_Dmd_Ver1 VALUES ('mysql',  0);
INSERT INTO EH_Analysis_Dmd_Ver1 VALUES ('mysql2',  0);
INSERT INTO EH_Analysis_Dmd_Ver1 VALUES ('teradata',  0);

-- DBMS Query Processes 
-- Note that postgres may use different names 
-- EH_Analysis_QMD_Ver1 : Exhaustive_Analysis_DBMS_Utility_Process_Metadata
DROP TABLE EH_Analysis_Qmd_Ver1;
CREATE TABLE EH_Analysis_Qmd_Ver1 -- Primary key is (dbms, query_process_name).
(
	dbmsname	VARCHAR2(10) REFERENCES EH_Analysis_Dmd_Ver1(dbmsname) ON DELETE CASCADE,
	qprocname 	VARCHAR2(10) NOT NULL, -- query process name
	PRIMARY KEY (dbmsname, qprocname)
);
INSERT INTO EH_Analysis_Qmd_Ver1 VALUES ('db2',    'db2sysc');
INSERT INTO EH_Analysis_Qmd_Ver1 VALUES ('oracle', 'oracle');
INSERT INTO EH_Analysis_Qmd_Ver1 VALUES ('pgsql',  'postmaster');
-- we add the record below as symbolic name of 'postmaster'
INSERT INTO EH_Analysis_Qmd_Ver1 VALUES ('pgsql',  'postgres');	
--INSERT INTO EH_Analysis_Qmd_Ver1 VALUES ('mysql',  'mysqld');
INSERT INTO EH_Analysis_Qmd_Ver1 VALUES ('mysql2',  'mysqld');
INSERT INTO EH_Analysis_Qmd_Ver1 VALUES ('teradata',  'actmain');

-- DBMS Utility Processes 
-- Note that db2 has utility processes with different names, while the other dbmses - oracle, postgres,  mysql - uses the same name for their utility process(es) as that of query process.
-- EH_Analysis_UMD_Ver1 : Exhaustive_Analysis_DBMS_Utility_Process_Metadata
DROP TABLE EH_Analysis_Umd_Ver1;
CREATE TABLE EH_Analysis_Umd_Ver1 -- Primary key is (dbms, utility_process_name).
(
	dbmsname 	VARCHAR2(10) REFERENCES EH_Analysis_Dmd_Ver1(dbmsname) ON DELETE CASCADE,
	uprocname 	VARCHAR2(20) NOT NULL,  -- utility process name
	PRIMARY KEY (dbmsname, uprocname)
);
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2dasstm');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2dasrrm');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2fm');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2fmd');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2fmcd');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2dascln');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2fmp');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2dasstml');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2set');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('db2',    'db2bp');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('oracle', 'oracle');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('pgsql',  'postmaster');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('pgsql',  'postgres');
--INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('mysql',  'mysqld');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('mysql2',  'mysqld');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('teradata',  'disstart');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('teradata',  'fsustart');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('teradata',  'pdemain');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('teradata',  'pdevproc');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('teradata',  'tvsa_agent');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('teradata',  'tvsaallocator');
INSERT INTO EH_Analysis_Umd_Ver1 VALUES ('teradata',  'tdsched_check');
-- selected users/runs for labshelf 'AZDBLab_5_19'
-- create a table for user
DROP TABLE EH_Chosen_Users_Ver1;
CREATE TABLE EH_Chosen_Users_Ver1 AS -- Primary key is userName.
	SELECT userName 
	FROM AZDBLab_User
	WHERE userName = 'Sabah';
ALTER TABLE EH_Chosen_Users_Ver1 ADD PRIMARY KEY (userName);

-- create a table for notebook(s)
DROP TABLE EH_Chosen_Notebooks_Ver1;
CREATE TABLE EH_Chosen_Notebooks_Ver1 AS -- Primary key is notebook name.
	SELECT notebookName 
	FROM AZDBLab_NoteBook 
	WHERE notebookName LIKE 'VLDB2012%';
ALTER TABLE EH_Chosen_Notebooks_Ver1 ADD PRIMARY KEY (notebookName);

-- create a table for labshelf version
DROP TABLE EH_Chosen_LabShelf_Ver1;
CREATE TABLE EH_Chosen_LabShelf_Ver1 AS -- Primary key is version.
	SELECT 519 AS version FROM Dual;
ALTER TABLE EH_Chosen_LabShelf_Ver1 ADD PRIMARY KEY (version);

-- create a table for runs 
DROP TABLE EH_Chosen_Runs_Ver1;
CREATE TABLE EH_Chosen_Runs_Ver1 AS -- Primary key is runid.
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	WHERE runid IN (16,22,33,37,42, 4,17,24,34,35, 32,89,95) -- 5 oracle runs + 5 postgres runs + 3 mysql runs
	ORDER BY runid;
ALTER TABLE EH_Chosen_Runs_Ver1 ADD PRIMARY KEY (runid);

-- Step 0 : Get all query executions from the chosen labshelf

-- EH_Analysis_S0_AQE_Ver1 : Exhaustive_Analysis_S0_All_Query_Executions_Ver1
DROP TABLE EH_Analysis_S0_AQE_Ver1;
CREATE TABLE EH_Analysis_S0_AQE_Ver1 AS -- Primary key is a query execution: (qeid)
	SELECT  c_labshelf.version,	    -- labshelf version
	 	ex.experimentid, 	    -- experiment id
		ex.experimentname, 	    -- experiment name
		er.dbms, 		    -- dbms that ran the experiment
		q.runid, 		    -- run id
		q.queryNumber AS querynum,  -- querynumber in the experiment
		qe.queryexecutionid AS qeid,-- queryexecution id
		qe.cardinality AS card,     -- cardinality
		qe.iternum AS qenum, 	    -- query execution number
		qe.runtime AS measured_time,-- measured time
		qp.planid, 		    -- plan id
		qea.numphantomspresent,     -- # of phantoms
		qea.stoppedprocesses, 	    -- # of stopped processes
		qea.USERMODETICKS,     	    -- usermode ticks
		qea.SYSTEMMODETICKS,   	    -- systemmode ticks		
		qea.iowaitticks,	    -- iowait ticks
		qea.irqticks as irq,	    -- irq
		qea.softirqticks as softirq -- soft irq
	FROM  AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp, 
	      AZDBLab_QueryExecutionAspect qea, 
	      EH_Chosen_Runs_Ver1 c_run,
	      EH_Chosen_Users_Ver1 c_user,
              EH_Chosen_Notebooks_Ver1 c_notebook,
	      EH_Analysis_Dmd_Ver1 Dmd,
	      EH_Chosen_LabShelf_Ver1 c_labshelf
	 WHERE ex.experimentid=er.experimentid AND 
	       er.runid=q.runid AND 
               q.runid = c_run.runid AND
	       q.queryid=qe.queryid AND 
               qe.queryexecutionid=qp.queryexecutionid AND 
	       qe.queryexecutionid=qea.queryexecutionid AND 
	       er.currentstage  ='Completed' AND 
	       ex.userName = c_user.userName AND 
	       ex.notebookname = c_notebook.notebookName AND 
	       er.dbms = dmd.dbmsname AND
               er.percentage = 100;
ALTER TABLE EH_Analysis_S0_AQE_Ver1 ADD PRIMARY KEY (qeid); 

-- create a table for counting rows after each step 
DROP TABLE EH_Analysis_RowCount_Ver1;
CREATE TABLE EH_Analysis_RowCount_Ver1	-- Primary key is a (DBMS, experimentName, stepName).
(
	dbmsName	VARCHAR2(10),   -- dbms name
	exprName	VARCHAR2(50),   -- experiment name
	stepName	VARCHAR2(50), 	-- step name
	stepResultSize	NUMBER (10, 2), -- # of rows after each step
        PRIMARY KEY (dbmsName, exprName, stepName) 
);
DELETE FROM  EH_Analysis_RowCount_Ver1;
-- Count # of query executions per dbms before starting analysis
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S0_AQE_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S0_AQE_Ver1
	GROUP BY dbms, experimentname; 

-- Collect all query executions not timeouted
-- EH_Analysis_S1_VQE_Ver1 : Exhaustive_Analysis_S1_Valid_Query_Execution_Ver1 
DROP VIEW EH_Analysis_S1_VQE_Ver1;
CREATE VIEW EH_Analysis_S1_VQE_Ver1 AS -- Primary key is query execution id (queryexecutionid).
	SELECT *
	FROM EH_Analysis_S0_AQE_Ver1
	-- no timeout
	WHERE measured_time < 9999999;
ALTER VIEW EH_Analysis_S1_VQE_Ver1 ADD PRIMARY KEY (qeid) DISABLE;
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S1_VQE_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S1_VQE_Ver1
	GROUP BY dbms, experimentname; 

-- Show process info per query execution/process
-- EH_Analysis_API_Ver1 : Exhaustive_Analysis_All_Process_Info_Ver1
DROP VIEW EH_Analysis_API_Ver1;
CREATE VIEW EH_Analysis_API_Ver1 AS	-- Primary key is a query execution process: (qeid, procid) 
	SELECT DISTINCT 
	       qe.version,		   -- labshelf version
	       qe.experimentid,  	   -- experiment id
	       qe.experimentname,          -- experiment name
	       qe.runid,		   -- runid
	       qe.querynum,	 	   -- query number
	       qe.card as card, 	   -- cardinality
	       qe.planid, 	           -- plan id
	       qe.dbms,		  	   -- dbms
	       qe.measured_time,	   -- measured time
               qe.iowaitticks,		   -- iowaitticks
	       qe.irq,		   	   -- irq
	       qe.softirq,		   -- soft irq
	       qe.qeid, 		   -- query execution id
	       qe.qenum,		   -- query execution iteration number	
	       qp.processname as procname, -- process name
	       qp.ProcessID as procid, 	   -- process id
	       qp.UTime as uticks, 	   -- uticks 
	       qp.STime as sticks, 	   -- sticks 
	       qp.maj_flt as maj_flt 	   -- major faults
	FROM EH_Analysis_S1_VQE_Ver1 qe, 	   -- all raw query executions without any dropp
	     AZDBLab_QueryExecutionProcs qp
	WHERE qe.qeid = qp.queryexecutionid;
ALTER VIEW EH_Analysis_API_Ver1 ADD PRIMARY KEY (qeid, procid) DISABLE; 

-- Identify all DBMS processes with their total time at Q@C
-- EH_Analysis_ACDP_Ver1 : Exhaustive_Analysis_Candidate_DBMS_QueryProcesses_Ver1 se
DROP TABLE EH_Analysis_ACDP_Ver1;
CREATE TABLE EH_Analysis_ACDP_Ver1 AS -- Primary key is a Q@C (DBMS) process: (runid, querynum, card, processid)
	 SELECT s.runid, 
		s.querynum, 
	        s.card, 
		qp.processid as querypid, 
       		SUM(qp.UTIME+qp.STIME) q_total_time -- for 5.X
	 FROM EH_Analysis_S1_VQE_Ver1 s, 
	      AZDBLab_QueryExecutionProcs qp, 
 	      EH_Analysis_Qmd_Ver1 qmd 
	WHERE s.qeid = qp.queryexecutionid AND 
	      s.dbms = qmd.dbmsname AND		
	      qp.processname = qmd.qprocname 			-- ensure that the process should be dbms processes
	GROUP BY runid, querynum, card, qp.processid
	ORDER BY runid ASC, querynum ASC, card DESC, qp.processid ASC, q_total_time DESC;
ALTER TABLE EH_Analysis_ACDP_Ver1 ADD PRIMARY KEY (runid, querynum, card, querypid); 

-- Identify a "QUERY" process at Q@C
-- EH_Analysis_AQProc_QatC_Ver1 : Exhaustive_Analysis_Query_Process_QATC_Ver1 
DROP TABLE EH_Analysis_AQProc_QatC_Ver1;
CREATE TABLE EH_Analysis_AQProc_QatC_Ver1 AS  -- Primary key is a Q@C: (runid, querynum, card)
	SELECT DISTINCT t1.runid, 
			t1.querynum, 
			t1.card, 
			min(t1.querypid) as querypid -- not part of key 
	FROM EH_Analysis_ACDP_Ver1 t1, 
	     (SELECT DISTINCT t3.runid, -- looking at a Q@C
		     t3.querynum, 
		     t3.card, 
		     MAX(t3.q_total_time) AS maxtime 
	      FROM EH_Analysis_ACDP_Ver1 t3 
	      GROUP BY t3.runid, t3.querynum, t3.card) t2 
	WHERE t1.runid = t2.runid AND 
	      t1.querynum = t2.querynum AND 
	      t1.card = t2.card AND 
	      t1.q_total_time = t2.maxtime
	GROUP BY t1.runid, t1.querynum, t1.card;
ALTER TABLE EH_Analysis_AQProc_QatC_Ver1 ADD PRIMARY KEY (runid, querynum, card); 

-- Obtain query process information existing in a query execution 
-- Note : will not consider qeids that do not have an query process
-- EH_Analysis_AEQPI_Ver1 : Exhaustive_Analysis_Existing_Query_Process_Info_Ver1
DROP TABLE EH_Analysis_AEQPI_Ver1;
CREATE TABLE EH_Analysis_AEQPI_Ver1 AS --  Primary key is a query execution: (qeid) 
	SELECT qeid,   -- query execution id
	       uticks, -- uticks
	       sticks, -- sticks
	       maj_flt -- major faults
	FROM EH_Analysis_API_Ver1 t1, 
	     EH_Analysis_AQProc_QatC_Ver1 t2
 	WHERE t1.runid    = t2.runid 
          AND t1.querynum = t2.querynum
	  AND t1.card     = t2.card
	  AND t1.procid   = t2.querypid;
ALTER TABLE EH_Analysis_AEQPI_Ver1 ADD PRIMARY KEY (qeid); 
		            
-- Obtain query process information not existing in a query execution 
-- EH_Analysis_ANQPI_Ver1 : Exhaustive_Analysis_Non_Existing_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_ANQPI_Ver1;
CREATE VIEW EH_Analysis_ANQPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM EH_Analysis_API_Ver1 
	WHERE qeid NOT IN (SELECT qeid FROM EH_Analysis_AEQPI_Ver1);
ALTER VIEW EH_Analysis_ANQPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain overall utility query process information per query execution by taking union of EH_Analysis_AEQPI_Ver1 and EH_Analysis_ANQPI_Ver1
-- EH_Analysis_AQPI_Ver1 : Exhaustive_Analysis_Query_Process_Info_Ver1
DROP VIEW EH_Analysis_AQPI_Ver1;
CREATE VIEW EH_Analysis_AQPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT * FROM EH_Analysis_AEQPI_Ver1
	UNION
	SELECT * FROM EH_Analysis_ANQPI_Ver1;
ALTER VIEW EH_Analysis_AQPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain utility process information existing in a query execution 
-- Note : will not consider qeids that do not have an utility dbms process
-- EH_Analysis_AEUPI_Ver1 : Exhaustive_Analysis_Existing_Utility_Process_Info_Ver1
DROP TABLE EH_Analysis_AEUPI_Ver1;
CREATE TABLE EH_Analysis_AEUPI_Ver1 AS --  Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
	       	        SUM(uticks) AS uticks,
	  	        SUM(sticks) AS sticks,
		        SUM(maj_flt) AS maj_flt
	FROM EH_Analysis_API_Ver1 t1,
 	     EH_Analysis_Umd_Ver1 t2
 	WHERE (t1.procid NOT IN (SELECT DISTINCT querypid  -- not a query process
	 			 FROM EH_Analysis_AQProc_QatC_Ver1
			         WHERE runid    = t1.runid AND
                                       querynum = t1.querynum AND
				       card     = t1.card)) 
	  AND t1.dbms     = t2.dbmsname			   
	  AND t1.procname = t2.uprocname -- a utility process
	GROUP BY qeid;
ALTER TABLE EH_Analysis_AEUPI_Ver1 ADD PRIMARY KEY (qeid); 
		            
-- Obtain utility process information not existing in a query execution 
-- EH_Analysis_ANUPI_Ver1 : Exhaustive_Analysis_Non_Existing_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_ANUPI_Ver1;
CREATE VIEW EH_Analysis_ANUPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM EH_Analysis_API_Ver1 
	WHERE qeid NOT IN (SELECT qeid FROM EH_Analysis_AEUPI_Ver1);
ALTER VIEW EH_Analysis_ANUPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain overall utility dbms process information per query execution by taking union of EH_Analysis_AEUPI_Ver1 and EH_Analysis_ANUPI_Ver1
-- EH_Analysis_AUPI_Ver1 : Exhaustive_Analysis_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_AUPI_Ver1;
CREATE VIEW EH_Analysis_AUPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT * FROM EH_Analysis_AEUPI_Ver1
	UNION
	SELECT * FROM EH_Analysis_ANUPI_Ver1;
ALTER VIEW EH_Analysis_AUPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain daemon process information existing in a query execution 
-- Note : will not consider qeids that do not have an utility dbms process
-- EH_Analysis_AEDPI_Ver1 : Exhaustive_Analysis_Existing_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_AEDPI_Ver1;
CREATE VIEW EH_Analysis_AEDPI_Ver1 AS --  Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
		       SUM(uticks) AS uticks, 
		       SUM(sticks) AS sticks, 
		       SUM(maj_flt) AS maj_flt 
	FROM EH_Analysis_API_Ver1 
	WHERE procname NOT IN (SELECT qprocname 
			       FROM EH_Analysis_Qmd_Ver1 -- query process
			       UNION
			       SELECT uprocname
 			       FROM EH_Analysis_Umd_Ver1 -- utility process
			      ) 
        GROUP BY qeid;
ALTER VIEW EH_Analysis_AEDPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 
		 
-- Obtain daemon process information not existing in a query execution 
-- EH_Analysis_ANDPI_Ver1 : Exhaustive_Analysis_Non_Existing_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_ANDPI_Ver1;
CREATE VIEW EH_Analysis_ANDPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM EH_Analysis_API_Ver1 
	WHERE qeid NOT IN (SELECT qeid FROM EH_Analysis_AEDPI_Ver1);
ALTER VIEW EH_Analysis_ANDPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain overall daemon dbms process information per query execution by taking union of EH_Analysis_AEDPI_Ver1 and EH_Analysis_ANDPI_Ver1
-- Note : may have no daemon process
-- EH_Analysis_ADPI_Ver1 : Exhaustive_Analysis_Daemon_Process_Info_Ver1
DROP VIEW EH_Analysis_ADPI_Ver1;
CREATE VIEW EH_Analysis_ADPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT * FROM EH_Analysis_AEDPI_Ver1
	UNION
	SELECT * FROM EH_Analysis_ANDPI_Ver1;
ALTER VIEW EH_Analysis_ADPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtains detailed process information of a query process, a utility process(es), and a daemon process(es) per query execution
-- EH_Analysis_AQED_Ver1 : Exhaustive_Analysis_QueryExecution_Details_Ver1
DROP TABLE EH_Analysis_AQED_Ver1;
CREATE TABLE EH_Analysis_AQED_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT DISTINCT
		proc.version,		-- labshelf version
                proc.experimentid,  	-- experiment id
	        proc.experimentname,    -- experiment name
		proc.planid, 	        -- plan id
		proc.dbms,		-- dbms
		proc.qeid, 		-- query execution id
		proc.runid, 		-- runid
		proc.querynum, 		-- querynum
		proc.card, 		-- card		
		proc.qenum, 		-- query execution number
		proc.measured_time, 	-- measured time
		proc.iowaitticks, 	-- iowaitticks
		proc.irq,		-- irq
		proc.softirq, 		-- softirq
		qproc.uticks AS qp_uticks,   -- query process uticks
		qproc.sticks AS qp_sticks,   -- query process sticks
		qproc.maj_flt AS qp_maj_flt, -- query process major faults
		util_proc.uticks AS up_uticks,	-- utility process uticks
		util_proc.sticks AS up_sticks,	-- utility process sticks
		util_proc.maj_flt AS up_maj_flt,-- utility process major faults
		dproc.uticks AS dp_uticks, 	-- daemon process uticks
		dproc.sticks AS dp_sticks, 	-- daemon process sticks
		dproc.maj_flt as dp_maj_flt,	-- daemon process major faults
		(qproc.uticks+util_proc.uticks+dproc.uticks) AS sum_proc_uticks,     -- sum of process uticks
		(qproc.sticks+util_proc.sticks+dproc.sticks) AS sum_proc_sticks,     -- sum of process sticks
		(qproc.maj_flt+util_proc.maj_flt+dproc.maj_flt) AS sum_proc_maj_flt  -- sum of process major faults
	FROM	EH_Analysis_API_Ver1   proc,	-- process info
		EH_Analysis_AQPI_Ver1 qproc, 	-- query process info
		EH_Analysis_AUPI_Ver1 util_proc,	-- utility process info
		EH_Analysis_ADPI_Ver1 dproc	-- daemon Process info
	WHERE 	proc.qeid  = qproc.qeid
	    AND qproc.qeid = util_proc.qeid
	    AND qproc.qeid = dproc.qeid
	ORDER BY proc.qeid ASC;
ALTER TABLE EH_Analysis_AQED_Ver1 ADD PRIMARY KEY (qeid); 
-- Count # of query executions per dbms
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_AQED_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_AQED_Ver1
	GROUP BY dbms, experimentname; 

-- Compute query times
-- Ticks are to 2 decimal places. 
-- Times are to one decimal place. 
-- EH_Analysis_ACTQatC_Ver1 : Exhaustive_Analysis_Step4_Calculated_Time_QatC_VER1
DROP TABLE EH_Analysis_ACTQatC_Ver1;
CREATE TABLE EH_Analysis_ACTQatC_Ver1 AS -- Primary key is a Q@C: (runid, querynum, card)
	SELECT  qed.version,		-- labshelf version
	        qed.experimentid,  	-- experiment id
	        qed.experimentname,     -- experiment name
		qed.dbms, 	        -- dbms
		qed.runid, 	        -- runid
		qed.querynum, 	        -- query number
		qed.card, 	        -- cardinality
		qed.planid, 	        -- plan id
		MIN(qed.measured_time) as min_meas_time, 	    -- minimum measured time
		MAX(qed.measured_time) as max_meas_time, 	    -- maximum measured time
		ROUND(AVG(qed.measured_time),1) as avg_meas_time,   -- average measured time
		ROUND(STDDEV(qed.measured_time),1) as std_meas_time,-- std dev of measured time
		ROUND(MEDIAN((qp_uticks+qp_sticks)*10), 1) as med_cqt, -- median calculated time
		ROUND(STDDEV((qp_uticks+qp_sticks)*10), 1) as std_cqt, -- std dev of calculated time
		(CASE 
		    WHEN ROUND(MEDIAN((qp_uticks+qp_sticks)*10), 1) = 0 THEN 0
		    ELSE (ROUND(STDDEV((qp_uticks+qp_sticks)*10)/MEDIAN((qp_uticks+qp_sticks)*10), 1))
		  END) as var_cqt,
		ROUND(MEDIAN(qp_uticks), 2) as med_qp_uticks, -- median  query process uticks
		MIN(qp_uticks) as min_qp_uticks,  	      -- minimum query process uticks
		MAX(qp_uticks) as max_qp_uticks,     	      -- maximum query process uticks
		ROUND(AVG(qp_uticks),2) as avg_qp_uticks,     -- average query process uticks
		ROUND(stddev(qp_uticks),2) as std_qp_uticks,  -- std dev of query process uticks
		MIN(up_maj_flt) as min_up_maj_flt,   	      -- minimum utility process major faults
		MAX(up_maj_flt) as max_up_maj_flt,   	      -- maximum utility process major faults  
		ROUND(AVG(up_maj_flt),2) as avg_up_maj_flt,   -- average utility process major faults  
		ROUND(stddev(up_maj_flt),2) as std_up_maj_flt,-- std dev of utility process major faults
		MIN(dp_maj_flt) as min_dp_maj_flt, 	      -- minimum daemon process major faults		
		MAX(dp_maj_flt) as max_dp_maj_flt, 	      -- maximum daemon process major faults
		ROUND(AVG(dp_maj_flt),2) as avg_dp_maj_flt,   -- average daemon process major faults  
		ROUND(stddev(dp_maj_flt),2) as std_dp_maj_flt,-- std dev of daemon process major faults  
		MIN(qed.iowaitticks) as min_iowait, 	      -- minimum io wait ticks
		MAX(qed.iowaitticks) as max_iowait, 	      -- maximum io wait ticks
		ROUND(AVG(qed.iowaitticks),2) as avg_iowait,    -- average io wait ticks
		ROUND(stddev(qed.iowaitticks),2) as std_iowait  -- std dev of io wait ticks
	FROM EH_Analysis_AQED_Ver1 qed
	GROUP BY qed.version, qed.experimentid, qed.experimentname, qed.dbms, qed.runid, qed.querynum, qed.card, qed.planid -- required by oracle; 	
ALTER TABLE EH_Analysis_ACTQatC_Ver1 ADD PRIMARY KEY (runid, querynum, card); 
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_ACTQatC_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_ACTQatC_Ver1
	GROUP BY dbms, experimentname;

-- Collect all Q@Cs having the same plan for raw data
-- EH_Analysis_ASPQatC_Ver1 : Exhaustive_Analysis_Same_Plan_QatC_Ver1
DROP TABLE EH_Analysis_ASPQatC_Ver1;
CREATE TABLE EH_Analysis_ASPQatC_Ver1 AS
	SELECT p1.*, 
	       p2.card as card2, 
	       p2.med_cqt as med_cqt2,
	       p2.std_cqt as std_cqt2
	FROM EH_Analysis_ACTQatC_Ver1 p1, 		
	     EH_Analysis_ACTQatC_Ver1 p2 
	WHERE p1.runid    = p2.runid    AND 	-- same run
	      p1.querynum = p2.querynum AND 	-- same query
	      p1.planid   = p2.planid   AND 	-- same plan
	      p1.card < p2.card
	ORDER BY p1.runid, p1.querynum, p1.card, p2.card;
ALTER TABLE EH_Analysis_ASPQatC_Ver1 ADD PRIMARY KEY (runid, querynum, card, card2); 

-- Tests monotonicity by the strict condition of using plain median calculated time
-- EH_Analysis_ATSM_Ver1 : Exhaustive_Analysis_All_Test_Strict_Monotonicity
DROP TABLE EH_Analysis_ATSM_Ver1;
CREATE TABLE EH_Analysis_ATSM_Ver1 AS -- Primary key is a 2 related Q@Cs with the same plan (runid, querynum, card1, card2)
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM EH_Analysis_ASPQatC_Ver1
	WHERE med_cqt > med_cqt2 -- applying strict condition 
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE EH_Analysis_ATSM_Ver1 ADD PRIMARY KEY (runid, querynum, card, card2); 
-- Count # of Q@Cs per dbms at this analysis
delete from EH_Analysis_RowCount_Ver1 where stepName = 'EH_Analysis_ATSM_Ver1';
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_ATSM_Ver1' as stepName,
	       COALESCE(count(*),0) as stepResultSize
	FROM EH_Analysis_ATSM_Ver1
	GROUP BY dbms, experimentname;

-- Tests monotonicity by the relaxed condition of using half std dev of calculated time
-- EH_Analysis_ATRM_Ver1 : Exhaustive_Analysis_All_Test_Relaxed_Monotonicity
DROP TABLE EH_Analysis_ATRM_Ver1;
CREATE TABLE EH_Analysis_ATRM_Ver1 AS -- Primary key is a (runid, querynum, planid, different cardinalities)
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM EH_Analysis_ASPQatC_Ver1
	WHERE med_cqt-0.5*std_cqt > med_cqt2+0.5*std_cqt2 -- applying relaxed condition
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE EH_Analysis_ATRM_Ver1 ADD PRIMARY KEY (runid, querynum, card, card2); 
delete from EH_Analysis_RowCount_Ver1 where stepName = 'EH_Analysis_ATRM_Ver1';
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_ATRM_Ver1' as stepName,
	       COALESCE(COUNT(*), 0) as stepResultSize
	FROM EH_Analysis_ATRM_Ver1
	GROUP BY dbms, experimentname;


-- Collect all query execution aspects from EH_Analysis_S1_VQE_Ver1
-- EH_Analysis_S1_QEA_Ver1 : Exhaustive_Analysis_S1_Query_Execution_Aspect_Ver1
DROP VIEW EH_Analysis_S1_QEA_Ver1;
CREATE VIEW EH_Analysis_S1_QEA_Ver1 AS -- Primary key is query execution id (queryexecutionid).
	SELECT qe.dbms,
	       qe.experimentName,
	       qe.runid,
	       qe.querynum,
	       qe.card,
	       qe.measured_time,
	       qea.*
	FROM EH_Analysis_S1_VQE_Ver1 qe,
	     AZDBLab_QueryExecutionAspect qea 
	-- fetch aspect associated with query execution
	WHERE qe.qeid = qea.queryexecutionid;	
ALTER VIEW EH_Analysis_S1_QEA_Ver1 ADD PRIMARY KEY (queryexecutionid) DISABLE;

-- Count the total QEs across runs
-- EH_Analysis_S1_TQE_Ver1 : Exhaustive_Analysis_S1_Total_Query_Execution_Counts_Ver1
DROP VIEW EH_Analysis_S1_TQE_Ver1;
CREATE VIEW EH_Analysis_S1_TQE_Ver1 AS -- Primary key is a labshelf, so one row!
	SELECT count(*) AS totalQEs
	FROM EH_Analysis_S1_VQE_Ver1;
	
-- Collect all Q@Cs per run
-- EH_Analysis_S1_QatC_Ver1 : Exhaustive_Analysis_S1_QatC_Ver1
DROP VIEW EH_Analysis_S1_QatC_Ver1;
CREATE VIEW EH_Analysis_S1_QatC_Ver1 AS -- Primary key is a Q@C (runid, querynum, card).
	SELECT DISTINCT dbms,
	       		experimentName,
	 	        runid,
		        querynum,
		        card
	FROM  EH_Analysis_S1_VQE_Ver1;
ALTER VIEW EH_Analysis_S1_QatC_Ver1 ADD PRIMARY KEY (runid, querynum, card) DISABLE;

-- Count the total Q@Cs across runs
-- EH_Analysis_S1_TQC_Ver1 : Exhaustive_Analysis_S1_Total_QatCs_Ver1
DROP VIEW EH_Analysis_S1_TQC_Ver1;
CREATE VIEW EH_Analysis_S1_TQC_Ver1 AS -- Primary key is a labshelf, so one row!
	SELECT count(*) AS totalQatCs
	FROM EH_Analysis_S1_QatC_Ver1;

-- Overall sanity checks

-- Collect all missing queries per dbms per experiment
-- EH_Analysis_S1_MQ_PDE_Ver1 : Exhaustive_Analysis_S1_Missing_Queries_Per_DBMS_Per_Experiment_Ver1
DROP VIEW EH_Analysis_S1_MQ_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_MQ_PDE_Ver1 AS -- Primary key is runid.			
	SELECT dbms, 
	       experimentname,
	       runid,
	       COALESCE(SUM(numMissingQueries), 0) AS numMissingQueries
	FROM (
	        (SELECT dbms, 
		        experimentname,
		        runid, 
			(max(querynum)-min(querynum)+1)-count(querynum) AS numMissingQueries 
 		 FROM (SELECT DISTINCT dbms, 
				       experimentname,
		       		       runid, 
	        	     	       querynum 
	      	       FROM EH_Analysis_S0_AQE_Ver1)
		 GROUP BY dbms, experimentname, runid)
	     )
	GROUP BY dbms, experimentname, runid;
ALTER VIEW EH_Analysis_S1_MQ_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE;

-- Count total missing queries
-- EH_Analysis_S1_MQ_Ver1 : Exhaustive_Analysis_S1_Missing_Queries_Ver1 
DROP VIEW EH_Analysis_S1_MQ_Ver1;
CREATE VIEW EH_Analysis_S1_MQ_Ver1 AS -- Primary key is a labshelf, so just 1 row!			
	SELECT COALESCE(SUM(numMissingQueries), 0) AS numMissingQueries
	FROM EH_Analysis_S1_MQ_PDE_Ver1;

-- Count (query execution) aspect failures per dbms per experiment
-- EH_Analysis_S1_AF_PDE_Ver1 : Exhaustive_Analysis_S1_Aspect_Failures_Per_DBMS_Experiment_Ver1 
DROP VIEW EH_Analysis_S1_AF_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_AF_PDE_Ver1 AS -- Primary key is runid.			
	SELECT dbms, 
	       experimentname,
	       runid,
	       COALESCE(SUM(numAspectFailures), 0) AS numAspectFailures
	FROM (
		SELECT qe.dbms, 
		       qe.experimentname,
		       qe.runid,
		       (totalQEs - totalQEAs) as numAspectFailures 
		FROM 
			(SELECT dbms, 
				experimentName, 
				runid,
				count(qeid) AS totalQEs -- total number of executions per run
			 FROM EH_Analysis_S1_VQE_Ver1 
			 GROUP BY dbms, experimentname, runid) qe, 
			(SELECT dbms, 
				experimentName, 
				runid,
				count(queryexecutionid) AS totalQEAs -- total number of aspects per run
			 FROM EH_Analysis_S1_QEA_Ver1 
			 GROUP BY dbms, experimentname, runid) qea
		WHERE qe.runid = qea.runid
	     ) t0
	GROUP BY dbms, experimentname, runid;
ALTER VIEW EH_Analysis_S1_AF_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE;

-- Count (query execution) aspect failures
-- EH_Analysis_S1_AF_Ver1 : Exhaustive_Analysis_S1_Aspect_Failures_Ver1 
DROP VIEW EH_Analysis_S1_AF_Ver1;
CREATE VIEW EH_Analysis_S1_AF_Ver1 AS -- Primary key is a (dbms, experimentname)			
	SELECT COALESCE(SUM(numAspectFailures), 0) AS numAspectFailures
	FROM EH_Analysis_S1_AF_PDE_Ver1;

-- Count unique plan violations per dbms per experiment
-- EH_Analysis_S1_UPV_Ver1 : Exhaustive_Analysis_S1_Unique_Plan_Violations_Per_DBMS_Per_Experiment_Ver1 
DROP VIEW EH_Analysis_S1_UPV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_UPV_PDE_Ver1 AS -- Primary key is a (runid)
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(nUPViolations), 0) AS numUniquePlanViolations
	FROM  (SELECT t2.dbms,
		      t2.experimentname,
		      t1.runid, 
	    	      t1.querynum, 
		      t1.card, 
		      COALESCE(count(t2.qeid), 0) AS nUPViolations -- count unique plan violations per Q@C
	       FROM  EH_Analysis_S1_QatC_Ver1        t1, -- Q@C
		     EH_Analysis_S1_VQE_Ver1         t2, -- query execution
		     AZDBLab_QueryExecutionHasPlan qep -- query plan
	       WHERE   t1.runid    = t2.runid
		   AND t1.querynum = t2.querynum
		   AND t1.card	    = t2.card
		   AND t2.qeid     = qep.queryExecutionID
	       GROUP BY t2.dbms, t2.experimentname, t1.runid, t1.querynum, t1.card
	       HAVING count(DISTINCT qep.planID) > 1)  -- violating unique plan
	GROUP BY dbms, experimentname, runid;
ALTER VIEW EH_Analysis_S1_UPV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE;

-- Count unique plan violations
-- EH_Analysis_S1_UPV_Ver1 : Exhaustive_Analysis_S1_Unique_Plan_Violations_Ver1 
DROP VIEW EH_Analysis_S1_UPV_Ver1;
CREATE VIEW EH_Analysis_S1_UPV_Ver1 AS -- Primary key is a labshelf, so just 1 row!
	-- COALESCE sets the sum to 0 unless any row is returned
        SELECT COALESCE(SUM(numUniquePlanViolations), 0) AS numUniqPlanViols	
	FROM EH_Analysis_S1_UPV_PDE_Ver1;

-- Identify all DBMS processes with their total time at Q@C
-- EH_Analysis_S1_CDP_Ver1 : Exhaustive_Analysis_S1_Candidate_DBMS_QueryProcesses_Ver1 se
DROP TABLE EH_Analysis_S1_CDP_Ver1;
CREATE TABLE EH_Analysis_S1_CDP_Ver1 AS -- Primary key is a Q@C (DBMS) process: (runid, querynum, card, processid)
	 SELECT s.runid, 
		s.querynum, 
	        s.card, 
		qp.processid as querypid, 
       		SUM(qp.UTIME+qp.STIME) q_total_time
	 FROM EH_Analysis_S1_VQE_Ver1 s,
	      AZDBLab_QueryExecutionProcs qp, 
 	      EH_Analysis_Qmd_Ver1 qmd 
	WHERE s.qeid = qp.queryexecutionid AND 
	      s.dbms = qmd.dbmsname AND		
	      qp.processname = qmd.qprocname 	-- ensure that the process should be dbms processes
	GROUP BY runid, querynum, card, qp.processid
	ORDER BY runid ASC, querynum ASC, card DESC, qp.processid ASC, q_total_time DESC;
ALTER TABLE EH_Analysis_S1_CDP_Ver1 ADD PRIMARY KEY (runid, querynum, card, querypid); 

-- Identify a "QUERY" process at Q@C
-- EH_Analysis_S1_QProc_QatC_Ver1 : Exhaustive_Analysis_S1_Query_Process_QATC_Ver1 
DROP TABLE EH_Analysis_S1_QProc_QatC_Ver1;
CREATE TABLE EH_Analysis_S1_QProc_QatC_Ver1 AS  -- Primary key is a Q@C: (runid, querynum, card)
	SELECT DISTINCT t1.runid, 
			t1.querynum, 
			t1.card, 
			min(t1.querypid) as querypid -- not part of key 
	FROM EH_Analysis_S1_CDP_Ver1 t1, 
	     (SELECT DISTINCT t3.runid, -- looking at a Q@C
			     t3.querynum, 
			     t3.card, 
		     MAX(t3.q_total_time) AS maxtime 
	      FROM EH_Analysis_S1_CDP_Ver1 t3 
	      GROUP BY t3.runid, t3.querynum, t3.card) t2 
	WHERE t1.runid = t2.runid AND 
	      t1.querynum = t2.querynum AND 
	      t1.card = t2.card AND 
	      t1.q_total_time = t2.maxtime
	GROUP BY t1.runid, t1.querynum, t1.card;
ALTER TABLE EH_Analysis_S1_QProc_QatC_Ver1 ADD PRIMARY KEY (runid, querynum, card) ; 

-- Collect query time in query execution for excessive variation and query time sanity checks
-- EH_Analysis_S1_QProc_QatC_Ver1 : Exhaustive_Analysis_S1_Query_Process_QE_Ver1 
DROP VIEW EH_Analysis_S1_QProc_QE_Ver1;
CREATE VIEW EH_Analysis_S1_QProc_QE_Ver1 AS -- Primary key is qeid!
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,    -- Q@C
	       t1.querynum,
	       t1.card,
	       t1.qeid,	    -- query execution
	       t2.querypid, -- query process
	       qp.utime+qp.stime as QueryTime
	FROM  EH_Analysis_S1_VQE_Ver1  	   t1,
	      EH_Analysis_S1_QProc_QatC_Ver1  t2,
	      AZDBLab_QueryExecutionProcs  qp
	WHERE   t1.runid     = t2.runid
	    AND t1.querynum  = t2.querynum
	    AND t1.card	     = t2.card
	    AND t1.qeid	     = qp.queryexecutionid
	    AND t2.querypid  = qp.processid;
ALTER VIEW EH_Analysis_S1_QProc_QE_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Q@C sanity check

-- Counts Q@Cs revealing excessive variation in query time per DBMS per Experiment
-- EH_Analysis_S1_EQTV_PDE_Ver1 : Exhaustive_Analysis_Step5_Excessive_Query_Time_Variation_Per_DBMS_Per_Experiment_Ver1
DROP VIEW EH_Analysis_S1_EQTV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_EQTV_PDE_Ver1 AS -- Primary key is (runid).
	SELECT dbms, 
	       experimentname,
	       runid,
	       COALESCE(SUM(t1.numExcVarPerRun), 0) AS numExcVarPerDBMSPerExp
	FROM  (-- Q@Cs exposing excessive variations
		SELECT t0.dbms, 
		       t0.experimentname,
		       t0.runid, 
		       t0.querynum,
		       COALESCE(count(t0.card), 0) AS numExcVarPerRun
		FROM (SELECT dbms,
			     experimentname,
			     runid,
			     querynum,
			     card
		      FROM EH_Analysis_S1_QProc_QE_Ver1
		      HAVING TRUNC(STDDEV(queryTime), 0) > CEIL(0.2 * AVG(queryTime))
		      GROUP BY dbms, experimentname, runid, querynum, card) t0
		GROUP BY dbms, experimentname, runid, querynum) t1
	GROUP BY dbms, experimentname, runid;
ALTER VIEW EH_Analysis_S1_EQTV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Sum up all excessive variaions from all DBMSes
-- EH_Analysis_S1_EQTV_Ver1 : Exhaustive_Analysis_S1_Excessive_Query_Time_Variation_Ver1
DROP VIEW EH_Analysis_S1_EQTV_Ver1;
CREATE VIEW EH_Analysis_S1_EQTV_Ver1 AS -- Primary key is a labshelf, so one row!
	SELECT COALESCE(SUM(numExcVarPerDBMSPerExp), 0) AS excVarQatCs
	FROM EH_Analysis_S1_EQTV_PDE_Ver1;

-- Query execution sanity check

-- Count DBMS (query+utility) Time Violations per dbms per experiment: (CEIL(measured_time/10)-TRUNC(totalOtherTime/10, 0)) < 0
-- EH_Analysis_S1_DTV_PDE_Ver1 : Exhaustive_Analysis_S1_DBMS_Time_Violations_Ver1 
DROP VIEW EH_Analysis_S1_DTV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_DTV_PDE_Ver1 AS -- Primary key is (runid)
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(queryexecutionid), 0)  AS numDBMSTimeViolations
	FROM EH_Analysis_S1_QEA_Ver1 
	WHERE (CEIL(measured_time/10)-TRUNC(totalOtherTime/10, 0)) < 0 
	GROUP BY dbms, experimentname, runid;
ALTER VIEW EH_Analysis_S1_DTV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Count DBMS (query+utility) Time Violations: (CEIL(measured_time/10)-TRUNC(totalOtherTime/10, 0)) < 0
-- EH_Analysis_S1_DTV_Ver1 : Exhaustive_Analysis_S1_DBMS_Time_Violations_Ver1 
DROP VIEW EH_Analysis_S1_DTV_Ver1;
CREATE VIEW EH_Analysis_S1_DTV_Ver1 AS -- Primary key is a labshelf, so just 1 row!
	SELECT COALESCE(SUM(numDBMSTimeViolations), 0) AS DBMSTimeViols
	FROM EH_Analysis_S1_DTV_PDE_Ver1;

-- Count zero "Query Time" violations per dbms per experiment: querytime = 0
-- EH_Analysis_S1_ZQTV_PDE_Ver1 : Exhaustive_Analysis_S1_DBMS_Time_Violations_Ver1 
DROP VIEW EH_Analysis_S1_ZQTV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_ZQTV_PDE_Ver1 AS -- Primary key is (runid)
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0)  AS numZeroQueryTimes
	FROM  EH_Analysis_S1_QProc_QE_Ver1
	WHERE querytime = 0 -- in ticks
	GROUP BY dbms, experimentname, runid;
ALTER VIEW EH_Analysis_S1_ZQTV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Count zero "Query Time" violations : querytime = 0
-- EH_Analysis_S1_ZQTV_Ver1 : Exhaustive_Analysis_S1_Zero_Query_Time_Ver1 
DROP VIEW EH_Analysis_S1_ZQTV_Ver1;
CREATE VIEW EH_Analysis_S1_ZQTV_Ver1 AS -- Primary key is a labshelf, so just 1 row!
	SELECT COALESCE(SUM(numZeroQueryTimes), 0) AS ZeroQueryTimes
	FROM EH_Analysis_S1_ZQTV_PDE_Ver1;

-- Count "Query Time" violations per dbms per experiment: querytime > CEIL(measured_time/10)
-- EH_Analysis_S1_QTV_PDE_Ver1 : Exhaustive_Analysis_S1_DBMS_Time_Violations_Ver1 
DROP VIEW EH_Analysis_S1_QTV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_QTV_PDE_Ver1 AS -- Primary key is (runid)
	SELECT qproc.dbms,
	       qproc.experimentname,
	       qproc.runid, 
	       COALESCE(count(qproc.qeid), 0)  AS numQueryTimeViolations
	FROM  EH_Analysis_S1_QProc_QE_Ver1 qproc,
	      EH_Analysis_S1_QEA_Ver1 qea
	WHERE qproc.qeid = qea.queryexecutionid 
          AND querytime > CEIL(measured_time/10)
	GROUP BY qproc.dbms, qproc.experimentname, qproc.runid;
ALTER VIEW EH_Analysis_S1_QTV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Count "Query Time" violations : querytime = 0
-- EH_Analysis_S1_QTV_Ver1 : Exhaustive_Analysis_S1_Zero_Query_Time_Ver1 
DROP VIEW EH_Analysis_S1_QTV_Ver1;
CREATE VIEW EH_Analysis_S1_QTV_Ver1 AS -- Primary key is a labshelf, so just 1 row!
	SELECT COALESCE(SUM(numQueryTimeViolations), 0) AS QueryTimeViols
	FROM EH_Analysis_S1_QTV_PDE_Ver1;

-- Counts high tick violations per DBMS per experiment : ((userModeTicks + ... + stealStolenTicks) - CEIL(measured_time/10) >= 3 (ticks))
-- EH_Analysis_S1_HTV_PDE_Ver1 : Exhaustive_Analysis_S1_High_Tick_Violations_PDE_Ver1 
DROP VIEW EH_Analysis_S1_HTV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_HTV_PDE_Ver1 AS  -- Primary key is (runid)
	(SELECT dbms,
		experimentname, 
		runid, 
	        COALESCE(count(queryexecutionid), 0) AS numHighTickViolations
	 FROM EH_Analysis_S1_QEA_Ver1 
	 -- ticks are too high
	 WHERE (userModeTicks+lowPriorityUserModeTicks+systemModeTicks+idleTaskTicks+ioWaitTicks+stealStolenTicks) - CEIL(measured_time/10) >= 3
	 GROUP BY dbms, experimentname, runid);
ALTER VIEW EH_Analysis_S1_HTV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Counts high tick violations ((userModeTicks + ... + stealStolenTicks) - CEIL(measured_time/10) >= 3 (tick))
-- EH_Analysis_S1_HTV_Ver1 : Exhaustive_Analysis_S1_High_Tick_Violations_Ver1 
--DROP VIEW EH_Analysis_S1_HTV_Ver1;
--CREATE VIEW EH_Analysis_S1_HTV_Ver1 AS  -- Primary key is a labshelf, so just 1 row!
--	SELECT COALESCE(SUM(numHighTickViolations), 0)  AS HighTickViols
--	FROM EH_Analysis_S1_HTV_PDE_Ver1;

-- Counts low tick violations per DBMS per experiment : ((userModeTicks + ... + stealStolenTicks) - TRUNC(measured_time/10,0) <= -3 (ticks))
-- EH_Analysis_S1_LTV_PDE_Ver1 : Exhaustive_Analysis_S1_High_Tick_Violations_PDE_Ver1 
--DROP VIEW EH_Analysis_S1_LTV_PDE_Ver1;
--CREATE VIEW EH_Analysis_S1_LTV_PDE_Ver1 AS  -- Primary key is (runid)
--	(SELECT dbms,
--		experimentname, 
--		runid, 
--	        COALESCE(count(queryexecutionid), 0) AS numLowTickViolations
--	 FROM EH_Analysis_S1_QEA_Ver1 
	 -- ticks are too low
--	 WHERE (userModeTicks+lowPriorityUserModeTicks+systemModeTicks+idleTaskTicks+ioWaitTicks+stealStolenTicks) - TRUNC(measured_time/10,0) <= -9 
--	 GROUP BY dbms, experimentname, runid);
--ALTER VIEW EH_Analysis_S1_LTV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Counts low tick violations ((userModeTicks + ... + stealStolenTicks) - CEIL(measured_time/10) >= 3 (tick))
-- EH_Analysis_S1_LTV_Ver1 : Exhaustive_Analysis_S1_High_Tick_Violations_Ver1 
--DROP VIEW EH_Analysis_S1_LTV_Ver1;
--CREATE VIEW EH_Analysis_S1_LTV_Ver1 AS  -- Primary key is a labshelf, so just 1 row!
--	SELECT COALESCE(SUM(numLowTickViolations), 0)  AS LowTickViols
--	FROM EH_Analysis_S1_LTV_PDE_Ver1;

-- Count QEs having no query process per DBMS per experiment
-- EH_Analysis_S1_NQPV_PDE_Ver1 : Exhaustive_Analysis_S1_No_Query_Process_Violation_Per_DBMS_Per_Experiment_Ver1 
DROP VIEW EH_Analysis_S1_NQPV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_NQPV_PDE_Ver1 AS -- Primary key is runid.
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) numQEsWithoutQProcs
	FROM (
		SELECT dbms, 
		       experimentName, 
        	       runid, 
		       qeid -- all query executions 
        	FROM EH_Analysis_S1_VQE_Ver1
        	MINUS 
        	SELECT dbms, 
		       experimentName, 
        	       runid, 
		       qeid -- all query executions having query procs
      		FROM EH_Analysis_S1_QProc_QE_Ver1
     	)
	GROUP BY dbms, experimentName, runid;
ALTER VIEW EH_Analysis_S1_NQPV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Count QEs having no query process
-- EH_Analysis_S1_NQPV_Ver1 : Exhaustive_Analysis_S1_No_Query_Process_Violation_Ver1 
DROP VIEW EH_Analysis_S1_NQPV_Ver1;
CREATE VIEW EH_Analysis_S1_NQPV_Ver1 AS -- Primary key is qeid!
	SELECT COALESCE(SUM(numQEsWithoutQProcs), 0) AS NoQueryProcViols
	FROM EH_Analysis_S1_NQPV_PDE_Ver1;

-- Count QEs having other query processes per DBMS per experiment
-- EH_Analysis_S1_OQPV_PDE_Ver1 : Exhaustive_Analysis_S1_Other_Query_Process_Violation_Per_DBMS_Per_Experiment_Ver1 
DROP VIEW EH_Analysis_S1_OQPV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_OQPV_PDE_Ver1 AS -- Primary key is runid.
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) as numQEsWithOtherQProcs
	FROM EH_Analysis_S1_VQE_Ver1      qe,
	     AZDBLab_QueryExecutionProcs qp,
	     EH_Analysis_Qmd_Ver1 	qmd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> qmd.dbmsname
	  AND qp.processname = qmd.qprocname  
	GROUP BY dbms, experimentName, runid;
ALTER VIEW EH_Analysis_S1_OQPV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Count QEs having other query processes
-- EH_Analysis_S1_OQPV_Ver1 : Exhaustive_Analysis_S1_Other_Query_Process_Violation_Ver1 
DROP VIEW EH_Analysis_S1_OQPV_Ver1;
CREATE VIEW EH_Analysis_S1_OQPV_Ver1 AS -- Primary key is qeid!
	SELECT COALESCE(SUM(numQEsWithOtherQProcs), 0) AS OtherQueryProcViols
	FROM EH_Analysis_S1_OQPV_PDE_Ver1;

-- Count QEs having other utility processes per DBMS per experiment
-- EH_Analysis_S1_OUPV_Ver1 : Exhaustive_Analysis_S1_Other_Utility_Process_Violation_Ver1 
DROP VIEW EH_Analysis_S1_OUPV_PDE_Ver1;
CREATE VIEW EH_Analysis_S1_OUPV_PDE_Ver1 AS -- Primary key is runid.
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) as numQEsWithOtherUProcs
	FROM EH_Analysis_S1_VQE_Ver1        qe,
	     AZDBLab_QueryExecutionProcs qp,
	     EH_Analysis_Umd_Ver1 	umd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> umd.dbmsname
	  AND qp.processname = umd.uprocname  
	GROUP BY dbms, experimentName, runid;
ALTER VIEW EH_Analysis_S1_OUPV_PDE_Ver1 ADD PRIMARY KEY (runid) DISABLE; 

-- Count QEs having other utility processes
-- EH_Analysis_S1_OUPV_Ver1 : Exhaustive_Analysis_S1_Other_Utility_Process_Violation_Ver1 
DROP VIEW EH_Analysis_S1_OUPV_Ver1;
CREATE VIEW EH_Analysis_S1_OUPV_Ver1 AS -- Primary key is qeid!
	SELECT COALESCE(SUM(numQEsWithOtherUProcs), 0) AS OtherUtilProcViols
	FROM EH_Analysis_S1_OUPV_PDE_Ver1;

-- Collect all QEs failing to pass sanity checks
-- EH_Analysis_S1_FQE_Ver1 : Exhaustive_Analysis_S1_Failed_Query_Executions_Ver1
DROP VIEW EH_Analysis_S1_FQE_Ver1;
CREATE VIEW EH_Analysis_S1_FQE_Ver1 AS
	-- excessively varying query time
	SELECT t1.dbms,
	       t1.experimentname,
	       qeid
	FROM (SELECT dbms,
		     experimentname,
		     runid,
		     querynum,
		     card
	      FROM EH_Analysis_S1_QProc_QE_Ver1
	      HAVING TRUNC(STDDEV(queryTime), 0) > CEIL(0.2 * AVG(queryTime))
	      GROUP BY dbms, experimentname, runid, querynum, card) t0, 
	      EH_Analysis_S1_VQE_Ver1 t1
	WHERE t0.runid = t1.runid AND
	      t0.querynum = t1.querynum AND
	      t0.card     = t1.card
	UNION
	-- dbms time violations
	SELECT dbms,
	       experimentname,
	       queryexecutionid
	FROM EH_Analysis_S1_QEA_Ver1 
	WHERE (CEIL(measured_time/10)-TRUNC(totalOtherTime/10, 0)) < 0
	UNION
	-- zero query time violations
	SELECT dbms,
	       experimentname,
	       qeid
	FROM  EH_Analysis_S1_QProc_QE_Ver1
	WHERE querytime = 0 -- in ticks
	UNION
	-- query time violations
	SELECT qproc.dbms,
	       qproc.experimentname,
	       qproc.qeid
	FROM  EH_Analysis_S1_QProc_QE_Ver1 qproc,
	      EH_Analysis_S1_QEA_Ver1 qea
	WHERE qproc.qeid = qea.queryexecutionid 
	  AND querytime > CEIL(measured_time/10)
	UNION
	-- non-query proc violations
	SELECT dbms,
	       experimentname,
	       qeid
	FROM (
		SELECT dbms,
	       	       experimentname,
		       qeid -- all query executions 
        	FROM EH_Analysis_S1_VQE_Ver1
        	MINUS 
        	SELECT dbms,
	       	       experimentname,
		       qeid -- all query executions 
      		FROM EH_Analysis_S1_QProc_QE_Ver1
     	)
	UNION
	-- other query proc violations
	SELECT qe.dbms,
	       qe.experimentname,
               qeid
	FROM EH_Analysis_S1_VQE_Ver1        qe,
	     AZDBLab_QueryExecutionProcs qp,
	     EH_Analysis_Qmd_Ver1 		 qmd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> qmd.dbmsname
	  AND qp.processname = qmd.qprocname
	UNION
	-- other util proc violations
	SELECT qe.dbms,
	       qe.experimentname,
               qeid
	FROM EH_Analysis_S1_VQE_Ver1        qe,
	     AZDBLab_QueryExecutionProcs qp,
	     EH_Analysis_Umd_Ver1 		 umd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> umd.dbmsname
	  AND qp.processname = umd.uprocname;
ALTER VIEW EH_Analysis_S1_FQE_Ver1 ADD PRIMARY KEY (qeid) DISABLE;
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S1_FQE_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S1_FQE_Ver1
	GROUP BY dbms, experimentname;

-- Sanity checks on the chosen labshelf
-- Note: We convert all times to ticks, and round them to one decimal place for fair comparion.
-- EH_Analysis_S1_Ver1 
DROP VIEW EH_Analysis_S1_Ver1;
CREATE VIEW EH_Analysis_S1_Ver1 AS -- Primary key is a labshelf, so just 1 row!
	SELECT DISTINCT numMissingQueries, -- # of queries associated with this completed run : any is bad
		       numAspectFailures,  -- # of QEs having no associated aspect : any is bad
		       numUniqPlanViols, -- # of queries whose plan at a cardinality is not unique : any is bad
		       excVarQatCs, -- # of Q@Cs having the std. dev. of query times > 20% of the average query times : many is bad
		       DBMSTimeViols,  -- # of QEs having (CEIL(measured_time/10) - TRUNC(totalOtherTime/10, 0)) <= 0 
		       ZeroQueryTimes,      -- # of QEs with zero query times
		       QueryTimeViols, -- # of QEs with (querytime > CEIL(measured_time/10))
		       --HighTickViols,  -- # of QEs with (totalTicks - TRUNC(measured_time/10)) > 1
		       --LowTickViols,   -- # of QEs with (totalTicks - TRUNC(measured_time/10)) < 0
		       NoQueryProcViols, -- # of QEs without any query process
		       OtherQueryProcViols, -- # of QEs with other query processes
		       OtherUtilProcViols, -- # of QEs with other utility processes
		       totalQatCs,          -- # of total QatCs
		       totalQEs       	    -- # of total QEs
	FROM EH_Analysis_S1_MQ_Ver1 mq,	-- missing queries
	     EH_Analysis_S1_AF_Ver1 qea,	-- query execution aspects
	     EH_Analysis_S1_UPV_Ver1 upv,	-- unique plan violations
	     EH_Analysis_S1_EQTV_Ver1 evp,	-- Q@Cs with excessive variation 
	     EH_Analysis_S1_DTV_Ver1 dtv, 	-- dbms time violations
	     EH_Analysis_S1_ZQTV_Ver1 qtv,	-- zero query time violations
	     EH_Analysis_S1_QTV_Ver1 qtv,	-- query time violations
	     --EH_Analysis_S1_HTV_Ver1 htv,	-- high tick violations 
	     --EH_Analysis_S1_LTV_Ver1 ltv,	-- low tick violations
	     EH_Analysis_S1_NQPV_Ver1 nqpv,-- no query process violations
	     EH_Analysis_S1_OQPV_Ver1 oqpv,-- other query process violations
	     EH_Analysis_S1_OUPV_Ver1 oupv,-- other utility process violations
	     EH_Analysis_S1_TQE_Ver1 tqe,	-- total QEs
	     EH_Analysis_S1_TQC_Ver1 tqatc	-- total QatCs
	;

-- Step 2: Drop selected query Executions

-- Step 2-(i): drop query executions failing to pass sanity checks
-- EH_Analysis_S2_I_Ver1 : Exhaustive_Analysis_Step2_I_Ver1
DROP TABLE EH_Analysis_S2_I_Ver1;
CREATE TABLE EH_Analysis_S2_I_Ver1 AS -- Primary key is query execution id (queryexecutionid).
	SELECT t0.*
	FROM EH_Analysis_S1_VQE_Ver1 t0
	WHERE qeid NOT IN (SELECT qeid FROM EH_Analysis_S1_FQE_Ver1);
ALTER TABLE EH_Analysis_S2_I_Ver1 ADD PRIMARY KEY (qeid) DISABLE;
-- Count # of query executions per dbms at Step 2-(i)
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S2_I_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S2_I_Ver1
	GROUP BY dbms, experimentname;

-- Step 2-(ii): drop query executions having stopped & phantom processes
-- EH_Analysis_S2_II_Ver1 : Exhaustive_Analysis_Step2_II_Ver1
DROP TABLE EH_Analysis_S2_II_Ver1;
CREATE TABLE EH_Analysis_S2_II_Ver1 AS 	-- Primary key is a query execution: (qeid)
	SELECT  *
	FROM EH_Analysis_S2_I_Ver1 
	WHERE -- drop query executions below
	     (numphantomspresent = 0 AND stoppedprocesses=0);	
ALTER TABLE EH_Analysis_S2_II_Ver1 ADD PRIMARY KEY (qeid); 
-- Count # of query executions per dbms at Step 2-(ii)
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S2_II_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S2_II_Ver1
	GROUP BY dbms, experimentname;

-- Step 2-(iii) : drop some query executions where the IO Wait ticks are greater than 2 times median IO Wait on oracle/postgres
-- EH_Analysis_S2_III_Ver1 : Exhaustive_Analysis_Step2_III_Ver1
DROP VIEW EH_Analysis_S2_III_Ver1;
CREATE VIEW EH_Analysis_S2_III_Ver1 AS -- Primary key is a query execution: (qeid)
	SELECT t1.*
        FROM EH_Analysis_S2_II_Ver1 t1,
             (SELECT DISTINCT 	-- based on the median for the Q@C
			dbms,
			runid, 
  		        querynum, 
                        card, 
			MEDIAN(iowaitticks) as median_iowt
              FROM EH_Analysis_S2_II_Ver1 
	      WHERE dbms IN ('oracle', 'pgsql') -- oracle and postgres only
              GROUP BY dbms, runid, querynum, card) t2
        WHERE t1.dbms = t2.dbms AND
	      -- drop query executions where the IO Wait ticks are greater than 2 times median IO Wait on oracle/postgres
	      ((median_iowt>0 AND iowaitticks <= 2*median_iowt) OR (median_iowt=0 AND iowaitticks <= 2)) AND
              t1.runid = t2.runid AND
              t1.querynum=t2.querynum AND
              t1.card= t2.card
	UNION
	SELECT *
        FROM EH_Analysis_S2_II_Ver1 t1
	-- db2 and mysql only
        WHERE dbms IN ('db2', 'mysql2');
ALTER VIEW EH_Analysis_S2_III_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 
-- Count # of query executions per dbms at Step 2-(iii)
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S2_III_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S2_III_Ver1
	GROUP BY dbms, experimentname;

-- Step 2-(iv) : drop some query executions where the IO Wait ticks > 0 on db2 and IO Wait ticks > 1% of measured time on mysql
-- EH_Analysis_S2_IV_Ver1 : Exhaustive_Analysis_Step2_IV_Ver1
DROP VIEW EH_Analysis_S2_IV_Ver1;
CREATE VIEW EH_Analysis_S2_IV_Ver1 AS -- Primary key is a query execution: (qeid)
	SELECT *
	FROM EH_Analysis_S2_III_Ver1	
	MINUS
	SELECT *
        FROM EH_Analysis_S2_III_Ver1 t1
        WHERE -- drop query executions where IO Wait ticks > 0 on db2 and IO Wait ticks > 1% of measured time on mysql    
	     ((dbms = 'db2' AND iowaitticks > 0) OR (dbms = 'mysql2' AND iowaitticks*10 > CEIL(measured_time*0.01)));
ALTER VIEW EH_Analysis_S2_IV_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 
-- Count # of query executions per dbms at Step 2-(iv)
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S2_IV_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S2_IV_Ver1
	GROUP BY dbms, experimentname; 

-- Step 3: Drop selected Q@Cs 

-- Step 3-0: Count the current Q@Cs from remaining query executions
DROP TABLE EH_Analysis_S3_0_Ver1;
CREATE TABLE EH_Analysis_S3_0_Ver1 AS -- Primary key is a Now! Q@C: (runid, querynum, card)
	SELECT DISTINCT dbms, 
			experimentName,  
			runid, 
			querynum, 
			card 
	FROM EH_Analysis_S2_IV_Ver1 t1
        GROUP BY dbms, experimentName, runid, querynum, card;
ALTER TABLE EH_Analysis_S3_0_Ver1 ADD PRIMARY KEY (runid, querynum, card); 
-- Count # of Q@Cs per dbms at Step 3-0
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S3_0_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S3_0_Ver1
	GROUP BY dbms, experimentname;

-- Identify all DBMS processes with their total time at Q@C
-- EH_Analysis_CDP_Ver1 : Exhaustive_Analysis_Candidate_DBMS_QueryProcesses_Ver1 se
DROP TABLE EH_Analysis_CDP_Ver1;
CREATE TABLE EH_Analysis_CDP_Ver1 AS -- Primary key is a Q@C (DBMS) process: (runid, querynum, card, processid)
	 SELECT s.runid, 
		s.querynum, 
	        s.card, 
		qp.processid as querypid, 
       		SUM(qp.UTIME+qp.STIME) q_total_time
	 FROM EH_Analysis_S2_IV_Ver1 s,
	      AZDBLab_QueryExecutionProcs qp, 
 	      EH_Analysis_Qmd_Ver1 qmd 
	WHERE s.qeid = qp.queryexecutionid AND 
	      s.dbms = qmd.dbmsname AND		
	      qp.processname = qmd.qprocname 	-- ensure that the process should be dbms processes
	GROUP BY runid, querynum, card, qp.processid
	ORDER BY runid ASC, querynum ASC, card DESC, qp.processid ASC, q_total_time DESC;
ALTER TABLE EH_Analysis_CDP_Ver1 ADD PRIMARY KEY (runid, querynum, card, querypid); 

-- Identify a "QUERY" process at Q@C
-- EH_Analysis_QProc_QatC_Ver1 : Exhaustive_Analysis_Query_Process_QATC_Ver1 
DROP TABLE EH_Analysis_QProc_QatC_Ver1;
CREATE TABLE EH_Analysis_QProc_QatC_Ver1 AS  -- Primary key is a Q@C: (runid, querynum, card)
	SELECT DISTINCT t1.runid, 
			t1.querynum, 
			t1.card, 
			min(t1.querypid) as querypid -- not part of key 
	FROM EH_Analysis_CDP_Ver1 t1, 
	     (SELECT DISTINCT t3.runid, -- looking at a Q@C
		     t3.querynum, 
		     t3.card, 
		     MAX(t3.q_total_time) AS maxtime 
	      FROM EH_Analysis_CDP_Ver1 t3 
	      GROUP BY t3.runid, t3.querynum, t3.card) t2 
	WHERE t1.runid = t2.runid AND 
	      t1.querynum = t2.querynum AND 
	      t1.card = t2.card AND 
	      t1.q_total_time = t2.maxtime
	GROUP BY t1.runid, t1.querynum, t1.card;
ALTER TABLE EH_Analysis_QProc_QatC_Ver1 ADD PRIMARY KEY (runid, querynum, card);

-- Step 3-(i) : drop any Q@C for which the identified query process does not appear in every query execution for that Q@C 
-- EH_Analysis_S3_I_Ver1 : Exhaustive_Analysis_Step2_I_Ver1 
DROP TABLE EH_Analysis_S3_I_Ver1;
CREATE TABLE EH_Analysis_S3_I_Ver1 AS -- Primary key is a Now! Q@C: (runid, querynum, card)
	SELECT dbms,
	       experimentName,
	       runid,
	       querynum,
	       card, 	    
               AVG(measured_time) as average_measured_time, -- over query executions
	       COUNT(*) as num_executions
	FROM EH_Analysis_S2_IV_Ver1 
	-- drop Q@C if a query process does not appear in "EVERY" query execution
        WHERE (runid, querynum, card) NOT IN (
				 SELECT DISTINCT runid, querynum, card -- Q@Cs that has some query executions that do not have a query process
        	                 FROM (
				      SELECT t1.qeid, t1.runid, t1.querynum, t1.card  -- all query executions
				      FROM EH_Analysis_S2_IV_Ver1 t1
				      MINUS
				      SELECT t1.qeid, t1.runid, t1.querynum, t1.card  -- all query executions having the query process
			  	      FROM EH_Analysis_S2_IV_Ver1 t1, 
				           EH_Analysis_QProc_QatC_Ver1 t2,
				      	   AZDBLab_QueryExecutionProcs t3
				      WHERE t1.runid     = t2.runid
				        AND t1.querynum  = t2.querynum
				   	AND t1.card      = t2.card
				   	AND t1.qeid      = t3.queryexecutionid
				   	AND t3.processid = t2.querypid)
				)
        GROUP BY dbms, experimentName, runid, querynum, card;
ALTER TABLE EH_Analysis_S3_I_Ver1 ADD PRIMARY KEY (runid, querynum, card); 
-- Count # of Q@Cs per dbms at Step 3-(i)
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S3_I_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S3_I_Ver1
	GROUP BY dbms, experimentname;
      
-- Step 3-(ii): drop Q@Cs less than average of 20ms across remaining query executions 
-- EH_Analysis_S3_II_Ver1 : Exhaustive_Analysis_Step2_II_Ver1
DROP VIEW EH_Analysis_S3_II_Ver1;
CREATE VIEW EH_Analysis_S3_II_Ver1 AS  -- Primary key is a Q@C: (runid, querynum, card)
	SELECT *
	FROM EH_Analysis_S3_I_Ver1
	WHERE average_measured_time > 20;
ALTER VIEW EH_Analysis_S3_II_Ver1 ADD PRIMARY KEY (runid, querynum, card) DISABLE; 
-- Count # of Q@Cs per dbms at Step 3-(ii)
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S3_II_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S3_II_Ver1
	GROUP BY dbms, experimentname;

-- Step 3-(iii): drop Q@Cs less than 6 executions
-- EH_Analysis_S3_III_Ver1 : Exhaustive_Analysis_Step2_III_Ver1
DROP TABLE EH_Analysis_S3_III_Ver1;
CREATE TABLE EH_Analysis_S3_III_Ver1 AS -- Primary key is a Q@C: (runid, querynum, card)
	SELECT *
	FROM EH_Analysis_S3_II_Ver1
	WHERE num_executions >= 6;
ALTER TABLE EH_Analysis_S3_III_Ver1 ADD PRIMARY KEY (runid, querynum, card) DISABLE; 
-- Count # of Q@Cs per dbms at Step 3-(iii)
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S3_III_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S3_III_Ver1
	GROUP BY dbms, experimentname;

-- Step 4 : Calculate query time

-- Show process info per query execution/process
-- There should be at least one row in EH_Analysis_PI_Ver1 for every row in EH_Analysis_Step2_II that was not subsequently dropped
-- EH_Analysis_PI_Ver1 : Exhaustive_Analysis_PROCESS_Info_Ver1
DROP VIEW EH_Analysis_PI_Ver1;
CREATE VIEW EH_Analysis_PI_Ver1 AS	-- Primary key is a query execution process: (qeid, procid) 
	SELECT DISTINCT 
	       qe.version,		   -- labshelf version
	       qe.experimentid,  	   -- experiment id
	       qe.experimentname,          -- experiment name
	       qatc.runid,		   -- runid
	       qatc.querynum,	 	   -- query number
	       qatc.card as card, 	   -- cardinality
	       qe.planid, 	           -- plan id
	       qe.dbms,		  	   -- dbms
	       qe.measured_time,	   -- measured time
               qe.iowaitticks,		   -- iowaitticks
	       qe.irq,		   	   -- irq
	       qe.softirq,		   -- soft irq
	       qe.qeid, 		   -- query execution id
	       qe.qenum,		   -- query execution iteration number	
	       qp.processname as procname, -- process name
	       qp.ProcessID as procid, 	   -- process id
	       qp.UTime as uticks, 	   -- uticks (for 5.X)
	       qp.STime as sticks, 	   -- sticks (for 5.X)
	       qp.maj_flt as maj_flt 	   -- major faults
	FROM EH_Analysis_S3_III_Ver1 qatc, 
	     EH_Analysis_S2_IV_Ver1 qe,	   -- to get info on experiment, query, plan
	     AZDBLab_QueryExecutionProcs qp
	WHERE qatc.runid = qe.runid AND 
	      qatc.querynum = qe.querynum AND
	      qatc.card = qe.card AND
	      qe.qeid = qp.queryexecutionid;
ALTER VIEW EH_Analysis_PI_Ver1 ADD PRIMARY KEY (qeid, procid) DISABLE; 

-- Obtain query process information per query execution 
-- EH_Analysis_QPI_Ver1 : Exhaustive_Analysis_Query_Process_Info_Ver1
DROP VIEW EH_Analysis_QPI_Ver1;
CREATE VIEW EH_Analysis_QPI_Ver1 AS  --  Primary key is a query execution: (qeid) 
	SELECT qeid,   -- query execution id
	       uticks, -- uticks
	       sticks, -- sticks
	       maj_flt -- major faults
	FROM EH_Analysis_PI_Ver1 t1, 
	     EH_Analysis_QProc_QatC_Ver1 t2
 	WHERE t1.runid    = t2.runid 
          AND t1.querynum = t2.querynum
	  AND t1.card     = t2.card
	  AND t1.procid   = t2.querypid;
ALTER VIEW EH_Analysis_QPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain utility process information existing in a query execution 
-- Note : will not consider qeids that do not have an utility dbms process
-- EH_Analysis_EUPI_Ver1 : Exhaustive_Analysis_Existing_Utility_Process_Info_Ver1
DROP TABLE EH_Analysis_EUPI_Ver1;
CREATE TABLE EH_Analysis_EUPI_Ver1 AS --  Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
	       	        SUM(uticks) AS uticks,
	  	        SUM(sticks) AS sticks,
		        SUM(maj_flt) AS maj_flt
	FROM EH_Analysis_PI_Ver1 t1,
 	     EH_Analysis_Umd_Ver1 t2
 	WHERE (t1.procid NOT IN (SELECT DISTINCT querypid  -- not a query process
	 			 FROM EH_Analysis_QProc_QatC_Ver1
			         WHERE runid    = t1.runid AND
                                       querynum = t1.querynum AND
				       card     = t1.card)) 
	  AND t1.dbms     = t2.dbmsname			   
	  AND t1.procname = t2.uprocname		   -- a utility process
	GROUP BY qeid;
ALTER TABLE EH_Analysis_EUPI_Ver1 ADD PRIMARY KEY (qeid); 
		            
-- Obtain utility process information not existing in a query execution 
-- EH_Analysis_NUPI_Ver1 : Exhaustive_Analysis_Non_Existing_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_NUPI_Ver1;
CREATE VIEW EH_Analysis_NUPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM EH_Analysis_PI_Ver1 
	WHERE qeid NOT IN (SELECT qeid FROM EH_Analysis_EUPI_Ver1);
ALTER VIEW EH_Analysis_NUPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain overall utility dbms process information per query execution by taking union of EH_Analysis_EUPI_Ver1 and EH_Analysis_NUPI_Ver1
-- EH_Analysis_UPI_Ver1 : Exhaustive_Analysis_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_UPI_Ver1;
CREATE VIEW EH_Analysis_UPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT * FROM EH_Analysis_EUPI_Ver1
	UNION
	SELECT * FROM EH_Analysis_NUPI_Ver1;
ALTER VIEW EH_Analysis_UPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain daemon process information existing in a query execution 
-- Note : will not consider qeids that do not have an utility dbms process
-- EH_Analysis_EDPI_Ver1 : Exhaustive_Analysis_Existing_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_EDPI_Ver1;
CREATE VIEW EH_Analysis_EDPI_Ver1 AS --  Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
		       SUM(uticks) AS uticks, 
		       SUM(sticks) AS sticks, 
		       SUM(maj_flt) AS maj_flt 
	FROM EH_Analysis_PI_Ver1 
	WHERE procname NOT IN (SELECT qprocname 
			       FROM EH_Analysis_Qmd_Ver1 -- query process
			       UNION
			       SELECT uprocname
 			       FROM EH_Analysis_Umd_Ver1 -- utility process
			      ) 
        GROUP BY qeid;
ALTER VIEW EH_Analysis_EDPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 
		 
-- Obtain daemon process information not existing in a query execution 
-- EH_Analysis_NDPI_Ver1 : Exhaustive_Analysis_Non_Existing_Utility_Process_Info_Ver1
DROP VIEW EH_Analysis_NDPI_Ver1;
CREATE VIEW EH_Analysis_NDPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM EH_Analysis_PI_Ver1 
	WHERE qeid NOT IN (SELECT qeid FROM EH_Analysis_EDPI_Ver1);
ALTER VIEW EH_Analysis_NDPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtain overall daemon dbms process information per query execution by taking union of EH_Analysis_EDPI_Ver1 and EH_Analysis_NDPI_Ver1
-- Note : may have no daemon process
-- EH_Analysis_DPI_Ver1 : Exhaustive_Analysis_Daemon_Process_Info_Ver1
DROP VIEW EH_Analysis_DPI_Ver1;
CREATE VIEW EH_Analysis_DPI_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT * FROM EH_Analysis_EDPI_Ver1
	UNION
	SELECT * FROM EH_Analysis_NDPI_Ver1;
ALTER VIEW EH_Analysis_DPI_Ver1 ADD PRIMARY KEY (qeid) DISABLE; 

-- Obtains detailed process information of a query process, a utility process(es), and a daemon process(es) per query execution
-- EH_Analysis_QED_Ver1 : Exhaustive_Analysis_QueryExecution_Details_Ver1
DROP TABLE EH_Analysis_QED_Ver1;
CREATE TABLE EH_Analysis_QED_Ver1 AS -- Primary key is a query execution: (qeid) 
	SELECT DISTINCT
		proc.version,		-- labshelf version
                proc.experimentid,  	-- experiment id
	        proc.experimentname,    -- experiment name
		proc.planid, 	        -- plan id
		proc.dbms,		-- dbms
		proc.qeid, 		-- query execution id
		proc.runid, 		-- runid
		proc.querynum, 		-- querynum
		proc.card, 		-- card		
		proc.qenum, 		-- query execution number
		proc.measured_time, 	-- measured time
		proc.iowaitticks, 	-- iowaitticks
		proc.irq,		-- irq
		proc.softirq, 		-- softirq
		qproc.uticks AS qp_uticks,   -- query process uticks
		qproc.sticks AS qp_sticks,   -- query process sticks
		(qproc.uticks+qproc.sticks) AS queryTime,  -- query time (uticks+sticks)
		qproc.maj_flt AS qp_maj_flt, -- query process major faults
		util_proc.uticks AS up_uticks,	-- utility process uticks
		util_proc.sticks AS up_sticks,	-- utility process sticks
		util_proc.maj_flt AS up_maj_flt,-- utility process major faults
		dproc.uticks AS dp_uticks, 	-- daemon process uticks
		dproc.sticks AS dp_sticks, 	-- daemon process sticks
		dproc.maj_flt as dp_maj_flt,	-- daemon process major faults
		(qproc.uticks+util_proc.uticks+dproc.uticks) AS sum_proc_uticks,     -- sum of process uticks
		(qproc.sticks+util_proc.sticks+dproc.sticks) AS sum_proc_sticks,     -- sum of process sticks
		(qproc.maj_flt+util_proc.maj_flt+dproc.maj_flt) AS sum_proc_maj_flt  -- sum of process major faults
	FROM	EH_Analysis_PI_Ver1 proc,		-- process info
		EH_Analysis_QPI_Ver1 qproc, 	-- query process info
		EH_Analysis_UPI_Ver1 util_proc,	-- utility process info
		EH_Analysis_DPI_Ver1 dproc		-- daemon Process info
	WHERE 	proc.qeid  = qproc.qeid
	    AND qproc.qeid = util_proc.qeid
	    AND qproc.qeid = dproc.qeid
	ORDER BY proc.qeid ASC;
ALTER TABLE EH_Analysis_QED_Ver1 ADD PRIMARY KEY (qeid); 
-- Count # of query executions per dbms before Step 4
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_QED_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_QED_Ver1
	GROUP BY dbms, experimentname;

-- Compute query times
-- Ticks are to 2 decimal places. 
-- Times are to one decimal place. 
-- EH_Analysis_S4_CTQatC_VER1 : Exhaustive_Analysis_Step4_Calculated_Time_QatC_VER1
DROP TABLE EH_Analysis_S4_CTQatC_Ver1;
CREATE TABLE EH_Analysis_S4_CTQatC_Ver1 AS -- Primary key is a Q@C: (runid, querynum, card)
	SELECT  qed.version,		-- labshelf version
	        qed.experimentid,  	-- experiment id
	        qed.experimentname,     -- experiment name
		qed.dbms, 	        -- dbms
		qed.runid, 	        -- runid
		qed.querynum, 	        -- query number
		qed.card, 	        -- cardinality
		qed.planid, 	        -- plan id
		MIN(qed.measured_time) as min_meas_time, 	    -- minimum measured time
		MAX(qed.measured_time) as max_meas_time, 	    -- maximum measured time
		ROUND(AVG(qed.measured_time),1) as avg_meas_time,   -- average measured time
		ROUND(STDDEV(qed.measured_time),1) as std_meas_time,-- std dev of measured time
		ROUND(MEDIAN((qp_uticks+qp_sticks+Dmd.coef*qp_uticks)*10), 1) as med_cqt, -- median calculated time
		ROUND(STDDEV((qp_uticks+qp_sticks+Dmd.coef*qp_uticks)*10), 1) as std_cqt, -- std dev of calculated time
		ROUND(STDDEV((qp_uticks+qp_sticks+Dmd.coef*qp_uticks)*10)/MEDIAN((qp_uticks+qp_sticks+Dmd.coef*qp_uticks)*10), 1) as var_cqt, -- amount of variance in calculated time
		ROUND(MEDIAN(qp_uticks), 2) as med_qp_uticks, -- median  query process uticks
		MIN(qp_uticks) as min_qp_uticks,  	      -- minimum query process uticks
		MAX(qp_uticks) as max_qp_uticks,     	      -- maximum query process uticks
		ROUND(AVG(qp_uticks),2) as avg_qp_uticks,     -- average query process uticks
		ROUND(stddev(qp_uticks),2) as std_qp_uticks,  -- std dev of query process uticks
		MIN(up_maj_flt) as min_up_maj_flt,   	      -- minimum utility process major faults
		MAX(up_maj_flt) as max_up_maj_flt,   	      -- maximum utility process major faults  
		ROUND(AVG(up_maj_flt),2) as avg_up_maj_flt,   -- average utility process major faults  
		ROUND(stddev(up_maj_flt),2) as std_up_maj_flt,-- std dev of utility process major faults
		MIN(dp_maj_flt) as min_dp_maj_flt, 	      -- minimum daemon process major faults		
		MAX(dp_maj_flt) as max_dp_maj_flt, 	      -- maximum daemon process major faults
		ROUND(AVG(dp_maj_flt),2) as avg_dp_maj_flt,   -- average daemon process major faults  
		ROUND(stddev(dp_maj_flt),2) as std_dp_maj_flt,-- std dev of daemon process major faults  
		MIN(qed.iowaitticks) as min_iowait, 	      -- minimum io wait ticks
		MAX(qed.iowaitticks) as max_iowait, 	      -- maximum io wait ticks
		ROUND(AVG(qed.iowaitticks),2) as avg_iowait,    -- average io wait ticks
		ROUND(stddev(qed.iowaitticks),2) as std_iowait  -- std dev of io wait ticks
	FROM EH_Analysis_QED_Ver1 qed,   -- query execution details 		
	     EH_Analysis_Dmd_Ver1 Dmd    -- used dbmses
	WHERE qed.dbms   = Dmd.dbmsname
        GROUP BY qed.version, qed.experimentid, qed.experimentname, qed.dbms, qed.runid, qed.querynum, qed.card, qed.planid -- required by oracle; 	
ALTER TABLE EH_Analysis_S4_CTQatC_Ver1 ADD PRIMARY KEY (runid, querynum, card);
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S4_CTQatC_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S4_CTQatC_Ver1
	GROUP BY dbms, experimentname;
select sum(numQs) from (select runid, count(distinct querynum) as numQs from EH_Analysis_S4_CTQatC_Ver1 group by runid);
-- Step 5 : Post sanity check - Excessive query time variation and monotonicity violations

-- Counts Q@Cs revealing excessive variation in query time per DBMS per Experiment
-- EH_Analysis_S5_I_EQTV_PDE_Ver1 : Exhaustive_Analysis_Step5_Excessive_Query_Time_Variation_Per_DBMS_Per_Experiment_Ver1
DROP VIEW EH_Analysis_S5_I_EQTV_PDE_Ver1;
CREATE VIEW EH_Analysis_S5_I_EQTV_PDE_Ver1 AS -- Primary key is (dbms, exprName).
	SELECT dbms, 
	       experimentname,
	       count(t1.numExcVarPerRun) AS numExcVarPerDBMSPerExp
	FROM  (-- Q@Cs exposing excessive variations
		SELECT t0.dbms, 
		       t0.experimentname,
		       t0.runid, 
		       COALESCE(count(t0.card), 0) AS numExcVarPerRun
		FROM (SELECT dbms,
			     experimentname,
			     runid,
			     querynum,
			     card
		      FROM EH_Analysis_QED_Ver1 qed,
			   EH_Analysis_Dmd_Ver1 dmd
		      WHERE qed.dbms = dmd.dbmsname 
		      HAVING TRUNC(STDDEV(querytime+qp_uticks*dmd.coef), 0) > CEIL(0.2 * AVG(querytime+qp_uticks*dmd.coef))
		      GROUP BY dbms, experimentname, runid, querynum, card) t0
		GROUP BY dbms, experimentname, runid) t1
	GROUP BY dbms, experimentname;
ALTER VIEW EH_Analysis_S5_I_EQTV_PDE_Ver1 ADD PRIMARY KEY (dbms, experimentname) DISABLE; 
-- Insert a record into rowcount table
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S5_I_EQTV_PDE_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM EH_Analysis_S5_I_EQTV_PDE_Ver1
	GROUP BY dbms, experimentname;

-- Sum up all excessive variaions from all DBMSes
-- EH_Analysis_S5_I_EQTV_Ver1 : Exhaustive_Analysis_S5_I_Excessive_Query_Time_Variation_Ver1
DROP VIEW EH_Analysis_S5_I_EQTV_Ver1;
CREATE VIEW EH_Analysis_S5_I_EQTV_Ver1 AS -- Primary key is a labshelf, so one row!
	SELECT COALESCE(SUM(numExcVarPerDBMSPerExp), 0) AS excVarQatCs
	FROM EH_Analysis_S5_I_EQTV_PDE_Ver1;

-- Collect all Q@Cs having the same plan
-- EH_Analysis_SPQatC_Ver1 : Exhaustive_Analysis_Same_Plan_QatC_Ver1
DROP TABLE EH_Analysis_SPQatC_Ver1;
CREATE TABLE EH_Analysis_SPQatC_Ver1 AS
	SELECT p1.*, 
	       p2.card as card2, 
	       p2.med_cqt as med_cqt2,
	       p2.std_cqt as std_cqt2
	FROM EH_Analysis_S4_CTQatC_Ver1 p1, 		
	     EH_Analysis_S4_CTQatC_Ver1 p2 
	WHERE p1.runid    = p2.runid    AND 	-- same run
	      p1.querynum = p2.querynum AND 	-- same query
	      p1.planid   = p2.planid   AND 	-- same plan
	      p1.card < p2.card
	ORDER BY p1.runid, p1.querynum, p1.card, p2.card;
ALTER TABLE EH_Analysis_SPQatC_Ver1 ADD PRIMARY KEY (runid, querynum, card, card2); 
--SELECT count(*) from EH_Analysis_SPQatC_Ver1;

-- Tests monotonicity by the strict condition of using plain median calculated time
-- EH_Analysis_S5_II_TSM_Ver1 : Exhaustive_Analysis_S5_II_Test_Strict_Monotonicity
DROP TABLE EH_Analysis_S5_II_TSM_Ver1;
CREATE TABLE EH_Analysis_S5_II_TSM_Ver1 AS -- Primary key is a 2 related Q@Cs with the same plan (runid, querynum, card1, card2)
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM EH_Analysis_SPQatC_Ver1
	WHERE med_cqt > med_cqt2 -- applying strict condition 
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE EH_Analysis_S5_II_TSM_Ver1 ADD PRIMARY KEY (runid, querynum, card, card2); 
-- Count # of Q@Cs per dbms at this analysis
--delete from EH_Analysis_RowCount_Ver1 where stepName = 'EH_Analysis_S5_II_TSM_Ver1';
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S5_II_TSM_Ver1' as stepName,
	       COALESCE(count(*),0) as stepResultSize
	FROM EH_Analysis_S5_II_TSM_Ver1
	GROUP BY dbms, experimentname;
--select sum(stepResultSize) from EH_Analysis_RowCount_Ver1 where stepName = 'EH_Analysis_S5_II_TSM_Ver1'
-- Print out all query executions violating strict monotonicity 
-- EH_Analysis_S5_II_SMVP_Ver1 : Exhaustive_Analysis_S5_II_Strict_Monotonicity_Violation_Printout_Ver1
DROP TABLE EH_Analysis_S5_II_SMVP_Ver1;
CREATE TABLE EH_Analysis_S5_II_SMVP_Ver1 AS
	 SELECT *
	 FROM (
		SELECT t2.*
 	 	FROM EH_Analysis_S5_II_TSM_Ver1 t1,
	     	     EH_Analysis_QED_Ver1 t2
		WHERE t1.runid    = t2.runid AND
     	       	      t1.querynum = t2.querynum AND
	              t1.card     = t2.card -- lower cardinality
		UNION
		SELECT t2.*
		FROM EH_Analysis_S5_II_TSM_Ver1 t1,
              	     EH_Analysis_QED_Ver1 t2
		WHERE t1.runid    = t2.runid AND
               	      t1.querynum = t2.querynum AND
		      t1.card2    = t2.card  -- higher cardinality
	      ) t0 
         ORDER BY runid, card, querynum asc;
ALTER TABLE EH_Analysis_S5_II_SMVP_Ver1 ADD PRIMARY KEY (qeid); 

-- Tests monotonicity by the relaxed condition of using half std dev of calculated time
-- EH_Analysis_S5_II_Test_RM_Ver1 : Exhaustive_Analysis_S5_II_Test_Relaxed_Monotonicity
DROP TABLE EH_Analysis_S5_II_TRM_Ver1;
CREATE TABLE EH_Analysis_S5_II_TRM_Ver1 AS -- Primary key is a (runid, querynum, planid, different cardinalities)
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM EH_Analysis_SPQatC_Ver1
	WHERE med_cqt-0.5*std_cqt > med_cqt2+0.5*std_cqt2 -- applying relaxed condition
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE EH_Analysis_S5_II_TRM_Ver1 ADD PRIMARY KEY (runid, querynum, card, card2); 
--delete from EH_Analysis_RowCount_Ver1 where stepName = 'EH_Analysis_S5_II_TRM_Ver1';
INSERT INTO EH_Analysis_RowCount_Ver1 (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'EH_Analysis_S5_II_TRM_Ver1' as stepName,
	       COALESCE(COUNT(*), 0) as stepResultSize
	FROM EH_Analysis_S5_II_TRM_Ver1
	GROUP BY dbms, experimentname;

-- Print out all query executions violating relaxed monotonicity 
-- EH_Analysis_S5_II_RMVP_Ver1 : Exhaustive_Analysis_S5_II_Relaxed_Monotonicity_Violation_Printout_Ver1
DROP TABLE EH_Analysis_S5_II_RMVP_Ver1;
CREATE TABLE EH_Analysis_S5_II_RMVP_Ver1 AS
	 SELECT *
	 FROM (
		SELECT t2.*
 	 	FROM EH_Analysis_S5_II_TRM_Ver1 t1,
	     	     EH_Analysis_QED_Ver1 t2
		WHERE t1.runid    = t2.runid AND
     	       	      t1.querynum = t2.querynum AND
	              t1.card     = t2.card -- lower cardinality
		UNION
		SELECT t2.*
		FROM EH_Analysis_S5_II_TRM_Ver1 t1,
              	     EH_Analysis_QED_Ver1 t2
		WHERE t1.runid    = t2.runid AND
               	      t1.querynum = t2.querynum AND
		      t1.card2    = t2.card  -- higher cardinality
	      ) t0 
         ORDER BY runid, card, querynum asc;
ALTER TABLE EH_Analysis_S5_II_RMVP_Ver1 ADD PRIMARY KEY (qeid); 

-- View the total of the raw qatc
SELECT count(*) from EH_Analysis_ASPQatC_Ver1;
-- View the total of the qatc after protocol
SELECT count(*) from EH_Analysis_SPQatC_Ver1;

-- View Sanity Check results
SELECT * FROM EH_Analysis_S1_Ver1;

-- View rowcounts by dbms after each step
--SELECT * 
--FROM EH_Analysis_RowCount_Ver1 
--ORDER BY dbmsname, exprName, stepResultSize desc, stepName asc;

SELECT count(*) as queries -- queries 
FROM (SELECT distinct runid, querynum
     FROM EH_Analysis_S4_CTQatC_Ver1);

SELECT count(*) as queries -- queries 
FROM (SELECT distinct runid, querynum
     FROM EH_Analysis_S0_AQE_Ver1 );

SELECT runid, count(distinct querynum) as maxq
FROM EH_Analysis_ACTQatC_Ver1
group by runid 
order by runid

SELECT count(*) as qatcs -- qatcs 
FROM (SELECT distinct runid, querynum, card
      FROM EH_Analysis_S0_AQE_Ver1 
      group by runid, querynum, card)

SELECT count(qeid) as qes -- qes 
FROM (EH_Analysis_S0_AQE_Ver1);

SELECT sum(var_cqt)
FROM EH_Analysis_S4_CTQatC_Ver1;

-- total counts after each step
SELECT stepName, sum(stepResultSize) as stepResultSize 
FROM EH_Analysis_RowCount_Ver1 
GROUP BY stepName
ORDER BY stepResultSize desc, stepName asc;
