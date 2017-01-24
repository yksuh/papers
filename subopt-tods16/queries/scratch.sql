select sum(queries) from (select runid, count(distinct querynum) as queries from (select runid, querynum from Cnfm_Analysis_SuboptDefn where Subopt_SD = 3) group by runid)


column expName format a20 
column dbms format a10 
SELECT expName, dbms, runid, count(*) as nqueries -- queries 
FROM (SELECT distinct experimentname as expName, dbms, runid, querynum
     FROM NSOCnfm_S0_AQE) 
group by expName, dbms, runid
order by nqueries desc, expName, dbms, runid


EXPNAME 	     DBMS	     RUNID   NQUERIES
-------------------- ---------- ---------- ----------
op-pk-1M-390q	     db2	       439	  290
op-pk-1M-390q	     oracle	       438	  290
op-pk-1M-390q	     pgsql	       796	  290
op-pk-30K-130q-2     mysql	       898	  130
op-pk-30K-130q-3     mysql	       899	  130
op-pk-1M-110q	     db2	       959	  110
op-pk-1M-110q	     db2	      2277	  110
op-pk-1M-110q	     oracle	       958	  110
op-pk-1M-110q	     oracle	      2318	  110
op-pk-1M-110q	     pgsql	       960	  110
op-pk-1M-110q	     pgsql	      2317	  110
op-pk-30K-110q	     mysql	       957	  110
op-pk-30K-110q	     mysql	      2297	  110
op-1M-100q-10	     db2	       436	  100
op-1M-100q-10	     oracle	       437	  100
op-1M-100q-10	     pgsql	       681	  100
op-1M-100q-3	     db2	       259	  100
op-1M-100q-3	     oracle	       260	  100
op-1M-100q-3	     pgsql		95	  100
op-1M-100q-4	     db2	       261	  100
op-1M-100q-4	     oracle	       262	  100
op-1M-100q-4	     pgsql	       286	  100
op-1M-100q-5	     db2	       288	  100
op-1M-100q-5	     oracle	       287	  100
op-1M-100q-5	     pgsql	       422	  100
op-1M-100q-6	     db2	       596	  100
op-1M-100q-6	     oracle	       289	  100
op-1M-100q-6	     pgsql	       440	  100
op-1M-100q-7	     db2	       414	  100
op-1M-100q-7	     oracle	       413	  100
op-1M-100q-7	     pgsql	       578	  100
op-1M-100q-8	     db2	       416	  100
op-1M-100q-8	     oracle	       556	  100
op-1M-100q-8	     pgsql	       636	  100
op-1M-100q-9	     db2	       419	  100
op-1M-100q-9	     oracle	       421	  100
op-1M-100q-9	     pgsql	       676	  100
op-1M-100q-no-skew   db2	      2019	  100
op-1M-100q-no-skew   oracle	      2018	  100
op-1M-100q-no-skew   pgsql	      2020	  100
op-1M-100sq-1	     db2	      2058	  100
op-1M-100sq-1	     oracle	      2057	  100
op-1M-100sq-1	     pgsql	      2059	  100
op-30K-100q-10	     mysql	       857	  100
op-30K-100q-3	     mysql	       518	  100
op-30K-100q-4	     mysql	       616	  100
op-30K-100q-5	     mysql	       658	  100
op-30K-100q-6	     mysql	       716	  100
op-30K-100q-7	     mysql	       756	  100
op-30K-100q-8	     mysql	       776	  100
op-30K-100q-9	     mysql	       816	  100
op-30K-100q-no-sk    mysql	      2037	  100
op-30K-100sq-1	     mysql	      2060	  100
op-pk-1M-100q-idx    db2	      1117	  100
op-pk-1M-100q-idx    oracle	      1057	  100
op-pk-1M-100q-idx    pgsql	      2337	  100
op-pk-1M-100sq	     db2	      1737	  100
op-pk-1M-100sq	     oracle	      1719	  100
op-pk-1M-100sq	     pgsql	      1657	  100
op-pk-1M-100sq1-idx  db2	      2077	  100
op-pk-1M-100sq1-idx  oracle	      2097	  100
op-pk-1M-100sq1-idx  pgsql	      2098	  100
op-pk-1M-100sq2-idx  db2	      2237	  100
op-pk-1M-100sq2-idx  oracle	      2197	  100
op-pk-1M-100sq2-idx  pgsql	      2217	  100
op-pk-30K-100q-idx   mysql	      1097	  100
op-pk-30K-100sq      mysql	      1677	  100
op-pk-30K-100sq1-idx mysql	      2120	  100
op-pk-30K-100sq2-idx mysql	      2257	  100
op-pk-30K-130q-1     mysql	       897	   30

70 rows selected.
 

