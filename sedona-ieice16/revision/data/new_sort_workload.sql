-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 02/02/17
-- Description: Define a set of tables/views for SEDONA evaluation 

DROP TABLE NSORT_RUN_PROC_INFO CASCADE CONSTRAINTS;
CREATE TABLE NSORT_RUN_PROC_INFO AS
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
	--and proc.processname NOT IN ('specCpu')
	and arr.algrunid IN (
                -- SORT100K, SORT200K, SORT400K, SORT800K, SORT1600K, SORT3200K, SORT6400K
                13200,12760,13620,12800,13800,13860,13960  
        )
	group by arr.algrunid, ar.exp_run_time, arr.iternum, arr.runtime, proc.processname
	order by iternum, pt desc;
ALTER TABLE NSORT_RUN_PROC_INFO ADD PRIMARY KEY (algrunid, iternum, processname);
-- SELECT exp_run_time, iternum, processname, pt as PRTIME from NSORT_RUN_PROC_INFO where algrunid = 13860 and iternum IN (1,2,3,4,5,6,7,8,9,10) order by exp_run_time asc, iternum asc, pt desc
-- SELECT exp_run_time, iternum, processname, pt as PRTIME from NSORT_RUN_PROC_INFO where algrunid = 13960 and iternum IN (1,2,3,4,5,6,7,8,9,10) order by exp_run_time asc, iternum asc, pt desc

DROP TABLE NSORT_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE NSORT_RUN_Stat AS
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
	FROM NSORT_RUN_PROC_INFO erpi
	WHERE erpi.processname = 'incr_work'
	group by erpi.algrunid, erpi.exp_run_time, erpi.processname
	order by exp_run_time;
ALTER TABLE NSORT_RUN_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
-- select * from NSORT_RUN_Stat;

DROP TABLE NSORT_RUN_TASK_TIME CASCADE CONSTRAINTS;
CREATE TABLE NSORT_RUN_TASK_TIME AS
	SELECT NSORT_RUN.algrunid,
	       NSORT_RUN.exp_run_time,
	       round(median(NSORT_RUN.pt), 0) as task_time,
	       round(avg(NSORT_RUN.pt), 0) as avg_task_time,
	       round(stddev(NSORT_RUN.pt), 1) as std_task_time
	FROM NSORT_RUN_PROC_INFO NSORT_RUN, NSORT_RUN_Stat sort_stat
	WHERE NSORT_RUN.algrunid = sort_stat.algrunid 
	and NSORT_RUN.exp_run_time = sort_stat.exp_run_time
	and NSORT_RUN.processname = 'incr_work'
	and NSORT_RUN.pt <= (sort_stat.avg_pt+2*sort_stat.std_pt) 
	and NSORT_RUN.pt >= (sort_stat.avg_pt-2*sort_stat.std_pt) 
	having count(NSORT_RUN.iternum) > 6 --- at least 6 trials
	group by NSORT_RUN.algrunid, NSORT_RUN.exp_run_time
	order by exp_run_time;
ALTER TABLE NSORT_RUN_TASK_TIME ADD PRIMARY KEY (algrunid, exp_run_time);

--- select algrunid, exp_run_time, task_time from NSORT_RUN_TASK_TIME order by exp_run_time, algrunid asc
  ALGRUNID EXP_RUN_TIME  TASK_TIME
---------- ------------ ----------
     13200	    100       4238
     12760	    200      17226
     13620	    400      69200
     12800	    800     275089
     13800	   1600    1101066
     13860	   3200    4410719
     13960	   6400   17684424

7 rows selected.

