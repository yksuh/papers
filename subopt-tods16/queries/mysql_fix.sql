-- exploratory

SQL> SELECT	t0.dbms,
 	t0.runid,
	t0.querynum,
	t0.card,
	t0.planid
FROM	SOExpl_S0_AQE t0
where t0.qenum = 1 
and (t0.runid = 897 and querynum = 31 and card = 30600 
or t0.runid = 897 and querynum = 45 and card = 30300)  2    3    4    5    6    7    8    9  ;

DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
mysql
       897	   31	   30600 7.8900E+17

mysql
       897	   31	   30600 4.0403E+18

mysql
       897	   31	   30600 4.0403E+18


DBMS
--------------------------------------------------------------------------------
     RUNID   QUERYNUM	    CARD     PLANID
---------- ---------- ---------- ----------
mysql
       897	   45	   30300 7.3055E+18

mysql
       897	   45	   30300 7.3055E+18

 SELECT	t0.dbms,
 	t0.runid,
	t0.querynum,
	t0.card,
	t0.planid
FROM	SOExpl_S0_AQE t0
where t0.qenum = 1 
and t0.runid = 897 and querynum = 31 and card = 30600 

---

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 897
and q.querynumber = 31
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qe.queryexecutionid

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 1603721	897	     31       60000	     1 4.0403E+18
	 1603768	897	     31       30900	     1 4.0403E+18
	 1603791	897	     31       30600	     1 7.8900E+17
	 1604071	897	     31       29100	     1 7.8900E+17
	 1604091	897	     31       28800	     1 -1.310E+18

ok!

---

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 897
and q.querynumber = 45
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qe.queryexecutionid

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 1605034	897	     45       60000	     1 7.3055E+18
	 1605070	897	     45       30300	     1 7.3055E+18
	 1605133	897	     45       30300	     1 7.3055E+18
	 1605146	897	     45       30000	     1 7.3055E+18
	 1605196	897	     45       29100	     1 7.3055E+18
	 1605212	897	     45       28800	     1 7.3055E+18

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe
	where q.queryid = qe.queryid 
	and q.runid = 897
	and q.querynumber = 45 
	and qe.cardinality < 60000
	--order by qe.queryexecutionid
)


SQL> select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 897
and q.querynumber = 45
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qe.queryexecutionid  2    3    4    5    6    7    8  ;

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 1605034	897	     45       60000	     1 7.3055E+18

SQL> commit;

Commit complete.

-- problematic QatCs 
select count(*)
from nsoexpl_s4_ctqatc 
where (
    (runid = 2060 and querynum = 7 and card = 30000) 
or  (runid = 2060 and querynum = 52 and card = 30000) 
or  (runid = 2120 and querynum = 17 and card = 30300) 
or  (runid = 2120 and querynum = 54 and card = 30300) 
or  (runid = 2120 and querynum = 61 and card = 30300) 
or  (runid = 2120 and querynum = 97 and card = 30300) 
or  (runid = 2257 and querynum = 3 and card = 30300)
or  (runid = 2257 and querynum = 31 and card = 30300) 
or  (runid = 2257 and querynum = 49 and card = 30300) 
or  (runid = 2257 and querynum = 49 and card = 30000) 
or  (runid = 2257 and querynum = 60 and card = 31200) 
or  (runid = 2257 and querynum = 79 and card = 30600) 
or  (runid = 2257 and querynum = 95 and card = 30300) 
or  (runid = 2257 and querynum = 98 and card = 30000) 
or  (runid = 2297 and querynum = 54 and card = 30600) 
)

----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2060
and q.querynumber = 7
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qe.queryexecutionid

QUERYEXECUTIONID      RUNID CARDINALITY    ITERNUM     PLANID
---------------- ---------- ----------- ---------- ----------
	 2098906       2060	  60000 	 1 7.3956E+18
	 2099058       2060	  30300 	 1 7.3956E+18
	 2099266       2060	  30000 	 1 -7.003E+18
	 2099618       2060	  30000 	 1 7.3956E+18
	 2099716       2060	  29700 	 1 -7.003E+18
	 2099841       2060	  29400 	 1 7.3956E+18
	 2099989       2060	  29100 	 1 -7.003E+18

