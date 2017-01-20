-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 01/11/17
-- Description: Define tables/views for EMP evaluation on INC programs 

DROP TABLE EMP_INC_RUN_PROC_INFO CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_PROC_INFO AS
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
	-- 1 sec, 2 secs, 4 secs, 8 secs, 16 secs, 32 secs, 64 secs
	and (arr.algrunid IN (5292, 5332, 5372, 5412, 5452, 5492, 5532)
	-- 128 secs, 256 secs, 512 secs, 1024 secs, 2048 secs, 4096 secs, 8192 secs, 16384 secs
	or arr.algrunid IN (6258, 6278, 6338, 6318, 6378, 8119, 8880, 8900))
	--or arr.algrunid IN (6258, 6278, 6338, 6318, 6378, 8960, 8880, 8900))
	--and arr.iternum <= 300 -- first 300 
	--group by arr.algrunid, ar.exp_run_time, arr.iternum, arr.runtime, proc.processname
	order by iternum, pt desc;
ALTER TABLE EMP_INC_RUN_PROC_INFO ADD PRIMARY KEY (algrunid, iternum, procid,processname);

DROP TABLE EMP_INC_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Stat AS
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
	FROM EMP_INC_RUN_PROC_INFO erpi
	WHERE erpi.processname = 'incr_work'
	group by erpi.algrunid, erpi.exp_run_time, erpi.processname
	order by exp_run_time;
ALTER TABLE EMP_INC_RUN_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
-- select exp_run_time, numTrials, avg_et, std_et, avg_pt, std_pt from EMP_INC_RUN_Stat

EXP_RUN_TIME  NUMTRIALS     AVG_ET     STD_ET	  AVG_PT     STD_PT
------------ ---------- ---------- ---------- ---------- ----------
	   1	    400    1002.54	    1	 1002.42	 .8
	   2	    400    2004.84	  1.6	 2004.62	1.5
	   4	    400    4009.03	  1.7	 4008.58	1.5
	   8	    400    8019.16	  1.9	 8018.11	1.8
	  16	    400    16036.3	  2.1	16034.32	1.9
	  32	    400   32073.09	 18.9	32068.09	  2
	  64	    400   64145.52	 34.4	64135.23	2.3
	 128	    300  128254.81	 39.1  128251.06	2.3
	 256	    300  256515.69	126.6  256501.84	3.3
	 512	    300  513128.75     1331.6  513004.56	9.4
	1024	    300 1026175.17     1578.2 1026011.53       11.4
	2048	    300  2052151.1	 1169 2052012.42       11.2
	4096	    300 4169058.35     2301.8 4105526.46	 26
	8192	     40 8208373.03	339.6 8207919.35	 21
       16384	     40 16417981.3     5661.7 16415811.5       40.4

15 rows selected.

--column PROCESSNAME format a15
DROP TABLE EMP_INC_RUN_CUTOFF_Info CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_CUTOFF_Info AS
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from EMP_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 3600 and ild.TASK_LEN < 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from EMP_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 3600 and ild.TASK_LEN = 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from EMP_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 720 and ild.TASK_LEN < 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from EMP_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 720 and ild.TASK_LEN = 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from EMP_INC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and dpi.processname NOT IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1', 'rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	order by exp_run_time, iternum
	;
ALTER TABLE EMP_INC_RUN_CUTOFF_Info ADD PRIMARY KEY (exp_run_time, processname, iternum);
-- select distinct exp_run_time, processname, round(avg(pt),0) as avg_pt from EMP_INC_RUN_CUTOFF_Info group by exp_run_time, processname order by exp_run_time, processname asc
-- select distinct exp_run_time, iternum from EMP_INC_RUN_CUTOFF_Info where exp_run_time = 1024 and iter num 
--select distinct exp_run_time, processname,  count(iternum) as numOls, min(pt) as min_pt, round(avg(pt),0) as avg_pt, round(stddev(pt),1) as std_pt from EMP_INC_RUN_CUTOFF_Info group by exp_run_time, processname order by exp_run_time, processname asc

select distinct exp_run_time, iternum from EMP_INC_RUN_CUTOFF_Info order by exp_run_time, iternum

EXP_RUN_TIME	ITERNUM
------------ ----------
	  32	    284
	  32	    291
	  64	     85
	  64	     89
	 128	     90
	 128	    202
	 256	      6
	 256	     62
	 256	    118
	 256	    171
	 256	    202
	 256	    258
	 512	     16
	 512	     44
	 512	     72
	 512	    100
	 512	    128
	 512	    156
	 512	    184
	 512	    212
	 512	    240
	 512	    268
	 512	    296
	 512	    297
	1024	     27
	1024	     88
	1024	    252
	1024	    276
	2048	    117
	4096	     33
	4096	     36
	4096	     57
	4096	    116
	4096	    119
	4096	    135
	4096	    180
	4096	    284
       16384	     10
       16384	     16

