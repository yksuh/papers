
select genNum, round(avg(numQatCs),0) as avgCPQ, max(numQatCs) as maxCPQ
from  (select runid, querynum, genNum, count(distinct card) as numQatCs 
      from NSO_Gen_Stat_at_QatC 
      group by runid, querynum, genNum) 
group by genNum
order by genNum asc

    GENNUM     AVGCPQ	  MAXCPQ
---------- ---------- ----------
	 1	    1	       1
	 2	    5	      66
	 3	   13	     115
	 4	    9	     136
	 5	   14	     132
	 6	   15	     141
	 7	    4	      42
	 8	   12	     172
	 9	    1	       2
	10	    3	      12
	11	    6	      55
	12	    7	      29
	13	    1	       1

13 rows selected.


select genNum, round(avg(numQatCs),0) as avgPCPQ, max(numQatCs) as maxPCPQ
from  (select runid, querynum, genNum, planid, count(distinct card) as numQatCs 
      from NSO_Gen_Stat_at_QatC 
      group by runid, querynum, genNum, planid) 
group by genNum
order by genNum asc

    GENNUM    AVGPCPQ	 MAXPCPQ
---------- ---------- ----------
	 1	    1	       1
	 2	    2	      25
	 3	    4	      64
	 4	    3	      74
	 5	    5	      51
	 6	    4	      52
	 7	    2	      19
	 8	    4	      57
	 9	    1	       2
	10	    2	       6
	11	    3	      31
	12	    2	      10
	13	    1	       1

13 rows selected.



select dbms, genNum, round(avg(numQatCs),0) as avgPCPQ, max(numQatCs) as maxPCPQ
from  (select dbms, runid, querynum, genNum, planid, count(distinct card) as numQatCs 
      from NSO_Gen_Stat_at_QatC 
      group by dbms, runid, querynum, genNum, planid) 
group by dbms, genNum
order by dbms, genNum asc

DBMS
--------------------------------------------------------------------------------
    GENNUM    AVGPCPQ	 MAXPCPQ
---------- ---------- ----------
db2
	 3	    3	      64

db2
	 4	    5	      56

db2
	 5	    4	      44

db2
	 6	    4	      52

db2
	 7	    2	      11

db2
	 9	    1	       2

db2
	11	    3	      31

db2
	13	    1	       1

mysql
	 1	    1	       1

mysql
	 2	    2	       5

mysql
	 4	    2	       5

mysql
	 5	    2	       5

oracle
	 2	    2	      25

oracle
	 3	    2	      29

oracle
	 4	    2	      25

oracle
	 5	    2	       6

oracle
	 6	    2	      17

oracle
	 7	    1	       2

pgsql
	 1	    1	       1

pgsql
	 3	    6	      51

pgsql
	 4	    5	      74

pgsql
	 5	    6	      51

pgsql
	 6	    6	      44

pgsql
	 7	    2	      19

pgsql
	 8	    4	      57

pgsql
	10	    2	       6

pgsql
	11	    2	      13

pgsql
	12	    2	      10


28 rows selected.


 ----
select dbms, runid, querynum
 from NSO_Gen_Stat_at_QatC 
where dbms = 'pgsql' 
and genNum = 8 
having count(distinct card) = 172
group by dbms, runid, querynum

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM
---------- ----------
pgsql
      2337	   26

select dbms, runid, querynum
 from NSO_Gen_Stat_at_QatC 
where dbms = 'db2' 
and genNum = 3 
having count(distinct card) = 104
group by dbms, runid, querynum

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM
---------- ----------
db2
      2058	   88

select dbms, genNum, round(avg(numQatCs),0) as avgCPQ, max(numQatCs) as maxCPQ
from  (select dbms, runid, querynum, genNum, count(distinct card) as numQatCs 
      from NSO_Gen_Stat_at_QatC 
      group by dbms, runid, querynum, genNum) 
group by dbms, genNum
order by dbms, genNum asc

DBMS
--------------------------------------------------------------------------------
    GENNUM     AVGCPQ	  MAXCPQ
---------- ---------- ----------
db2
	 3	    9	     104

db2
	 4	   14	      93

db2
	 5	   17	      92

db2
	 6	   16	      95

db2
	 7	    4	      26

db2
	 9	    1	       2

db2
	11	    6	      55

db2
	13	    1	       1

mysql
	 1	    1	       1

mysql
	 2	    3	      10

mysql
	 4	    3	       9

mysql
	 5	    3	       9

oracle
	 2	    7	      66

oracle
	 3	    7	      73

oracle
	 4	    8	      58

oracle
	 5	    4	      16

oracle
	 6	    4	      39

oracle
	 7	    1	       3

pgsql
	 1	    1	       1

