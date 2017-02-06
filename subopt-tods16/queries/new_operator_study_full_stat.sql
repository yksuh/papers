-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 05/31/16
-- Second Revision: 06/08/16
-- Final Revision: 11/21/16
-- Description: Define a suite of queries for DBMS operator study. 32 runs included in this study.

-- DBMSes used in our analysis
-- NSOOper_DMD: New_SubOpt_Oper_DBMS_Metadata
DROP TABLE NSOOper_Dmd CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_Dmd
(
	dbmsname	VARCHAR2(10) NULL PRIMARY KEY
);
INSERT INTO NSOOper_Dmd VALUES ('db2');
INSERT INTO NSOOper_Dmd VALUES ('oracle');
INSERT INTO NSOOper_Dmd VALUES ('pgsql');
INSERT INTO NSOOper_Dmd VALUES ('mysql');

-- Create a table for chosen labshelf (Get this from GUI)
DROP TABLE NSOOper_LabShelf CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_LabShelf AS
	SELECT '7.0' AS version, ---- version ---	
	'username' AS username, ---- username ---	
	'password' AS password, ---- password ---
	'connect_string' as connstr
	FROM Dual;
ALTER TABLE NSOOper_LabShelf ADD PRIMARY KEY (version);

DROP TABLE NSOOper_Runs CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_Runs AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	-- exploratory analysis
	WHERE runid IN (
		-- normal
		228,229,230,231, 246,247,248,412, 259,260,95,518, 261,262,286,616, 288,287,422,658, 
	  	596,289,440,716, 414,413,578,756, 416,556,636,776, 419,421,676,816, 436,437,681,857,
		-- no skew
		2018,2020,2019,2037,
		-- added runs for subquery
		2057,2058,2059,2060
	)	
	ORDER BY runid;
ALTER TABLE NSOOper_PK_Runs ADD PRIMARY KEY (runid);

