DROP TABLE NSOMySQL_MAXCardP CASCADE CONSTRAINTS;
CREATE TABLE NSOMySQL_MAXCardP AS
	SELECT  ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.cardinality AS card,
		qp.planid			
	FROM  AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      NSOOper_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	WHERE er.DBMSNAME = 'mysql' AND 
	      qe.cardinality = 60000 AND
              ex.experimentid=er.experimentid AND 
	      er.runid=c_run.runid AND 
              c_run.runid=q.runid AND
	      q.queryid=qe.queryid AND qe.ITERNUM = 1 AND -- all QatCs
              qe.queryexecutionid=qp.queryexecutionid  -- all QPs
	      er.currentstage  ='Completed' AND
              er.percentage = 100
	UNION
	SELECT  ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.cardinality AS card,
		qp.planid			
	FROM  AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      NSOOper_PK_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	WHERE er.DBMSNAME = 'mysql' AND 
	      qe.cardinality = 60000 AND
              ex.experimentid=er.experimentid AND 
	      er.runid=c_run.runid AND 
              c_run.runid=q.runid AND
	      q.queryid=qe.queryid AND qe.ITERNUM = 1 AND -- all QatCs
              qe.queryexecutionid=qp.queryexecutionid AND -- all QPs
	      er.currentstage  ='Completed' AND
              er.percentage = 100;
ALTER TABLE NSOMySQL_MAXCardP ADD PRIMARY KEY (runid, querynum, card, planid);

DROP TABLE NSOMySQL_SecCard CASCADE CONSTRAINTS;
CREATE TABLE NSOMySQL_SecCard AS
	SELECT  q.runid,
		q.queryNumber AS querynum,
		max(qe.cardinality) AS sec_card		
	FROM  AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      NSOOper_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	WHERE er.DBMSNAME = 'mysql' AND 
	      qe.cardinality < 60000 AND
              ex.experimentid=er.experimentid AND 
	      er.runid=c_run.runid AND 
              c_run.runid=q.runid AND
	      q.queryid=qe.queryid AND qe.ITERNUM = 1 AND -- all QatCs
              qe.queryexecutionid=qp.queryexecutionid AND -- all QPs
	      er.currentstage  ='Completed' AND
              er.percentage = 100
	group by q.runid, q.queryNumber
	UNION
	SELECT  q.runid,
		q.queryNumber AS querynum,
		max(qe.cardinality) AS sec_card		
	FROM  AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      NSOOper_PK_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	WHERE er.DBMSNAME = 'mysql' AND 
	      qe.cardinality < 60000 AND
              ex.experimentid=er.experimentid AND 
	      er.runid=c_run.runid AND 
              c_run.runid=q.runid AND
	      q.queryid=qe.queryid AND qe.ITERNUM = 1 AND -- all QatCs
              qe.queryexecutionid=qp.queryexecutionid AND -- all QPs
	      er.currentstage  ='Completed' AND
              er.percentage = 100
	group by q.runid, q.queryNumber
	order by runid, querynum
	;
ALTER TABLE NSOMySQL_SecCard ADD PRIMARY KEY (runid, querynum, sec_card);
--select * from NSOMySQL_SecCard where runid = 2120 and querynum = 13

DROP TABLE NSOMySQL_SecCardP CASCADE CONSTRAINTS;
CREATE TABLE NSOMySQL_SecCardP AS
	SELECT --distinct
	       t0.*,
	       qp.planid 	
	FROM  NSOMySQL_SecCard t0,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp
	WHERE t0.runid=q.runid AND 
	      t0.querynum = q.querynumber AND
	      t0.sec_card = qe.cardinality AND
	      q.queryid=qe.queryid AND qe.ITERNUM = 1 AND -- all QatCs
              qe.queryexecutionid=qp.queryexecutionid-- all QPs
	;
--ALTER TABLE NSOMySQL_SecCardP ADD PRIMARY KEY (runid, querynum, sec_card, planid);
--select * from NSOMySQL_SecCardP where runid = 2120 and querynum = 13

DROP TABLE NSOMySQL_WrongQatCs CASCADE CONSTRAINTS;
CREATE TABLE NSOMySQL_WrongQatCs AS
	SELECT t0.experimentname as expName,
	       t0.runid,
	       t0.querynum,
	       t0.card as max_card,
	       t0.planid as max_plan,
	       t1.sec_card,
	       t1.planid as sec_plan	
	FROM  NSOMySQL_MaxCardP t0,
	      NSOMySQL_SecCardP t1
	WHERE t0.runid=t1.runid AND
	      t0.querynum=t1.querynum AND 
              t0.planid <> t1.planid
	order by runid, querynum, max_card desc, sec_card desc
	;
--ALTER TABLE NSOMySQL_WrongQatCs ADD PRIMARY KEY (runid, querynum);
-- select * from NSOMySQL_WrongQatCs order by runid, querynum, max_card desc
-- select count(*) from NSOMySQL_WrongQatCs order by runid, querynum, max_card desc


select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 412
and q.querynumber = 96
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc


select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 33
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber =  0
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc



select runid, querynum, card
from nsocnfm_qed
having count(qenum) > 10
group by runid, querynum, card
order by runid, querynum, card desc






DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM NEWER_GEN_NUM UPPER_CARD LOWER_CARD  REL_DELTA
---------- ---------- ------------- ---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
mysql
      2120	   13		  5	 29400	    29100    -768.59
ALL:Full Table Scan with Join,ALL:Full Table Scan,eq_ref,ref
ALL:Full Table Scan,eq_ref,index,ref


select avg(rel_delta), max(rel_delta) from NSO_Calc_RD where rel_delta < 0

select * from NSO_Newer_Gen_at_Lower_Card where runid = 2120 and querynum = 13
select * from NSO_Newer_Gen_at_Upper_Card where runid = 2120 and querynum = 13

select * from NSO_Lower_EQT where runid = 2120 and querynum = 13
select * from NSO_Upper_EQT where runid = 2120 and querynum = 13

select * from NSO_Upper_EQT where runid = 2120 and querynum = 13;

SQL> select * from NSO_Lower_EQT where runid = 2120 and querynum = 13;

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM  UPPER_GEN  LOWER_GEN NEAREST_CARD UPPER_CARD LOWER_CARD
---------- ---------- ---------- ---------- ------------ ---------- ----------
NEAREST_CQT  UPPER_CQT	LOWER_CQT LOWER_EP_CQT
----------- ---------- ---------- ------------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
mysql
      2120	   13	       4	  5	   30600      29400	 29100
     151745	141170	      180     138526.3
ALL:Full Table Scan with Join,ALL:Full Table Scan,eq_ref,ref
ALL:Full Table Scan,eq_ref,index,ref

151745 - 141170
30600 - 29400 

SQL> select * from NSO_Newer_Gen_at_Lower_Card where runid = 2120 and querynum = 13;

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM UPPER_CARD LOWER_CARD  UPPER_GEN	LOWER_GEN UPPER_PLAN
---------- ---------- ---------- ---------- ---------- ---------- ----------
LOWER_PLAN  UPPER_CQT  LOWER_CQT
---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
mysql
      2120	   13	   30600      30300	     4		5 -4.183E+18
-6.749E+18     151745	     190
ALL:Full Table Scan with Join,ALL:Full Table Scan,eq_ref,ref
ALL:Full Table Scan,eq_ref,index,ref

mysql
      2120	   13	   29400      29100	     4		5 -4.183E+18
-6.749E+18     141170	     180
ALL:Full Table Scan with Join,ALL:Full Table Scan,eq_ref,ref
ALL:Full Table Scan,eq_ref,index,ref

select runid, querynum, card
from nsocnfm_aqed
having count(qenum) > 10
group by runid, querynum, card
order by runid, querynum, card desc

     RUNID   QUERYNUM	    CARD
---------- ---------- ----------
       658	   26	   30300
       658	   56	   30300
       658	   93	   30300
       716	   87	   30000
       816	   42	   30900
       897	  119	   31200
       898	   79	   30300
       899	   37	   30300
       957	   57	   30000
      1097	   37	   30600
      1097	   52	   30600
      1097	   63	   31500
      1097	   73	   31500
      1097	   81	   31500
      1097	   86	   31500
      2037	   73	   31200
      2060	   60	   30900
      2060	   96	   30600
      2120	    8	   30600
      2120	   33	   30600
      2120	   60	   30600
      2120	   84	   30600
      2257	   50	   30600
      2257	   61	   31200
      2257	   68	   30600
      2257	   93	   30600

26 rows selected.

select runid, querynum, card
from nsocnfm_qed
having count(qenum) > 10
group by runid, querynum, card
order by runid, querynum, card desc

select experimentname, runid, querynum, card, med_calc_qt, planid
from nsocnfm_actqatc 
where runid = 2120 and querynum = 13
order by card desc

select experimentname, runid, querynum, card, med_calc_qt, planid
from nsocnfm_s4_ctqatc 
where runid = 2120 and querynum = 13
order by card desc

EXPERIMENTNAME
--------------------------------------------------------------------------------
     RUNID   QUERYNUM	    CARD MED_CALC_QT	 PLANID
---------- ---------- ---------- ----------- ----------
op-pk-30K-100sq1-idx
      2120	   13	   60000	 310 -6.749E+18

op-pk-30K-100sq1-idx
      2120	   13	   30600      151745 -4.183E+18

op-pk-30K-100sq1-idx
      2120	   13	   30300	 190 -6.749E+18

op-pk-30K-100sq1-idx
      2120	   13	   29400      141170 -4.183E+18

op-pk-30K-100sq1-idx
      2120	   13	   29100	 180 -6.749E+18

op-pk-30K-100sq1-idx
      2120	   13	   28800	 110 5.2135E+18


6 rows selected.


select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 13
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2224374       2120	     13       60000	     1 -6.749E+18
	 2224968       2120	     13       30600	     1 -4.183E+18
	 2225241       2120	     13       30300	     1 -6.749E+18
	 2225300       2120	     13       29400	     1 -4.183E+18
	 2225549       2120	     13       29100	     1 -6.749E+18
	 2225570       2120	     13       28800	     1 5.2135E+18

6 rows selected.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 33
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 66
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 66
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