39 rows selected.

select t1.exp_run_time, coalesce(count(distinct t0.iternum), 0) as numOutliers, max(t1.iternum) as numTrials
from EMP_INC_RUN_CUTOFF_Info t0, EMP_INC_RUN_PROC_INFO t1
where t0.algrunid = t1.algrunid
group by t1.exp_run_time order by exp_run_time asc

EXP_RUN_TIME NUMOUTLIERS  NUMTRIALS
------------ ----------- ----------
	  32	       2	300
	  64	       2	300
	 128	       2	300
	 256	       6	300
	 512	      12	300
	1024	       4	300
	2048	       1	300
	4096	       8	300
       16384	       2	 40

9 rows selected.

select t1.exp_run_time, coalesce(count(distinct t0.iternum), 0) as numOutliers, max(t1.iternum) as numTrials
from EMP_INC_RUN_PROC_INFO t1 
LEFT OUTER JOIN EMP_INC_RUN_CUTOFF_Info t0
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
	  32	       2	300
	  64	       2	300
	 128	       2	300
	 256	       6	300
	 512	      12	300
	1024	       4	300
	2048	       1	300
	4096	       8	300
	8192	       0	 40
       16384	       2	 40

15 rows selected.

DROP TABLE EMP_INC_RUN_Retained1 CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Retained1 AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.runtime as et,
		dpi.pt
	from EMP_INC_RUN_PROC_INFO dpi 
	where dpi.processname = 'incr_work'
	and dpi.iternum NOT IN (select distinct ild.iternum 
				from EMP_INC_RUN_CUTOFF_Info ild 
				where dpi.algrunid = ild.algrunid);
ALTER TABLE EMP_INC_RUN_Retained1 ADD PRIMARY KEY (algrunid, exp_run_time, iternum);
select exp_run_time as ts_len,avg_et, std_et, re_et, avg_pt, std_pt from EMP_INC_RUN_Retained1_Stat

DROP TABLE EMP_INC_RUN_Retained1_Stat CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Retained1_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained1,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et, 
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt
	from EMP_INC_RUN_Retained1 dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE EMP_INC_RUN_Retained1_Stat ADD PRIMARY KEY (exp_run_time);

DROP TABLE EMP_INC_RUN_Retained2_ET CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Retained2_ET AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.et
	from EMP_INC_RUN_Retained1 dpi, EMP_INC_RUN_Retained1_Stat ms
	where 
	    dpi.algrunid = ms.algrunid 
	and dpi.exp_run_time = ms.exp_run_time
	-- two std margin
	and ((dpi.et >= ms.avg_et - 2*ms.std_et) and (dpi.et <= ms.avg_et + 2*ms.std_et));
ALTER TABLE EMP_INC_RUN_Retained2_ET ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE EMP_INC_RUN_Retained2_PT CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Retained2_PT AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.pt
	from EMP_INC_RUN_Retained1 dpi, EMP_INC_RUN_Retained1_Stat ms
	where 
	    dpi.algrunid = ms.algrunid 
	and dpi.exp_run_time = ms.exp_run_time
	-- two std margin
	and ((dpi.pt >= ms.avg_pt - 2*ms.std_pt) and (dpi.pt <= ms.avg_pt + 2*ms.std_pt));
ALTER TABLE EMP_INC_RUN_Retained2_PT ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE EMP_INC_RUN_Retained2_ET_Stat CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Retained2_ET_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained2,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et
	from EMP_INC_RUN_Retained2_ET dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE EMP_INC_RUN_Retained2_ET_Stat ADD PRIMARY KEY (algrunid, exp_run_time);

DROP TABLE EMP_INC_RUN_Retained2_PT_Stat CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Retained2_PT_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained2,
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt
	from EMP_INC_RUN_Retained2_PT dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE EMP_INC_RUN_Retained2_PT_Stat ADD PRIMARY KEY (algrunid, exp_run_time);