pgsql
	 3	   20	     115

pgsql
	 4	   21	     136

pgsql
	 5	   20	     132

pgsql
	 6	   27	     141

pgsql
	 7	    4	      42

pgsql
	 8	   12	     172

pgsql
	10	    3	      12

pgsql
	11	    5	      31

pgsql
	12	    7	      29


28 rows selected.

select dbms, runid, querynum, count(distinct card) as numQatCs 
from NSO_Gen_Stat_at_QatC 
group by dbms, runid, querynum

select dbms, genNum, numQatCs from (select dbms, genNum, count(*) as numQatCs from NSO_Gen_Stat_at_QatC group by dbms, gennum order by dbms, gennum asc)  
order by dbms, genNum asc


--select dbms, runid, querynum, card 
--from NSOExpl_S4_CTQatC t0
--minus
--select dbms, runid, querynum, card 
--from NSO_Gen_Stat_at_QatC
--==> all mysql
-- select count(*) from NSO_Gen_Stat_at_QatC
--  COUNT(*)
----------
--      8544: timeouts: 13 Q@Cs
-- select * from NSO_Gen_Stat_at_QatC where dbms = 'mysql' and generation like '%ALL%'
-- select * from NSO_Gen_Stat_at_QatC where dbms = 'pgsql' and generation like '%HAgg%'
-- select * from NSO_Gen_Stat_at_QatC where dbms = 'pgsql' and generation like '%HashAgg%'




select dbms, runid, querynum, count(distinct card) as ncards
from NSO_Gen_Stat_at_QatC 
where dbms = 'mysql'
having count(distinct card) = 12
group by dbms, runid, querynum

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM	  NCARDS
---------- ---------- ----------
mysql
      2120	   57	      12

mysql
      2120	   10	      12

select card, gennum, med_calc_qt
from NSO_Gen_Stat_at_QatC
where dbms = 'mysql' 
and runid = 2120 
and querynum = 57
order by card desc

      CARD     GENNUM MED_CALC_QT
---------- ---------- -----------
     60000	    5	      250
     45000	    4	   136150
     44700	    5	      200
     44400	    5	      210
     44100	    4	   130620
     43800	    5	      200
     43500	    5	      190
     43200	    5	      200
     29700	    4	    59545
     29400	    5	      140
     29100	    5	      140
     28800	    5	      210

12 rows selected.

select card, gennum, med_calc_qt
from NSO_Gen_Stat_at_QatC
where dbms = 'mysql' 
and runid = 2120 
and querynum = 10
order by card desc

      CARD     GENNUM MED_CALC_QT
---------- ---------- -----------
     60000	    5	      210
     33900	    4	      110
     33600	    5	      140
     33300	    4	      110
     33000	    5	      140
     32700	    5	      120
     30300	    4	       90
     30000	    5	      120
     29700	    5	      110
     29400	    4	       90
     29100	    5	      110
     28800	    5	      110

12 rows selected.

select dbms, max(ngen) as maxGen, max(nCards) as maxCard
from 
	(select dbms, runid, querynum, count(distinct genNum) as ngen, count(distinct card) as ncards
	from NSO_Gen_Stat_at_QatC
	group by dbms, runid, querynum) t0
group by dbms

DBMS    MAXGEN    MAXCARD
------	-------	  ----------
db2
	 3	  138

mysql
	 2	   12

oracle
	 4	   74

pgsql
	 5	  172

----
select runid, querynum, count(distinct genNum) as ngen, count(distinct card) as ncards
from NSO_Gen_Stat_at_QatC
where dbms = 'db2' 
having count(distinct card) = 57
group by runid, querynum

     RUNID   QUERYNUM	    NGEN     NCARDS
---------- ---------- ---------- ----------
       416	   58	       1	 57
       439	    8	       2	 57
       439	  241	       2	 57
       439	  334	       1	 57

select card, gennum, med_calc_qt
from NSO_Gen_Stat_at_QatC
where dbms = 'db2' 
and runid = 439 
and querynum = 241
order by card asc

      CARD     GENNUM MED_CALC_QT