-- Create a table for pk runs  (Get this from GUI)
DROP TABLE NSOOper_PK_Runs CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_PK_Runs AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	-- runs with primary keys
	WHERE runid IN (
		439,438,796,897,898,899, 959,958,960,957, -- pk only (normal)
		1117,1057,2337,1097, -- pk+idx (1059: pgsql's run incorrect)
		1737,1719,1657,1677, -- pk+subquery
		2097,2077,2098,2120, -- pk+idx+subquery
		-- added runs for pk+subquery+index 2
		2197,2237,2217,2257,
		-- pk only (#15)
		2318,2277,2317,2297
	) 	
	ORDER BY runid;
ALTER TABLE NSOOper_PK_Runs ADD PRIMARY KEY (runid);

-- Get all Q@Cs from the chosen labshelf 
-- NSOOper_S0_AQatC:  NSOOper_Step0_All_Query_at_Cardinalities
DROP TABLE NSOOper_AQatC CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_AQatC AS
	--- non PK runs
	SELECT  distinct
		c_labshelf.version,	    -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.cardinality AS card,  
		--qe.queryexecutionid AS qeid,
		qp.planid			-- for checking plans
	FROM  NSOOper_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      NSOOper_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	 WHERE ex.experimentid=er.experimentid AND 
	       er.runid=c_run.runid AND 
               c_run.runid=q.runid AND
	       q.queryid=qe.queryid AND qe.ITERNUM = 1 AND -- all QatCs
               qe.queryexecutionid=qp.queryexecutionid AND -- all QPs
	       er.currentstage  ='Completed' AND
               er.percentage = 100
	UNION
	--- PK runs
	SELECT  distinct
		c_labshelf.version,	   
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.cardinality AS card,
		--qe.queryexecutionid AS qeid,
		qp.planid			-- for checking plans
	FROM  NSOOper_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      NSOOper_PK_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	 WHERE ex.experimentid=er.experimentid AND 
	       er.runid=c_run.runid AND 
               c_run.runid=q.runid AND
	       --q.QUERYNUMBER < 100 AND	-- the first 100 queries only chosen
	       q.queryid=qe.queryid AND qe.ITERNUM = 1 AND -- all QatCs
               qe.queryexecutionid=qp.queryexecutionid AND -- all QPs
	       er.currentstage  ='Completed' AND
               er.percentage = 100;
ALTER TABLE NSOOper_AQatC ADD PRIMARY KEY (runid, querynum, card, planid);
-- select count(*) from NSOOper_AQatC
  COUNT(*)
----------
    112138

-- select count(distinct runid) from NSOOper_AQatC
COUNT(DISTINCTRUNID)
--------------------
		  78

--- Remove some problematic qatcs and set the retained to the initial
DROP TABLE NSOOper_S0_AQatC CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_S0_AQatC AS	
	SELECT t0.*
	FROM NSOOper_AQatC t0
	WHERE (dbms, runid, querynum) NOT IN 
		(select dbms, 
			runid,
			querynum 
		from 
			(SELECT  dbms,
				runid, 
				querynum,
				card
			FROM NSOOper_AQatC 
			HAVING count(planid) > 1
			GROUP BY dbms, runid, querynum, card))
	;
ALTER TABLE NSOOper_S0_AQatC ADD PRIMARY KEY (runid, querynum, card, planid);
-- select count(*) from NSOOper_S0_AQatC

  COUNT(*)
----------
     112132


select count(*)
from nsoexpl_s4_ctqatc 
where (
    (runid = 2060 and querynum = 7 and card = 30000) 
or  (runid = 2060 and querynum = 52 and card = 30000) 
or  (runid = 2120 and querynum = 17 and card = 30300) 
or  (runid = 2120 and querynum = 54 and card = 30300) 
or  (runid = 2120 and querynum = 61 and card = 30300) 
or  (runid = 2120 and querynum = 97 and card = 30300) 
or  (runid = 2257 and querynum = 3 and card = 30300)
or  (runid = 2257 and querynum = 31 and card = 30300) 
or  (runid = 2257 and querynum = 49 and card = 30300) 
or  (runid = 2257 and querynum = 49 and card = 30000) 
or  (runid = 2257 and querynum = 60 and card = 31200) 
or  (runid = 2257 and querynum = 79 and card = 30600) 
or  (runid = 2257 and querynum = 95 and card = 30300) 
or  (runid = 2257 and querynum = 98 and card = 30000) 
or  (runid = 2297 and querynum = 54 and card = 30600) 
)

--DROP TABLE NSOOper_S0_AQatC CASCADE CONSTRAINTS;
--CREATE TABLE NSOOper_S0_AQatC AS
--	SELECT  version,	   
--		experimentid,
--		experimentname,
--		dbms,
--		runid,
--		querynum,
--		card,
--		planid
--	FROM NSOExpl_ACTQatC -- Q@C data before protocool
--ALTER TABLE NSOOper_S0_AQatC ADD PRIMARY KEY (runid, querynum, card, planid);

-- Store the number of rows (step size) in a major step table/view
-- NSOOper_RowCount:  NSOOper_Row_Count
DROP TABLE NSOOper_RowCount CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_RowCount
(
	dbmsName	VARCHAR2(10),
	exprName	VARCHAR2(50),
	stepName	VARCHAR2(50),
	stepResultSize	NUMBER (10, 2),
        PRIMARY KEY (dbmsName, exprName, stepName) 
);

-- Record the result size of NSOOper_Step0_AQatC
DELETE FROM NSOOper_RowCount where stepname ='NSOOper_S0_AQatC';
INSERT INTO NSOOper_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'NSOOper_S0_AQatC' as stepName,
	       count(*) as stepResultSize
	FROM NSOOper_S0_AQatC
	GROUP BY dbms, experimentname;

-- Q@C statistics
-- Compute the total number of Q@Cs by dbms, experiment, run, query 
-- NSOOper_S0_QatC_Per_Query: NSOOper_Step0_QatC_Per_Query
DROP VIEW NSOOper_S0_QatC_Per_Query CASCADE CONSTRAINTS;
CREATE VIEW NSOOper_S0_QatC_Per_Query AS
	SELECT dbms, 
	       experimentName, 
	       runid,
	       querynum,
               count(*) as numCards
	FROM (SELECT 
			distinct 
			dbms, 
			experimentName, 
			runid, 
			querynum, 
			card 
		FROM NSOOper_S0_AQatC) 
	GROUP by dbms, experimentName, runid, querynum;	
ALTER VIEW NSOOper_S0_QatC_Per_Query ADD PRIMARY KEY (dbms,experimentName,runid, querynum) DISABLE;
-- select * from NSOOper_S0_QatC_Per_Query 
-- select count(*) from NSOOper_S0_QatC_Per_Query 
-- select sum(numCards) from NSOOper_S0_QatC_Per_Query 
SUM(NUMCARDS)
-------------
	54418
-- select  dbms, experimentname as expName, runid, count(querynum) as nq from NSOOper_S0_QatC_Per_Query group by dbms, experimentname, runid
-- Record the result size of NSOOper_Step0_QatC_Per_Query
DELETE FROM NSOOper_RowCount WHERE stepname = 'NSOOper_S0_QatC_Per_Query';
INSERT INTO NSOOper_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'NSOOper_S0_QatC_Per_Query' as stepName,
	       sum(numCards) as stepResultSize
	FROM NSOOper_S0_QatC_Per_Query
	GROUP BY dbms, experimentname;

-- Compute the total number of Q@Cs by dbms, experiment, run
-- NSOOper_S0_QatC_Per_Run: NSOOper_Step0_QatC_Per_Run
DROP VIEW NSOOper_S0_QatC_Per_Run CASCADE CONSTRAINTS;
CREATE VIEW NSOOper_S0_QatC_Per_Run AS
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
		FROM NSOOper_S0_AQatC) 
	GROUP by dbms, experimentName, runid;	
ALTER VIEW NSOOper_S0_QatC_Per_Run ADD PRIMARY KEY (dbms,experimentName,runid) DISABLE;
-- select * from NSOOper_S0_QatC_Per_Run 
-- Record the result size of NSOOper_S0_QatC_Per_Run
DELETE FROM NSOOper_RowCount WHERE stepname = 'NSOOper_S0_QatC_Per_Run';
INSERT INTO NSOOper_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'NSOOper_S0_QatC_Per_Run' as stepName,
	       numQatCs as stepResultSize
	FROM NSOOper_S0_QatC_Per_Run;

-- Roll up the number of Q@Cs by dbms
-- NSOOper_S0_DTQatC: NSOOper_Step0_DBMS_Total_QatC
DROP VIEW NSOOper_S0_DTQatC CASCADE CONSTRAINTS;
CREATE VIEW NSOOper_S0_DTQatC AS
	SELECT dbms,
	       sum(numQatCs) AS totalQatCs
	FROM NSOOper_S0_QatC_Per_Run
	GROUP BY dbms;
ALTER VIEW NSOOper_S0_DTQatC ADD PRIMARY KEY (dbms) DISABLE;
--select * from NSOOper_S0_DTQatC order by dbms

-- Compute the total number of Q@Cs across DBMSes
-- NSOOper_S0_TQatC: NSOOper_Step0_Total_QatC
DROP VIEW NSOOper_S0_TQatC CASCADE CONSTRAINTS;
CREATE VIEW NSOOper_S0_TQatC AS
	SELECT sum(totalQatCs) AS totalQatCs
	FROM NSOOper_S0_DTQatC;
-- select * from NSOOper_S0_TQatC;
--TOTALQATCS
----------
     54418

-- Query statistics
-- Compute the total number of queries by dbms, experiment, run
DROP VIEW NSOOper_S0_Q CASCADE CONSTRAINTS;
CREATE VIEW NSOOper_S0_Q AS
	SELECT qatc.dbms,
	       qatc.experimentName,
	       qatc.runid,
	       count(distinct qatc.querynum) as numQs
	FROM NSOOper_S0_AQatC qatc
	GROUP BY (qatc.dbms, qatc.experimentName,qatc.runid);
ALTER VIEW NSOOper_S0_Q ADD PRIMARY KEY (runid) DISABLE;

-- Record the result size of NSOOper_S0_Q
DELETE FROM NSOOper_RowCount where stepname ='NSOOper_S0_Q';
INSERT INTO NSOOper_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'NSOOper_S0_Q' as stepName,
	       SUM(numQs) as stepResultSize
	FROM NSOOper_S0_Q
	GROUP BY dbms, experimentname;

-- Roll up the number of queries by dbms
-- NSOOper_S0_DTQ: NSOOper_Step0_DBMS_Total_Query
DROP VIEW NSOOper_S0_DTQ CASCADE CONSTRAINTS;
CREATE VIEW NSOOper_S0_DTQ AS
	SELECT dbms,
	       sum(numQs) AS totalQs
	FROM NSOOper_S0_Q 
	GROUP BY dbms;
ALTER VIEW NSOOper_S0_DTQ ADD PRIMARY KEY (dbms) DISABLE;

-- Compute the total number of queries across DBMSes
-- NSOOper_S0_TQ: NSOOper_S0_Total_Query
DROP VIEW NSOOper_S0_TQ CASCADE CONSTRAINTS;
CREATE VIEW NSOOper_S0_TQ AS
	SELECT sum(totalQs) AS totalQs
	FROM NSOOper_S0_DTQ;
--   TOTALQS
----------
--      3986

-- Get all operators captured at all Q@Cs by DBMS
-- NSOOper_S0_AQatC_Plan:  NSOOper_Step0_All_Query_at_Cardinalities_Plan
DROP TABLE NSOOper_S0_AQatC_Plan CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_S0_AQatC_Plan AS
	SELECT  qatc.dbms,
		qatc.runid,
		qatc.querynum,
		qatc.card,  
		qatc.planid,
		po.PLANOPERATORID as opid,	
		po.OPERATORNAME as opname		
	FROM  NSOOper_S0_AQatC qatc, 
	      AZDBLab_PlanOperator po
	WHERE qatc.planid = po.planid
	and qatc.dbms <> 'pgsql'
	UNION
	SELECT  qatc.dbms,
		qatc.runid,
		qatc.querynum,
		qatc.card,  
		qatc.planid,
		po.PLANOPERATORID as opid,	
		case 
			when po.OPERATORNAME like '%Index Scan%' then REGEXP_REPLACE(po.OPERATORNAME, 'Index Scan(.*)', 'Index Scan') 
			when po.OPERATORNAME like '%Index Only Scan%' then REGEXP_REPLACE(po.OPERATORNAME, 'Index Only Scan(.*)', 'Index Only Scan') 
			else po.OPERATORNAME
		end as opname 	
	FROM  NSOOper_S0_AQatC qatc, 
	      AZDBLab_PlanOperator po
	WHERE qatc.planid = po.planid
	and qatc.dbms = 'pgsql'
	;
ALTER TABLE NSOOper_S0_AQatC_Plan ADD PRIMARY KEY (runid, querynum, card, planid,opid);
-- select * from NSOOper_S0_AQatC_Plan where runid = 2098 and querynum = 17 and card = 410000 order by qeid
-- select * from NSOOper_S0_AQatC_Plan where runid = 2098 and querynum = 19 and card = 40000 order by qeid

-- Compute the per-run stat for used query operators
-- NSOOper_S0_Stat_Per_Run: Subopt_Operator_Step0_Stats_Per_Run
DROP TABLE NSOOper_S0_Stat_Per_Run CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_S0_Stat_Per_Run AS
	SELECT  dbms,
		runid,
		opname, 
		count(*) as numUsed	
	FROM  NSOOper_S0_AQatC_Plan
	GROUP BY dbms, runid, opname;
	--ORDER BY t0.dbms, t0.runid, t0.numUsed desc
ALTER TABLE NSOOper_S0_Stat_Per_Run ADD PRIMARY KEY (dbms, runid, opname);

-- Compute the total stat for used query operators
-- NSOOper_S0_Stat: Subopt_Operator_Step0_Statistics
DROP TABLE NSOOper_S0_Stat CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_S0_Stat AS
	SELECT dbms,
	       opname, 
	       sum(numUsed) as totalUsed
	FROM NSOOper_S0_Stat_Per_Run t0
	GROUP BY t0.dbms, opname
	ORDER BY t0.dbms, sum(numUsed) desc, opname;
ALTER TABLE NSOOper_S0_Stat ADD PRIMARY KEY (dbms, opname);
--select * from NSOOper_S0_Stat where dbms = 'db2' order by totalUsed

-- Get each operator per DBMS
-- NSOOper_S0_DBMS_Op: Subopt_Operator_Step0_DBMS_Operators
DROP TABLE NSOOper_S0_DBMS_Op  CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_S0_DBMS_Op AS
	SELECT  dbms,
		opname
	FROM NSOOper_S0_Stat
	ORDER BY dbms, opname;
ALTER TABLE NSOOper_S0_DBMS_Op ADD PRIMARY KEY (dbms, opname);

-- Get an operator per Q@C per DBMS
-- NSOOper_S1_QatC_Op: Subopt_Operator_Step1_DBMS_Operators
DROP TABLE NSOOper_S1_QatC_Op CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_S1_QatC_Op AS
	SELECT  distinct 
		dbms,
		runid,
		querynum,
		card,
		opname
	FROM NSOOper_S0_AQatC_Plan
	ORDER BY dbms, runid, querynum, card, opname;
ALTER TABLE NSOOper_S1_QatC_Op ADD PRIMARY KEY (runid, querynum, card, opname);	 

-- Figure out generation per DBMS
column dbms format a10;
column dbms opname a50;
-- 1 operator:
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card 
HAVING COUNT(*)=1)
SELECT o1.dbms, a1.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
GROUP BY o1.dbms, a1.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 2 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=2)
SELECT o1.dbms, a1.opname||', '||a2.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 3 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=3)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 4 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=4)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 5 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op 
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=5)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 6 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=6)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, NSOOper_S1_QatC_Op a6
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 7 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=7)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, NSOOper_S1_QatC_Op a6, NSOOper_S1_QatC_Op a7
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
AND a1.dbms = a7.dbms
AND a1.runid = a7.runid
AND a1.querynum = a7.querynum
AND a1.card = a7.card
AND a1.opname>a7.opname 
AND a2.opname>a7.opname 
AND a3.opname>a7.opname 
AND a4.opname>a7.opname 
AND a5.opname>a7.opname 
AND a6.opname>a7.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 8 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=8)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname AS operatorName, o1.noOperators, COUNT(*) numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, NSOOper_S1_QatC_Op a6, NSOOper_S1_QatC_Op a7, NSOOper_S1_QatC_Op a8
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
AND a1.dbms = a7.dbms
AND a1.runid = a7.runid
AND a1.querynum = a7.querynum
AND a1.card = a7.card
AND a1.opname>a7.opname 
AND a2.opname>a7.opname 
AND a3.opname>a7.opname 
AND a4.opname>a7.opname 
AND a5.opname>a7.opname 
AND a6.opname>a7.opname 
AND a1.dbms = a8.dbms
AND a1.runid = a8.runid
AND a1.querynum = a8.querynum
AND a1.card = a8.card
AND a1.opname>a8.opname 
AND a2.opname>a8.opname 
AND a3.opname>a8.opname 
AND a4.opname>a8.opname 
AND a5.opname>a8.opname 
AND a6.opname>a8.opname 
AND a7.opname>a8.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

