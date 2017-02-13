-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 02/13/17
-- Description: Define tables/views for EMP evaluation on INC programs 

DROP TABLE S12_INC_RUN_PROC_INFO CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_PROC_INFO AS
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
	--and proc.processname NOT IN ('incr_work')
	-- 1 sec, 2 secs, 4 secs, 8 secs, 16 secs, 32 secs, 64 secs, 128 secs
	-- sodb8
	--and arr.algrunid IN (17260,17340,17400,17460,17520,17580,17640,17700)
	-- sodb9
	--and arr.algrunid IN (17280,17360,17420,17480,17540,17600,17660,17720)
	-- sodb10
	--and arr.algrunid IN (17300,17380,17440,17500,17560,17620,17680,17740)
	-- sodb12
	and arr.algrunid IN (17320,17760,17780,17800,17820,17840,17860,17880)
	order by iternum, pt desc;
ALTER TABLE S12_INC_RUN_PROC_INFO ADD PRIMARY KEY (algrunid, iternum, procid,processname);

DROP TABLE S12_INC_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Stat AS
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
	FROM S12_INC_RUN_PROC_INFO erpi
	WHERE erpi.processname = 'incr_work'
	group by erpi.algrunid, erpi.exp_run_time, erpi.processname
	order by exp_run_time;
ALTER TABLE S12_INC_RUN_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
-- select exp_run_time, numTrials, avg_et, std_et, avg_pt, std_pt from S12_INC_RUN_Stat

EXP_RUN_TIME  NUMTRIALS     AVG_ET     STD_ET	  AVG_PT     STD_PT
------------ ---------- ---------- ---------- ---------- ----------
	   1	    300    1002.08	    1	 1002.04	  1
	   2	    300    2004.13	  1.5	 2004.03	1.5
	   4	    300    4008.06	  2.1	 4007.97	2.1
	   8	    300    8015.99	  2.6	 8015.95	2.6
	  16	    300   16031.62	  1.2	16031.48	1.2
	  32	    300   32062.74	  1.9	32062.67	1.9
	  64	    300   64125.86	  3.8	64125.46	2.2
	 128	    300  128250.63	  2.4  128250.17	2.5

8 rows selected.

--column PROCESSNAME format a15
DROP TABLE S12_INC_RUN_CUTOFF_Info CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_CUTOFF_Info AS
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from S12_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 3600 and ild.TASK_LEN < 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from S12_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 3600 and ild.TASK_LEN = 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from S12_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 720 and ild.TASK_LEN < 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from S12_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 720 and ild.TASK_LEN = 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from S12_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and dpi.processname NOT IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1', 'rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	order by exp_run_time, iternum
	;
ALTER TABLE S12_INC_RUN_CUTOFF_Info ADD PRIMARY KEY (exp_run_time, processname, iternum);
-- select distinct exp_run_time, processname, round(avg(pt),0) as avg_pt from S12_INC_RUN_CUTOFF_Info group by exp_run_time, processname order by exp_run_time, processname asc
-- select distinct exp_run_time, iternum from S12_INC_RUN_CUTOFF_Info where exp_run_time = 1024 and iter num 
--select distinct exp_run_time, processname,  count(iternum) as numOls, min(pt) as min_pt, round(avg(pt),0) as avg_pt, round(stddev(pt),1) as std_pt from S12_INC_RUN_CUTOFF_Info group by exp_run_time, processname order by exp_run_time, processname asc

select distinct exp_run_time, algrunid, iternum from S12_INC_RUN_CUTOFF_Info order by exp_run_time, algrunid, iternum


select t1.exp_run_time, coalesce(count(distinct t0.iternum), 0) as numOutliers, max(t1.iternum) as numTrials
from S12_INC_RUN_CUTOFF_Info t0, S12_INC_RUN_PROC_INFO t1
where t0.algrunid = t1.algrunid
group by t1.exp_run_time order by exp_run_time asc


select t1.exp_run_time, coalesce(count(distinct t0.iternum), 0) as numOutliers, max(t1.iternum) as numTrials
from S12_INC_RUN_PROC_INFO t1 
LEFT OUTER JOIN S12_INC_RUN_CUTOFF_Info t0
ON t0.algrunid = t1.algrunid 
group by t1.exp_run_time
order by exp_run_time

EXP_RUN_TIME NUMOUTLIERS  NUMTRIALS
------------ ----------- ----------
	   1	       0	300
	   2	       0	300
	   4	       0	300
	   8	       0	300
	  16	       0	300
	  32	       0	300
	  64	       0	300
	 128	       0	300

8 rows selected.

DROP TABLE S12_INC_RUN_Retained1 CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Retained1 AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.runtime as et,
		dpi.pt
	from S12_INC_RUN_PROC_INFO dpi 
	where dpi.processname = 'incr_work'
	and dpi.iternum NOT IN (select distinct ild.iternum 
				from S12_INC_RUN_CUTOFF_Info ild 
				where dpi.algrunid = ild.algrunid);
ALTER TABLE S12_INC_RUN_Retained1 ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE S12_INC_RUN_Retained1_Stat CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Retained1_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained1,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et, 
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt
	from S12_INC_RUN_Retained1 dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE S12_INC_RUN_Retained1_Stat ADD PRIMARY KEY (exp_run_time);