---------- ---------- -----------
     10000	    6		?
    640000	    6	      460
    650000	    6	      650
    720000	    6	      770
    730000	    6	      555
    740000	    6	      790
    760000	    6	      820
    770000	    6	      610
    780000	    6	      610
    790000	    6	      860
    850000	    6	      970
    860000	    6	      710
    870000	    6	     1000
    880000	    6	      730
    890000	    6	     1040
    900000	    6	     1060
    910000	    6	      780
    920000	    6	     1090
    940000	    6	     1125
    950000	    6	      820
    960000	    6	     1160
    980000	    6	     1200
    990000	    6	      880
   1000000	    6	     1250
   1020000	    6	     1280
   1030000	    6	      940
   1040000	    6	     1320
   1090000	    6	     1430
   1100000	    6	     1045
   1110000	    6	     1470
   1450000	    6	     2360
   1460000	    6	     1700
   1470000	    6	     2410
   1480000	    6	     2450
   1490000	    6	     1730
   1500000	    6	     2520
   1510000	    6	     1790
   1520000	    6	     2580
   1530000	    6	     2610
   1540000	    6	     1870
   1560000	    6	     1910
   1570000	    6	     2750
   1710000	    6	     3240
   1720000	    6	     2320
   1730000	    6	     3340
   1750000	    6	     3390
   1760000	    6	     2400
   1770000	    6	     3480
   1810000	    6	     3640
   1820000	    6	     2560
   1830000	    6	     3725
   1890000	    6	     3975
   1900000	   11	     2110
   1910000	    6	     4055
   1970000	    6	     4335
   1980000	   11	     2230
   1990000	   11	     2260
   2000000	    6	     4460

57 rows selected.


select *
from NSO_Calc_RD 
where rel_delta > -1 and rel_delta < 1 
and dbms='db2' and runid IN (439) 
and querynum IN (241) 

--- db2

select distinct t0.dbms, t0.runid, t0.querynum, max(t0.genCnt), max(t1.rel_delta)
from 	
	NSO_Calc_RD t1,
	(select dbms, runid, querynum, count(distinct genNum) as genCnt
	from NSO_GenNum_at_QatC 
	where dbms = 'db2' 
	having count(distinct genNum) > 2
	group by dbms, runid, querynum
	order by genCnt desc) t0
where t1.dbms = t0.dbms
and t1.dbms = 'db2' 
and t1.runid = t0.runid 
and t1.querynum = t0.querynum 
--and t1.runid IN (416) 
--and t1.querynum IN (58) 
and rel_delta > -1 and rel_delta < 1 
and t0.genCnt >= 2
group by t0.dbms, t0.runid, t0.querynum

db2
      1117	   86		   3		   .36

select card, gennum, med_calc_qt
from NSO_Gen_Stat_at_QatC
where dbms = 'db2' 
and runid = 1117 
and querynum = 86
order by card asc

      CARD     GENNUM MED_CALC_QT
---------- ---------- -----------
     90000	    7	      170
    100000	    6	      280
    130000	    6	      340
    140000	   11	      230
    720000	   11	      530
    730000	   11	      520
   1010000	   11	      650
   1020000	    6	     1030
   1120000	    6	     1100
   1130000	    6	     1160
   2000000	    6	     1630

11 rows selected.


select querysql 
from azdblab_query 
where runid = 1117 and querynumber = 86

QUERYSQL
--------------------------------------------------------------------------------
SELECT t0.id2, t2.id3, t2.id1, SUM(t0.id3)  FROM ft_HT3 t2, ft_HT2 t1, ft_HT1 t0
  WHERE  (t2.id1=t1.id3 AND t1.id3=t0.id4)  GROUP BY t0.id2, t2.id3, t2.id1

select *
from NSO_Calc_RD 
where rel_delta > -1 and rel_delta < 1 
and dbms='db2' and newer_gen_num = 11

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM NEWER_GEN_NUM UPPER_CARD LOWER_CARD  REL_DELTA
---------- ---------- ------------- ---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
db2
      2277	  109		 11	900000	   890000	 .64
GRPBY,HSJOIN,IXSCAN,RETURN,SORT,TBSCAN
FETCH,FILTER,GRPBY,IXSCAN,MSJOIN,RETURN,SORT,TBSCAN


select dbms, newer_gen_num, count(*) as counts
from NSO_Calc_RD 
where rel_delta > -1 and rel_delta < 1
group by dbms, newer_gen_num
order by dbms, newer_gen_num

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	  COUNTS
------------- ----------
db2
	    7	     383

db2
	    9	       7

db2
	   11	     738

db2
	   13	      12

mysql
	    5	      22

oracle
	    4	      26

oracle
	    5	     400

oracle
	    6	     211

oracle
	    7	      40

pgsql
	    5	      71

pgsql
	    6	     184

pgsql
	    7	     176

pgsql
	    8	     316

pgsql
	   10	     185

pgsql
	   11	     258

pgsql
	   12	      59


16 rows selected.

select round(avg(rel_delta),2) as avg_rd, max(rel_delta) as max_rd, count(*) as counts 
from NSO_Calc_RD 
where rel_delta >= 0 and rel_delta < 1 --- SubOpt

    AVG_RD     MAX_RD	  COUNTS
---------- ---------- ----------
       .25	    .96	    1710

