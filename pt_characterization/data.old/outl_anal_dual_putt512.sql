select *
from AZDBLab_NewAlgRunResult2 arr
where arr.algrunid = 10620 and iternum = 4

SELECT 
    arr.algrunid,
    (proc.iternum),
    arr.runtime,
    proc.processname, 
    proc.utime+proc.stime as dtime
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 500*1000
and arr.algrunid IN (10620);

  ALGRUNID    ITERNUM	 RUNTIME PROCESSNAME			       DTIME
---------- ---------- ---------- -------------------------------- ----------
     10620	    4	  513713 rhn_check			      542000
     10620	   32	  513938 rhn_check			      779000
     10620	   60	  513705 rhn_check			      548000
     10620	   88	  513937 rhn_check			      777000
     10620	  116	  513705 rhn_check			      541000
     10620	  144	  513943 rhn_check			      783000
     10620	  172	  513710 rhn_check			      542000
     10620	  200	  513942 rhn_check			      776000
     10620	  228	  513696 rhn_check			      546000
     10620	  256	  513944 rhn_check			      775000
     10620	  284	  513699 rhn_check			      544000

  ALGRUNID    ITERNUM	 RUNTIME PROCESSNAME			       DTIME
---------- ---------- ---------- -------------------------------- ----------
     10620	  312	  513945 rhn_check			      785000
     10620	  340	  513702 rhn_check			      540000
     10620	  368	  513957 rhn_check			      786000
     10620	  396	  513710 rhn_check			      542000
     10620	  424	  513932 rhn_check			      779000
     10620	  452	  513702 rhn_check			      544000
     10620	  471	  513947 rhn_check			      783000
     10620	  499	  513703 rhn_check			      542000
     10620	  527	  513948 rhn_check			      779000
     10620	  555	  513710 rhn_check			      545000
     10620	  583	  513945 rhn_check			      775000

  ALGRUNID    ITERNUM	 RUNTIME PROCESSNAME			       DTIME
---------- ---------- ---------- -------------------------------- ----------
     10620	  611	  513701 rhn_check			      540000
     10620	  639	  513947 rhn_check			      776000
     10620	  667	  513707 rhn_check			      543000
     10620	  695	  513952 rhn_check			      781000
     10620	  723	  513697 rhn_check			      541000
     10620	  751	  513945 rhn_check			      779000
     10620	  779	  513695 rhn_check			      542000
     10620	  814	  513945 rhn_check			      782000
     10620	  842	  513697 rhn_check			      542000
     10620	  870	  513951 rhn_check			      777000
     10620	  898	  513695 rhn_check			      543000

  ALGRUNID    ITERNUM	 RUNTIME PROCESSNAME			       DTIME
---------- ---------- ---------- -------------------------------- ----------
     10620	  926	  513936 rhn_check			      776000
     10620	  954	  513690 rhn_check			      536000
     10620	  983	  513957 rhn_check			      791000


SELECT 
    arr.algrunid,
    (proc.iternum),
    arr.runtime,
    proc.processname, 
    proc.utime+proc.stime as dtime
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 1000*1000
--and (proc.utime+proc.stime) > 1000
--and arr.iternum IN (123,122,124,165,163,164)
-- arr.algrunid IN (9720)
and arr.algrunid IN (10620,10680);

  ALGRUNID    ITERNUM	 RUNTIME PROCESSNAME			       DTIME
---------- ---------- ---------- -------------------------------- ----------
     10680	   79	 1058029 rhn_check			    31189000
     10680	  151	 1056039 rhn_check			    29294000
     10680	  663	 1058045 rhn_check			    31231000
     10680	  834	 1058595 rhn_check			    31784000

SELECT 
    arr.algrunid,
    (proc.iternum),
    arr.runtime,
    proc.processname, 
    proc.utime+proc.stime as dtime
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
--and proc.processname = 'rhn_check'
and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 0
and arr.iternum IN (123,122,124,165,163,164)
and arr.algrunid IN (9720);

122     2052479 2052534
123     2083183 2052493
124     2052512 2052526
...
163     2052408 2052511
164     2052555 2052534
165     2082988 2052505

  ALGRUNID    ITERNUM	 RUNTIME PROCESSNAME			       DTIME
---------- ---------- ---------- -------------------------------- ----------
      9720	  124	 4105161 java					1000
      9720	  124	 4105161 rhsmcertd-worke		      115000
      9720	  163	 4105147 rhsmcertd-worke		      115000
      9720	  165	 4105805 java					1000
      9720	  165	 4105805 rhn_check			      770000


DROP TABLE SOC_F CASCADE CONSTRAINTS;
CREATE TABLE SOC_DP_PER_RUN AS
	SELECT 
	    arr.algrunid,
	    (proc.iternum),
	    arr.runtime,
	    proc.processname, 
	    proc.utime+proc.stime as dtime
	FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and proc.processname = 'rhn_check'
	and (proc.utime+proc.stime) > 1000*1000
	--and arr.iternum IN (123,122,124,165,163,164)
	-- arr.algrunid IN (9720)
	and arr.algrunid IN (10620,10680);
ALTER TABLE SOC_DP_PER_RUN ADD PRIMARY KEY (runid, iternum, processname);

   ITERNUM PROCESSNAME				 DTIME
---------- -------------------------------- ----------
	56 rhn_check			      30031000
       249 rhn_check			      30111000
       330 rhn_check			      30191000
       393 rhn_check			       2611000
       455 rhn_check			      30165000
       626 rhn_check			      30114000
       668 rhn_check			      29936000
       752 rhn_check			      30057000
       794 rhn_check			      30406000
       815 rhn_check			      30516000
       941 rhn_check			      28862000

SELECT 
	    arr.algrunid,
	    (proc.iternum),
	    arr.runtime,
	    proc.processname, 
	    proc.utime+proc.stime as dtime
	FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and proc.processname = 'rhn_check'
	and (proc.utime+proc.stime) > 770*1000
	--and arr.iternum IN (123,122,124,165,163,164)
	and arr.algrunid IN (9720)
	order by iternum


