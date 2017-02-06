CREATE TABLE Cnfm_Analysis_SuboptDefn AS
SELECT qc1.experimentid, qc1.experimentname, qc1.dbms, qc1.runid, qc1.queryNum,
  qc1.card as HighCard, qc1.med_calc_qt AS MedianHighCard,
  qc1.std_calc_qt AS SDHighCard, qc2.med_calc_qt AS MedianLowCard, qc2.std_calc_qt AS SDLowCard,
  qc2.card as LowCard, qc1.planid AS PlHighCard, qc2.planid PlLowCard,
  CASE WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))< 0 THEN 0 WHEN (qc2.med_calc_qt-(0.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(0.5*qc1.std_calc_qt))>= 0
   AND (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))< 0 THEN 1 WHEN (qc2.med_calc_qt-(1.0*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.0*qc1.std_calc_qt))>= 0
   AND (qc2.med_calc_qt-(1.5*qc2.std_calc_qt))-(qc1.med_calc_qt+(1.5*qc1.std_calc_qt))< 0 THEN 2 ELSE 3 END AS Subopt_SD
  , 100*(qc2.med_calc_qt-qc1.med_calc_qt)/qc1.med_calc_qt AS Subopt_rel
FROM NSOCnfm_S4_CTQatC qc1, NSOCnfm_S4_CTQatC qc2
WHERE qc1.experimentid=qc1.experimentid
AND qc1.runid=qc2.runid
AND qc1.querynum=qc2.querynum
and ((qc1.dbms='mysql' and qc1.card=qc2.card+300)
OR (qc1.dbms!='mysql' and qc1.card=qc2.card+10000))
and qc1.planid<>qc2.planid;





select count(*)
from 
(select experimentid, dbms, runid, queryNum, max(Subopt_rel) as max_sor 
from Cnfm_Analysis_SuboptDefn 
group by experimentid, dbms, runid, queryNum
having max(Subopt_rel)>0)

select count(*)
from 
(select experimentid, dbms, runid, queryNum, max(Subopt_rel) as max_sor 
from Cnfm_Analysis_SuboptDefn 
group by experimentid, dbms, runid, queryNum
having max(Subopt_rel)<0)

WITH subopt1 AS (select experimentid, dbms, runid, queryNum, max(Subopt_rel) as max_sor from Cnfm_Analysis_SuboptDefn group by experimentid, dbms, runid, queryNum
having max(Subopt_rel)>0) SELECT CASE WHEN max_sor>=72000 THEN 'GT= 72000%'  WHEN max_sor>=71000 THEN 'GT= 71000%' WHEN max_sor>=40000 THEN 'GT= 40000%' WHEN max_sor>=30000 THEN 'GT= 30000%' WHEN max_sor>=20000 THEN 'GT= 20000%' WHEN max_sor>=10000 THEN 'GT= 10000%' WHEN max_sor>=5000 THEN 'GT= 5000%' WHEN max_sor>=2500 THEN 'GT= 2500%' WHEN max_sor>=1000 THEN 'GT= 1000%' WHEN max_sor>=500 THEN 'GT= 500%' WHEN max_sor>=250 THEN 'GT= 250%' WHEN max_sor>=100 THEN 'GT= 100%' WHEN max_sor>=70 THEN 'GT= 70%' WHEN max_sor>=60 THEN 'GT= 60%' WHEN max_sor>=50 THEN 'GT= 50%' WHEN max_sor>=40 THEN 'GT= 40%' WHEN max_sor>=30 THEN 'GT= 30%' WHEN max_sor>=20 THEN 'GT= 20%' WHEN max_sor>=10 THEN 'GT= 10%' ELSE 'GT 0' END AS SuboptRanges, COUNT(*) FROM subopt1 a GROUP BY CASE WHEN max_sor>=72000 THEN 'GT= 72000%'  WHEN max_sor>=71000 THEN 'GT= 71000%' WHEN max_sor>=40000 THEN 'GT= 40000%' WHEN max_sor>=30000 THEN 'GT= 30000%' WHEN max_sor>=20000 THEN 'GT= 20000%' WHEN max_sor>=10000 THEN 'GT= 10000%' WHEN max_sor>=5000 THEN 'GT= 5000%' WHEN max_sor>=2500 THEN 'GT= 2500%' WHEN max_sor>=1000 THEN 'GT= 1000%' WHEN max_sor>=500 THEN 'GT= 500%' WHEN max_sor>=250 THEN 'GT= 250%' WHEN max_sor>=100 THEN 'GT= 100%' WHEN max_sor>=70 THEN 'GT= 70%' WHEN max_sor>=60 THEN 'GT= 60%' WHEN max_sor>=50 THEN 'GT= 50%' WHEN max_sor>=40 THEN 'GT= 40%' WHEN max_sor>=30 THEN 'GT= 30%' WHEN max_sor>=20 THEN 'GT= 20%' WHEN max_sor>=10 THEN 'GT= 10%' ELSE 'GT 0' END ORDER BY SuboptRanges;