7 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2060
	and q.querynumber = 7 
	and qe.cardinality = 30000
	and qe.queryexecutionid = qep.queryexecutionid
	and qep.planid = (select planid from nsoexpl_actqatc where runid = 2060 and querynum = 7 and card = 30300)
	--order by qe.queryexecutionid
)

10 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2060
and q.querynumber = 7
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qe.queryexecutionid

QUERYEXECUTIONID      RUNID CARDINALITY    ITERNUM     PLANID
---------------- ---------- ----------- ---------- ----------
	 2098906       2060	  60000 	 1 7.3956E+18
	 2099058       2060	  30300 	 1 7.3956E+18
	 2099266       2060	  30000 	 1 -7.003E+18
	 2099716       2060	  29700 	 1 -7.003E+18
	 2099841       2060	  29400 	 1 7.3956E+18
	 2099989       2060	  29100 	 1 -7.003E+18

6 rows selected.

SQL> commit;

Commit complete.

-----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2060
and q.querynumber = 52
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qe.queryexecutionid

QUERYEXECUTIONID      RUNID CARDINALITY    ITERNUM     PLANID
---------------- ---------- ----------- ---------- ----------
	 2156919       2060	  60000 	 1 -2.741E+18
	 2157552       2060	  30300 	 1 -2.741E+18
	 2157808       2060	  30000 	 1 -8.659E+18
	 2158487       2060	  30000 	 1 -2.741E+18
	 2158934       2060	  29700 	 1 6.4933E+18
	 2159312       2060	  29400 	 1 6.4933E+18
	 2159424       2060	  29100 	 1 -2.741E+18
	 2159639       2060	  28800 	 1 6.4933E+18

8 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2060
	and q.querynumber = 52 
	and qe.cardinality = 30000
	and qe.queryexecutionid = qep.queryexecutionid
	and qep.planid = (select planid from nsoexpl_actqatc where runid = 2060 and querynum = 52 and card = 30300)
	--order by qe.queryexecutionid
)

10 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2060
and q.querynumber = 52
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.cardinality desc, qe.queryexecutionid

QUERYEXECUTIONID      RUNID CARDINALITY    ITERNUM     PLANID
---------------- ---------- ----------- ---------- ----------
	 2156919       2060	  60000 	 1 -2.741E+18
	 2157552       2060	  30300 	 1 -2.741E+18
	 2157808       2060	  30000 	 1 -8.659E+18
	 2158934       2060	  29700 	 1 6.4933E+18
	 2159312       2060	  29400 	 1 6.4933E+18
	 2159424       2060	  29100 	 1 -2.741E+18
	 2159639       2060	  28800 	 1 6.4933E+18

7 rows selected.

SQL> commit;

Commit complete.

-----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 17
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2226506       2120	     17       60000	     1 -6.914E+18
	 2226716       2120	     17       30600	     1 6.7722E+18
	 2226982       2120	     17       30600	     1 6.7722E+18
	 2227180       2120	     17       30300	     1 -6.914E+18
	 2227465       2120	     17       30300	     1 6.7722E+18
	 2227680       2120	     17       30000	     1 -6.914E+18
	 2227737       2120	     17       29400	     1 6.7722E+18
	 2227983       2120	     17       29100	     1 -6.914E+18
	 2228011       2120	     17       28800	     1 -6.919E+18

9 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe
	where q.queryid = qe.queryid 
	and q.runid = 2120
	and q.querynumber = 17 
	and qe.cardinality IN (30600, 30300, 30000, 29400)
	--order by qe.queryexecutionid
)

60 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 17
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2226506       2120	     17       60000	     1 -6.914E+18
	 2227983       2120	     17       29100	     1 -6.914E+18
	 2228011       2120	     17       28800	     1 -6.919E+18

SQL> commit;

Commit complete.

-----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 54
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2236928       2120	     54       60000	     1 -4.465E+18
	 2237029       2120	     54       30600	     1 -8.113E+18
	 2237109       2120	     54       30300	     1 -4.465E+18
	 2237264       2120	     54       30300	     1 -8.113E+18
	 2237324       2120	     54       30000	     1 -4.464E+18
	 2237338       2120	     54       29700	     1 -4.465E+18
	 2237351       2120	     54       29100	     1 -4.465E+18
	 2237365       2120	     54       28800	     1 -4.464E+18

8 rows selected.


delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2120
	and q.querynumber = 54 
	and qe.cardinality = 30600
	UNION
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2120
	and q.querynumber = 54 
	and qe.cardinality = 30300
	and qe.queryexecutionid = qep.queryexecutionid
	and qep.planid = (select planid from nsoexpl_actqatc where runid = 2120 and querynum = 54 and card = 30600)
) 

20 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 54
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2236928       2120	     54       60000	     1 -4.465E+18
	 2237109       2120	     54       30300	     1 -4.465E+18
	 2237324       2120	     54       30000	     1 -4.464E+18
	 2237338       2120	     54       29700	     1 -4.465E+18
	 2237351       2120	     54       29100	     1 -4.465E+18
	 2237365       2120	     54       28800	     1 -4.464E+18

6 rows selected.

SQL> commit;

Commit complete.

----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 61
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2239414       2120	     61       60000	     1 8.9819E+18
	 2239456       2120	     61       30300	     1 8.9819E+18
	 2239511       2120	     61       30300	     1 3.3398E+18
	 2239542       2120	     61       30000	     1 8.9819E+18
	 2239558       2120	     61       29100	     1 8.9819E+18
	 2239573       2120	     61       28800	     1 8.9821E+18

6 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2120
	and q.querynumber = 61 
	and qe.cardinality IN (30300, 30000)
) 

30 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 61
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2239414       2120	     61       60000	     1 8.9819E+18
	 2239558       2120	     61       29100	     1 8.9819E+18
	 2239573       2120	     61       28800	     1 8.9821E+18

SQL> commit;

Commit complete.

----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 97
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2253986       2120	     97       60000	     1 1.2445E+18
	 2254168       2120	     97       30600	     1 7.9694E+18
	 2254278       2120	     97       30300	     1 1.2445E+18
	 2254607       2120	     97       30300	     1 7.9694E+18
	 2254744       2120	     97       30000	     1 1.2445E+18
	 2254766       2120	     97       29700	     1 -5.665E+18

6 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2120
	and q.querynumber = 97 
	and qe.cardinality IN (30600, 30300)
) 

30 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2120
and q.querynumber = 97
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2253986       2120	     97       60000	     1 1.2445E+18
	 2254744       2120	     97       30000	     1 1.2445E+18
	 2254766       2120	     97       29700	     1 -5.665E+18

SQL> commit;

Commit complete.

---

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 3
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2265913       2257	      3       60000	     1 3.4135E+18
	 2266027       2257	      3       30300	     1 3.4135E+18
	 2266189       2257	      3       30300	     1 -4.703E+18
	 2266546       2257	      3       30000	     1 3.4135E+18
	 2266582       2257	      3       29700	     1 -3.235E+18
	 2266609       2257	      3       29400	     1 3.4135E+18
	 2266629       2257	      3       29100	     1 3.4135E+18
	 2266647       2257	      3       28800	     1 -3.235E+18

8 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 3
	and qe.cardinality IN (30300)
) 

20 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 3
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2265913       2257	      3       60000	     1 3.4135E+18
	 2266546       2257	      3       30000	     1 3.4135E+18
	 2266582       2257	      3       29700	     1 -3.235E+18
	 2266609       2257	      3       29400	     1 3.4135E+18
	 2266629       2257	      3       29100	     1 3.4135E+18
	 2266647       2257	      3       28800	     1 -3.235E+18

6 rows selected.

SQL> commit;

Commit complete.

---

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 31
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2272814       2257	     31       60000	     1 -6.914E+18
	 2272928       2257	     31       30600	     1 6.7722E+18
	 2273088       2257	     31       30300	     1 -6.914E+18
	 2273483       2257	     31       30300	     1 6.7722E+18
	 2273616       2257	     31       30000	     1 -6.914E+18
	 2273634       2257	     31       29700	     1 -6.914E+18
	 2273651       2257	     31       29400	     1 -6.919E+18
	 2273668       2257	     31       29100	     1 -6.914E+18
	 2273686       2257	     31       28800	     1 -6.919E+18

9 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 31
	and qe.cardinality IN (30600,30300,30000)
) 

40 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 31
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc


QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2272814       2257	     31       60000	     1 -6.914E+18
	 2273634       2257	     31       29700	     1 -6.914E+18
	 2273651       2257	     31       29400	     1 -6.919E+18
	 2273668       2257	     31       29100	     1 -6.914E+18
	 2273686       2257	     31       28800	     1 -6.919E+18

SQL> commit;

Commit complete.