-- 9 operators
WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=9)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname AS operatorName, o1.noOperators, COUNT(*) numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, NSOOper_S1_QatC_Op a6, NSOOper_S1_QatC_Op a7, NSOOper_S1_QatC_Op a8, NSOOper_S1_QatC_Op a9
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
AND a1.dbms = a7.dbms
AND a1.runid = a7.runid
AND a1.querynum = a7.querynum
AND a1.card = a7.card
AND a1.opname>a7.opname 
AND a2.opname>a7.opname 
AND a3.opname>a7.opname 
AND a4.opname>a7.opname 
AND a5.opname>a7.opname 
AND a6.opname>a7.opname 
AND a1.dbms = a8.dbms
AND a1.runid = a8.runid
AND a1.querynum = a8.querynum
AND a1.card = a8.card
AND a1.opname>a8.opname 
AND a2.opname>a8.opname 
AND a3.opname>a8.opname 
AND a4.opname>a8.opname 
AND a5.opname>a8.opname 
AND a6.opname>a8.opname 
AND a7.opname>a8.opname 
AND a1.dbms = a9.dbms
AND a1.runid = a9.runid
AND a1.querynum = a9.querynum
AND a1.card = a9.card
AND a1.opname>a9.opname 
AND a2.opname>a9.opname 
AND a3.opname>a9.opname 
AND a4.opname>a9.opname 
AND a5.opname>a9.opname 
AND a6.opname>a9.opname 
AND a7.opname>a9.opname 
AND a8.opname>a9.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname, o1.noOperators 
order by o1.dbms, numQatCs desc;

WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=10)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, 
NSOOper_S1_QatC_Op a6, NSOOper_S1_QatC_Op a7, NSOOper_S1_QatC_Op a8, NSOOper_S1_QatC_Op a9, NSOOper_S1_QatC_Op a10
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
AND a1.dbms = a7.dbms
AND a1.runid = a7.runid
AND a1.querynum = a7.querynum
AND a1.card = a7.card
AND a1.opname>a7.opname 
AND a2.opname>a7.opname 
AND a3.opname>a7.opname 
AND a4.opname>a7.opname 
AND a5.opname>a7.opname 
AND a6.opname>a7.opname 
AND a1.dbms = a8.dbms
AND a1.runid = a8.runid
AND a1.querynum = a8.querynum
AND a1.card = a8.card
AND a1.opname>a8.opname 
AND a2.opname>a8.opname 
AND a3.opname>a8.opname 
AND a4.opname>a8.opname 
AND a5.opname>a8.opname 
AND a6.opname>a8.opname 
AND a7.opname>a8.opname 
AND a1.dbms = a9.dbms
AND a1.runid = a9.runid
AND a1.querynum = a9.querynum
AND a1.card = a9.card
AND a1.opname>a9.opname 
AND a2.opname>a9.opname 
AND a3.opname>a9.opname 
AND a4.opname>a9.opname 
AND a5.opname>a9.opname 
AND a6.opname>a9.opname 
AND a7.opname>a9.opname 
AND a8.opname>a9.opname 
AND a1.dbms = a10.dbms
AND a1.runid = a10.runid
AND a1.querynum = a10.querynum
AND a1.card = a10.card
AND a1.opname>a10.opname 
AND a2.opname>a10.opname 
AND a3.opname>a10.opname 
AND a4.opname>a10.opname 
AND a5.opname>a10.opname 
AND a6.opname>a10.opname 
AND a7.opname>a10.opname 
AND a8.opname>a10.opname 
AND a9.opname>a10.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname, o1.noOperators
order by o1.dbms, numQatCs desc

WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=11)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname||', '||a11.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, 
NSOOper_S1_QatC_Op a6, NSOOper_S1_QatC_Op a7, NSOOper_S1_QatC_Op a8, NSOOper_S1_QatC_Op a9, NSOOper_S1_QatC_Op a10, NSOOper_S1_QatC_Op a11
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
AND a1.dbms = a7.dbms
AND a1.runid = a7.runid
AND a1.querynum = a7.querynum
AND a1.card = a7.card
AND a1.opname>a7.opname 
AND a2.opname>a7.opname 
AND a3.opname>a7.opname 
AND a4.opname>a7.opname 
AND a5.opname>a7.opname 
AND a6.opname>a7.opname 
AND a1.dbms = a8.dbms
AND a1.runid = a8.runid
AND a1.querynum = a8.querynum
AND a1.card = a8.card
AND a1.opname>a8.opname 
AND a2.opname>a8.opname 
AND a3.opname>a8.opname 
AND a4.opname>a8.opname 
AND a5.opname>a8.opname 
AND a6.opname>a8.opname 
AND a7.opname>a8.opname 
AND a1.dbms = a9.dbms
AND a1.runid = a9.runid
AND a1.querynum = a9.querynum
AND a1.card = a9.card
AND a1.opname>a9.opname 
AND a2.opname>a9.opname 
AND a3.opname>a9.opname 
AND a4.opname>a9.opname 
AND a5.opname>a9.opname 
AND a6.opname>a9.opname 
AND a7.opname>a9.opname 
AND a8.opname>a9.opname 
AND a1.dbms = a10.dbms
AND a1.runid = a10.runid
AND a1.querynum = a10.querynum
AND a1.card = a10.card
AND a1.opname>a10.opname 
AND a2.opname>a10.opname 
AND a3.opname>a10.opname 
AND a4.opname>a10.opname 
AND a5.opname>a10.opname 
AND a6.opname>a10.opname 
AND a7.opname>a10.opname 
AND a8.opname>a10.opname 
AND a9.opname>a10.opname 
AND a1.dbms = a11.dbms
AND a1.runid = a11.runid
AND a1.querynum = a11.querynum
AND a1.card = a11.card
AND a1.opname>a11.opname 
AND a2.opname>a11.opname 
AND a3.opname>a11.opname 
AND a4.opname>a11.opname 
AND a5.opname>a11.opname 
AND a6.opname>a11.opname 
AND a7.opname>a11.opname 
AND a8.opname>a11.opname 
AND a9.opname>a11.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname||', '||a11.opname, o1.noOperators
order by o1.dbms, numQatCs desc

WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=12)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname||', '||a11.opname||', '||a12.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, 
NSOOper_S1_QatC_Op a6, NSOOper_S1_QatC_Op a7, NSOOper_S1_QatC_Op a8, NSOOper_S1_QatC_Op a9, NSOOper_S1_QatC_Op a10, NSOOper_S1_QatC_Op a11, NSOOper_S1_QatC_Op a12
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
AND a1.dbms = a7.dbms
AND a1.runid = a7.runid
AND a1.querynum = a7.querynum
AND a1.card = a7.card
AND a1.opname>a7.opname 
AND a2.opname>a7.opname 
AND a3.opname>a7.opname 
AND a4.opname>a7.opname 
AND a5.opname>a7.opname 
AND a6.opname>a7.opname 
AND a1.dbms = a8.dbms
AND a1.runid = a8.runid
AND a1.querynum = a8.querynum
AND a1.card = a8.card
AND a1.opname>a8.opname 
AND a2.opname>a8.opname 
AND a3.opname>a8.opname 
AND a4.opname>a8.opname 
AND a5.opname>a8.opname 
AND a6.opname>a8.opname 
AND a7.opname>a8.opname 
AND a1.dbms = a9.dbms
AND a1.runid = a9.runid
AND a1.querynum = a9.querynum
AND a1.card = a9.card
AND a1.opname>a9.opname 
AND a2.opname>a9.opname 
AND a3.opname>a9.opname 
AND a4.opname>a9.opname 
AND a5.opname>a9.opname 
AND a6.opname>a9.opname 
AND a7.opname>a9.opname 
AND a8.opname>a9.opname 
AND a1.dbms = a10.dbms
AND a1.runid = a10.runid
AND a1.querynum = a10.querynum
AND a1.card = a10.card
AND a1.opname>a10.opname 
AND a2.opname>a10.opname 
AND a3.opname>a10.opname 
AND a4.opname>a10.opname 
AND a5.opname>a10.opname 
AND a6.opname>a10.opname 
AND a7.opname>a10.opname 
AND a8.opname>a10.opname 
AND a9.opname>a10.opname 
AND a1.dbms = a11.dbms
AND a1.runid = a11.runid
AND a1.querynum = a11.querynum
AND a1.card = a11.card
AND a1.opname>a11.opname 
AND a2.opname>a11.opname 
AND a3.opname>a11.opname 
AND a4.opname>a11.opname 
AND a5.opname>a11.opname 
AND a6.opname>a11.opname 
AND a7.opname>a11.opname 
AND a8.opname>a11.opname 
AND a9.opname>a11.opname 
AND a1.dbms = a12.dbms
AND a1.runid = a12.runid
AND a1.querynum = a12.querynum
AND a1.card = a12.card
AND a1.opname>a12.opname 
AND a2.opname>a12.opname 
AND a3.opname>a12.opname 
AND a4.opname>a12.opname 
AND a5.opname>a12.opname 
AND a6.opname>a12.opname 
AND a7.opname>a12.opname 
AND a8.opname>a12.opname 
AND a9.opname>a12.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname||', '||a11.opname||', '||a12.opname, o1.noOperators
order by o1.dbms, numQatCs desc

