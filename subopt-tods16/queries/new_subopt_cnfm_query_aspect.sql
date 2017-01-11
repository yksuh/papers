-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 01/02/17
-- Final Revision: 01/02/17
-- Description: Define additional queries for new variables---number of repeats, presence of secondary indexes, data skew, and presence of subqueries

--- Variable: Number of Repeats
-- Obtain all the plans per query
-- NSOCnfm_TPQ: NSOCnfm_Total_Plans_at_QueryNSOCnfm
DROP TABLE NSOCnfm_TPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_TPQ AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t1.card,
		t1.planid -- lower plan
	FROM	NSOCnfm_S0_AQE t0,
		NSOCnfm_S0_AQE t1
	WHERE t0.runid = t1.runid 
	and t0.querynum = t1.querynum 
	and t0.qenum = t1.qenum and t0.qenum = 1
	and ((t0.dbms <> 'mysql' and t0.card = t1.card+10000) or (t0.dbms = 'mysql' and t0.card = t1.card+300))
	and t1.planid <> t0.planid
	--and t0.runid = 229 and t0.querynum IN (4, 8, 9)
	UNION
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t0.card,
		t0.planid -- 2M (or 60K) plan
	FROM	NSOCnfm_S0_AQE t0
	WHERE ((t0.dbms <> 'mysql' and t0.card = 2000000) or (t0.dbms = 'mysql' and t0.card = 60000))
	and t0.qenum = 1
	;
ALTER TABLE NSOCnfm_TPQ ADD PRIMARY KEY (dbms, runid, querynum, card, planid);
--select * from NSOCnfm_TPQ order by card desc

-- Count the number of plans per query
-- NSOCnfm_TPQ: NSOCnfm_Count_Total_Plans_at_Query
DROP TABLE NSOCnfm_CTPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_CTPQ AS
	SELECT t0.dbms,
	       t0.runid,
	       t0.querynum, 
	       count(t0.planid) as num_of_plans
	FROM NSOCnfm_TPQ t0
	GROUP BY dbms, runid, querynum;
ALTER TABLE NSOCnfm_CTPQ ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOCnfm_CTPQ where runid = 2019 and querynum = 5

-- Count the number of distinct plans per query
-- NSOCnfm_TPQ: NSOCnfm_Count_Distinct_Plans_at_Query
DROP TABLE NSOCnfm_CDPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_CDPQ AS
	select dbms, runid, querynum, count(distinct planid) as num_of_dis_plans
	from NSOCnfm_TPQ
	group by dbms, runid, querynum;
ALTER TABLE NSOCnfm_CDPQ ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOCnfm_CDPQ

-- Compute the number of repeats per query
-- NSOCnfm_NRPQ: NSOCnfm_Number_of_RepeatedPlans_at_Query
DROP TABLE NSOCnfm_NRPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_NRPQ AS
	select t0.dbms, t0.runid, t0.querynum, (t0.num_of_plans-t1.num_of_dis_plans) as num_repeats
	from NSOCnfm_CTPQ t0, NSOCnfm_CDPQ t1
	where t0.dbms = t1.dbms 
  	and t0.runid = t1.runid
	and t0.querynum = t1.querynum
	order by t0.dbms, t0.runid, t0.querynum asc
	;
ALTER TABLE NSOCnfm_NRPQ ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOCnfm_NRPQ  where runid = 2019 and querynum = 3
-- select * from NSOCnfm_NRPQ  where runid = 2037 and querynum = 17
--- Variable: Presence of Primary Key
---- Figure out the presence of primary key
-- NSOCnfm_PK: NSOCnfm_Primary_Key_presence
DROP TABLE NSOCnfm_PK CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_PK AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%pk%' THEN 1 -- presence
		    ELSE 0 -- absence
		END ) pk_pr
	FROM NSOCnfm_ACTQatC t0;
ALTER TABLE NSOCnfm_PK ADD PRIMARY KEY (dbms, runid, querynum);

--- Variable: Presence of Secondary Indexes
---- Figure out the presence of secondary indexes 
-- NSOCnfm_Sec_Idx: NSOCnfm_Secondary_Index_presence
DROP TABLE NSOCnfm_Sec_Idx CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_Sec_Idx AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%idx%' THEN 1 -- presence
		    ELSE 0 -- absence
		END ) sec_idx_pr
	FROM NSOCnfm_ACTQatC t0;
