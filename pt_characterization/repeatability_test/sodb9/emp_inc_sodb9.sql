-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 03/08/17
-- Description: Define tables/views for EMP evaluation on INC programs 

DROP TABLE NS9_INC_RUN_PROC_INFO CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_PROC_INFO AS
	SELECT arr.algrunid,
	       ar.exp_run_time,
	       arr.iternum,
	       arr.runtime,
	       proc.procid,
	       proc.processname,
	       (proc.utime+proc.stime)/1000 as pt
	FROM AZDBLab_NewAlgRun2 ar, AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE 
	    ar.algrunid = arr.algrunid
	and arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and (proc.utime+proc.stime) > 0
	-- sodb9 
			    -- 1 sec, 2 secs, 4 secs, 8 secs, 16 secs,
	and arr.algrunid IN (18140, 18160, 18180, 18200, 18220, 
		-- 32 secs, 64 secs, 128 secs, 256 secs, 512 secs
		18240, 18260, 18280, 18300, 18320
		-- 1024 secs
		-- , 18400
	)
	order by iternum, pt desc;
ALTER TABLE NS9_INC_RUN_PROC_INFO ADD PRIMARY KEY (algrunid, iternum, procid,processname);
-- select max(iternum) from AZDBLab_ProcInfo2 where algrunid = 18140 and processname = 'incr_work'

DROP TABLE NS9_INC_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Stat AS
	SELECT erpi.algrunid,
	       erpi.exp_run_time,
	       erpi.processname,
	       count(erpi.iternum) as numTrials,
	       round(avg(runtime), 2) as avg_et,
	       round(stddev(runtime), 1) as std_et,
	       round((round(stddev(runtime),1) / round(avg(runtime),0)), 6) as re_et,
	       round(avg(pt), 2) as avg_pt,
	       round(stddev(pt), 1) as std_pt,
	       round((round(stddev(pt),1) / round(avg(pt),0)), 6) as re_pt
	FROM NS9_INC_RUN_PROC_INFO erpi
	WHERE erpi.processname = 'incr_work'
	group by erpi.algrunid, erpi.exp_run_time, erpi.processname
	order by exp_run_time;
ALTER TABLE NS9_INC_RUN_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
-- select algrunid, exp_run_time, numTrials, avg_et, std_et, avg_pt, std_pt from NS9_INC_RUN_Stat

  ALGRUNID EXP_RUN_TIME  NUMTRIALS     AVG_ET	  STD_ET     AVG_PT	STD_PT
---------- ------------ ---------- ---------- ---------- ---------- ----------
     18140	      1       1000    1002.63	     1.2    1002.48	   1.1
     18160	      2       1000    2004.79	     1.8    2004.54	   1.6
     18180	      4       1000    4009.13	     2.5    4008.71	   2.4
     18200	      8       1000    8019.29	     2.9    8018.19	   2.8
     18220	     16       1000   16036.47	     2.3    16034.5	   2.2
     18240	     32       1000   32072.15	     3.5   32068.39	   2.8
     18260	     64       1000   64142.87	       3   64135.62	   2.9
     18280	    128        300  128286.86	     4.9  128271.88	   3.2
     18300	    256        300  256574.38	     5.9  256544.79	   4.6
     18320	    512        300  513150.17	      99   513086.7	  16.7

10 rows selected.

--column PROCESSNAME format a15
DROP TABLE NS9_INC_RUN_CUTOFF_Info CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_CUTOFF_Info AS
	select distinct * 
	from 
	(select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from NS9_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 3600 and ild.TASK_LEN < 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from NS9_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 3600 and ild.TASK_LEN = 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from NS9_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 720 and ild.TASK_LEN < 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from NS9_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 720 and ild.TASK_LEN = 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from NS9_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and dpi.processname NOT IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1', 'rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	order by exp_run_time, iternum
	)
	;