WITH operatorCard AS 
(SELECT dbms, runid, querynum, card, COUNT(*) AS noOperators
FROM NSOOper_S1_QatC_Op
GROUP BY dbms, runid, querynum, card
HAVING COUNT(*)=12)
SELECT o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname||', '||a11.opname||', '||a12.opname||', '||a13.opname AS operatorName, o1.noOperators, COUNT(*) as numQatCs
FROM operatorCard o1, NSOOper_S1_QatC_Op a1, NSOOper_S1_QatC_Op a2, NSOOper_S1_QatC_Op a3, NSOOper_S1_QatC_Op a4, NSOOper_S1_QatC_Op a5, 
NSOOper_S1_QatC_Op a6, NSOOper_S1_QatC_Op a7, NSOOper_S1_QatC_Op a8, NSOOper_S1_QatC_Op a9, NSOOper_S1_QatC_Op a10, NSOOper_S1_QatC_Op a11, NSOOper_S1_QatC_Op a12, NSOOper_S1_QatC_Op a13
WHERE a1.dbms = o1.dbms
AND a1.runid = o1.runid
AND a1.querynum = o1.querynum
AND a1.card = o1.card 
AND a1.dbms = a2.dbms
AND a1.runid = a2.runid
AND a1.querynum = a2.querynum
AND a1.card = a2.card
AND a1.opname>a2.opname 
AND a1.dbms = a3.dbms
AND a1.runid = a3.runid
AND a1.querynum = a3.querynum
AND a1.card = a3.card
AND a1.opname>a3.opname 
AND a2.opname>a3.opname 
AND a1.dbms = a4.dbms
AND a1.runid = a4.runid
AND a1.querynum = a4.querynum
AND a1.card = a4.card
AND a1.opname>a4.opname 
AND a2.opname>a4.opname 
AND a3.opname>a4.opname 
AND a1.dbms = a5.dbms
AND a1.runid = a5.runid
AND a1.querynum = a5.querynum
AND a1.card = a5.card
AND a1.opname>a5.opname 
AND a2.opname>a5.opname 
AND a3.opname>a5.opname 
AND a4.opname>a5.opname 
AND a1.dbms = a6.dbms
AND a1.runid = a6.runid
AND a1.querynum = a6.querynum
AND a1.card = a6.card
AND a1.opname>a6.opname 
AND a2.opname>a6.opname 
AND a3.opname>a6.opname 
AND a4.opname>a6.opname 
AND a5.opname>a6.opname 
AND a1.dbms = a7.dbms
AND a1.runid = a7.runid
AND a1.querynum = a7.querynum
AND a1.card = a7.card
AND a1.opname>a7.opname 
AND a2.opname>a7.opname 
AND a3.opname>a7.opname 
AND a4.opname>a7.opname 
AND a5.opname>a7.opname 
AND a6.opname>a7.opname 
AND a1.dbms = a8.dbms
AND a1.runid = a8.runid
AND a1.querynum = a8.querynum
AND a1.card = a8.card
AND a1.opname>a8.opname 
AND a2.opname>a8.opname 
AND a3.opname>a8.opname 
AND a4.opname>a8.opname 
AND a5.opname>a8.opname 
AND a6.opname>a8.opname 
AND a7.opname>a8.opname 
AND a1.dbms = a9.dbms
AND a1.runid = a9.runid
AND a1.querynum = a9.querynum
AND a1.card = a9.card
AND a1.opname>a9.opname 
AND a2.opname>a9.opname 
AND a3.opname>a9.opname 
AND a4.opname>a9.opname 
AND a5.opname>a9.opname 
AND a6.opname>a9.opname 
AND a7.opname>a9.opname 
AND a8.opname>a9.opname 
AND a1.dbms = a10.dbms
AND a1.runid = a10.runid
AND a1.querynum = a10.querynum
AND a1.card = a10.card
AND a1.opname>a10.opname 
AND a2.opname>a10.opname 
AND a3.opname>a10.opname 
AND a4.opname>a10.opname 
AND a5.opname>a10.opname 
AND a6.opname>a10.opname 
AND a7.opname>a10.opname 
AND a8.opname>a10.opname 
AND a9.opname>a10.opname 
AND a1.dbms = a11.dbms
AND a1.runid = a11.runid
AND a1.querynum = a11.querynum
AND a1.card = a11.card
AND a1.opname>a11.opname 
AND a2.opname>a11.opname 
AND a3.opname>a11.opname 
AND a4.opname>a11.opname 
AND a5.opname>a11.opname 
AND a6.opname>a11.opname 
AND a7.opname>a11.opname 
AND a8.opname>a11.opname 
AND a9.opname>a11.opname 
AND a1.dbms = a12.dbms
AND a1.runid = a12.runid
AND a1.querynum = a12.querynum
AND a1.card = a12.card
AND a1.opname>a12.opname 
AND a2.opname>a12.opname 
AND a3.opname>a12.opname 
AND a4.opname>a12.opname 
AND a5.opname>a12.opname 
AND a6.opname>a12.opname 
AND a7.opname>a12.opname 
AND a8.opname>a12.opname 
AND a9.opname>a12.opname 
AND a1.dbms = a13.dbms
AND a1.runid = a13.runid
AND a1.querynum = a13.querynum
AND a1.card = a13.card
AND a1.opname>a13.opname 
AND a2.opname>a13.opname 
AND a3.opname>a13.opname 
AND a4.opname>a13.opname 
AND a5.opname>a13.opname 
AND a6.opname>a13.opname 
AND a7.opname>a13.opname 
AND a8.opname>a13.opname 
AND a9.opname>a13.opname 
GROUP BY o1.dbms, a1.opname||', '||a2.opname||', '||a3.opname||', '||a4.opname||', '||a5.opname||', '||a6.opname||', '||a7.opname||', '||a8.opname||', '||a9.opname||', '||a10.opname||', '||a11.opname||', '||a12.opname||', '||a13.opname, o1.noOperators
order by o1.dbms, numQatCs desc;

--- DBMS operator generation
DROP TABLE NSO_DBMS_Op_Gen CASCADE CONSTRAINTS;
CREATE TABLE NSO_DBMS_Op_Gen
(
	dbmsName	VARCHAR2(10) NULL,
	genNum	NUMBER NULL,
	genTxt	VARCHAR2(1000) NULL
);
ALTER TABLE NSO_DBMS_Op_Gen ADD PRIMARY KEY (dbmsName, genNum);	
-- for oracle 
INSERT INTO NSO_DBMS_Op_Gen VALUES ('oracle', 1, 'SELECT STATEMENT');
-- HJOIN: hash join
INSERT INTO NSO_DBMS_Op_Gen VALUES ('oracle', 2, 'HJOIN'); 
INSERT INTO NSO_DBMS_Op_Gen VALUES ('oracle', 3, 'HASH');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('oracle', 4, 'SORT');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('oracle', 5, 'VIEW');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('oracle', 6, 'MERGE JOIN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('oracle', 7, 'NESTED LOOPS');
-- for mysql 
INSERT INTO NSO_DBMS_Op_Gen VALUES ('mysql', 1, 'ALL:Full Table Scan');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('mysql', 2, 'AJOIN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('mysql', 3, 'eq_ref');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('mysql', 4, 'ref');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('mysql', 5, 'index');

-- for pgsql 
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 1, 'Seq Scan');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 2, 'Hash');
-- HJoin: Hash Join
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 3, 'HJoin');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 4, 'Hash Semi Join');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 5, 'Sort');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 6, 'Merge Join');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 7, 'Index Scan');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 8, 'Index Only Scan');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 9, 'Hash Aggregate');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 10, 'Nested Loop');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 11, 'Merge Semi Join');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('pgsql', 12, 'Nested Loop Semi Join');

-- for db2
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 1, 'TBSCAN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 2, 'RETURN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 3, 'HSJOIN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 4, 'GRPBY');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 5, 'IXSCAN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 6, 'SORT');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 7, 'NLJOIN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 8, 'FETCH');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 9, 'UNIQUE');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 10, 'FILTER');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 11, 'MSJOIN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 12, 'RIDSCN');
INSERT INTO NSO_DBMS_Op_Gen VALUES ('db2', 13, 'IXAND');