SELECT expName, dbms, runid, count(*) as nqueries -- queries 
FROM (SELECT distinct experimentname as expName, dbms, runid, querynum
     FROM NSOCnfm_QED) 
group by expName, dbms, runid
order by nqueries desc, expName, dbms, runid

EXPNAME 	     DBMS	     RUNID   NQUERIES
-------------------- ---------- ---------- ----------
op-pk-1M-390q	     db2	       439	  290
op-pk-1M-390q	     pgsql	       796	  290
op-pk-1M-390q	     oracle	       438	  270
op-pk-1M-110q	     db2	       959	  110
op-pk-1M-110q	     db2	      2277	  110
op-pk-1M-110q	     oracle	       958	  110
op-pk-1M-110q	     oracle	      2318	  110
op-pk-1M-110q	     pgsql	       960	  110
op-pk-30K-130q-3     mysql	       899	  109
op-pk-1M-110q	     pgsql	      2317	  101
op-1M-100q-10	     db2	       436	  100
op-1M-100q-4	     pgsql	       286	  100
op-1M-100q-5	     pgsql	       422	  100
op-1M-100q-6	     pgsql	       440	  100
op-1M-100q-7	     db2	       414	  100
op-1M-100q-7	     pgsql	       578	  100
op-1M-100q-8	     db2	       416	  100
op-1M-100q-8	     pgsql	       636	  100
op-1M-100q-9	     db2	       419	  100
op-1M-100q-9	     pgsql	       676	  100
op-1M-100sq-1	     db2	      2058	  100
op-1M-100sq-1	     oracle	      2057	  100
op-1M-100sq-1	     pgsql	      2059	  100
op-pk-1M-100q-idx    db2	      1117	  100
op-pk-1M-100sq	     oracle	      1719	  100
op-pk-1M-100sq1-idx  oracle	      2097	  100
op-pk-1M-100sq1-idx  pgsql	      2098	  100
op-pk-1M-100sq2-idx  db2	      2237	  100
op-pk-1M-100sq2-idx  oracle	      2197	  100
op-pk-1M-100sq2-idx  pgsql	      2217	  100
op-1M-100q-3	     pgsql		95	   99
op-pk-1M-100q-idx    oracle	      1057	   99
op-pk-1M-100sq1-idx  db2	      2077	   99
op-pk-30K-100q-idx   mysql	      1097	   99
op-pk-30K-100sq2-idx mysql	      2257	   99
op-pk-1M-100sq	     db2	      1737	   98
op-pk-30K-100sq1-idx mysql	      2120	   98
op-pk-1M-100sq	     pgsql	      1657	   97
op-1M-100q-9	     oracle	       421	   96
op-pk-30K-130q-2     mysql	       898	   96
op-1M-100q-4	     db2	       261	   95
op-1M-100q-5	     db2	       288	   95
op-1M-100q-6	     db2	       596	   95
op-1M-100q-7	     oracle	       413	   95
op-1M-100q-3	     db2	       259	   94
op-1M-100q-8	     oracle	       556	   92
op-1M-100q-10	     oracle	       437	   91
op-1M-100q-5	     oracle	       287	   91
op-pk-1M-100q-idx    pgsql	      2337	   91
op-1M-100q-10	     pgsql	       681	   90
op-1M-100q-no-skew   db2	      2019	   90
op-1M-100q-no-skew   oracle	      2018	   90
op-1M-100q-no-skew   pgsql	      2020	   90
op-1M-100q-3	     oracle	       260	   89
op-30K-100q-no-sk    mysql	      2037	   88
op-pk-30K-110q	     mysql	      2297	   87
op-1M-100q-6	     oracle	       289	   85
op-30K-100q-4	     mysql	       616	   85
op-30K-100q-5	     mysql	       658	   85
op-30K-100q-7	     mysql	       756	   85
op-30K-100q-10	     mysql	       857	   84
op-30K-100q-6	     mysql	       716	   84
op-30K-100q-3	     mysql	       518	   82
op-1M-100q-4	     oracle	       262	   81
op-pk-30K-100sq      mysql	      1677	   78
op-30K-100sq-1	     mysql	      2060	   76
op-30K-100q-9	     mysql	       816	   72
op-pk-30K-130q-1     mysql	       897	   25
op-pk-30K-110q	     mysql	       957	    6
op-30K-100q-8	     mysql	       776	    2

SELECT expName, dbms, runid, count(*) as nqueries -- queries 
FROM (SELECT distinct experimentname as expName, dbms, runid, querynum
     FROM NSOCnfm_S0_AQE 
     WHERE measured_time = 9999999) 
group by expName, dbms, runid
order by nqueries desc, expName, dbms, runid