SQL> select sum(stepResultSize) from NSOCnfm_RowCount where stepname ='NSOCnfm_SPQatC';

SUM(STEPRESULTSIZE)
-------------------
	     452684

SQL> select sum(ExcQCTViolsPerRun) from NSOCnfm_S5_EQCTV;

SUM(EXCQCTVIOLSPERRUN)
----------------------
		     3

SQL> select sum(stepResultSize) from NSOCnfm_RowCount where stepname ='NSOCnfm_S5_TSM';

SUM(STEPRESULTSIZE)
-------------------
	       3347

SQL> select sum(stepResultSize) from NSOCnfm_RowCount where stepname ='NSOCnfm_S5_TRM';

SUM(STEPRESULTSIZE)
-------------------
	       1966

SQL> select count(querynum) from (select distinct runid, querynum from NSOCnfm_S4_CTQatC) 

COUNT(QUERYNUM)
---------------
	   6983

SQL> select count(*) from NSOCnfm_QED;

  COUNT(*)
----------
    890631

SQL> select count(*) from NSOCnfm_S4_CTQatC;

  COUNT(*)
----------
     94502


select min(Subopt_rel), max(Subopt_rel)
from Cnfm_Analysis_SuboptDefn 



	select tot_subopt, count(t0.querynum) as numSubOptQs
	from (select distinct dbms, runid, querynum, sum(subopt_sd) as tot_subopt
	from Cnfm_Analysis_SuboptDefn 
	group by dbms, runid, querynum) t0
	group by tot_subopt 
	order by tot_subopt asc

TOT_SUBOPT NUMSUBOPTQS
---------- -----------
	 0	  3033
	 1	   246
	 2	   182
	 3	  1262
	 4	   200
	 5	   189
	 6	   512
	 7	   103
	 8	    79
	 9	   206
	10	    71
	11	    54
	12	    79
	13	    38
	14	    46
	15	    67
	16	    26
	17	    37
	18	    47
	19	    21
	20	    23
	21	    52
	22	    19
	23	    20
	24	    34
	25	    22
	26	    10
	27	    30
	28	    11
	29	     8
	30	    23
	31	    10
	32	     6
	33	    15
	34	     6
	35	     3
	36	    13
	37	     7
	38	     4
	39	     8
	40	     1
	41	     4
	42	     6
	43	     9
	44	     3
	45	     5
	46	     5
	47	     1
	48	     2
	49	     3
	50	     4
	51	     9
	52	     4
	53	     3
	54	    10
	55	     3
	56	     4
	57	     3
	58	     6
	59	     2
	60	     5
	61	     4
	62	     2
	63	     4
	64	     2
	65	     2
	66	     4
	69	     5
	70	     1
	71	     1
	72	     3
	74	     1
	75	     2
	77	     1
	78	     1
	80	     1
	83	     3
	84	     4
	85	     1
	87	     2
	88	     2
	89	     1
	93	     1
       100	     2
       103	     1
       133	     1

select count(t0.querynum) as numSubOptQs
from (select distinct dbms, runid, querynum, sum(subopt_sd) as tot_subopt
from Cnfm_Analysis_SuboptDefn 
group by dbms, runid, querynum) t0
where tot_subopt > 0

