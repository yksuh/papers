-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 02/02/17
-- Description: Define a set of tables/views for SEDONA evaluation 

DROP TABLE NMATC_RUN_PROC_INFO CASCADE CONSTRAINTS;
CREATE TABLE NMATC_RUN_PROC_INFO AS
	SELECT arr.algrunid,
	       ar.exp_run_time,
	       arr.iternum,
	       arr.runtime,
	       proc.processname,
	       sum((proc.utime+proc.stime)/1000) as pt
	FROM AZDBLab_NewAlgRun2 ar, AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE 
	    ar.algrunid = arr.algrunid
	and arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and (proc.utime+proc.stime) > 0
	and arr.algrunid IN (
                -- MATC1K, MATC4K, MATC8K
                13240,12900,13020,
		-- and arr.iternum <= 10 -- the first 10 
                --MATC2K
               13420
	   -- and arr.iternum > 20 and arr.iternum <= 30 -- middle 10 
        )
	group by arr.algrunid, ar.exp_run_time, arr.iternum, arr.runtime, proc.processname
	order by iternum, pt desc;
ALTER TABLE NMATC_RUN_PROC_INFO ADD PRIMARY KEY (algrunid, iternum, processname);

DROP TABLE NMATC_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE NMATC_RUN_Stat AS
	SELECT erpi.algrunid,
	       erpi.exp_run_time,
	       erpi.processname,
	       count(erpi.iternum) as numTrials,
	       round(avg(runtime), 0) as avg_et,
	       round(stddev(runtime), 1) as std_et,
	       round((round(stddev(runtime),1) / round(avg(runtime),0)), 6) as re_et,
	       round(avg(pt), 0) as avg_pt,
	       round(stddev(pt), 1) as std_pt,
	       round((round(stddev(pt),1) / round(avg(pt),0)), 6) as re_pt
	FROM NMATC_RUN_PROC_INFO erpi
	WHERE erpi.processname = 'incr_work'
	and (algrunid IN (13240,13420,12900,13020) and iternum >= 6 and iternum <= 40)
	group by erpi.algrunid, erpi.exp_run_time, erpi.processname
	order by exp_run_time;
ALTER TABLE NMATC_RUN_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
-- select * from NMATC_RUN_Stat;

DROP TABLE NMATC_RUN_TASK_TIME CASCADE CONSTRAINTS;
CREATE TABLE NMATC_RUN_TASK_TIME AS
	SELECT sort_run.algrunid,
	       sort_run.exp_run_time,
	       round(median(sort_run.pt), 0) as task_time,
	       round(avg(sort_run.pt), 0) as avg_task_time,
	       round(stddev(sort_run.pt), 1) as std_task_time
	FROM NMATC_RUN_PROC_INFO sort_run, NMATC_RUN_Stat sort_stat
	WHERE sort_run.algrunid = sort_stat.algrunid 
	and sort_run.exp_run_time = sort_stat.exp_run_time
	and sort_run.processname = 'incr_work'
	and sort_run.pt <= (sort_stat.avg_pt+2*sort_stat.std_pt) 
	and sort_run.pt >= (sort_stat.avg_pt-2*sort_stat.std_pt) 
	having count(sort_run.iternum) > 6 --- at least 6 trials
	group by sort_run.algrunid, sort_run.exp_run_time
	order by exp_run_time;
ALTER TABLE NMATC_RUN_TASK_TIME ADD PRIMARY KEY (algrunid, exp_run_time);

--- select algrunid, exp_run_time, task_time from NMATC_RUN_TASK_TIME order by exp_run_time, algrunid asc

  ALGRUNID EXP_RUN_TIME  TASK_TIME
---------- ------------ ----------
     13240	   1000       8486
     13420	   2000      29069
     12900	   4000     274025
     13020	   8000    2155930