-- Rename a specific operator's name with the predefined name for later use
-- Will restore the renamed one with the original name later
--NSOOper_S1_QatC_Ren_Op: SubOpt_Operator_Step1_QatC_Renamed_Operator
DROP TABLE NSOOper_S1_QatC_Ren_Op CASCADE CONSTRAINTS;
CREATE TABLE NSOOper_S1_QatC_Ren_Op AS
	-- for oracle
	SELECT dbms, runid, querynum, card, 
		case opname
			when 'HASH JOIN' then REGEXP_REPLACE(opname, 'HASH JOIN', 'HJOIN')
			else REGEXP_REPLACE(opname, 'VIEW:(.*)', 'VIEW')
		end as opname
	FROM NSOOper_S1_QatC_Op t0
	WHERE dbms ='oracle'
	UNION
	-- for mysql
	SELECT dbms, runid, querynum, card, 
		case opname
			when 'ALL:Full Table Scan with Join' then REGEXP_REPLACE(opname, 'ALL:Full Table Scan with Join', 'AJOIN')
			else opname
		end as opname
	FROM NSOOper_S1_QatC_Op t0
	WHERE dbms ='mysql' 
	UNION
	-- for pgsql
	SELECT dbms, runid, querynum, card, 
		case 
			when opname like '%Hash Join%' then REGEXP_REPLACE(opname, 'Hash Join', 'HJoin')
			--when opname like '%HashAggregate%' then REGEXP_REPLACE(opname, 'HashAggregate', 'HAgg') 
			when opname like '%Index Scan%' then REGEXP_REPLACE(opname, 'Index Scan(.*)', 'Index Scan') 
			when opname like '%Index Only Scan%' then REGEXP_REPLACE(opname, 'Index Only Scan(.*)', 'Index Only Scan') 
			else opname
		end as opname
	FROM NSOOper_S1_QatC_Op t0
	WHERE dbms ='pgsql'
	UNION
	-- for db2
	SELECT dbms, runid, querynum, card, opname
	FROM NSOOper_S1_QatC_Op t0
	WHERE dbms ='db2'
	;
ALTER TABLE NSOOper_S1_QatC_Ren_Op ADD PRIMARY KEY (runid, querynum, card, opname);	
-- select count(*) from (select distinct runid, querynum, card from NSOOper_S1_QatC_Ren_Op)
  COUNT(*)
----------
    112132
--select * from NSOOper_S1_QatC_Ren_Op where dbms = 'mysql' order by card desc;
-- select * from NSOOper_S1_QatC_Ren_Op where opname IN ('HAgg', 'Index Only Scan') order by card desc;
--select * from  NSOOper_S1_QatC_Ren_Op where runid = 438 and card = 2000000 and querynum = 361
DROP TABLE NSO_Gen_at_QatC CASCADE CONSTRAINTS;
CREATE TABLE NSO_Gen_at_QatC AS
	SELECT distinct dbms, runid, querynum, card, 
	       LISTAGG(opname, ',') WITHIN GROUP (ORDER BY opname) AS generation
	FROM NSOOper_S1_QatC_Ren_Op
	group by dbms, runid, querynum, card
	order by dbms, runid, querynum, card desc;
ALTER TABLE NSO_Gen_at_QatC ADD PRIMARY KEY (runid, querynum, card);	
-- select count(*) from  NSO_Gen_at_QatC
  COUNT(*)
----------
     112132
--     RUNID   QUERYNUM	    CARD
---------- ---------- ----------
--       438	  361	 2000000
--select * from  NSO_Gen_at_QatC where dbms ='db2' order by card desc
--select * from  NSO_Gen_at_QatC where dbms ='mysql' order by card desc
--select distinct generation from  NSO_Gen_at_QatC where dbms = 'pgsql' 
--select distinct generation from  NSO_Gen_at_QatC where dbms = 'db2' 
--select * from  NSO_Gen_at_QatC where dbms ='pgsql' and card = 1460000 and querynum = 49
--select * from  NSO_Gen_at_QatC where runid = 438 and querynum = 83 order by card desc
DROP TABLE NSO_GenNum_at_QatC CASCADE CONSTRAINTS;
CREATE TABLE NSO_GenNum_at_QatC AS
	SELECT t0.dbms,
 		t0.runid,
 		t0.querynum,
 		t0.card,
 		max(t0.gennum) as genNum
	FROM
		(SELECT dbms,
			runid,
			querynum,
			card,
			t1.genTxt,
			t1.genNum
		FROM NSO_DBMS_Op_Gen t1, 
		     NSO_Gen_at_QatC t2
		WHERE t1.dbmsName = t2.dbms
		--and t2.runid = 438 and t2.querynum = 83 and t2.card = 960000
		and t2.generation like CONCAT(CONCAT('%',t1.genTxt),'%')
		ORDER BY dbms, runid, querynum, card desc) t0
	--WHERE t0.runid = 438 and t0.querynum = 83 and t0.card = 960000
	GROUP BY t0.dbms, t0.runid, t0.querynum, t0.card;
ALTER TABLE NSO_GenNum_at_QatC ADD PRIMARY KEY (runid, querynum, card);
-- select count(*) from NSO_GenNum_at_QatC; 
  COUNT(*)
----------
     112131
--- select count(distinct runid) from NSO_GenNum_at_QatC; 
-- select * from NSO_GenNum_at_QatC where dbms = 'db2' and genNum = 2; 
--select * from NSO_GenNum_at_QatC where dbms ='mysql' order by card desc;
--select * from NSO_GenNum_at_QatC where dbms ='mysql' and runid = 231 and card = 28800 and querynum = 33 order by runid, querynum, card desc;
--select * from NSO_GenNum_at_QatC where dbms ='mysql' and runid = 897 and card = 28800 and querynum = 96 order by runid, querynum, card desc;
--select * from NSO_GenNum_at_QatC where dbms ='pgsql' order by card desc;
--select * from NSO_GenNum_at_QatC where dbms ='db2' and runid = 439 and card = 10000 and querynum = 26 order by runid, querynum, card desc;
--select * from NSO_GenNum_at_QatC where runid = 438 and querynum = 83 order by runid, querynum, card desc;
--DBMS
--------------------------------------------------------------------------------
--     RUNID   QUERYNUM	    CARD
---------- ---------- ----------
--OPNAME
--------------------------------------------------------------------------------
--oracle
--      438	   63	   10000
--NESTED LOOPS

--DBMS
--------------------------------------------------------------------------------
--     RUNID   QUERYNUM	    CARD     GENNUM
---------- ---------- ---------- ----------
--pgsql
--       796	   25	   40000	  9
--pgsql
--       796	   36	  100000	  9
--DBMS
--------------------------------------------------------------------------------
--     RUNID   QUERYNUM	    CARD     GENNUM
---------- ---------- ---------- ----------
--db2
--       439	   26	   10000	 12
--DBMS
--------------------------------------------------------------------------------
--     RUNID   QUERYNUM	    CARD     GENNUM
---------- ---------- ---------- ----------
--mysql
--       231	   33	   28800	  2
DROP TABLE NSO_Gen_Stat_at_QatC0 CASCADE CONSTRAINTS;
CREATE TABLE NSO_Gen_Stat_at_QatC0 AS
	SELECT	distinct
		t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card,
		t1.genNum,
		t0.planid,
		case 
		     -- for oracle
		     when t2.generation like '%HJOIN%' then REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN')
		     -- for mysql
		     when t2.generation like '%AJOIN%' then REGEXP_REPLACE(t2.generation, 'AJOIN', 'ALL:Full Table Scan with Join')
		     -- for pgsql
		     when t2.generation like '%HJoin%' then REGEXP_REPLACE(t2.generation, 'HJoin', 'Hash Join') 
		     -- for db2
		     --when 'db2' then REGEXP_REPLACE(t2.generation, 'Hjoin', 'Hash Join')
		     else t2.generation
		end as generation	
		--REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN') as generation
	FROM	--SOExpl_ACTQatC t0,
		SOExpl_S0_AQE t0,
		NSO_GenNum_at_QatC t1,
		NSO_Gen_at_QatC t2
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.card = t1.card 
	and t0.qenum = 1
	and t1.runid = t2.runid
	and t1.querynum = t2.querynum 
	and t1.card = t2.card
	and (t0.runid IN (228,229,230,231,246,247,248,412) or 
	   (t0.runid IN (439,438,796,897) and t0.querynum < 100)
	)
	UNION
	SELECT	distinct
		t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card,
		t1.genNum,
		t0.planid,
		case 
		     -- for oracle
		     when t2.generation like '%HJOIN%' then REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN')
		     -- for mysql
		     when t2.generation like '%AJOIN%' then REGEXP_REPLACE(t2.generation, 'AJOIN', 'ALL:Full Table Scan with Join')
		     -- for pgsql
		     when t2.generation like '%HJoin%' then REGEXP_REPLACE(t2.generation, 'HJoin', 'Hash Join') 
		     -- for db2
		     --when 'db2' then REGEXP_REPLACE(t2.generation, 'Hjoin', 'Hash Join')
		     else t2.generation
		end as generation	
		--REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN') as generation
	FROM	NSOCnfm_S0_AQE t0,
		NSO_GenNum_at_QatC t1,
		NSO_Gen_at_QatC t2
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.card = t1.card 
	and t0.qenum = 1
	and t1.runid = t2.runid
	and t1.querynum = t2.querynum 
	and t1.card = t2.card
	and (t0.runid NOT IN (228,229,230,231,246,247,248,412,439,438,796,897) or  
	   (t0.runid IN (439,438,796,897) and t0.querynum >= 100))
	;