EXPNAME 	     DBMS	     RUNID   NQUERIES
-------------------- ---------- ---------- ----------
op-pk-30K-130q-2     mysql	       898	   19
op-pk-30K-110q	     mysql	       957	   18
op-30K-100q-9	     mysql	       816	   15
op-30K-100q-10	     mysql	       857	   12
op-30K-100q-4	     mysql	       616	   12
op-pk-30K-130q-3     mysql	       899	   12
op-30K-100q-3	     mysql	       518	   11
op-30K-100q-8	     mysql	       776	   11
op-30K-100q-6	     mysql	       716	    9
op-30K-100q-5	     mysql	       658	    8
op-30K-100q-7	     mysql	       756	    8
op-pk-30K-100sq      mysql	      1677	    5
op-30K-100sq-1	     mysql	      2060	    4
op-pk-30K-130q-1     mysql	       897	    4
op-pk-30K-110q	     mysql	      2297	    3
op-1M-100q-4	     pgsql	       286	    2
op-30K-100q-no-sk    mysql	      2037	    2
op-pk-30K-100sq1-idx mysql	      2120	    2
op-pk-30K-100sq2-idx mysql	      2257	    2
op-1M-100sq-1	     pgsql	      2059	    1
op-pk-1M-100sq2-idx  pgsql	      2217	    1
op-pk-1M-390q	     oracle	       438	    1
op-pk-1M-390q	     pgsql	       796	    1

23 rows selected.

SELECT stepName, stepResultSize
FROM NSOCnfm_RowCount
WHERE exprName = 'op-30K-100q-8'
order BY stepResultSize desc, stepName

STEPNAME					   STEPRESULTSIZE
-------------------------------------------------- --------------
NSOCnfm_S0_QE						     3141
NSOCnfm_S1_FQE						     2828
NSOCnfm_S2						      313
NSOCnfm_ACTQatC 					      313
NSOCnfm_ASPQatC 					      164
NSOCnfm_S3_0						      162
NSOCnfm_S3_I						      162
NSOCnfm_S3_II						      162
NSOCnfm_S3_III						      162
NSOCnfm_S0_Q						      100
NSOCnfm_ACTQ						       89
NSOCnfm_QED						       24
NSOCnfm_S1_PQRCV						9
NSOCnfm_S3_IV							4
NSOCnfm_S4_CTQatC						4
NSOCnfm_S4_TQ							2
NSOCnfm_SPQatC							1

17 rows selected.
 

SELECT stepName, stepResultSize
FROM NSOCnfm_RowCount
WHERE exprName = 'op-pk-30K-110q'
order BY stepResultSize desc, stepName 

STEPNAME					   STEPRESULTSIZE
-------------------------------------------------- --------------
NSOCnfm_S0_QE						     5041
NSOCnfm_S1_FQE						     2150
NSOCnfm_S2						     2891
NSOCnfm_QED						     2465
NSOCnfm_ACTQatC 					      502
NSOCnfm_S3_0						      381
NSOCnfm_S3_I						      360
NSOCnfm_S3_II						      360
NSOCnfm_S3_III						      360
NSOCnfm_S3_IV						      250
NSOCnfm_S4_CTQatC					      250
NSOCnfm_ASPQatC 					      232
NSOCnfm_S0_Q						      220
NSOCnfm_ACTQ						      201
NSOCnfm_SPQatC						      129
NSOCnfm_S4_TQ						       93
NSOCnfm_S1_PQRCV					       30
NSOCnfm_ATSM							4
NSOCnfm_ATRM							3
NSOCnfm_S5_TSM							2
NSOCnfm_S5_TRM							1

21 rows selected.

SELECT count(qeid)
FROM NSOCnfm_S1_NQPV_PDE
where dbms = 'mysql' 
and experimentname = 'op-pk-30K-110q'

COUNT(QEID)
-----------
	 20

SELECT count(qeid)
FROM NSOCnfm_S1_AQPV_PDE
where dbms = 'mysql' 
and experimentname = 'op-pk-30K-110q'

COUNT(QEID)
-----------
	  0

SELECT count(qeid)
FROM NSOCnfm_S1_IOWTV_PDE
where dbms = 'mysql' 
and experimentname = 'op-pk-30K-110q'

COUNT(QEID)
-----------
	 10

SELECT experimentname, runId, count(qeid)
FROM NSOCnfm_S1_QPTV_PDE
where dbms = 'mysql' 
and experimentname IN ('op-pk-30K-110q', 'op-30K-100q-8', 'op-30K-100q-10')
group by experimentname, runid
order by experimentname

EXPERIMENTNAME
--------------------------------------------------------------------------------
COUNT(QEID)
-----------
op-30K-100q-8
       2811

op-pk-30K-110q
       1761