DROP TABLE EMP_INC_RUN_Final_ET_Stat CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Final_ET_Stat AS
	select  t0.algrunid, 
		t0.exp_run_time as ts_len, 
		t2.numTrials, 
		(t2.numTrials-t1.numRetained1) as num1ndOls,
		(t1.numRetained1-t0.numRetained2) as num2ndOls,
		t0.numRetained2 as numRet,
		t0.avg_et, 
		t0.std_et,
		round(t0.std_et/t0.avg_et, 6) as re_et
	from EMP_INC_RUN_Retained2_ET_Stat t0, 
	     EMP_INC_RUN_Retained1_Stat t1,
	     EMP_INC_RUN_Stat t2
	where t0.algrunid = t1.algrunid 
	and t1.algrunid = t2.algrunid 
	and t0.exp_run_time = t1.exp_run_time
	and t1.exp_run_time = t2.exp_run_time
	order by ts_len asc;
ALTER TABLE EMP_INC_RUN_Final_ET_Stat ADD PRIMARY KEY (algrunid, ts_len);
-- select ts_len,numTrials, num1ndOls, num2ndOls, avg_et, std_et, re_et from EMP_INC_RUN_Final_ET_Stat

    TS_LEN  NUMTRIALS  NUM1NDOLS  NUM2NDOLS	AVG_ET	   STD_ET      RE_ET
---------- ---------- ---------- ---------- ---------- ---------- ----------
	 1	  300	       0	 13	  1003	       .8    .000798
	 2	  300	       0	 17	  2005		1    .000499
	 4	  300	       0	  0	  4009	      1.8    .000449
	 8	  300	       0	  8	  8019	      1.8    .000224
	16	  300	       0	  6	 16036		2    .000125
	32	  300	       2	 12	 32072	      1.6     .00005
	64	  300	       2	 15	 64143		2    .000031
       128	  300	       2	  9	128252	      2.1    .000016
       256	  300	       6	 19	256502	      2.4    .000009
       512	  300	      12	 11	513005		3    .000006
      1024	  300	       4	 20    1026014	      4.9    .000005
      2048	  300	       1	 21    2052047	    103.5     .00005
      4096	  300	       8	  1    4168780	    355.7    .000085
      8192	   40	       0	  0    8208373	    339.6    .000041
     16384	   40	       2	  4   16416637	    138.6    .000008

15 rows selected.


DROP TABLE EMP_INC_RUN_Final_PT_Stat CASCADE CONSTRAINTS;
CREATE TABLE EMP_INC_RUN_Final_PT_Stat AS
	select  t0.algrunid, 
		t0.exp_run_time as ts_len, 
		t2.numTrials, 
		(t2.numTrials-t1.numRetained1) as num1ndOls,
		(t1.numRetained1-t0.numRetained2) as num2ndOls,
		t0.numRetained2 as numRet,
		t0.avg_pt, 
		t0.std_pt,
		round(t0.std_pt/t0.avg_pt, 6) as re_pt
	from EMP_INC_RUN_Retained2_PT_Stat t0, 
	     EMP_INC_RUN_Retained1_Stat t1,
	     EMP_INC_RUN_Stat t2
	where t0.algrunid = t1.algrunid 
	and t1.algrunid = t2.algrunid 
	and t0.exp_run_time = t1.exp_run_time
	and t1.exp_run_time = t2.exp_run_time
	order by ts_len asc;
ALTER TABLE EMP_INC_RUN_Final_PT_Stat ADD PRIMARY KEY (algrunid, ts_len);
-- select ts_len,numTrials, num1ndOls, num2ndOls, avg_pt, std_pt, re_pt from EMP_INC_RUN_Final_PT_Stat

    TS_LEN  NUMTRIALS  NUM1NDOLS  NUM2NDOLS	AVG_PT	   STD_PT      RE_PT
---------- ---------- ---------- ---------- ---------- ---------- ----------
	 1	 1000	       0	 57	  1002	       .6    .000599
	 2	 1000	       0	 86	  2005	       .8    .000399
	 4	 1000	       0	 25	  4009	      1.5    .000374
	 8	 1000	       2	  9	  8018	      1.7    .000212
	16	 1000	       2	 41	 16034	      1.7    .000106
	32	 1000	       5	 60	 32068	      1.7    .000053
	64	 1000	      11	 37	 64135		2    .000031
       128	  300	       2	  7	128251	      2.1    .000016
       256	  300	       6	 11	256502	      2.4    .000009
       512	  300	      12	 12	513004	      2.7    .000005
      1024	  300	       4	 12    1026011	      4.1    .000004
      2048	  300	       1	 14    2052012	      6.3    .000003
      4096	   40	       1	  2    4103969	      6.9    .000002
      8192	   40	       0	  2    8207919	     18.4    .000002
     16384	   40	       2	  0   16415805	     26.7    .000002

15 rows selected.