select dbms, newer_gen_num, count(*) as counts
from NSO_Calc_RD 
where rel_delta >= 0 and rel_delta < 1
group by dbms, newer_gen_num
order by dbms, newer_gen_num

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	  COUNTS
------------- ----------
db2
	    7	      62

db2
	    9	       3

db2
	   11	     534

db2
	   13	      12

mysql
	    5	       9

oracle
	    4	       2

oracle
	    5	     156

oracle
	    6	      79

oracle
	    7	      38

pgsql
	    5	      46

pgsql
	    6	       7

pgsql
	    7	     163

pgsql
	    8	     273

pgsql
	   10	     168

pgsql
	   11	     105

pgsql
	   12	      53


select newer_gen_num, 
	round(avg(rel_delta),2) as avg_rd, 
	max(rel_delta) as max_rd,
	count(*) as counts
from NSO_Calc_RD 
where rel_delta >= 0 and rel_delta < 1
group by newer_gen_num
order by newer_gen_num asc

NEWER_GEN_NUM	  AVG_RD     MAX_RD	COUNTS
------------- ---------- ---------- ----------
	    4	     .19	.33	     2
	    5	     .08	.61	   211
	    6	     .16	.76	    86
	    7	      .3	 .9	   263
	    8	      .3	.91	   273
	    9	     .04	 .1	     3
	   10	     .32	.94	   168
	   11	     .24	.96	   639
	   12	     .35	.87	    53
	   13	      .4	.78	    12

10 rows selected.

--- NSO
select round(avg(rel_delta),2) as avg_rd, min(rel_delta) as max_rd, count(*) as counts 
from NSO_Calc_RD 
where rel_delta > -1 and rel_delta < 0 

    AVG_RD     MAX_RD	  COUNTS
---------- ---------- ----------
      -.23	 -.01	    1378


select dbms, newer_gen_num, count(*) as counts
from NSO_Calc_RD 
where rel_delta > -1 and rel_delta < 0
group by dbms, newer_gen_num
order by dbms, newer_gen_num

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	  COUNTS
------------- ----------
db2
	    7	     321

db2
	    9	       4

db2
	   11	     204

mysql
	    5	      13

oracle
	    4	      24

oracle
	    5	     244

oracle
	    6	     132

oracle
	    7	       2

pgsql
	    5	      25

pgsql
	    6	     177

pgsql
	    7	      13

pgsql
	    8	      43

pgsql
	   10	      17

pgsql
	   11	     153

pgsql
	   12	       6


15 rows selected.

select newer_gen_num, 
	round(avg(rel_delta),2) as avg_rd, 
	min(rel_delta) as max_rd,
	count(*) as counts
from NSO_Calc_RD 
where rel_delta > -1 and rel_delta < 0
group by newer_gen_num
order by newer_gen_num asc

NEWER_GEN_NUM	  AVG_RD     MAX_RD	COUNTS
------------- ---------- ---------- ----------
	    4	    -.28       -.57	    24
	    5	    -.12       -.93	   282
	    6	    -.27       -.82	   309
	    7	    -.32       -.92	   336
	    8	     -.2       -.41	    43
	    9	    -.12       -.29	     4
	   10	    -.29       -.91	    17
	   11	    -.18       -.68	   357
	   12	    -.25       -.68	     6

9 rows selected.
----

select * from NSO_Calc_RD where rel_delta = .9 and newer_gen_num = 7;
DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM NEWER_GEN_NUM UPPER_CARD LOWER_CARD  REL_DELTA
---------- ---------- ------------- ---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
db2
      2237	   57		  7	 30000	    20000	  .9
GRPBY,HSJOIN,RETURN,SORT,TBSCAN
GRPBY,HSJOIN,IXSCAN,NLJOIN,RETURN,SORT,TBSCAN



----
-- select dbms, gen, numQatCPairs from NSO_AQatCPairs order by dbms, gen
select count(*) from 
	(select dbms, runid, querynum, upper_card, lower_card
	from NSO_GP_QatCs);
  COUNT(*)
----------
     66792

select count(*) from 
	(select dbms, runid, querynum, upper_card, lower_card
	from NSO_GP_QatCs
	where upper_gen = lower_gen);

  COUNT(*)
----------
      62903

select count(*) from 
	(select dbms, runid, querynum, upper_card, lower_card
	from NSO_GP_QatCs
	where upper_gen < lower_gen);

  COUNT(*)
----------
       2257

select count(*) from 
	(select dbms, runid, querynum, upper_card, lower_card
	from NSO_GP_QatCs
	where upper_gen > lower_gen)

  COUNT(*)
----------
       1632