----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 49
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2284655       2257	     49       60000	     1 -6.914E+18
	 2284833       2257	     49       30600	     1 7.2341E+17
	 2284936       2257	     49       30300	     1 -6.914E+18
	 2285028       2257	     49       30300	     1 7.2341E+17
	 2285056       2257	     49       30000	     1 -6.914E+18
	 2285120       2257	     49       30000	     1 7.2341E+17
	 2285162       2257	     49       29700	     1 -6.914E+18
	 2285198       2257	     49       29400	     1 -6.914E+18
	 2285211       2257	     49       29100	     1 -6.914E+18
	 2285225       2257	     49       28800	     1 -6.919E+18

10 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 49
	and qe.cardinality IN (30600,29400)
	UNION
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 49 
	and qe.cardinality = 30300
	and qe.queryexecutionid = qep.queryexecutionid
	and qep.planid = (select planid from nsoexpl_actqatc where runid = 2257 and querynum = 49 and card = 30600)
	UNION
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 49 
	and qe.cardinality = 30000
	and qe.queryexecutionid = qep.queryexecutionid
	and qep.planid = (select planid from nsoexpl_actqatc where runid = 2257 and querynum = 49 and card = 60000)
) 

40 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 49
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2284655       2257	     49       60000	     1 -6.914E+18
	 2284936       2257	     49       30300	     1 -6.914E+18
	 2285120       2257	     49       30000	     1 7.2341E+17
	 2285162       2257	     49       29700	     1 -6.914E+18
	 2285211       2257	     49       29100	     1 -6.914E+18
	 2285225       2257	     49       28800	     1 -6.919E+18

6 rows selected.

SQL> commit;

Commit complete.

-----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 60
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2298981       2257	     60       60000	     1 -1.017E+18
	 2299242       2257	     60       31500	     1 3.3398E+18
	 2299299       2257	     60       31200	     1 -1.017E+18
	 2299393       2257	     60       31200	     1 3.3398E+18
	 2299443       2257	     60       30900	     1 -1.017E+18
	 2299493       2257	     60       30600	     1 3.3398E+18
	 2299579       2257	     60       30300	     1 -1.017E+18
	 2299600       2257	     60       30000	     1 3.0524E+18
	 2299617       2257	     60       29700	     1 3.0524E+18
	 2299638       2257	     60       29400	     1 -6.424E+18
	 2299662       2257	     60       29100	     1 3.0524E+18
	 2299681       2257	     60       28800	     1 -6.424E+18

12 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 60
	and qe.cardinality IN (31500,31200)
) 

30 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 60
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2298981       2257	     60       60000	     1 -1.017E+18
	 2299443       2257	     60       30900	     1 -1.017E+18
	 2299493       2257	     60       30600	     1 3.3398E+18
	 2299579       2257	     60       30300	     1 -1.017E+18
	 2299600       2257	     60       30000	     1 3.0524E+18
	 2299617       2257	     60       29700	     1 3.0524E+18
	 2299638       2257	     60       29400	     1 -6.424E+18
	 2299662       2257	     60       29100	     1 3.0524E+18
	 2299681       2257	     60       28800	     1 -6.424E+18

9 rows selected.

SQL> commit;

Commit complete.

-----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 79
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2305611       2257	     79       60000	     1 -2.541E+18
	 2305718       2257	     79       31500	     1 6.8694E+18
	 2305816       2257	     79       31500	     1 6.8694E+18
	 2305925       2257	     79       31500	     1 6.8694E+18
	 2306100       2257	     79       31500	     1 6.8694E+18
	 2306856       2257	     79       31500	     1 6.8694E+18
	 2306872       2257	     79       31200	     1 -2.541E+18
	 2306918       2257	     79       30900	     1 -2.541E+18
	 2306971       2257	     79       30600	     1 -6.621E+18
	 2307066       2257	     79       30600	     1 6.8694E+18
	 2307083       2257	     79       30300	     1 -2.541E+18
	 2307102       2257	     79       30000	     1 -6.621E+18
	 2307125       2257	     79       29700	     1 -6.621E+18
	 2307140       2257	     79       29100	     1 -6.621E+18
	 2307158       2257	     79       28800	     1 2.1709E+18

15 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 79
	and qe.cardinality IN (31500,31200,29700)
	UNION
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 79 
	and qe.cardinality = 30600
	and qe.queryexecutionid = qep.queryexecutionid
	and qep.planid = (select planid from nsoexpl_actqatc where runid = 2257 and querynum = 79 and card = 30000)
) 