ALTER TABLE NSO_Gen_Stat_at_QatC0 ADD PRIMARY KEY (runid, querynum, card);
--select dbms, genNum, coalesce(count(*),0) as numQatCs from NSO_Gen_Stat_at_QatC0 group by dbms, gennum order by dbms, gennum asc
-- select sum(numQatCs) from (select dbms, genNum, count(*) as numQatCs from NSO_Gen_Stat_at_QatC0 group by dbms, gennum order by dbms, gennum asc) 
--SUM(NUMQATCS)
-------------
--       112127

DROP TABLE NSO_Gen_Stat_at_QatC CASCADE CONSTRAINTS;
CREATE TABLE NSO_Gen_Stat_at_QatC AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card,
		t1.genNum,
		t0.med_calc_qt,
		t0.planid,
		case 
		     -- for oracle
		     when t2.generation like '%HJOIN%' then REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN')
		     -- for mysql
		     when t2.generation like '%AJOIN%' then REGEXP_REPLACE(t2.generation, 'AJOIN', 'ALL:Full Table Scan with Join')
		     -- for pgsql
		     when t2.generation like '%HJoin%' then REGEXP_REPLACE(t2.generation, 'HJoin', 'Hash Join') 
		     -- for db2
		     --when 'db2' then REGEXP_REPLACE(t2.generation, 'Hjoin', 'Hash Join')
		     else t2.generation
		end as generation	
		--REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN') as generation
	FROM	SOExpl_S4_CTQatC t0,
		NSO_GenNum_at_QatC t1,
		NSO_Gen_at_QatC t2
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.card = t1.card 
	and t1.runid = t2.runid
	and t1.querynum = t2.querynum 
	and t1.card = t2.card
	and (t0.runid IN (228,229,230,231,246,247,248,412) or 
	   (t0.runid IN (439,438,796,897) and t0.querynum < 100)
	)
	UNION
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card,
		t1.genNum,
		t0.med_calc_qt,
		t0.planid,
		case 
		     -- for oracle
		     when t2.generation like '%HJOIN%' then REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN')
		     -- for mysql
		     when t2.generation like '%AJOIN%' then REGEXP_REPLACE(t2.generation, 'AJOIN', 'ALL:Full Table Scan with Join')
		     -- for pgsql
		     when t2.generation like '%HJoin%' then REGEXP_REPLACE(t2.generation, 'HJoin', 'Hash Join') 
		     -- for db2
		     --when 'db2' then REGEXP_REPLACE(t2.generation, 'Hjoin', 'Hash Join')
		     else t2.generation
		end as generation	
		--REGEXP_REPLACE(t2.generation, 'HJOIN', 'HASH JOIN') as generation
	FROM	NSOCnfm_S4_CTQatC t0,
		NSO_GenNum_at_QatC t1,
		NSO_Gen_at_QatC t2
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.card = t1.card 
	and t1.runid = t2.runid
	and t1.querynum = t2.querynum 
	and t1.card = t2.card
	and (t0.runid NOT IN (228,229,230,231,246,247,248,412,439,438,796,897) or  
	   (t0.runid IN (439,438,796,897) and t0.querynum >= 100))
	;
ALTER TABLE NSO_Gen_Stat_at_QatC ADD PRIMARY KEY (runid, querynum, card);
-- select dbms, genNum, coalesce(count(*),0) as numQatCs from NSO_Gen_Stat_at_QatC group by dbms, gennum order by dbms, gennum asc
-- select sum(numQatCs) from (select dbms, genNum, count(*) as numQatCs from NSO_Gen_Stat_at_QatC group by dbms, gennum order by dbms, gennum asc) 
SUM(NUMQATCS)
-------------
       106601

DROP TABLE NSO_GP_QatCs CASCADE CONSTRAINTS;
CREATE TABLE NSO_GP_QatCs AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card as upper_card,
		t1.card as lower_card,
		t0.genNum as upper_gen,
		t1.genNum as lower_gen,
		t0.planid as upper_plan,
		t1.planid as lower_plan,
		t0.med_calc_qt as upper_cqt,
		t1.med_calc_qt as lower_cqt,
		t0.generation as upper_gen_txt,
		t1.generation as lower_gen_txt
	FROM	NSO_Gen_Stat_at_QatC t0,
		NSO_Gen_Stat_at_QatC t1
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	-- t0.card: upper card, t1.card: lower card
	and ((t0.dbms <> 'mysql' and t0.card = t1.card+10000) 
	or (t0.dbms = 'mysql' and t0.card = t1.card+300));
ALTER TABLE NSO_GP_QatCs ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);
--select dbms, upper_gen, count(*) from NSO_GP_QatCs group by dbms, upper_gen order by dbms, upper_gen
--select count(*) from NSO_GP_QatCs;
--  COUNT(*)
----------
--     66792
--
DROP TABLE NSO_AQatCPairs CASCADE CONSTRAINTS;
CREATE TABLE NSO_AQatCPairs AS
	select dbms,
	       gen,
	       sum(numQatCPairs) as numQatCPairs
	from 
		(select dbms, lower_gen as gen, count(*) as numQatCPairs from NSO_GP_QatCs where upper_gen <> lower_gen group by dbms, lower_gen 
		union
		select dbms, upper_gen as gen, count(*) as numQatCPairs from NSO_GP_QatCs where upper_gen = lower_gen group by dbms, upper_gen)
	group by dbms, gen;
ALTER TABLE NSO_AQatCPairs ADD PRIMARY KEY (dbms, gen);

DROP TABLE NSO_AQatCPairs CASCADE CONSTRAINTS;
CREATE TABLE NSO_AQatCPairs AS
	select dbms,
	       gen,
	       sum(numQueries) as numQueries
	from 
		(select dbms, lower_gen as gen, count(distinct querynum) as numQueries from NSO_GP_QatCs where upper_gen <> lower_gen group by dbms, lower_gen 
		union
		select dbms, upper_gen as gen, count(distinct querynum) as numQueries from NSO_GP_QatCs where upper_gen = lower_gen group by dbms, upper_gen)
	group by dbms, gen;
ALTER TABLE NSO_AQatCPairs ADD PRIMARY KEY (dbms, gen);
-- select dbms, newer_gen_num, count(distinct querynum) as numQueries 
-- from NSO_AQatCPairs group by dbms, newer_gen_num order by dbms, newer_gen_num

DROP TABLE NSO_Newer_Gen_at_Upper_Card CASCADE CONSTRAINTS;
CREATE TABLE NSO_Newer_Gen_at_Upper_Card AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card as upper_card,
		t1.card as lower_card,
		t0.genNum as upper_gen,
		t1.genNum as lower_gen,
		t0.planid as upper_plan,
		t1.planid as lower_plan,
		t0.med_calc_qt as upper_cqt,
		t1.med_calc_qt as lower_cqt,
		t0.generation as upper_gen_txt,
		t1.generation as lower_gen_txt
	FROM	NSO_Gen_Stat_at_QatC t0,
		NSO_Gen_Stat_at_QatC t1
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	--and t1.querynum = 24
	-- t0.card: upper card, t1.card: lower card
	and ((t0.dbms <> 'mysql' and t0.card = t1.card+10000) 
	or (t0.dbms = 'mysql' and t0.card = t1.card+300))
	and t0.genNum > t1.genNum -- upper: newer / lower: older
	;
ALTER TABLE NSO_Newer_Gen_at_Upper_Card ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);
-- select count(*) from NSO_Newer_Gen_at_Upper_Card;
--  COUNT(*)
----------
--       1632

-- select * from NSO_Newer_Gen_at_Upper_Card where runid = 438 and querynum = 83
-- select * from NSO_Newer_Gen_at_Upper_Card where dbms = 'pgsql'
DROP TABLE NSO_Upper_EQT CASCADE CONSTRAINTS;
CREATE TABLE NSO_Upper_EQT  AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.upper_gen,
		t0.lower_gen,
		t0.upper_card, 
		t0.lower_card,
		t1.card as nearest_card, 
		t0.upper_cqt,
		case t0.lower_card - t1.card
			when 0 then t0.lower_cqt
			else
round(
-- y-intercept
t1.med_calc_qt-(((t0.lower_cqt - t1.med_calc_qt) / (t0.lower_card - t1.card))*t1.card)+
-- slope
(((t0.lower_cqt - t1.med_calc_qt) / (t0.lower_card - t1.card))*t0.upper_card)
, 1) 
		end as upper_ep_cqt,
		t0.lower_cqt,
		t1.med_calc_qt as nearest_cqt,
		t0.upper_gen_txt,
		t0.lower_gen_txt
	FROM NSO_Newer_Gen_at_Upper_Card t0, 
	     NSO_Gen_Stat_at_QatC t1
	WHERE t0.dbms = t1.dbms 
	and t0.runid = t1.runid 
	and t0.querynum = t1.querynum -- same query
	and t0.lower_plan = t1.planid -- same plan
	-- 143K > 30K
	and t0.lower_card > t1.card
	and NOT EXISTS (SELECT * -- NOT EXISTS between lower card and nearest card (to be used for extrapolation)
			FROM NSO_Gen_Stat_at_QatC t2
			WHERE t1.runid = t2.runid 
			and t1.querynum = t2.querynum
			and t1.planid = t2.planid 
			and t0.runid = t2.runid
			and t0.querynum = t2.querynum
			and t0.lower_plan = t2.planid
			-- should be no cardinality between lower card and nearest (upper) card with the same plans
			-- x > 30K
			and t2.card > t1.card
			-- x < 143K
			and t2.card < t0.lower_card
			)
	ORDER BY dbms, runid, querynum, lower_card desc, nearest_card desc;
