DROP TABLE DiscontOp_S0;
CREATE TABLE DiscontOp_S0 AS 
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
		value as estCost
	FROM azdblab_experimentrun er,
	     azdblab_query q,
	     azdblab_queryexecution qe, 
	     AZDBLAB_QUERYEXECUTIONHASPLAN qep,
	     AZDBLAB_PLANOPERATOR po,
	     AZDBLAB_QUERYEXECUTIONHASSTAT qes
	WHERE er.runid IN (16)
	      --er.runid IN (select runid from EH_Chosen_Runs_Ver1)
	  --AND q.queryid = 132
	  AND qe.ITERNUM = 1
	  AND er.runid = q.runid 
	  AND q.queryid = qe.queryid
	  AND qe.queryexecutionid = qep.QUERYEXECUTIONID
	  AND qep.PLANID = po.planid
	  AND qe.queryexecutionid = qes.QUERYEXECUTIONID
	  AND qes.PLANOPERATORID = po.PLANOPERATORID
	  --AND qe.cardinality >= 1500000 
	  AND qes.NAME = 'ORA_COST' -- oracle 
	  --AND po.operatorname = 'HASH JOIN'
	--ORDER BY runid, querynum, card asc, qep.PLANID, po.operatorname, qe.cardinality, value	
	ORDER BY runid, querynum, card asc, PLANID, opname, oporder, statname;	
ALTER TABLE DiscontOp_S0 ADD PRIMARY KEY (runid,querynum,card,PLANID,opID,statName);
--select * from DiscontOp_S0 where opname = 'HASH'

DROP TABLE DiscontOp_S1;
CREATE TABLE DiscontOp_S1 AS 
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
	FROM DiscontOp_S0 t0, -- low card
	     DiscontOp_S0 t1  -- high card 
	WHERE t0.runid = t1.runid 
	AND t0.querynum = t1.querynum 
	AND t0.card+10000 = t1.card -- adjacent cardinalities
	AND t0.planid = t1.planid 
	AND t0.opID = t1.opID
	ORDER BY runid, querynum, high_card asc, PLANID, opID, slope;	
ALTER TABLE DiscontOp_S1 ADD PRIMARY KEY (runid,querynum,high_card,PLANID,opID,slope);
--select * from DiscontOp_S1 where opname = 'HASH' and high_card >= 1100000 and high_card <= 1200000
--select card from DiscontOp_S0 where opname = 'SELECT STATEMENT' 
--(select distinct card from DiscontOp_S0 where opname = 'SELECT STATEMENT' minus select high_card from DiscontOp_S1 where opname = 'SELECT STATEMENT')
--select high_card, slope from DiscontOp_S1 where opname = 'HASH'

column opname FORMAT A20;
DROP TABLE DiscontOp_S1_Stat;
CREATE TABLE DiscontOp_S1_Stat AS 
	SELECT  t0.DBMS,
		t0.runid,
		t0.querynum,
		t0.planid,
		t0.opID,
		t0.opname,
		t0.oporder,
		avg(t0.slope) as slp_avg,
		stddev(t0.slope) as slp_std
	FROM DiscontOp_S1 t0
	GROUP BY DBMS,runid, querynum,PLANID,opID,opname,oporder 
	ORDER BY DBMS,runid, querynum,PLANID,oporder,opname;
ALTER TABLE DiscontOp_S1_Stat ADD PRIMARY KEY (runid,querynum,PLANID,opID);
-- select planid,opname, oporder, slp_avg,slp_std from DiscontOp_S1_Std 

DROP TABLE DiscontOp_S2;
CREATE TABLE DiscontOp_S2 AS 
	SELECT	t0.DBMS,
		t0.runid,
		t0.querynum,
		t0.high_card,	
		t0.planid,
		t0.opId,
		t0.opname,
		t0.oporder,
		t0.slope
	FROM 	DiscontOp_S1 t0,
		DiscontOp_S1_Stat t1
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.planid = t1.planid
	and t0.opID = t1.opID 
	-- locate one > one avg + one standard dev.
	and t0.slope > t1.slp_avg+2*t1.slp_std; 
ALTER TABLE DiscontOp_S2 ADD PRIMARY KEY (runid,querynum,high_card,PLANID,opID,slope);

DROP TABLE DiscontOp_S3_PerRun;
CREATE TABLE DiscontOp_S3_PerRun AS 
	SELECT distinct 
	       dbms,
	       runid,
	       opname
	FROM DiscontOp_S2
	ORDER BY runid, opname desc;
ALTER TABLE DiscontOp_S3_PerRun ADD PRIMARY KEY (dbms,runid,opname);

DROP TABLE DiscontOp_S3;
CREATE TABLE DiscontOp_S3 AS 
	SELECT distinct 
	       dbms,
	       opname
	FROM DiscontOp_S3_PerRun
	ORDER BY opname desc;
ALTER TABLE DiscontOp_S3 ADD PRIMARY KEY (dbms,opname);
select * from DiscontOp_S3;