80 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 79
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2305611       2257	     79       60000	     1 -2.541E+18
	 2306918       2257	     79       30900	     1 -2.541E+18
	 2307066       2257	     79       30600	     1 6.8694E+18
	 2307083       2257	     79       30300	     1 -2.541E+18
	 2307102       2257	     79       30000	     1 -6.621E+18
	 2307140       2257	     79       29100	     1 -6.621E+18
	 2307158       2257	     79       28800	     1 2.1709E+18

7 rows selected.

SQL> commit;

Commit complete.

---

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 95
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2312281       2257	     95       60000	     1 -6.914E+18
	 2312403       2257	     95       30600	     1 6.7722E+18
	 2312474       2257	     95       30300	     1 -6.914E+18
	 2312527       2257	     95       30300	     1 6.7722E+18
	 2312577       2257	     95       30000	     1 -6.914E+18
	 2312721       2257	     95       29700	     1 6.7722E+18
	 2312840       2257	     95       29400	     1 -6.914E+18
	 2312850       2257	     95       29100	     1 -6.914E+18
	 2312860       2257	     95       28800	     1 -6.919E+18

9 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 95
	and qe.cardinality IN (30600,30300)
) 

30 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 95
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2312281       2257	     95       60000	     1 -6.914E+18
	 2312577       2257	     95       30000	     1 -6.914E+18
	 2312721       2257	     95       29700	     1 6.7722E+18
	 2312840       2257	     95       29400	     1 -6.914E+18
	 2312850       2257	     95       29100	     1 -6.914E+18
	 2312860       2257	     95       28800	     1 -6.919E+18

SQL> commit;

Commit complete.

----

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 98
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2313147       2257	     98       60000	     1 -6.110E+18
	 2313173       2257	     98       30000	     1 -6.110E+18
	 2313231       2257	     98       30000	     1 7.4341E+18
	 2313333       2257	     98       29700	     1 -6.110E+18
	 2313356       2257	     98       29400	     1 -6.110E+18

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2257
	and q.querynumber = 98
	and qe.cardinality IN (30000,29700,29400)
) 

40 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2257
and q.querynumber = 98
--and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2313147       2257	     98       60000	     1 -6.110E+18

SQL> commit;

Commit complete.

---

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2297
and q.querynumber = 54
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2374324       2297	     54       60000	     1 7.2036E+18
	 2374636       2297	     54       31200	     1 7.2036E+18
	 2374822       2297	     54       30900	     1 7.2036E+18
	 2374953       2297	     54       30600	     1 7.2036E+18
	 2375799       2297	     54       30600	     1 7.2036E+18
	 2376240       2297	     54       30300	     1 7.2036E+18
	 2376491       2297	     54       30000	     1 7.2036E+18
	 2376669       2297	     54       29700	     1 -6.355E+18
	 2376806       2297	     54       29400	     1 7.2036E+18
	 2376988       2297	     54       29100	     1 -6.355E+18

10 rows selected.

delete from azdblab_queryexecution qe 
where qe.queryexecutionid 
IN (
	select qe.queryexecutionid
	from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
	where q.queryid = qe.queryid 
	and q.runid = 2297
	and q.querynumber = 54
	and qe.cardinality IN (31200, 30900,30600,30300)
) 

50 rows deleted.

select qe.queryexecutionid, q.runid, q.querynumber, qe.cardinality, qe.iternum, qep.planid
from azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep
where q.queryid = qe.queryid 
and q.runid = 2297
and q.querynumber = 54
and qe.iternum = 1
and qe.queryexecutionid = qep.queryexecutionid
order by qe.queryexecutionid, qe.cardinality desc

QUERYEXECUTIONID      RUNID QUERYNUMBER CARDINALITY    ITERNUM	   PLANID
---------------- ---------- ----------- ----------- ---------- ----------
	 2374324       2297	     54       60000	     1 7.2036E+18
	 2376491       2297	     54       30000	     1 7.2036E+18
	 2376669       2297	     54       29700	     1 -6.355E+18
	 2376806       2297	     54       29400	     1 7.2036E+18
	 2376988       2297	     54       29100	     1 -6.355E+18

10 rows selected.

SQL> commit;

Commit complete.