ALTER TABLE NSO_Upper_EQT ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);
--select * from NSO_Upper_EQT where runid = 438 and querynum = 83;
-- select count(*) from NSO_Upper_EQT --- 494
--  COUNT(*)
----------
--       1078

--select * from NSO_Newer_Gen_at_Upper_Card where dbms = 'pgsql';
DROP TABLE NSO_Newer_Gen_at_Lower_Card CASCADE CONSTRAINTS;
CREATE TABLE NSO_Newer_Gen_at_Lower_Card AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card as upper_card,
		t1.card as lower_card,
		t0.genNum as upper_gen,
		t1.genNum as lower_gen,
		t0.planid as upper_plan,
		t1.planid as lower_plan,
		t0.med_calc_qt as upper_cqt,
		t1.med_calc_qt as lower_cqt,
		t0.generation as upper_gen_txt,
		t1.generation as lower_gen_txt
	FROM	NSO_Gen_Stat_at_QatC t0,
		NSO_Gen_Stat_at_QatC t1
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	-- t0.card: upper card, t1.card: lower card
	and ((t0.dbms <> 'mysql' and t0.card = t1.card+10000) 
	or (t0.dbms = 'mysql' and t0.card = t1.card+300))
	and t0.genNum < t1.genNum -- upper: older / lower: newer
	;
ALTER TABLE NSO_Newer_Gen_at_Lower_Card ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);
-- select count(*) from NSO_Newer_Gen_at_Lower_Card;
  COUNT(*)
----------
       2257
--select * from NSO_Newer_Gen_at_Lower_Card where dbms = 'mysql'
-- select * from NSO_Newer_Gen_at_Lower_Card where runid = 438 and querynum = 41
-- select * from NSO_Newer_Gen_at_Lower_Card where runid = 438 and querynum = 41

DROP TABLE NSO_Lower_EQT CASCADE CONSTRAINTS;
CREATE TABLE NSO_Lower_EQT  AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.upper_gen,
		t0.lower_gen,
		t1.card as nearest_card, 
		t0.upper_card, 
		t0.lower_card,
		t1.med_calc_qt as nearest_cqt,
		t0.upper_cqt,
		t0.lower_cqt,
		case t1.card - t0.upper_card
			when 0 then t0.upper_cqt
			else 
round(
-- y-intercept
(t0.upper_cqt-((t1.med_calc_qt-t0.upper_cqt)/(t1.card-t0.upper_card))*t0.upper_card+
-- slope
((t1.med_calc_qt-t0.upper_cqt)/(t1.card-t0.upper_card))*t0.lower_card), 1) 
		end as lower_ep_cqt,
		t0.upper_gen_txt,
		t0.lower_gen_txt
	FROM NSO_Newer_Gen_at_Lower_Card t0, 
	     NSO_Gen_Stat_at_QatC t1
	WHERE t0.dbms = t1.dbms 
	and t0.runid = t1.runid 
	and t0.querynum = t1.querynum -- same query
	and t0.upper_plan = t1.planid -- same plan
	-- 760K > 40K
	and t1.card > t0.upper_card -- higher card > upper card
	and NOT EXISTS (SELECT * -- NOT EXISTS between lower card and nearest card (to be used for extrapolation)
			FROM NSO_Gen_Stat_at_QatC t2
			WHERE t1.runid = t2.runid 
			and t1.querynum = t2.querynum
			and t1.planid = t2.planid 
			and t0.runid = t2.runid
			and t0.querynum = t2.querynum
			and t0.upper_plan = t2.planid
			-- should be no cardinality between upper card and nearest (lower) card with the same plans
			-- x < 760K 
			and t2.card < t1.card
			--- x > 40K
			and t2.card > t0.upper_card
			)
	ORDER BY dbms, runid, querynum, nearest_card desc;
ALTER TABLE NSO_Lower_EQT ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);
--select * from NSO_Lower_EQT where runid = 438 and querynum = 83;
--select * from NSO_Lower_EQT where runid = 796 and querynum = 83 and upper_card = 130000;
--select * from NSO_Upper_EQT where runid = 796 and querynum = 91 and upper_card = 20000;
--select * from NSO_Lower_EQT where runid = 796 and querynum = 91 and upper_card = 20000;
-- select count(*) from NSO_Lower_EQT
  COUNT(*)
----------
      2033

-- Calculate the relative delta
DROP TABLE NSO_Calc_RD CASCADE CONSTRAINTS;
CREATE TABLE NSO_Calc_RD  AS
	-- upper plan is a newer generation
	SELECT t0.dbms,
	       t0.runid,
	       t0.querynum,
	       t0.upper_gen as newer_gen_num,
	       --t0.lower_gen as lower_gen_num,
	       t0.upper_card,
	       t0.lower_card,
	       case 
		when t0.upper_ep_cqt < 0 then round(((t0.upper_cqt) / t0.upper_cqt), 2)
		when t0.upper_ep_cqt > t0.upper_cqt then round(((t0.upper_ep_cqt - t0.upper_cqt) / t0.upper_ep_cqt), 2)
		else round(((t0.upper_ep_cqt - t0.upper_cqt) / t0.upper_cqt), 2)
		--when t0.upper_cqt < t0.upper_ep_cqt then round(((t0.upper_ep_cqt - t0.upper_cqt) / t0.upper_ep_cqt), 2)
		--else  round(((t0.upper_cqt - t0.upper_ep_cqt) / t0.upper_cqt), 2)
	       end as rel_delta,
	       t0.upper_gen_txt as upper_gen_txt,
	       t0.lower_gen_txt as lower_gen_txt
	FROM NSO_Upper_EQT t0
	WHERE t0.upper_cqt > 0
	UNION
	-- lower plan is a newer generation
	SELECT t0.dbms,
	       t0.runid,
	       t0.querynum,
	       t0.lower_gen as newer_gen_num,
	       --t0.upper_gen as upper_gen_num,
	       t0.upper_card,
	       t0.lower_card,
	       case
		when t0.lower_ep_cqt < 0 then round(((t0.lower_cqt) / t0.lower_cqt), 2) 
		when t0.lower_ep_cqt > t0.lower_cqt then round(((t0.lower_ep_cqt - t0.lower_cqt) / t0.lower_ep_cqt), 2) 
		else round(((t0.lower_ep_cqt - t0.lower_cqt) / t0.lower_cqt), 2) 
	        --else round(((t0.lower_cqt - t0.lower_ep_cqt) / t0.lower_cqt), 2) 
	       end as rel_delta,
	       t0.upper_gen_txt as upper_gen_txt,
	       t0.lower_gen_txt as lower_gen_txt
	FROM NSO_Lower_EQT t0
	WHERE t0.lower_cqt > 0
	ORDER BY dbms, runid, querynum, upper_card desc;
ALTER TABLE NSO_Calc_RD ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);
--select * from NSO_Calc_RD where runid = 796 and querynum = 15;
--select * from NSO_Calc_RD where runid = 438 and querynum = 83;
--select * from NSO_Calc_RD where dbms = 'pgsql' and newer_gen_num = 6;
--select * from NSO_Calc_RD where dbms = 'db2' and newer_gen_num = 11;
--select count(*) from NSO_Calc_RD
  COUNT(*)
----------
       3111

-- Calculate the averge relative delta
DROP TABLE NSO_RD_Stat CASCADE CONSTRAINTS;
CREATE TABLE NSO_RD_Stat  AS
	-- upper plan is a newer generation
	SELECT dbms,
	       newer_gen_num,
	       round(avg(rel_delta), 2) as avg_rd
	FROM NSO_Calc_RD
	GROUP BY dbms, newer_gen_num
	ORDER BY dbms, newer_gen_num;
ALTER TABLE NSO_RD_Stat ADD PRIMARY KEY (dbms, newer_gen_num);
--select * from NSO_RD_Stat order by dbms, newer_gen_num


