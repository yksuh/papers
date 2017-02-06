-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 06/29/15
-- Final Revision: 07/15/15
-- Description: Define additional queries for new variables---number of repeats, presence of secondary indexes, data skew, and presence of subqueries

--- Variable: Number of Repeats
-- Obtain all the plans per query
-- NSOExpl_TPQ: NSOExpl_Total_Plans_at_Query
DROP TABLE NSOExpl_TPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_TPQ AS
	SELECT	t0.dbms,
	 	t0.runid,
		t0.querynum,
		t1.card,
		t1.planid -- lower plan
	FROM	NSOExpl_S0_AQE t0,
		NSOExpl_S0_AQE t1
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
	FROM	NSOExpl_S0_AQE t0
	WHERE ((t0.dbms <> 'mysql' and t0.card = 2000000) or (t0.dbms = 'mysql' and t0.card = 60000))
	and t0.qenum = 1
	;
ALTER TABLE NSOExpl_TPQ ADD PRIMARY KEY (dbms, runid, querynum, card, planid);
--select * from NSOExpl_TPQ order by card desc

-- Count the number of plans per query
-- NSOExpl_TPQ: NSOExpl_Count_Total_Plans_at_Query
DROP TABLE NSOExpl_CTPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_CTPQ AS
	SELECT t0.dbms,
	       t0.runid,
	       t0.querynum, 
	       count(t0.planid) as num_of_plans
	FROM NSOExpl_TPQ t0
	GROUP BY dbms, runid, querynum;
ALTER TABLE NSOExpl_CTPQ ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOExpl_CTPQ where runid = 2019 and querynum = 5

-- Count the number of distinct plans per query
-- NSOExpl_TPQ: NSOExpl_Count_Distinct_Plans_at_Query
DROP TABLE NSOExpl_CDPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_CDPQ AS
	select dbms, runid, querynum, count(distinct planid) as num_of_dis_plans
	from NSOExpl_TPQ
	group by dbms, runid, querynum;
ALTER TABLE NSOExpl_CDPQ ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOExpl_CDPQ

-- Compute the number of repeats per query
-- NSOExpl_NRPQ: NSOExpl_Number_of_RepeatedPlans_at_Query
DROP TABLE NSOExpl_NRPQ CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_NRPQ AS
	select t0.dbms, t0.runid, t0.querynum, (t0.num_of_plans-t1.num_of_dis_plans) as num_repeats
	from NSOExpl_CTPQ t0, NSOExpl_CDPQ t1
	where t0.dbms = t1.dbms 
  	and t0.runid = t1.runid
	and t0.querynum = t1.querynum
	order by t0.dbms, t0.runid, t0.querynum asc
	;
ALTER TABLE NSOExpl_NRPQ ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOExpl_NRPQ  where runid = 2019 and querynum = 3
-- select * from NSOExpl_NRPQ  where runid = 2037 and querynum = 17
--- Variable: Presence of Primary Key
---- Figure out the presence of primary key
-- NSOExpl_PK: NSOExpl_Primary_Key_presence
DROP TABLE NSOExpl_PK CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_PK AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%pk%' THEN 1 -- presence
		    ELSE 0 -- absence
		END ) pk_pr
	FROM NSOExpl_ACTQatC t0;
ALTER TABLE NSOExpl_PK ADD PRIMARY KEY (dbms, runid, querynum);

--- Variable: Presence of Secondary Indexes
---- Figure out the presence of secondary indexes 
-- NSOExpl_Sec_Idx: NSOExpl_Secondary_Index_presence
DROP TABLE NSOExpl_Sec_Idx CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_Sec_Idx AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%idx%' THEN 1 -- presence
		    ELSE 0 -- absence
		END ) sec_idx_pr
	FROM NSOExpl_ACTQatC t0;
ALTER TABLE NSOExpl_Sec_Idx ADD PRIMARY KEY (dbms, runid, querynum);

--- Variable: Presence of Subqueries
---- Figure out the presence of subquery
-- NSOExpl_SQ: NSOExpl_SubQuery_presence
DROP TABLE NSOExpl_SQ CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_SQ AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%sq%' THEN 1 -- presence
		    ELSE 0 -- absence
		END ) sq_pr
	FROM NSOExpl_ACTQatC t0;