DROP TABLE MATC_CUTOFF_Info CASCADE CONSTRAINTS;
CREATE TABLE MATC_CUTOFF_Info AS
    select distinct dpi.exp_run_time,
           	    dpi.iternum
    from NMATC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
	(dpi.processname = ild.PROCESSNAME and ((select task_time from NMATC_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) < 3600 and ild.TASK_LEN < 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NMATC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and ((select task_time from NMATC_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) >= 3600 and ild.TASK_LEN = 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NMATC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and ((select task_time from NMATC_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) < 720 and ild.TASK_LEN < 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NMATC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and ((select task_time from NMATC_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) >= 720 and ild.TASK_LEN = 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NMATC_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and dpi.processname NOT IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1', 'rhnsd', 'rhsmcertd-worke', 'rhn_check'))
    and dpi.pt > ild.cutoff_pt 
    order by exp_run_time, iternum;
ALTER TABLE MATC_CUTOFF_Info ADD PRIMARY KEY (exp_run_time, iternum);
-- select * from MATC_CUTOFF_Info order by exp_run_time, iternum

EXP_RUN_TIME	ITERNUM
------------ ----------
	4000	     27
	8000	      3
	8000	     10
	8000	     16
	8000	     22
	8000	     23
	8000	     30
	8000	     36

8 rows selected.

DROP TABLE NMATC_RUN_V4_Stat CASCADE CONSTRAINTS;
CREATE TABLE NMATC_RUN_V4_Stat AS
	SELECT erpi.algrunid,
	       erpi.exp_run_time,
	       erpi.processname,
	       count(erpi.iternum) as numTrials,
	       round(avg(runtime), 0) as avg_et,
	       round(stddev(runtime), 1) as std_et,
	       round((round(stddev(runtime),1) / round(avg(runtime),0)), 6) as re_et,
	       round(avg(pt), 0) as avg_pt,
	       round(stddev(pt), 1) as std_pt,
	       round((round(stddev(pt),1) / round(avg(pt),0)), 6) as re_pt
	FROM NMATC_RUN_PROC_INFO erpi
	WHERE erpi.processname = 'incr_work'
	--and iternum > 30 and iternum <= 40
	and iternum > 10
	group by erpi.algrunid, erpi.exp_run_time, erpi.processname
	order by exp_run_time;
ALTER TABLE NMATC_RUN_V4_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
SELECT * from NMATC_RUN_V4_Stat;

DROP TABLE NMATC_RUN_Retained1 CASCADE CONSTRAINTS;
CREATE TABLE NMATC_RUN_Retained1 AS
	select  dpi.exp_run_time, 
		dpi.iternum,
		dpi.runtime as et,
		dpi.pt
	from NMATC_RUN_PROC_INFO dpi 
	where dpi.processname = 'incr_work'
	--and iternum > 30 and iternum <= 40
	and iternum > 10
	and dpi.iternum NOT IN (select distinct ild.iternum 
				from MATC_CUTOFF_Info ild 
				where dpi.exp_run_time = ild.exp_run_time);
ALTER TABLE NMATC_RUN_Retained1 ADD PRIMARY KEY (exp_run_time, iternum);

DROP TABLE NMATC_RUN_Retained1_Stat CASCADE CONSTRAINTS;
CREATE TABLE NMATC_RUN_Retained1_Stat AS
	select  t2.exp_run_time, 
		round(avg(t2.pt),0) as avg_pt, 
		round(stddev(t2.pt),1) as std_pt,
		round((round(stddev(pt),1) / round(avg(pt),0)), 6) as re_pt
	from  NMATC_RUN_Retained1 t2
	group by exp_run_time
	order by exp_run_time asc;
ALTER TABLE NMATC_RUN_Retained1_Stat ADD PRIMARY KEY (exp_run_time);

DROP TABLE NMATC_RUN_FinalStat CASCADE CONSTRAINTS;
CREATE TABLE NMATC_RUN_FinalStat AS
	select  t2.exp_run_time, 
		round(t1.std_et,0) as std_et,
		t1.re_et,
		round(t2.std_pt,0) as std_pt,
		t2.re_pt
	from NMATC_RUN_V4_Stat t1,
	     NMATC_RUN_Retained1_Stat t2
	where t1.exp_run_time = t2.exp_run_time
	order by exp_run_time
	;
ALTER TABLE NMATC_RUN_FinalStat ADD PRIMARY KEY (exp_run_time);
SELECT * from NMATC_RUN_FinalStat;