select dbms, count(*) from NSO_Gen_Stat_at_QatC group by dbms order by dbms
DBMS
--------------------------------------------------------------------------------
  COUNT(*)
----------
db2
     30675

mysql
      5431

oracle
     16971

pgsql
     53524


select dbms, count(*)
from
	(select distinct t0.*
	from NSO_GP_QatCs t0, NSO_GP_QatCs t1
	where 
	((t0.lower_card-10000 = t1.upper_card and t1.upper_card-t1.lower_card=10000) and t0.dbms <> 'mysql') or  ((t0.lower_card-300 = t1.upper_card and t1.upper_card-t1.lower_card=300) and t0.dbms = 'mysql') 
	--t0.lower_card = t1.upper_card 
	and t0.dbms = t1.dbms
	and t0.runid = t1.runid
	and t0.querynum = t1.querynum) 
group by dbms
order by dbms

DBMS
--------------------------------------------------------------------------------
  COUNT(*)
----------
db2
     10135

mysql
       304

oracle
      4986

pgsql
     16816

select count(*)
from
	(select distinct t0.*
	from NSO_GP_QatCs t0, NSO_GP_QatCs t1
	where 
	((t0.lower_card-10000 = t1.upper_card) and t0.dbms <> 'mysql') or  ((t0.lower_card-300 = t1.upper_card) and t0.dbms = 'mysql') 
	--t0.lower_card = t1.upper_card 
	and t0.dbms = t1.dbms
	and t0.runid = t1.runid
	and t0.querynum = t1.querynum)

  COUNT(*)
----------
     32241

------ here! ---- 
select dbms, count(*)
from 
	(select distinct t0.dbms, t0.runid, t0.querynum, t0.upper_card, t0.lower_card
	from NSO_GP_QatCs t0, NSO_GP_QatCs t1
	where ((t0.lower_card-10000 > t1.upper_card) and t0.dbms <> 'mysql') or  ((t0.lower_card-300 > t1.upper_card) and t0.dbms = 'mysql') 
	and t0.dbms = t1.dbms
	and t0.runid = t1.runid
	and t0.querynum = t1.querynum)
group by dbms
order by dbms

DBMS
--------------------------------------------------------------------------------
  COUNT(*)
----------
db2
      1729

mysql
	35

oracle
       589

pgsql
      2559

select count(*)
from 
	(select distinct t0.dbms, t0.runid, t0.querynum, t0.upper_card, t0.lower_card
	from NSO_GP_QatCs t0, NSO_GP_QatCs t1
	where ((t0.lower_card-10000 > t1.upper_card) and t0.dbms <> 'mysql') or  ((t0.lower_card-300 > t1.upper_card) and t0.dbms = 'mysql') 
	and t0.dbms = t1.dbms
	and t0.runid = t1.runid
	and t0.querynum = t1.querynum)

  COUNT(*)
----------
      4912



--- positive delta

select avg(rel_delta), max(rel_delta) from NSO_Calc_RD 
where rel_delta > 0 

AVG(REL_DELTA) MAX(REL_DELTA)
-------------- --------------
    .231805755		    1

- select * from NSO_Calc_RD where rel_delta > .23 and rel_delta < .25 and dbms = 'mysql'

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM NEWER_GEN_NUM UPPER_CARD LOWER_CARD  REL_DELTA
---------- ---------- ------------- ---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
oracle
      2057	   98		  5	540000	   530000	 .24
HASH,HASH JOIN,SELECT STATEMENT,VIEW
HASH,HASH JOIN,SELECT STATEMENT

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2057
and q.querynumber = 98
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2121408       2057	     98     2000000	     1 6.1629E+18
	 2121509       2057	     98     1600000	     1 6.1629E+18
	 2121528       2057	     98     1590000	     1 6.2633E+18
...
	 2121701       2057	     98      570000	     1 -7.922E+18
	 2121729       2057	     98      540000	     1 -7.922E+18
	 2121756       2057	     98      530000	     1 2.1818E+16
...
	 2121944       2057	     98       90000	     1 6.4267E+18
	 2121959       2057	     98       30000	     1 6.4267E+18
	 2121972       2057	     98       20000	     1 1.7322E+18

19 rows selected.

select * from NSO_Upper_EQT where runid = 2057 and querynum = 98

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM  UPPER_GEN  LOWER_GEN UPPER_CARD LOWER_CARD NEAREST_CARD
---------- ---------- ---------- ---------- ---------- ---------- ------------
 UPPER_CQT UPPER_EP_CQT  LOWER_CQT NEAREST_CQT
---------- ------------ ---------- -----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
oracle
      2057	   98	       5	  3	540000	   530000	510000
    2012.5	 1522.5       1505	  1470