ALTER TABLE NSOCnfm_Sec_Idx ADD PRIMARY KEY (dbms, runid, querynum);

--- Variable: Presence of Subqueries
---- Figure out the presence of subquery
-- NSOCnfm_SQ: NSOCnfm_SubQuery_presence
DROP TABLE NSOCnfm_SQ CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_SQ AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%sq%' THEN 1 -- presence
		    ELSE 0 -- absence
		END ) sq_pr
	FROM NSOCnfm_ACTQatC t0;
ALTER TABLE NSOCnfm_SQ ADD PRIMARY KEY (dbms, runid, querynum);

--- Variable: Presence of Data Skew
---- Figure out the presence of skewness
-- NSOCnfm_Skew_Presence: NSOCnfm_Skew_presence
DROP TABLE NSOCnfm_Skew CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_Skew AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%skew%' THEN 0 -- no skew
		    ELSE 1 -- skew presence
		END ) skew_pr
	FROM NSOCnfm_ACTQatC t0;
ALTER TABLE NSOCnfm_Skew ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOCnfm_Skew where runid = 2037 and querynum =17
--select * from NSOCnfm_Skew where runid = 2019 and querynum =5

---- Gather all the column values regarding the new variables
-- NSOCnfm_All_New_Var: NSOCnfm_All_New_Varirable_data
DROP TABLE NSOCnfm_All_New_Var CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_All_New_Var AS
	SELECT t1.dbms, 
		t1.runid,
		t1.querynum,
		t0.pk_pr, 	-- presence of primary keys
		t1.num_repeats, -- number of repeats
		t2.sec_idx_pr,	-- presence of secondary indexes
		t3.sq_pr,	-- presence of subqueries
		t4.skew_pr	-- presence of data skew
	FROM NSOCnfm_PK      t0, 
	     NSOCnfm_NRPQ    t1, 
	     NSOCnfm_Sec_Idx t2,
	     NSOCnfm_SQ      t3,
	     NSOCnfm_Skew    t4
	WHERE t0.dbms = t1.dbms 
	and t1.dbms = t2.dbms 
	and t2.dbms = t3.dbms
	and t3.dbms = t4.dbms
	and t0.runid = t1.runid
	and t1.runid = t2.runid 
	and t2.runid = t3.runid 
	and t3.runid = t4.runid 
	and t0.querynum = t1.querynum
	and t1.querynum = t2.querynum
	and t2.querynum = t3.querynum
	and t3.querynum = t4.querynum;
ALTER TABLE NSOCnfm_All_New_Var ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOCnfm_All_New_Var where runid = 2037 and querynum =17;
--select stepName, sum(stepResultSize) from NSOCnfm_rowcount  group by stepname order by stepname;
---- Gather all the column values regarding the new variables after protocol
-- NSOCnfm_S4_New_Var: NSOCnfm_Step4_New_Varirable_data
DROP TABLE NSOCnfm_S4_New_Var CASCADE CONSTRAINTS;
CREATE TABLE NSOCnfm_S4_New_Var AS
	SELECT distinct t1.*
	FROM NSOCnfm_All_New_Var t1,
	     NSOCnfm_S4_CTQatC t2
	WHERE t1.dbms = t2.dbms 
	and t1.runid = t2.runid 
	and t1.querynum = t2.querynum;
ALTER TABLE NSOCnfm_S4_New_Var ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOCnfm_S4_New_Var where runid = 2019 and querynum =11;
--select * from NSOCnfm_S4_New_Var where runid = 1117 and querynum = 3;
--select * from NSOCnfm_S4_New_Var where runid = 1657 and querynum = 3;
--select * from NSOCnfm_S4_New_Var where runid = 439 and querynum = 3;
--select * from NSOCnfm_S4_New_Var where runid = 438 and querynum = 7;
--select * from NSOCnfm_S4_New_Var where runid = 412 and querynum = 3; 
-- select avg(num_repeats) from NSOCnfm_S4_New_Var;
-- select count(*) from NSOCnfm_S4_New_Var;
-- select count(*) from NSOCnfm_S4_CTQatC;
-- select distinct dbms, runid, querynum from NSOCnfm_S4_CTQatC minus select distinct dbms, runid, querynum from NSOCnfm_S4_New_Var

