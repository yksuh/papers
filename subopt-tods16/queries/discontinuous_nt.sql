-- Writer      : Young-Kyoon Suh
-- Date        : 03/15/17
-- Description : Define analysis queries for identifying discontinous operators 
-- labshelf 5.19/6.0

-- Gather all estimated cost per operator per plan across runs
-- DiscontOpNt_S0: DiscontinuousOperator_Step0
DROP TABLE DiscontOpNt_S0;
CREATE TABLE DiscontOpNt_S0 AS 
	SELECT 
		--distinct 
		er.DBMS,
		er.runid, 
		q.querynumber as querynum, 
		qe.cardinality as card, 
		qep.PLANID, 
		po.PLANOPERATORID as opID,
		po.operatorname as opname, 
		po.OPERATORORDER as oporder, 
		qes.NAME as statName, 
		qes.value as estCost
	FROM azdblab_experimentrun er,
	     azdblab_query q,
	     azdblab_queryexecution qe, 
	     AZDBLAB_QUERYEXECUTIONHASPLAN qep,
	     AZDBLAB_PLANOPERATOR po,
	     AZDBLAB_QUERYEXECUTIONHASSTAT qes
	WHERE --er.runid IN (select runid from EH_Chosen_Runs_Ver1) 
	   er.runid IN (select runid from EHNT_RT_Chosen_Runs_Ver1)
	  --AND q.queryid = 132
	  AND qe.ITERNUM = 1
	  AND er.runid = q.runid 
	  AND q.queryid = qe.queryid
	  AND qe.queryexecutionid = qep.QUERYEXECUTIONID
	  AND qep.PLANID = po.planid
	  AND qe.queryexecutionid = qes.QUERYEXECUTIONID
	  AND qes.PLANOPERATORID = po.PLANOPERATORID
	  --AND qe.cardinality >= 1500000 
	  AND (qes.NAME IN ('ORA_COST', -- oracle 
	  'DB2_TOTAL_COST', -- db2
	  'PG_TOTAL_COST', -- pgsql
	  'MY_ROWS')) -- mysql 
	  --AND po.operatorname = 'HASH JOIN'
	--ORDER BY runid, querynum, card asc, qep.PLANID, po.operatorname, qe.cardinality, value	
	ORDER BY runid, querynum, card asc, PLANID, opname, oporder, statname;	
ALTER TABLE DiscontOpNt_S0 ADD PRIMARY KEY (runid,querynum,card,PLANID,opID,statName);
--select * from DiscontOpNt_S0 where opname = 'ALL:Full Table Scan'
--select distinct opname from DiscontOpNt_S0 where DBMS = 'oracle'column opname FORMAT A20;
column dbms FORMAT A20;
select distinct dbms, opname from DiscontOpNt_S0 order by dbms, opname

DROP TABLE DiscontOpNt_S1;
CREATE TABLE DiscontOpNt_S1 AS 
	SELECT  t0.DBMS,
		t0.runid,
		t0.querynum,
		t0.card as low_card,
		t1.card as high_card,
		t0.planid,
		t0.opID,
		t0.opname,
		t0.oporder,
		t0.estCost as low_cost,
		t1.estCost as high_cost,
		((t1.estCost-t0.estCost)/10000) as slope
	FROM DiscontOpNt_S0 t0, -- low card
	     DiscontOpNt_S0 t1  -- high card 
	WHERE t0.runid = t1.runid 
	AND t0.querynum = t1.querynum 
	AND (t0.card+10000 = t1.card -- adjacent cardinalities
	OR t0.card+300 = t1.card)
	AND t0.planid = t1.planid 
	AND t0.opID = t1.opID
	ORDER BY runid, querynum, high_card asc, PLANID, opID, slope;	
ALTER TABLE DiscontOpNt_S1 ADD PRIMARY KEY (runid,querynum,high_card,PLANID,opID,slope);
--select * from DiscontOpNt_S1 where opname = 'HASH' and high_card >= 1100000 and high_card <= 1200000
--select card from DiscontOpNt_S0 where opname = 'SELECT STATEMENT' 
--(select distinct card from DiscontOpNt_S0 where opname = 'SELECT STATEMENT' minus select high_card from DiscontOpNt_S1 where opname = 'SELECT STATEMENT')
--select high_card, slope from DiscontOpNt_S1 where opname = 'ALL:Full Table Scan'

column opname FORMAT A20;
DROP TABLE DiscontOpNt_S1_Stat;
CREATE TABLE DiscontOpNt_S1_Stat AS 
	SELECT  t0.DBMS,
		t0.runid,
		t0.querynum,
		t0.planid,
		t0.opID,
		t0.opname,
		t0.oporder,
		avg(t0.slope) as slp_avg,
		stddev(t0.slope) as slp_std
	FROM DiscontOpNt_S1 t0
	GROUP BY DBMS,runid, querynum,PLANID,opID,opname,oporder 
	ORDER BY DBMS,runid, querynum,PLANID,oporder,opname;
ALTER TABLE DiscontOpNt_S1_Stat ADD PRIMARY KEY (runid,querynum,PLANID,opID);

-- select planid,opname, oporder, slp_avg,slp_std from DiscontOpNt_S1_Stat 
DROP TABLE DiscontOpNt_S2;
CREATE TABLE DiscontOpNt_S2 AS 
	SELECT	t0.DBMS,
		t0.runid,
		t0.querynum,
		t0.high_card,	
		t0.planid,
		t0.opId,
		t0.opname,
		t0.oporder,
		t0.slope
	FROM 	DiscontOpNt_S1 t0,
		DiscontOpNt_S1_Stat t1
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.planid = t1.planid
	and t0.opID = t1.opID 
	-- locate one > one avg + one standard dev.
	and t0.slope > t1.slp_avg+2*t1.slp_std; 
ALTER TABLE DiscontOpNt_S2 ADD PRIMARY KEY (runid,querynum,high_card,PLANID,opID,slope);

DROP TABLE DiscontOpNt_S3_PerRun;
CREATE TABLE DiscontOpNt_S3_PerRun AS 
	SELECT distinct 
	       dbms,
	       runid,
	       opname
	FROM DiscontOpNt_S2
	ORDER BY runid, opname desc;
ALTER TABLE DiscontOpNt_S3_PerRun ADD PRIMARY KEY (dbms,runid,opname);

DROP TABLE DiscontOpNt_S3;
CREATE TABLE DiscontOpNt_S3 AS 
	SELECT distinct 
	       dbms,
	       opname
	FROM DiscontOpNt_S3_PerRun
	ORDER BY opname desc;
ALTER TABLE DiscontOpNt_S3 ADD PRIMARY KEY (dbms,opname);
column opname FORMAT A20;
column dbms FORMAT A20;
select dbms, opname from DiscontOpNt_S3;

