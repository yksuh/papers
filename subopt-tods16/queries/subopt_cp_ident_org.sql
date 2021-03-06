-- young wrote this.
Drop TABLE SOExpl_SuboptDefn CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_SuboptDefn AS
SELECT qc1.experimentid, qc1.experimentname, qc1.dbms, qc1.runid, qc1.queryNum,
  qc1.card as HighCard, qc1.med_calc_qt AS MedianHighCard,
  qc1.std_calc_qt AS SDHighCard, qc2.med_calc_qt AS MedianLowCard, qc2.std_calc_qt AS SDLowCard,
  qc2.card as LowCard, qc1.planid AS PlHighCard, qc2.planid PlLowCard,
  CASE WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))< 0 THEN 0 WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))>= 0
   AND (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))< 0 THEN 1 WHEN (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))>= 0
   AND (qc2.med_calc_qt-(1.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.5*qc1.std_calc_qt))< 0 THEN 2 ELSE 3 END AS Subopt_SD, 
100*(qc2.med_calc_qt-qc1.med_calc_qt)/qc1.med_calc_qt AS Subopt_rel
FROM SOExpl_S4_CTQatC qc1, SOExpl_S4_CTQatC qc2
WHERE qc1.experimentid=qc1.experimentid
AND qc1.runid=qc2.runid
AND qc1.querynum=qc2.querynum
and ((qc1.dbms='mysql' and qc1.card=qc2.card+300)
OR (qc1.dbms!='mysql' and qc1.card=qc2.card+10000))
and qc1.planid<>qc2.planid;
alter table SOExpl_SuboptDefn add primary key (runid, querynum, highcard, lowcard);

Drop TABLE SOExpl_SuboptCP CASCADE CONSTRAINTS;
CREATE TABLE SOExpl_SuboptCP AS
	SELECT t0.*
	FROM SOExpl_SuboptDefn t0
	--WHERE Subopt_rel < 0
	WHERE t0.Subopt_SD > 0;	
alter table SOExpl_SuboptCP add primary key (runid, querynum, highcard, lowcard);

DROP TABLE SO_RD_SubOpt CASCADE CONSTRAINTS;
CREATE TABLE SO_RD_SubOpt  AS
	select t0.dbms, 
	       t0.runid,
	       t0.querynum,
	       t0.newer_gen_num,
	       t0.upper_card,
	       t0.lower_card,
	       t0.rel_delta
	from 
		SO_Calc_RD t0,
		SOExpl_SuboptCP t1
	where t0.runid = t1.runid
	 and t0.querynum = t1.querynum
	 and t0.upper_card = t1.highcard
	 and t0.lower_card = t1.lowcard
	and t0.rel_delta < 0
	;
ALTER TABLE SO_RD_SubOpt ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);

DROP TABLE SO_SubOpt_Gen CASCADE CONSTRAINTS;
CREATE TABLE SO_SubOpt_Gen  AS
	select t0.dbms, 
	       t0.runid,
	       t0.querynum,
	       t0.upper_gen as gen_num,
	       t0.upper_card,
	       t0.lower_card
	from SO_Newer_Gen_at_Upper_Card t0,
	     SOExpl_SuboptCP t1
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
		SO_Newer_Gen_at_Lower_Card t0,
		SOExpl_SuboptCP t1
	where t0.runid = t1.runid
	 and t0.querynum = t1.querynum
	 and t0.upper_card = t1.highcard
	 and t0.lower_card = t1.lowcard
	;
ALTER TABLE SO_SubOpt_Gen ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);

DROP TABLE SO_SubOpt_Gen_Stat CASCADE CONSTRAINTS;
CREATE TABLE SO_SubOpt_Gen_Stat  AS
	select t0.dbms, 
	       t0.gen_num,
	       count(*) as subOptCnt
	from SO_SubOpt_Gen t0
	group by t0.dbms, t0.gen_num;
ALTER TABLE SO_SubOpt_Gen_Stat ADD PRIMARY KEY (dbms, gen_num);

-- for generating graph data
-- 3rd graph
--select dbms, genNum, sum(numQatCs)
--from
--	(select dbms, genNum, count(*) as numQatCs
--	from SO_Gen_Stat_at_QatC
--	group by dbms, genNum)
--group by dbms, gennum 
--order by dbms, gennum 

-- fourth graph
--select dbms, gen_num, sum(subOptCnt) 
--from SO_SubOpt_Gen_Stat 
--group by dbms, gen_num 
--order by dbms, gen_num;

--select gen_num, sum(subOptCnt) 
--from SO_SubOpt_Gen_Stat 
--group by gen_num 
--order by gen_num;
--select count(*) from SO_Calc_RD
--select *from SO_RD_Stat;

--select t0.rd as rel_delta, sum(cnts) as numQatCs
--from 
--	(select rel_delta*(-1) as rd, count(*) as cnts from SO_Calc_RD 
--	 group by rel_delta order by rel_delta) t0
--group by t0.rd
--order by t0.rd