HASH,HASH JOIN,SELECT STATEMENT,VIEW
HASH,HASH JOIN,SELECT STATEMENT

            (1505 - 1470)
* slope = ------------------
         (530000 - 510000)

* y-intercept = 1470 - ((1505 - 1470)/(530000 - 510000))*510000
* extrapolated time of gen 6 at 1.44M = 1470 - ((1505 - 1470)/(530000 - 510000))*510000 + ((1505 - 1470) /  (530000 - 510000))(540000)
 				      = 1522.5
* relative delta = (2012.5 - 1522.5) / 2012.5 = .24

round(
-- y-intercept
t1.med_calc_qt-(((t0.lower_cqt - t1.med_calc_qt) / (t0.lower_card - t1.card))*t1.card)+
-- slope
(((t0.lower_cqt - t1.med_calc_qt) / (t0.lower_card - t1.card))*t0.upper_card)
, 1) 

t0.upper_card: 30000
t0.lower_card: 20000
t0.upper_cqt: 30
(t0.lower_cqt): 20
t1.med_calc_qt: 5242.5 (nearest_cqt)
t1.card: 1480000 (nearest_card)

- select * from NSO_Calc_RD where rel_delta = 1

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM NEWER_GEN_NUM UPPER_CARD LOWER_CARD  REL_DELTA
---------- ---------- ------------- ---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
oracle
       260	   49		  5	 30000	    20000	   1
HASH,HASH JOIN,SELECT STATEMENT
HASH,HASH JOIN,SELECT STATEMENT,VIEW

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 260
and q.querynumber = 49
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	  783797	260	     49     2000000	     1 2.4966E+18
	  783929	260	     49     1490000	     1 2.4966E+18
	  783957	260	     49     1480000	     1 -3.424E+18
	  784088	260	     49       30000	     1 -3.424E+18
	  784106	260	     49       20000	     1 7.4182E+18
	  784122	260	     49       10000	     1 -3.424E+18

6 rows selected.

select * from NSO_Lower_EQT where runid = 260 and querynum = 49
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
oracle
       260	   49	       3	  5	 1480000      30000	 20000
     5242.5	    30	       20	  -5.9
HASH,HASH JOIN,SELECT STATEMENT
HASH,HASH JOIN,SELECT STATEMENT,VIEW

            (5242.5 - 30)
* slope = ------------------
         (1480000 - 30000)

* y-intercept = 30 - ((5242.5 - 30)/(1480000 - 30000))*30000
* extrapolated time of gen 3 at 20K = 30 - ((5242.5 - 30)/(1480000 - 30000))*30000 + ((5242.5 - 30)/(1480000 - 30000))(20000)
 				      =  -5.9 = 0
* relative delta = (20 - 0) / 20 = 1

t0.upper_card: 30000
t0.lower_card: 20000
t0.upper_cqt: 30
(t0.lower_cqt): 20
t1.med_calc_qt: 5242.5 (nearest_cqt)
t1.card: 1480000 (nearest_card)

round(
-- y-intercept
(t0.upper_cqt-((t1.med_calc_qt-t0.upper_cqt)/(t1.card-t0.upper_card))*t0.upper_card+
-- slope
((t1.med_calc_qt-t0.upper_cqt)/(t1.card-t0.upper_card))*t0.lower_card), 1) 

----



--- negative delta

select avg(rel_delta), min(rel_delta) from NSO_Calc_RD 
where rel_delta < 0 and 
(
(RUNID <> 2120 and querynum <> 13) and 
(RUNID <> 2257 and querynum <> 0) and
(RUNID <> 1097 and querynum <> 59) 
)

AVG(REL_DELTA) MIN(REL_DELTA)
-------------- --------------
    -.60787141	       -25.12

select * from NSO_Calc_RD where rel_delta = -25.12

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM NEWER_GEN_NUM UPPER_CARD LOWER_CARD  REL_DELTA
---------- ---------- ------------- ---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
pgsql
      2059	   75		 11	 20000	    10000     -25.12
Hash Join,Hash,Hash Semi Join,Seq Scan
Merge Join,Merge Semi Join,Nested Loop,Seq Scan,Sort

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2059
and q.querynumber = 75
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2145106       2059	     75     2000000	     1 -2.685E+18
	 2145131       2059	     75     1840000	     1 -2.685E+18
	 2145149       2059	     75     1830000	     1 3.5293E+18
...
	 2145515       2059	     75      370000	     1 1.5959E+18
	 2145525       2059	     75      360000	     1 3.0749E+17
	 2145536       2059	     75       20000	     1 3.0749E+17
	 2145552       2059	     75       10000	     1 3.6671E+18

33 rows selected.


