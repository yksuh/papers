select runid, querynum, card, count(planid)
from NSOExpl_ACTQatC
having count(planid) > 1
group by runid, querynum, card;

SQL> select runid, querynum, card, count(planid)
from NSOExpl_ACTQatC
having count(planid) > 1
group by runid, querynum, card;  2    3    4  

     RUNID   QUERYNUM	    CARD COUNT(PLANID)
---------- ---------- ---------- -------------
      1677	   39	   30300	     2 (done)
       897	   31	   30600	     2 (done)
      1097	   13	   30600	     2 (done)
      1097	   32	   30900	     2 (done)
      1097	   73	   30600	     2 (done)
      1097	   73	   31200	     2 (done)
      1097	   92	   30600	     2 (done)


select runid, querynum, card, planid
from NSOExpl_ACTQatC
WHERE runid = 897 and querynum = 31
order by card desc

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
       897	   31	   60000 4.0403E+18
       897	   31	   30900 4.0403E+18
       897	   31	   30600 4.0403E+18 (V)
       897	   31	   30600 7.8900E+17
       897	   31	   30300 4.0403E+18 (V)
       897	   31	   29100 7.8900E+17
       897	   31	   28800 -1.310E+18

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
       897	   31	   60000 4.0403E+18
       897	   31	   30900 4.0403E+18
       897	   31	   30600 7.8900E+17
       897	   31	   29100 7.8900E+17
       897	   31	   28800 -1.310E+18

select runid, querynum, card, planid
from NSOExpl_ACTQatC
WHERE runid = 1677 and querynum = 39
order by card desc

SQL> select runid, querynum, card, planid
from NSOExpl_ACTQatC
WHERE runid = 1677 and querynum = 39
order by card desc
  2    3    4    5  ;

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1677	   39	   60000 -6.894E+18
      1677	   39	   30300 -2.843E+18
      1677	   39	   30300 -6.894E+18
      1677	   39	   30000 -2.843E+18
      1677	   39	   29100 -2.843E+18
      1677	   39	   28800 1.7814E+18

select runid, querynum, card, planid
from NSOExpl_ACTQatC
WHERE runid = 1097 and querynum = 13
order by card desc

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   13	   60000 -1.484E+18
      1097	   13	   31200 -1.484E+18
      1097	   13	   30900 6.6311E+17
      1097	   13	   30600 -1.484E+18 (V)
      1097	   13	   30600 -8.801E+18 (V)
      1097	   13	   30300 -1.484E+18 (V)
      1097	   13	   30000 6.6311E+17 (V)
      1097	   13	   29400 -8.801E+18
      1097	   13	   29100 6.6311E+17
      1097	   13	   28800 4.5777E+18

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   13	   60000 -1.484E+18
      1097	   13	   31200 -1.484E+18
      1097	   13	   30900 6.6311E+17
      1097	   13	   29100 6.6311E+17
      1097	   13	   28800 4.5777E+18

select runid, querynum, card, planid
from NSOExpl_ACTQatC
WHERE runid = 1097 and querynum = 32
order by card desc

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   32	   60000 -8.961E+18
      1097	   32	   31500 -9.683E+17 (V)
      1097	   32	   31200 -8.961E+18
      1097	   32	   30900 -9.683E+17
      1097	   32	   30900 -8.961E+18 (V)
      1097	   32	   30600 -8.961E+18 
      1097	   32	   30300 -8.961E+18 (V)
      1097	   32	   30000 -8.961E+18 
      1097	   32	   29700 -9.683E+17
      1097	   32	   29400 -8.961E+18

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   32	   60000 -8.961E+18
      1097	   32	   31200 -8.961E+18
      1097	   32	   30900 -9.683E+17
      1097	   32	   30600 -8.961E+18
      1097	   32	   30000 -8.961E+18
      1097	   32	   29700 -9.683E+17
      1097	   32	   29400 -8.961E+18

select runid, querynum, card, planid
from NSOExpl_ACTQatC
WHERE runid = 1097 and querynum = 73
order by card desc

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   73	   60000 2.4709E+18
      1097	   73	   31500 -3.189E+17
      1097	   73	   31200 2.4709E+18 
      1097	   73	   31200 -3.189E+17 (V)
      1097	   73	   30900 8.8834E+18 
      1097	   73	   30600 2.4709E+18 (V)
      1097	   73	   30600 -3.189E+17 (V)
      1097	   73	   30300 2.4709E+18 (v)
      1097	   73	   30000 -1.331E+18 (V)
      1097	   73	   29700 8.8834E+18
      1097	   73	   29400 -1.331E+18
      1097	   73	   29100 8.8834E+18
      1097	   73	   28800 -1.331E+18

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   73	   60000 2.4709E+18
      1097	   73	   31200 2.4709E+18
      1097	   73	   30900 8.8834E+18
      1097	   73	   29700 8.8834E+18
      1097	   73	   29400 -1.331E+18
      1097	   73	   29100 8.8834E+18
      1097	   73	   28800 -1.331E+18