DROP TABLE SORT_CUTOFF_Info CASCADE CONSTRAINTS;
CREATE TABLE SORT_CUTOFF_Info AS
    select distinct dpi.exp_run_time,
           	    dpi.iternum
    from NSORT_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
	(dpi.processname = ild.PROCESSNAME and ((select task_time from NSORT_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) < 3600 and ild.TASK_LEN < 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NSORT_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and ((select task_time from NSORT_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) >= 3600 and ild.TASK_LEN = 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NSORT_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and ((select task_time from NSORT_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) < 720 and ild.TASK_LEN < 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NSORT_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and ((select task_time from NSORT_RUN_TASK_TIME t0 where t0.exp_run_time = dpi.exp_run_time) >= 720 and ild.TASK_LEN = 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
    and dpi.pt > ild.cutoff_pt 
    UNION
    select distinct dpi.exp_run_time,
            dpi.iternum
    from NSORT_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
    where 
    (dpi.processname = ild.PROCESSNAME and dpi.processname NOT IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1', 'rhnsd', 'rhsmcertd-worke', 'rhn_check'))
    and dpi.pt > ild.cutoff_pt 
    order by exp_run_time, iternum;
ALTER TABLE SORT_CUTOFF_Info ADD PRIMARY KEY (exp_run_time, iternum);
-- select * from SORT_CUTOFF_Info where iternum <= 10 order by exp_run_time, iternum

EXP_RUN_TIME	ITERNUM
------------ ----------
	3200	      3
	3200	      6
	3200	     10
	6400	      1
	6400	      2
	6400	      3
	6400	      4
	6400	      5
	6400	      6
	6400	      7
	6400	      8
	6400	      9
	6400	     10

13 rows selected.

select t1.exp_run_time, coalesce(count(distinct t0.iternum), 0) as numOutliers, max(t1.iternum) as numTrials
from NSORT_RUN_PROC_INFO t1 
LEFT OUTER JOIN SORT_CUTOFF_Info t0
ON t0.EXP_RUN_TIME = t1.EXP_RUN_TIME and t0.iternum > 30 and t0.iternum <= 40 
WHERE t1.iternum <= 10 
group by t1.exp_run_time
order by exp_run_time

EXP_RUN_TIME NUMOUTLIERS  NUMTRIALS
------------ ----------- ----------
	 100	       0	 10
	 200	       0	 10
	 400	       0	 10
	 800	       0	 10
	1600	       0	 10
	3200	       2	 10
	6400	      10	 10

7 rows selected.

DROP TABLE NSORT_RUN_V4_Stat CASCADE CONSTRAINTS;
CREATE TABLE NSORT_RUN_V4_Stat AS
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
	FROM NSORT_RUN_PROC_INFO erpi
	WHERE erpi.processname = 'incr_work'
	--and iternum > 30 and iternum <= 40
	and iternum > 10
	group by erpi.algrunid, erpi.exp_run_time, erpi.processname
	order by exp_run_time;
ALTER TABLE NSORT_RUN_V4_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
SELECT * from NSORT_RUN_V4_Stat;

DROP TABLE NSORT_RUN_Retained1 CASCADE CONSTRAINTS;
CREATE TABLE NSORT_RUN_Retained1 AS
	select  dpi.exp_run_time, 
		dpi.iternum,
		dpi.runtime as et,
		dpi.pt
	from NSORT_RUN_PROC_INFO dpi 
	where dpi.processname = 'incr_work'
	--and iternum > 30 and iternum <= 40
	and iternum > 10
	and dpi.iternum NOT IN (select distinct ild.iternum 
				from SORT_CUTOFF_Info ild 
				where dpi.exp_run_time = ild.exp_run_time);
ALTER TABLE NSORT_RUN_Retained1 ADD PRIMARY KEY (exp_run_time, iternum);

DROP TABLE NSORT_RUN_Retained1_Stat CASCADE CONSTRAINTS;
CREATE TABLE NSORT_RUN_Retained1_Stat AS
	select  t2.exp_run_time, 
		round(avg(t2.pt),0) as avg_pt, 
		round(stddev(t2.pt),1) as std_pt,
		round((round(stddev(pt),1) / round(avg(pt),0)), 6) as re_pt
	from  NSORT_RUN_Retained1 t2
	group by exp_run_time
	order by exp_run_time asc;
ALTER TABLE NSORT_RUN_Retained1_Stat ADD PRIMARY KEY (exp_run_time);

DROP TABLE NSORT_RUN_FinalStat CASCADE CONSTRAINTS;
CREATE TABLE NSORT_RUN_FinalStat AS
	select  t2.exp_run_time, 
		round(t1.std_et,0) as std_et,
		t1.re_et,
		round(t2.std_pt,0) as std_pt,
		t2.re_pt
	from NSORT_RUN_V4_Stat t1,
	     NSORT_RUN_Retained1_Stat t2
	where t1.exp_run_time = t2.exp_run_time
	order by exp_run_time
	;
ALTER TABLE NSORT_RUN_FinalStat ADD PRIMARY KEY (exp_run_time);
SELECT * from NSORT_RUN_FinalStat;