select * from NSO_Lower_EQT where runid = 2059 and querynum = 75

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
pgsql
      2059	   75	       4	 11	  360000      20000	 10000
	920	   280	       10	 261.2
Hash Join,Hash,Hash Semi Join,Seq Scan
Merge Join,Merge Semi Join,Nested Loop,Seq Scan,Sort

            (920 - 280)
* slope = ------------------
         (360000 - 20000)

* y-intercept = 280 - ((920 - 280)/(360000 - 20000))*20000
* extrapolated time of gen 4 at 10K = 280 - ((920 - 280)/(360000 - 20000))*20000 + ((920 - 280) / (360000 - 20000))(10000)
 				      = 261.2
* relative delta = (10 - 261.2) / 10 = -25.12

t0.upper_card: 20000
t0.lower_card: 10000
t0.upper_cqt: 280
(t0.lower_cqt): 10
t1.med_calc_qt: 920 (nearest_cqt)
t1.card: 360000 (nearest_card)

round(
-- y-intercept
(t0.upper_cqt-((t1.med_calc_qt-t0.upper_cqt)/(t1.card-t0.upper_card))*t0.upper_card+
-- slope
((t1.med_calc_qt-t0.upper_cqt)/(t1.card-t0.upper_card))*t0.lower_card), 1) 

-----

select * from NSO_Calc_RD where rel_delta > -.6 and rel_delta < -.5 and dbms = 'db2'

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM NEWER_GEN_NUM UPPER_CARD LOWER_CARD  REL_DELTA
---------- ---------- ------------- ---------- ---------- ----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
db2
      2277	   60		 11    1440000	  1430000	-.53
FILTER,GRPBY,HSJOIN,MSJOIN,RETURN,SORT,TBSCAN
GRPBY,HSJOIN,RETURN,SORT,TBSCAN

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2277
and q.querynumber = 60
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2291568       2277	     60     2000000	     1 3.4866E+18
	 2291608       2277	     60     1880000	     1 3.4866E+18
	 2291635       2277	     60     1870000	     1 -1.886E+18
...
	 2291786       2277	     60     1440000	     1 5.3515E+18
	 2291802       2277	     60     1430000	     1 -8.672E+18
	 2291856       2277	     60      320000	     1 -8.672E+18
...
	 2291983       2277	     60       40000	     1 -8.672E+18
	 2291998       2277	     60       30000	     1 6.3430E+18

23 rows selected.

select * from NSO_Upper_EQT where runid = 2277 and querynum = 60

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM  UPPER_GEN  LOWER_GEN UPPER_CARD LOWER_CARD NEAREST_CARD
---------- ---------- ---------- ---------- ---------- ---------- ------------
 UPPER_CQT UPPER_EP_CQT  LOWER_CQT NEAREST_CQT
---------- ------------ ---------- -----------
UPPER_GEN_TXT
--------------------------------------------------------------------------------
LOWER_GEN_TXT
--------------------------------------------------------------------------------
db2
      2277	   60	      11	  6    1440000	  1430000	320000
      2130	 3251.5       3225	   280
FILTER,GRPBY,HSJOIN,MSJOIN,RETURN,SORT,TBSCAN
GRPBY,HSJOIN,RETURN,SORT,TBSCAN

            (3225 - 280)
* slope = ------------------
         (1430000 - 320000)

* y-intercept = 280 - ((3225 - 280)/(1430000 - 320000))*320000
* extrapolated time of gen 6 at 1.44M = 280 - ((3225 - 280)/(1430000 - 320000))*320000 + ((3225 - 280) / (1430000 - 320000))(1430000)
 				      = 3251.5
* relative delta = (2130 - 3251.5) / 2130 = -0.5265258215962442

round(
-- y-intercept
t1.med_calc_qt-(((t0.lower_cqt - t1.med_calc_qt) / (t0.lower_card - t1.card))*t1.card)+
-- slope
(((t0.lower_cqt - t1.med_calc_qt) / (t0.lower_card - t1.card))*t0.upper_card)
, 1) 


select dbms, newer_gen_num, rel_delta from NSO_Calc_RD order by rel_delta

--select dbms, newer_gen_num, count(*) from NSO_Calc_RD group by dbms, newer_gen_num order by dbms, newer_gen_num

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
db2
	    7	     386

db2
	    9	       8

db2
	   11	     738


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
db2
	   13	      12

mysql
	    5	      33

oracle
	    4	      26


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
oracle
	    5	     406

oracle
	    6	     211

oracle
	    7	      40


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
pgsql
	    5	      71

pgsql
	    6	     184

pgsql
	    7	     176


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
pgsql
	    8	     316

pgsql
	   10	     186

pgsql
	   11	     258


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
pgsql
	   12	      60


16 rows selected.


