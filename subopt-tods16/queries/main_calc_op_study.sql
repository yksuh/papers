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
	FROM	--NSOExpl_ACTQatC t0,
		NSOExpl_S4_CTQatC t0,
		NSO_GenNum_at_QatC t1,
		NSO_Gen_at_QatC t2
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.card = t1.card 
	and t1.runid = t2.runid
	and t1.querynum = t2.querynum 
	and t1.card = t2.card;
ALTER TABLE NSO_Gen_Stat_at_QatC ADD PRIMARY KEY (runid, querynum, card);

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
		else  round(((t0.upper_cqt - t0.upper_ep_cqt) / t0.upper_cqt), 2)
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
		else round(((t0.lower_cqt - t0.lower_ep_cqt) / t0.lower_cqt), 2) 
	       end as rel_delta,
	       t0.upper_gen_txt as upper_gen_txt,
	       t0.lower_gen_txt as lower_gen_txt
	FROM NSO_Lower_EQT t0
	WHERE t0.lower_cqt > 0
	ORDER BY dbms, runid, querynum, upper_card desc;
ALTER TABLE NSO_Calc_RD ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);

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

Drop TABLE NSOExpl_SuboptDefn CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_SuboptDefn AS
	SELECT qc1.experimentid, qc1.experimentname, qc1.dbms, qc1.runid, qc1.queryNum,
	  qc1.card as HighCard, qc1.med_calc_qt AS MedianHighCard,
	  qc1.std_calc_qt AS SDHighCard, qc2.med_calc_qt AS MedianLowCard, qc2.std_calc_qt AS SDLowCard,
	  qc2.card as LowCard, qc1.planid AS PlHighCard, qc2.planid PlLowCard,
	  CASE WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))< 0 THEN 0 WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))>= 0
	   AND (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))< 0 THEN 1 WHEN (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))>= 0
	   AND (qc2.med_calc_qt-(1.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.5*qc1.std_calc_qt))< 0 THEN 2 ELSE 3 END AS Subopt_SD
	  , 100*(qc2.med_calc_qt-qc1.med_calc_qt)/qc1.med_calc_qt AS Subopt_rel
	FROM NSOExpl_S4_CTQatC qc1, 
	     NSOExpl_S4_CTQatC qc2
	WHERE qc1.experimentid=qc1.experimentid
	AND qc1.runid=qc2.runid
	AND qc1.querynum=qc2.querynum
	and ((qc1.dbms='mysql' and qc1.card=qc2.card+300)
	OR (qc1.dbms!='mysql' and qc1.card=qc2.card+10000))
	and (qc1.runid IN (select * from NSOOper_Runs) or qc1.runid IN (select * from NSOOper_PK_Runs))
	and qc1.planid<>qc2.planid
	;
alter table NSOExpl_SuboptDefn add primary key (runid, querynum, highcard, lowcard);

Drop TABLE NSOExpl_SuboptCP CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_SuboptCP AS
	SELECT t0.*
	FROM NSOExpl_SuboptDefn t0
	WHERE t0.Subopt_SD > 0;
alter table NSOExpl_SuboptCP add primary key (runid, querynum, highcard, lowcard);

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
		NSOExpl_SuboptCP t1
	where t0.runid = t1.runid
	 and t0.querynum = t1.querynum
	 and t0.upper_card = t1.highcard
	 and t0.lower_card = t1.lowcard;
ALTER TABLE NSO_RD_SubOpt ADD PRIMARY KEY (runid, querynum, upper_card, lower_card);

DROP TABLE NSO_SubOpt_Gen CASCADE CONSTRAINTS;
CREATE TABLE NSO_SubOpt_Gen  AS
	select t0.dbms, 
	       t0.runid,
	       t0.querynum,
	       t0.upper_gen as gen_num,
	       t0.upper_card,
	       t0.lower_card
	from NSO_Newer_Gen_at_Upper_Card t0,
	     NSOExpl_SuboptCP t1
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
		NSOExpl_SuboptCP t1
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