ALTER TABLE NS9_INC_RUN_CUTOFF_Info ADD PRIMARY KEY (exp_run_time, processname, iternum);
-- select distinct exp_run_time, processname, round(avg(pt),0) as avg_pt from NS9_INC_RUN_CUTOFF_Info group by exp_run_time, processname order by exp_run_time, processname asc
-- select distinct exp_run_time, iternum from NS9_INC_RUN_CUTOFF_Info where exp_run_time = 1024 and iter num 
--select distinct exp_run_time, processname,  count(iternum) as numOls, min(pt) as min_pt, round(avg(pt),0) as avg_pt, round(stddev(pt),1) as std_pt from NS9_INC_RUN_CUTOFF_Info group by exp_run_time, processname order by exp_run_time, processname asc

select distinct exp_run_time, algrunid, iternum from NS9_INC_RUN_CUTOFF_Info order by exp_run_time, algrunid, iternum

EXP_RUN_TIME   ALGRUNID    ITERNUM
------------ ---------- ----------
	  32	  18240        433
	 128	  18280 	26
	 256	  18300        199
	 512	  18320        114
	 512	  18320        186
	 512	  18320        285

6 rows selected.

select t1.exp_run_time, coalesce(count(distinct t0.iternum), 0) as numOutliers, max(t1.iternum) as numTrials
from NS9_INC_RUN_CUTOFF_Info t0, NS9_INC_RUN_PROC_INFO t1
where t0.algrunid = t1.algrunid
group by t1.exp_run_time order by exp_run_time asc

EXP_RUN_TIME NUMOUTLIERS  NUMTRIALS
------------ ----------- ----------
	   8	       1	300

select t1.exp_run_time, coalesce(count(distinct t0.iternum), 0) as numOutliers, max(t1.iternum) as numTrials
from NS9_INC_RUN_PROC_INFO t1 
LEFT OUTER JOIN NS9_INC_RUN_CUTOFF_Info t0
ON t0.algrunid = t1.algrunid 
group by t1.exp_run_time
order by exp_run_time

EXP_RUN_TIME NUMOUTLIERS  NUMTRIALS
------------ ----------- ----------
	   1	       0	300
	   2	       0	300
	   4	       0	300
	   8	       1	300
	  16	       0	300
	  32	       0	300
	  64	       0	300
	 128	       0	300

8 rows selected.

DROP TABLE NS9_INC_RUN_Retained1 CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Retained1 AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.runtime as et,
		dpi.pt
	from NS9_INC_RUN_PROC_INFO dpi 
	where dpi.processname = 'incr_work'
	and dpi.iternum NOT IN (select distinct ild.iternum 
				from NS9_INC_RUN_CUTOFF_Info ild 
				where dpi.algrunid = ild.algrunid);
ALTER TABLE NS9_INC_RUN_Retained1 ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE NS9_INC_RUN_Retained1_Stat CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Retained1_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained1,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et, 
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt
	from NS9_INC_RUN_Retained1 dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE NS9_INC_RUN_Retained1_Stat ADD PRIMARY KEY (exp_run_time);

DROP TABLE NS9_INC_RUN_Retained2_ET CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Retained2_ET AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.et
	from NS9_INC_RUN_Retained1 dpi, NS9_INC_RUN_Retained1_Stat ms
	where 
	    dpi.algrunid = ms.algrunid 
	and dpi.exp_run_time = ms.exp_run_time
	-- two std margin
	and ((dpi.et >= ms.avg_et - 2*ms.std_et) and (dpi.et <= ms.avg_et + 2*ms.std_et));
ALTER TABLE NS9_INC_RUN_Retained2_ET ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE NS9_INC_RUN_Retained2_PT CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Retained2_PT AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.pt
	from NS9_INC_RUN_Retained1 dpi, NS9_INC_RUN_Retained1_Stat ms
	where 
	    dpi.algrunid = ms.algrunid 
	and dpi.exp_run_time = ms.exp_run_time
	-- two std margin
	and ((dpi.pt >= ms.avg_pt - 2*ms.std_pt) and (dpi.pt <= ms.avg_pt + 2*ms.std_pt));
ALTER TABLE NS9_INC_RUN_Retained2_PT ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE NS9_INC_RUN_Retained2_ET_Stat CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Retained2_ET_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained2,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et
	from NS9_INC_RUN_Retained2_ET dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE NS9_INC_RUN_Retained2_ET_Stat ADD PRIMARY KEY (algrunid, exp_run_time);