ALTER TABLE NSOExpl_SQ ADD PRIMARY KEY (dbms, runid, querynum);

--- Variable: Presence of Data Skew
---- Figure out the presence of skewness
-- NSOExpl_Skew_Presence: NSOExpl_Skew_presence
DROP TABLE NSOExpl_Skew CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_Skew AS
	SELECT distinct
		t0.dbms, 
		t0.runid, 
		t0.querynum, 
		(CASE
		    WHEN (t0.experimentname) like '%skew%' THEN 0 -- no skew
		    ELSE 1 -- skew presence
		END ) skew_pr
	FROM NSOExpl_ACTQatC t0;
ALTER TABLE NSOExpl_Skew ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOExpl_Skew where runid = 2037 and querynum =17
--select * from NSOExpl_Skew where runid = 2019 and querynum =5

---- Gather all the column values regarding the new variables
-- NSOExpl_All_New_Var: NSOExpl_All_New_Varirable_data
DROP TABLE NSOExpl_All_New_Var CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_All_New_Var AS
	SELECT t1.dbms, 
		t1.runid,
		t1.querynum,
		t0.pk_pr, 	-- presence of primary keys
		t1.num_repeats, -- number of repeats
		t2.sec_idx_pr,	-- presence of secondary indexes
		t3.sq_pr,	-- presence of subqueries
		t4.skew_pr	-- presence of data skew
	FROM NSOExpl_PK      t0, 
	     NSOExpl_NRPQ    t1, 
	     NSOExpl_Sec_Idx t2,
	     NSOExpl_SQ      t3,
	     NSOExpl_Skew    t4
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
ALTER TABLE NSOExpl_All_New_Var ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOExpl_All_New_Var where runid = 2037 and querynum =17;
--select stepName, sum(stepResultSize) from nsoexpl_rowcount  group by stepname order by stepname;
---- Gather all the column values regarding the new variables after protocol
-- NSOExpl_S4_New_Var: NSOExpl_Step4_New_Varirable_data
DROP TABLE NSOExpl_S4_New_Var CASCADE CONSTRAINTS;
CREATE TABLE NSOExpl_S4_New_Var AS
	SELECT distinct t1.*
	FROM NSOExpl_All_New_Var t1,
	     NSOExpl_S4_CTQatC t2
	WHERE t1.dbms = t2.dbms 
	and t1.runid = t2.runid 
	and t1.querynum = t2.querynum;
ALTER TABLE NSOExpl_S4_New_Var ADD PRIMARY KEY (dbms, runid, querynum);
--select * from NSOExpl_S4_New_Var where runid = 2019 and querynum =11;
--select * from NSOExpl_S4_New_Var where runid = 1117 and querynum = 3;
--select * from NSOExpl_S4_New_Var where runid = 1657 and querynum = 3;
--select * from NSOExpl_S4_New_Var where runid = 439 and querynum = 3;
--select * from NSOExpl_S4_New_Var where runid = 438 and querynum = 7;
--select * from NSOExpl_S4_New_Var where runid = 412 and querynum = 3; 
-- select avg(num_repeats) from NSOExpl_S4_New_Var;
-- select count(*) from NSOExpl_S4_New_Var;
-- select count(*) from NSOExpl_S4_CTQatC;
-- select distinct dbms, runid, querynum from NSOExpl_S4_CTQatC minus select distinct dbms, runid, querynum from NSOExpl_S4_New_Var
SQL> select distinct dbms, runid, querynum from NSOExpl_S4_CTQatC minus select distinct dbms, runid, querynum from NSOExpl_S4_New_Var;

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM
---------- ----------
mysql
       231	   87
select dbms, runid, querynum, card, qeid from NSOExpl_S0_AQE where runid = 231 and querynum = 87
select dbms, runid, querynum, card, qeid from NSOExpl_QED where runid = 231 and querynum = 87
delete from NSOExpl_S4_CTQatC where runid = 231 and querynum = 87 and card = 30900
