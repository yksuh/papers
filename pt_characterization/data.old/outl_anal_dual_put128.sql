DROP TABLE SOC_DP_PER_RUN CASCADE CONSTRAINTS;
CREATE TABLE SOC_DP_PER_RUN AS
	SELECT 
	    arr.algrunid as runid,
	    proc.iternum,
	    proc.procid,
	    proc.processname, 
	    proc.utime+proc.stime as dtime
	FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	--and proc.processname <> 'proc_monitor'
	and (proc.utime+proc.stime) > 0
	and arr.algrunid = 10360 and arr.iternum 
	IN (68, 180, 292, 351, 435, 547, 659, 771, 883, 986);
ALTER TABLE SOC_DP_PER_RUN ADD PRIMARY KEY (runid, iternum, procid);
select iternum, procid,processname, dtime from SOC_DP_PER_RUN order by runid, iternum, dtime desc, procid;

   ITERNUM     PROCID PROCESSNAME			    DTIME
---------- ---------- -------------------------------- ----------
	68	16608 incr_work 			128264000
	68	12408 proc_monitor			   202000
	68	  166 kslowd000 			     7000
	68	  167 kslowd001 			     6000
	68	16598 java				     3000
	68	  474 md0_raid1 			     1000
	68	16886 java				     1000
       180	16608 incr_work 			128267000
       180	12408 proc_monitor			   204000
       180	  167 kslowd001 			     7000
       180	  166 kslowd000 			     6000

   ITERNUM     PROCID PROCESSNAME			    DTIME
---------- ---------- -------------------------------- ----------
       180	  474 md0_raid1 			     4000
       180	16598 java				     3000
       292	16608 incr_work 			128270000
       292	12408 proc_monitor			   202000
       292	  166 kslowd000 			     7000
       292	  167 kslowd001 			     6000
       292	  474 md0_raid1 			     3000
       292	16598 java				     3000
       351	16608 incr_work 			128270000
       351	18114 proc_monitor			   202000
       351	  167 kslowd001 			     7000

   ITERNUM     PROCID PROCESSNAME			    DTIME
---------- ---------- -------------------------------- ----------
       351	  166 kslowd000 			     6000
       351	16598 java				     3000
       351	   16 kblockd/0 			     1000
       351	  474 md0_raid1 			     1000
       351	18086 java				     1000
       435	16608 incr_work 			128270000
       435	18114 proc_monitor			   202000
       435	  166 kslowd000 			     7000
       435	  167 kslowd001 			     6000
       435	16598 java				     3000
       435	  474 md0_raid1 			     1000

   ITERNUM     PROCID PROCESSNAME			    DTIME
---------- ---------- -------------------------------- ----------
       547	16608 incr_work 			128275000
       547	18114 proc_monitor			   202000
       547	  167 kslowd001 			     7000
       547	  166 kslowd000 			     6000
       547	16598 java				     3000
       659	16608 incr_work 			128268000
       659	18114 proc_monitor			   202000
       659	  166 kslowd000 			     7000
       659	  167 kslowd001 			     6000
       659	16598 java				     3000
       659	  474 md0_raid1 			     2000

   ITERNUM     PROCID PROCESSNAME			    DTIME
---------- ---------- -------------------------------- ----------
       659	19372 java				     1000
       771	16608 incr_work 			128270000
       771	18114 proc_monitor			   202000
       771	  167 kslowd001 			     7000
       771	  166 kslowd000 			     6000
       771	16598 java				     3000
       771	  474 md0_raid1 			     2000
       883	16608 incr_work 			128271000
       883	18114 proc_monitor			   202000
       883	  166 kslowd000 			     7000
       883	  167 kslowd001 			     6000

   ITERNUM     PROCID PROCESSNAME			    DTIME
---------- ---------- -------------------------------- ----------
       883	16598 java				     3000
       883	  474 md0_raid1 			     1000
       986	16608 incr_work 			128273000
       986	18114 proc_monitor			   202000
       986	  167 kslowd001 			     7000
       986	  166 kslowd000 			     6000
       986	16598 java				     3000


DROP TABLE SOC_DP_STAT CASCADE CONSTRAINTS;
CREATE TABLE SOC_DP_STAT AS
	SELECT t0.runid,
		t0.iternum,
		t1.proc_time as put_time,
		t0.proc_time as daemon_time
	FROM 
		(SELECT runid,
		       iternum,
		       sum(dtime)/1000 as proc_time
		FROM SOC_DP_PER_RUN
		WHERE processname <> 'incr_work'	
		GROUP BY runid, iternum) t0,
		(SELECT runid,
		       iternum,
		       (dtime/1000) as proc_time
		FROM SOC_DP_PER_RUN
		WHERE processname = 'incr_work') t1
	WHERE t0.runid = t1.runid and t0.iternum = t1.iternum;
ALTER TABLE SOC_DP_STAT ADD PRIMARY KEY (runid, iternum);
select * from SOC_DP_STAT order by iternum;

SQL> select * from SOC_DP_STAT order by iternum;

     RUNID    ITERNUM	PUT_TIME DAEMON_TIME
---------- ---------- ---------- -----------
     10360	   68	  128264	  18
     10360	  180	  128267	  20
     10360	  292	  128270	  19
     10360	  351	  128270	  19
     10360	  435	  128270	  17
     10360	  547	  128275	  16
     10360	  659	  128268	  19
     10360	  771	  128270	  18
     10360	  883	  128271	  17
     10360	  986	  128273	  16

     RUNID    ITERNUM	PUT_TIME DAEMON_TIME
---------- ---------- ---------- -----------
     10360	   68	  128264	 220
     10360	  180	  128267	 224
     10360	  292	  128270	 221
     10360	  351	  128270	 221
     10360	  435	  128270	 219
     10360	  547	  128275	 218
     10360	  659	  128268	 221
     10360	  771	  128270	 220
     10360	  883	  128271	 219
     10360	  986	  128273	 218

select corr(put_time, daemon_time) from SOC_DP_STAT order by iternum;
-0.67

-.62661193