DROP TABLE NS9_INC_RUN_Retained2_PT_Stat CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Retained2_PT_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained2,
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt
	from NS9_INC_RUN_Retained2_PT dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE NS9_INC_RUN_Retained2_PT_Stat ADD PRIMARY KEY (algrunid, exp_run_time);

DROP TABLE NS9_INC_RUN_Final_ET_Stat CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Final_ET_Stat AS
	select  t0.algrunid, 
		t0.exp_run_time as ts_len, 
		t2.numTrials, 
		(t2.numTrials-t1.numRetained1) as num1ndOls,
		(t1.numRetained1-t0.numRetained2) as num2ndOls,
		t0.numRetained2 as numRet,
		t0.avg_et, 
		t0.std_et,
		round(t0.std_et/t0.avg_et, 6) as re_et
	from NS9_INC_RUN_Retained2_ET_Stat t0, 
	     NS9_INC_RUN_Retained1_Stat t1,
	     NS9_INC_RUN_Stat t2
	where t0.algrunid = t1.algrunid 
	and t1.algrunid = t2.algrunid 
	and t0.exp_run_time = t1.exp_run_time
	and t1.exp_run_time = t2.exp_run_time
	order by ts_len asc;
ALTER TABLE NS9_INC_RUN_Final_ET_Stat ADD PRIMARY KEY (algrunid, ts_len);
-- select ts_len,numTrials, num1ndOls, num2ndOls, avg_et, std_et, re_et from NS9_INC_RUN_Final_ET_Stat

    TS_LEN  NUMTRIALS  NUM1NDOLS  NUM2NDOLS	AVG_ET	   STD_ET      RE_ET
---------- ---------- ---------- ---------- ---------- ---------- ----------
	 1	  300	       0	 19	  1003	       .8    .000798
	 2	  300	       0	 21	  2005		1    .000499
	 4	  300	       0	 11	  4009	      2.2    .000549
	 8	  300	       1	  0	  8019	      2.9    .000362
	16	  300	       0	 21	 16036	      1.7    .000106
	32	  300	       0	  2	 32072	      2.7    .000084
	64	  300	       0	 14	 64143	      2.4    .000037
       128	  300	       0	 16	128286	      2.6     .00002

8 rows selected.


DROP TABLE NS9_INC_RUN_Final_PT_Stat CASCADE CONSTRAINTS;
CREATE TABLE NS9_INC_RUN_Final_PT_Stat AS
	select  t0.algrunid, 
		t0.exp_run_time as ts_len, 
		t2.numTrials, 
		(t2.numTrials-t1.numRetained1) as num1ndOls,
		(t1.numRetained1-t0.numRetained2) as num2ndOls,
		t0.numRetained2 as numRet,
		t0.avg_pt, 
		t0.std_pt,
		round(t0.std_pt/t0.avg_pt, 6) as re_pt
	from NS9_INC_RUN_Retained2_PT_Stat t0, 
	     NS9_INC_RUN_Retained1_Stat t1,
	     NS9_INC_RUN_Stat t2
	where t0.algrunid = t1.algrunid 
	and t1.algrunid = t2.algrunid 
	and t0.exp_run_time = t1.exp_run_time
	and t1.exp_run_time = t2.exp_run_time
	order by ts_len asc;
ALTER TABLE NS9_INC_RUN_Final_PT_Stat ADD PRIMARY KEY (algrunid, ts_len);
-- select ts_len,numTrials, num1ndOls, num2ndOls, avg_pt, std_pt, re_pt from NS9_INC_RUN_Final_PT_Stat

    TS_LEN  NUMTRIALS  NUM1NDOLS  NUM2NDOLS	AVG_PT	   STD_PT      RE_PT
---------- ---------- ---------- ---------- ---------- ---------- ----------
	 1	  300	       0	 21	  1003	       .6    .000598
	 2	  300	       0	 22	  2005	       .8    .000399
	 4	  300	       0	 38	  4009	      1.5    .000374
	 8	  300	       1	  0	  8018	      2.9    .000362
	16	  300	       0	 16	 16034	      1.6      .0001
	32	  300	       0	  2	 32068	      2.6    .000081
	64	  300	       0	 14	 64136	      2.3    .000036
       128	  300	       0	  8	128271	      2.7    .000021

8 rows selected.