select runid, querynum, card, planid
from NSOExpl_ACTQatC
WHERE runid = 1097 and querynum = 92
order by card desc

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   92	   60000 -1.484E+18
      1097	   92	   30600 -1.484E+18 (V)
      1097	   92	   30600 -8.801E+18 (V)
      1097	   92	   30300 -1.484E+18
      1097	   92	   30000 6.6311E+17
      1097	   92	   29100 6.6311E+17
      1097	   92	   28800 1.2433E+18

     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
      1097	   92	   60000 -1.484E+18
      1097	   92	   30300 -1.484E+18
      1097	   92	   30000 6.6311E+17
      1097	   92	   29100 6.6311E+17
      1097	   92	   28800 1.2433E+18


select runid, querynum, card, planid, count(qeid)
from NSOExpl_AQED
WHERE (runid = 1677 and querynum = 39 and card = 30300) 
or (runid = 897 and querynum = 31 and card = 30600) 
or (runid = 1097 and querynum = 13 and card = 30600) 
--having count(planid) > 1
group by runid, querynum, card, planid

select qe.cardinality, qe.queryexecutionid, qep.planid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.runid = 897 and q.querynumber = 31 and qe.cardinality IN (31500, 30900,30300) --and qep.planid = '-2.843E+18' 
and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qep.planid, qe.queryexecutionid;


-- delete from azdblab_queryexecution 
where queryexecutionid >= 1910972 and queryexecutionid <= 1910981

delete from NSOExpl_AQED
where qeid >= 1910972 and qeid <= 1910981

-- delete from azdblab_queryexecution 
where queryexecutionid IN (
1603880, 1603883, 1603886, 1603888, 1603890, 
1603891, 1603894, 1603896, 1603898, 1603901, 
1603963, 1603965, 1603968, 1603970, 1603972, 
1603975, 1603978, 1603980, 1603982, 1603985, 
1604033, 1604034, 1604035, 1604037, 1604038, 
1604039, 1604040, 1604042, 1604043, 1604044)

- delete from NSOExpl_AQED
where qeid IN (
1603880, 1603883, 1603886, 1603888, 1603890, 
1603891, 1603894, 1603896, 1603898, 1603901, 
1603963, 1603965, 1603968, 1603970, 1603972, 
1603975, 1603978, 1603980, 1603982, 1603985, 
1604033, 1604034, 1604035, 1604037, 1604038, 
1604039, 1604040, 1604042, 1604043, 1604044)

select qe.cardinality, qe.queryexecutionid, qep.planid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where 
q.runid = 1097 and q.querynumber = 13 and (qe.cardinality IN (30600, 30300, 30000)) and 
q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid 
order by qe.cardinality desc, qep.planid, qe.queryexecutionid;

select qe.cardinality, qe.queryexecutionid, qep.planid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where 
q.runid = 1097 and q.querynumber = 32 and (qe.cardinality IN (31500, 30900,30300)) and 
q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid 
order by qe.cardinality desc, qep.planid, qe.queryexecutionid;

select qe.cardinality, qe.queryexecutionid, qep.planid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where 
q.runid = 897 and q.querynumber = 31 and (qe.cardinality IN (30600)) and 
q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid 
order by qe.cardinality desc, qep.planid, qe.queryexecutionid;


select qe.cardinality, qe.queryexecutionid, qep.planid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where 
q.runid = 1677 and q.querynumber = 39 and (qe.cardinality IN (30300)) and 
q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid 
order by qe.cardinality desc, qep.planid, qe.queryexecutionid;

delete from NSOExpl_AQED where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 13 and (qe.cardinality IN (30600, 30300, 30000)) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)

--delete from NSOExpl_AQED where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 13 and (qe.cardinality IN (30600, 30300, 30000)) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)

--delete from azdblab_queryexecution where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 13 and (qe.cardinality IN (30600, 30300, 30000)) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)



--delete from NSOExpl_AQED where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 32 and (qe.cardinality IN (31500, 30900,30300)) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)

--delete from azdblab_queryexecution where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 32 and (qe.cardinality IN (31500, 30900,30300)) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)


--delete from NSOExpl_AQED where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 73 and (qe.cardinality IN (30600, 30300, 30000) or  (qe.cardinality IN (31200) and qep.planid < 0)) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)

--delete from azdblab_queryexecution where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 73 and (qe.cardinality IN (30600, 30300, 30000) or  (qe.cardinality IN (31200) and qep.planid < 0)) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)


-- delete from NSOExpl_AQED where qeid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 92 and qe.cardinality IN (30600) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid) 

-- delete from azdblab_queryexecution where queryexecutionid IN (select qe.queryexecutionid from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep where q.runid = 1097 and q.querynumber = 92 and qe.cardinality IN (30600) and q.queryid = qe.queryid and qe.queryexecutionid = qep.queryexecutionid)

SELECT  	distinct 
ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.cardinality AS card,  
		qe.ITERNUM as qenum,
		qe.queryexecutionid AS qeid,
		qe.runtime
	FROM  AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      NSOExpl_Runs c_run,
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe
	 WHERE ex.experimentid=er.experimentid AND 
	       er.runid=q.runid AND
	       q.queryid=qe.queryid AND -- all QEs
               qe.queryexecutionid=1724255
		--qe.queryid = 19448