DROP TABLE S12_INC_RUN_Retained2_ET CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Retained2_ET AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.et
	from S12_INC_RUN_Retained1 dpi, S12_INC_RUN_Retained1_Stat ms
	where 
	    dpi.algrunid = ms.algrunid 
	and dpi.exp_run_time = ms.exp_run_time
	-- two std margin
	and ((dpi.et >= ms.avg_et - 2*ms.std_et) and (dpi.et <= ms.avg_et + 2*ms.std_et));
ALTER TABLE S12_INC_RUN_Retained2_ET ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE S12_INC_RUN_Retained2_PT CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Retained2_PT AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.pt
	from S12_INC_RUN_Retained1 dpi, S12_INC_RUN_Retained1_Stat ms
	where 
	    dpi.algrunid = ms.algrunid 
	and dpi.exp_run_time = ms.exp_run_time
	-- two std margin
	and ((dpi.pt >= ms.avg_pt - 2*ms.std_pt) and (dpi.pt <= ms.avg_pt + 2*ms.std_pt));
ALTER TABLE S12_INC_RUN_Retained2_PT ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE S12_INC_RUN_Retained2_ET_Stat CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Retained2_ET_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained2,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et
	from S12_INC_RUN_Retained2_ET dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE S12_INC_RUN_Retained2_ET_Stat ADD PRIMARY KEY (algrunid, exp_run_time);

DROP TABLE S12_INC_RUN_Retained2_PT_Stat CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Retained2_PT_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained2,
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt
	from S12_INC_RUN_Retained2_PT dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE S12_INC_RUN_Retained2_PT_Stat ADD PRIMARY KEY (algrunid, exp_run_time);

DROP TABLE S12_INC_RUN_Final_ET_Stat CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Final_ET_Stat AS
	select  t0.algrunid, 
		t0.exp_run_time as ts_len, 
		t2.numTrials, 
		(t2.numTrials-t1.numRetained1) as num1ndOls,
		(t1.numRetained1-t0.numRetained2) as num2ndOls,
		t0.numRetained2 as numRet,
		t0.avg_et, 
		t0.std_et,
		round(t0.std_et/t0.avg_et, 6) as re_et
	from S12_INC_RUN_Retained2_ET_Stat t0, 
	     S12_INC_RUN_Retained1_Stat t1,
	     S12_INC_RUN_Stat t2
	where t0.algrunid = t1.algrunid 
	and t1.algrunid = t2.algrunid 
	and t0.exp_run_time = t1.exp_run_time
	and t1.exp_run_time = t2.exp_run_time
	order by ts_len asc;
ALTER TABLE S12_INC_RUN_Final_ET_Stat ADD PRIMARY KEY (algrunid, ts_len);
-- select ts_len,numTrials, num1ndOls, num2ndOls, avg_et, std_et, re_et from S12_INC_RUN_Final_ET_Stat


    TS_LEN  NUMTRIALS  NUM1NDOLS  NUM2NDOLS	AVG_ET	   STD_ET      RE_ET
---------- ---------- ---------- ---------- ---------- ---------- ----------
	 1	  300	       0	 14	  1002	       .7    .000699
	 2	  300	       0	 18	  2004		1    .000499
	 4	  300	       0	  1	  4008	      2.1    .000524
	 8	  300	       0	  0	  8016	      2.6    .000324
	16	  300	       0	 19	 16031	       .8     .00005
	32	  300	       0	 31	 32062	      1.1    .000034
	64	  300	       0	  2	 64126	      1.8    .000028
       128	  300	       0	  5	128251	      2.4    .000019

8 rows selected.
DROP TABLE S12_INC_RUN_Final_PT_Stat CASCADE CONSTRAINTS;
CREATE TABLE S12_INC_RUN_Final_PT_Stat AS
	select  t0.algrunid, 
		t0.exp_run_time as ts_len, 
		t2.numTrials, 
		(t2.numTrials-t1.numRetained1) as num1ndOls,
		(t1.numRetained1-t0.numRetained2) as num2ndOls,
		t0.numRetained2 as numRet,
		t0.avg_pt, 
		t0.std_pt,
select ts_len,numTrials, num1ndOls, num2ndOls, avg_pt, std_pt, re_pt from S12_INC_RUN_Final_PT_Stat		round(t0.std_pt/t0.avg_pt, 6) as re_pt
	from S12_INC_RUN_Retained2_PT_Stat t0, 
	     S12_INC_RUN_Retained1_Stat t1,
	     S12_INC_RUN_Stat t2
	where t0.algrunid = t1.algrunid 
	and t1.algrunid = t2.algrunid 
	and t0.exp_run_time = t1.exp_run_time
	and t1.exp_run_time = t2.exp_run_time
	order by ts_len asc;
ALTER TABLE S12_INC_RUN_Final_PT_Stat ADD PRIMARY KEY (algrunid, ts_len);
-- select ts_len,numTrials, num1ndOls, num2ndOls, avg_pt, std_pt, re_pt from S12_INC_RUN_Final_PT_Stat

    TS_LEN  NUMTRIALS  NUM1NDOLS  NUM2NDOLS	AVG_PT	   STD_PT      RE_PT
---------- ---------- ---------- ---------- ---------- ---------- ----------
	 1	  300	       0	 15	  1002	       .7    .000699
	 2	  300	       0	 18	  2004		1    .000499
	 4	  300	       0	  6	  4008		2    .000499
	 8	  300	       0	  0	  8016	      2.6    .000324
	16	  300	       0	 26	 16031	       .6    .000037
	32	  300	       0	 29	 32062	      1.2    .000037
	64	  300	       0	 21	 64125	      1.5    .000023
       128	  300	       0	  2	128250	      2.5    .000019

8 rows selected.