----
-- young wrote this.
Drop TABLE NSO_Defn CASCADE CONSTRAINTS;
CREATE TABLE NSO_Defn AS
	SELECT qc1.experimentid, qc1.experimentname, qc1.dbms, qc1.runid, qc1.queryNum,
	  qc1.card as HighCard, qc1.med_calc_qt AS MedianHighCard,
	  qc1.std_calc_qt AS SDHighCard, qc2.med_calc_qt AS MedianLowCard, qc2.std_calc_qt AS SDLowCard,
	  qc2.card as LowCard, qc1.planid AS PlHighCard, qc2.planid PlLowCard,
	  CASE WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))< 0 THEN 0 WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))>= 0
	   AND (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))< 0 THEN 1 WHEN (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))>= 0
	   AND (qc2.med_calc_qt-(1.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.5*qc1.std_calc_qt))< 0 THEN 2 ELSE 3 END AS Subopt_SD
	  , 100*(qc2.med_calc_qt-qc1.med_calc_qt)/qc1.med_calc_qt AS Subopt_rel
	FROM SOExpl_S4_CTQatC qc1, 
	     SOExpl_S4_CTQatC qc2
	WHERE qc1.experimentid=qc1.experimentid
	AND qc1.runid=qc2.runid
	AND qc1.querynum=qc2.querynum
	and ((qc1.dbms='mysql' and qc1.card=qc2.card+300)
	OR (qc1.dbms!='mysql' and qc1.card=qc2.card+10000))
	and (qc1.runid IN (select * from NSOOper_Runs) or qc1.runid IN (select * from NSOOper_PK_Runs))
	and qc1.planid<>qc2.planid
	UNION
	SELECT qc1.experimentid, qc1.experimentname, qc1.dbms, qc1.runid, qc1.queryNum,
	  qc1.card as HighCard, qc1.med_calc_qt AS MedianHighCard,
	  qc1.std_calc_qt AS SDHighCard, qc2.med_calc_qt AS MedianLowCard, qc2.std_calc_qt AS SDLowCard,
	  qc2.card as LowCard, qc1.planid AS PlHighCard, qc2.planid PlLowCard,
	  CASE WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))< 0 THEN 0 WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))>= 0
	   AND (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))< 0 THEN 1 WHEN (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))>= 0
	   AND (qc2.med_calc_qt-(1.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.5*qc1.std_calc_qt))< 0 THEN 2 ELSE 3 END AS Subopt_SD
	  , 100*(qc2.med_calc_qt-qc1.med_calc_qt)/qc1.med_calc_qt AS Subopt_rel
	FROM NSOCnfm_S4_CTQatC qc1, 
	     NSOCnfm_S4_CTQatC qc2
	WHERE qc1.experimentid=qc1.experimentid
	AND qc1.runid=qc2.runid
	AND qc1.querynum=qc2.querynum
	and ((qc1.dbms='mysql' and qc1.card=qc2.card+300)
	OR (qc1.dbms!='mysql' and qc1.card=qc2.card+10000))
	and (qc1.runid IN (select * from NSOOper_Runs) or qc1.runid IN (select * from NSOOper_PK_Runs))
	and qc1.planid<>qc2.planid
	;
alter table NSO_Defn add primary key (runid, querynum, highcard, lowcard);

Drop TABLE NSO_CP CASCADE CONSTRAINTS;
CREATE TABLE NSO_CP AS
	SELECT t0.*
	FROM NSO_Defn t0
	WHERE t0.Subopt_SD > 0;
alter table NSO_CP add primary key (runid, querynum, highcard, lowcard);

SELECT count(*) FROM NSO_Defn t0 WHERE Subopt_rel < 0;

  COUNT(*)
----------
     35802

SQL> select count(*) from NSO_Defn t0 where Subopt_rel >= 0;

  COUNT(*)
----------
     22787

SQL> select count(*) from NSO_Defn t0;

  COUNT(*)
----------
     58589

DROP TABLE NSO_RD_SubOpt CASCADE CONSTRAINTS;
CREATE TABLE NSO_RD_SubOpt  AS
	select t0.dbms, 
	       t0.runid,
	       t0.querynum,
	       t0.newer_gen_num,
	       t0.upper_card,
	       t0.lower_card,
	       t0.rel_delta
	from 
		NSO_Calc_RD t0,
		NSO_CP t1
	where t0.runid = t1.runid
	 and t0.querynum = t1.querynum
	 and t0.upper_card = t1.highcard
	 and t0.lower_card = t1.lowcard;
ALTER TABLE NSO_RD_SubOpt ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);
--select count(*) from NSO_RD_SubOpt;
  COUNT(*)
----------
       992

--select dbms, newer_gen_num, count(*) from NSO_RD_SubOpt group by dbms, newer_gen_num order by dbms, newer_gen_num

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
db2
	    7	     207

db2
	    9	       1

db2
	   11	     331

mysql
	    5	      11

oracle
	    4	       1

oracle
	    5	      98

oracle
	    6	      80

pgsql
	    5	       2

pgsql
	    6	      64

pgsql
	    7	      29

pgsql
	    8	      52

pgsql
	   10	      10

pgsql
	   11	     100

pgsql
	   12	       6


14 rows selected.


--select count(*) from NSO_RD_SubOpt where rel_delta >= 0;
  COUNT(*)
----------
       405

--select dbms, newer_gen_num, count(*) from NSO_RD_SubOpt where rel_delta >= 0 group by dbms, newer_gen_num order by dbms,newer_gen_num 
select newer_gen_num, sum(subOptCnt)
from (select dbms, newer_gen_num, count(*) as subOptCnt from NSO_RD_SubOpt where rel_delta >= 0 group by dbms, newer_gen_num)
group by newer_gen_num
order by newer_gen_num

NEWER_GEN_NUM SUM(SUBOPTCNT)
------------- --------------
	    4		   1
	    5		  64
	    6		  34
	    7		  24
	    8		  34
	   10		   5
	   11		 240
	   12		   3

8 rows selected.

select dbms, newer_gen_num, count(*) as subOptCnt from NSO_RD_SubOpt where rel_delta >= 0 group by dbms, newer_gen_num order by dbms, newer_gen_num asc

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM  SUBOPTCNT
------------- ----------
db2
	    7	       3

db2
	   11	     220

mysql
	    5	       3


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM  SUBOPTCNT
------------- ----------
oracle
	    4	       1

oracle
	    5	      59

oracle
	    6	      34


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM  SUBOPTCNT
------------- ----------
pgsql
	    5	       2

pgsql
	    7	      21

pgsql
	    8	      34


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM  SUBOPTCNT
------------- ----------
pgsql
	   10	       5

pgsql
	   11	      20

pgsql
	   12	       3


12 rows selected.


select dbms, newer_gen_num, count(*) as subOptCnt from NSO_RD_SubOpt where rel_delta < 0 group by dbms, newer_gen_num order by dbms, newer_gen_num asc

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM  SUBOPTCNT
------------- ----------
db2
	    7	     204

db2
	    9	       1

db2
	   11	     111

mysql
	    5	       8

oracle
	    5	      39

oracle
	    6	      46

pgsql
	    6	      64

pgsql
	    7	       8

pgsql
	    8	      18

pgsql
	   10	       5

pgsql
	   11	      80

pgsql
	   12	       3


12 rows selected.

DROP TABLE NSO_SubOpt_Gen CASCADE CONSTRAINTS;
CREATE TABLE NSO_SubOpt_Gen  AS
	select t0.dbms, 
	       t0.runid,
	       t0.querynum,
	       t0.upper_gen as gen_num,
	       t0.upper_card,
	       t0.lower_card
	from NSO_Newer_Gen_at_Upper_Card t0,
	     NSO_CP t1
	where t0.runid = t1.runid
	 and t0.querynum = t1.querynum
	 and t0.upper_card = t1.highcard
	 and t0.lower_card = t1.lowcard
	UNION
	select t0.dbms, 
	       t0.runid,
	       t0.querynum,
	       t0.lower_gen as gen_num,
	       t0.upper_card,
	       t0.lower_card
	from 
		NSO_Newer_Gen_at_Lower_Card t0,
		NSO_CP t1
	where t0.runid = t1.runid
	 and t0.querynum = t1.querynum
	 and t0.upper_card = t1.highcard
	 and t0.lower_card = t1.lowcard
	;
ALTER TABLE NSO_SubOpt_Gen ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);

DROP TABLE NSO_SubOpt_Gen_Stat CASCADE CONSTRAINTS;
CREATE TABLE NSO_SubOpt_Gen_Stat  AS
	select t0.dbms, 
	       t0.gen_num,
	       count(*) as subOptCnt
	from NSO_SubOpt_Gen t0
	group by t0.dbms, t0.gen_num;
ALTER TABLE NSO_SubOpt_Gen_Stat ADD PRIMARY KEY (dbms, gen_num);
--select * from NSO_SubOpt_Gen_Stat order by dbms, gen_num;
--select sum(subOptCnt) from NSO_SubOpt_Gen_Stat
SQL> select * from NSO_SubOpt_Gen_Stat order by dbms, gen_num;

DBMS
--------------------------------------------------------------------------------
   GEN_NUM  SUBOPTCNT
---------- ----------
db2
	 7	  225

db2
	 9	    1

db2
	11	  363


DBMS
--------------------------------------------------------------------------------
   GEN_NUM  SUBOPTCNT
---------- ----------
mysql
	 5	   56

oracle
	 4	    1

oracle
	 5	  125

oracle
	 6	   94

pgsql
	 5	    5

pgsql
	 6	   76

pgsql
	 7	   29

pgsql
	 8	   59

pgsql
	10	   15

pgsql
	11	  105

pgsql
	12	    9


14 rows selected.


-- 3rd graph
select dbms, genNum, sum(numQatCs)
from
	(select dbms, genNum, count(*) as numQatCs
	from NSO_Gen_Stat_at_QatC
	group by dbms, genNum)
group by dbms, gennum 
order by dbms, gennum 

-- fourthr graph
select dbms, gen_num, sum(subOptCnt) 
from NSO_SubOpt_Gen_Stat 
group by dbms, gen_num 
order by dbms, gen_num;

select gen_num, sum(subOptCnt) 
from NSO_SubOpt_Gen_Stat 
group by gen_num 
order by gen_num;
select count(*) from NSO_Calc_RD
select *from NSO_RD_Stat;

select t0.rd as rel_delta, sum(cnts) as numQatCs
from 
	(select rel_delta*(-1) as rd, count(*) as cnts from NSO_Calc_RD 
	 group by rel_delta order by rel_delta) t0
group by t0.rd
order by t0.rd