NUMSUBOPTQS
-----------
       3933

SQL> select count(t0.querynum) as numSubOptQs
from (select distinct dbms, runid, querynum 
from Cnfm_Analysis_SuboptDefn) t0  2    3  ;

NUMSUBOPTQS
-----------
       6966

select count(t0.querynum) as numSubOptQs
from (select distinct dbms, runid, querynum, coalesce(count(highcard),0) as numQatCs
from Cnfm_Analysis_SuboptDefn 
group by dbms, runid, querynum) t0 
where numQatCs = 2

NUMSUBOPTQS
-----------
       2338

select count(t0.querynum) as numQsPosCP
from (select distinct dbms, runid, querynum 
from NSOCnfm_S4_CTQatC 
having count(card) > 1
group by dbms, runid, querynum) t0

NUMQSPOSCP
----------
      5625

select count(t0.querynum) as numSubOptQs
from (select distinct dbms, runid, querynum, count(highcard) as cards
      from Cnfm_Analysis_SuboptDefn 
      group by dbms, runid, querynum) t0 
where cards = 1

NUMSUBOPTQS
-----------
       2338

select count(t0.querynum) as numQsPosCP
from (select distinct dbms, runid, querynum 
from NSOCnfm_ACTQatC 
having count(card) = 1
group by dbms, runid, querynum) t0

select count(t0.querynum) as numQsPosCP
from (select distinct dbms, runid, querynum 
from NSOCnfm_S4_CTQatC 
having count(card) = 1
group by dbms, runid, querynum) t0

NUMQSPOSCP
----------
      1358

select count(t0.querynum) as numSubOptQs
from (select distinct dbms, runid, querynum, sum(subopt_sd) as tot_subopt
from Cnfm_Analysis_SuboptDefn 
group by dbms, runid, querynum) t0
where tot_subopt = 0

NUMSUBOPTQS
-----------
       3033

select count(t0.querynum) as numMedSubOptQs
from (select distinct dbms, runid, querynum
from Cnfm_Analysis_SuboptDefn 
where Subopt_rel > 20 
group by dbms, runid, querynum) t0

NUMMEDSUBOPTQS
--------------
	  1917

select count(t0.querynum) as numHighSubOptQs
from (select distinct dbms, runid, querynum
from Cnfm_Analysis_SuboptDefn 
where Subopt_rel > 30 
group by dbms, runid, querynum) t0

NUMMEDSUBOPTQS
--------------
	  1341

select numCP, count(querynum) as numQs 
from 
(select distinct runid, querynum, coalesce(count(*),0) as numCP
from Cnfm_Analysis_SuboptDefn
group by runid, querynum) t0
group by numCP 
order by numCP asc

     NUMCP	NUMQS
---------- ----------
	 1	 2338
	 2	  785
	 3	  734
	 4	  546
	 5	  386
	 6	  300
	 7	  224
	 8	  149
	 9	  118
	10	  105
	11	  112
	12	  122
	13	   48
	14	   53
	15	   55
	16	   51
	17	   36
	18	   40
	19	   29
	20	   18
	21	   43
	22	   34
	23	   17
	24	   19
	25	   27
	26	   17
	27	   14
	28	   19
	29	   23
	30	   22
	31	   22
	32	   20
	33	   26
	34	   29
	35	    9
	36	   16
	37	   15
	38	   14
	39	   13
	40	   17
	41	   20
	42	   22
	43	    7
	44	   17
	45	   10
	46	   15
	47	   17
	48	   18
	49	   10
	50	    7
	51	    7
	52	   10
	53	    5
	54	   13
	55	    8
	56	    5
	57	    8
	58	    8
	59	    7
	60	   11
	61	    6
	62	    4
	63	    4
	64	    6
	65	    4
	66	    2
	67	    4
	68	    5
	69	    5
	70	    5
	71	    2
	72	    2
	73	    3
	74	    2
	75	    2
	77	    1
	78	    2
	79	    1
	80	    1
	81	    2
	82	    3
	83	    1
	84	    1
	87	    2
	88	    1
	89	    1
	92	    1
       119	    1
       122	    1
       130	    1

90 rows selected.