--select count(*) from NSO_Calc_RD where rel_delta < 0
  COUNT(*)
----------
      1651

-- select dbms, newer_gen_num, count(*) from NSO_Calc_RD where rel_delta < 0 group by dbms, newer_gen_num order by dbms, newer_gen_num
DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
db2
	    7	      54

db2
	    9	       2

db2
	   11	     521


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
db2
	   13	      12

mysql
	    5	      19

oracle
	    4	       2


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
oracle
	    5	     134

oracle
	    6	      71

oracle
	    7	      38


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
pgsql
	    5	      36

pgsql
	    6	       4

pgsql
	    7	     163


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
pgsql
	    8	     272

pgsql
	   10	     167

pgsql
	   11	     103


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
pgsql
	   12	      53


16 rows selected.

select dbms, newer_gen_num, count(*) from NSO_Calc_RD where rel_delta >= 0 group by dbms, newer_gen_num order by dbms, newer_gen_num

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	COUNT(*)
------------- ----------
db2
	    7	     332

db2
	    9	       6

db2
	   11	     217

mysql
	    5	      14

oracle
	    4	      24

oracle
	    5	     272

oracle
	    6	     140

oracle
	    7	       2

pgsql
	    5	      35

pgsql
	    6	     180

pgsql
	    7	      13

pgsql
	    8	      44

pgsql
	   10	      19

pgsql
	   11	     155

pgsql
	   12	       7


15 rows selected.

select avg(rel_delta), max(rel_delta) from NSO_Calc_RD where rel_delta > 0
AVG(REL_DELTA) MAX(REL_DELTA)
-------------- --------------
    .231805755		    1

select avg(rel_delta), max(rel_delta) from NSO_Calc_RD where rel_delta >= 0
AVG(REL_DELTA) MAX(REL_DELTA)
-------------- --------------
    .220691781		    1

select avg(rel_delta), max(rel_delta) from NSO_Calc_RD where rel_delta < 0

AVG(REL_DELTA) MAX(REL_DELTA)
-------------- --------------
    -4.2928892		 -.01


-----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 1097
and q.querynumber = 73
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 1097
and q.querynumber = 59
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 1795714       1097	     59       60000	     1 8.9718E+18
	 1795892       1097	     59       30600	     1 6.4401E+18
	 1795970       1097	     59       30300	     1 8.9718E+18
	 1796002       1097	     59       29400	     1 6.4401E+18
	 1796075       1097	     59       29100	     1 2.0029E+18

select * from NSO_Upper_EQT where runid = 1097 and querynum = 59

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
      1097	   59	       4	  5	   30600      29400	 29100
      58500	 53990	      130      52862.5

-- select dbms, gennum, count(*) from NSO_Gen_Stat_at_QatC group by dbms, gennum order by dbms, gennum
-- select dbms, gennum, count(*) from NSO_GP_QatCs group by dbms, gennum order by dbms, gennum 
DBMS
--------------------------------------------------------------------------------
    GENNUM   COUNT(*)
---------- ----------
db2
	 3	 4080

db2
	 4	 1325

db2
	 5	 2183

db2
	 6	 5870

db2
	 7	  865

db2
	 9	   10

db2
	11	 1148

db2
	13	   11

mysql
	 1	   29

mysql
	 2	  905

mysql
	 4	 1278

mysql
	 5	  519

oracle
	 2	 4110

oracle
	 3	 2829

oracle
	 4	 1002

oracle
	 5	  734

oracle
	 6	  426

oracle
	 7	   47

pgsql
	 1	   13

pgsql
	 3	 6786

pgsql
	 4	 5508

pgsql
	 5	 5890

pgsql
	 6	 1087

pgsql
	 7	  350

pgsql
	 8	 2948

pgsql
	10	  424

pgsql
	11	  572

pgsql
	12	  386


28 rows selected.

select count(*) 
	from 
		(SELECT t0.dbms,
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
		)

  COUNT(*)
----------
       649

select count(*) 
	from 
		(SELECT t0.dbms,
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
		)

  COUNT(*)
----------
       1427

DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	  AVG_RD
------------- ----------
db2
	    8	    -.22

db2
	    9	     -.57

db2
	   10	   .17

db2
	   12	    -1.34

db2
	   13	    .17

mysql
	    5	 -144.32
oracle
	    4	     .28
oracle
	    5	     .04

oracle
	    6	     .05

oracle
	    7	   -2.9

pgsql
	    5	      .2

pgsql
	    6	      .37


DBMS
--------------------------------------------------------------------------------
NEWER_GEN_NUM	  AVG_RD
------------- ----------
pgsql
	    7	    -.39

pgsql
	    8	    -.12

pgsql
	    9	    -1.27
