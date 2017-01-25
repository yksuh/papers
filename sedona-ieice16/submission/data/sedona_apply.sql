-- Applying the FIND scheme to PUT

DROP TABLE FIND_RUN_PROC_INFO CASCADE CONSTRAINTS;
CREATE TABLE FIND_RUN_PROC_INFO AS
	select * from FIND_RUN_PROC_INFO;
ALTER TABLE FIND_RUN_PROC_INFO ADD PRIMARY KEY (algrunid, iternum, procid,processname);

DROP TABLE FIND_PUT_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE FIND_PUT_RUN_Stat AS
	select * from EMP_PUT_RUN_Stat;
ALTER TABLE FIND_PUT_RUN_Stat ADD PRIMARY KEY  (algrunid, exp_run_time);
-- select exp_run_time, numTrials, avg_et, std_et, avg_pt, std_pt from FIND_PUT_RUN_Stat

--column PROCESSNAME format a15
DROP TABLE FIND_RUN_CUTOFF_Info CASCADE CONSTRAINTS;
CREATE TABLE FIND_RUN_CUTOFF_Info AS
	-- select * from EMP_RUN_CUTOFF_Info
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from FIND_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 3600 and ild.TASK_LEN < 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from FIND_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 3600 and ild.TASK_LEN = 3600) and dpi.processname IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from FIND_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time < 720 and ild.TASK_LEN < 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from FIND_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and (dpi.exp_run_time >= 720 and ild.TASK_LEN = 720) and dpi.processname IN ('rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	UNION
	select  dpi.algrunid,
		dpi.exp_run_time,
		dpi.processname, 
		dpi.iternum,
		dpi.pt
	from FIND_RUN_PROC_INFO dpi, IL_DAEMON_CUTOFF ild
	where 
	(dpi.processname = ild.PROCESSNAME and dpi.processname NOT IN ('flush-9:0', 'jbd2/md0-8', 'md0_raid1', 'rhnsd', 'rhsmcertd-worke', 'rhn_check'))
	and dpi.pt > ild.cutoff_pt 
	order by exp_run_time, iternum
	;
ALTER TABLE FIND_RUN_CUTOFF_Info ADD PRIMARY KEY (exp_run_time, processname, iternum);

DROP TABLE FIND_PUT_RUN CASCADE CONSTRAINTS;
CREATE TABLE FIND_PUT_RUN AS
	select  *
	from FIND_RUN_PROC_INFO 
	where processname = 'incr_work';
ALTER TABLE FIND_PUT_RUN ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE FIND_PUT_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE FIND_PUT_RUN_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numSamples,
		round(avg(dpi.RUNTIME),0) as avg_et, 
		round(stddev(dpi.RUNTIME),1) as std_et, 
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt,
		round(stddev(dpi.RUNTIME)/avg(dpi.RUNTIME),6) as re_et, 
		round(stddev(dpi.pt)/avg(dpi.pt),6) as re_pt
	from FIND_PUT_RUN dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE FIND_PUT_RUN_Stat ADD PRIMARY KEY (exp_run_time);

DROP TABLE FIND_PUT_RUN_Retained1 CASCADE CONSTRAINTS;
CREATE TABLE FIND_PUT_RUN_Retained1 AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		dpi.iternum,
		dpi.runtime as et,
		dpi.pt
	from FIND_RUN_PROC_INFO dpi 
	where dpi.processname = 'incr_work'
	and dpi.iternum NOT IN (select distinct ild.iternum 
				from EMP_RUN_CUTOFF_Info ild 
				where dpi.algrunid = ild.algrunid);
ALTER TABLE FIND_PUT_RUN_Retained1 ADD PRIMARY KEY (algrunid, exp_run_time, iternum);

DROP TABLE FIND_PUT_RUN_Retained1_Stat CASCADE CONSTRAINTS;
CREATE TABLE FIND_PUT_RUN_Retained1_Stat AS
	select  dpi.algrunid, 
		dpi.exp_run_time, 
		count(dpi.iternum) as numRetained1,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et, 
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt,
		round(stddev(dpi.et)/avg(dpi.et),6) as re_et, 
		round(stddev(dpi.pt)/avg(dpi.pt),6) as re_pt
	from FIND_PUT_RUN_Retained1 dpi 
	group by dpi.algrunid, dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE FIND_PUT_RUN_Retained1_Stat ADD PRIMARY KEY (exp_run_time);
select exp_run_time as ts_len,numSamples as nSz, std_et, re_et, std_pt, re_pt from FIND_PUT_RUN_Stat;
select exp_run_time as ts_len,numRetained1 as NRET,std_et, re_et, std_pt, re_pt from FIND_PUT_RUN_Retained1_Stat;

    TS_LEN	  NSZ	  STD_ET      RE_ET	STD_PT	    RE_PT
---------- ---------- ---------- ---------- ---------- ----------
	 1	  300	       1    .001025	    .9	  .000849
	 2	  300	     1.4    .000715	   1.3	  .000632
	 4	  300	     1.8    .000443	   1.5	  .000379
	 8	  300	     1.9    .000239	   1.8	  .000225
	16	  300	     2.1    .000133	   1.9	  .000116
	32	  300	    21.8     .00068	   1.9	   .00006
	64	  300	    24.1    .000376	   2.3	  .000035
       128	  300	    39.1    .000305	   2.3	  .000018
       128	  800	  1730.3    .013482	  10.9	  .000852
       256	  300	   126.6    .000493	   3.3	  .000013
       512	  300	  1331.6    .002595	   9.4	  .000018
      1024	  300	  1578.2    .001538	  11.4	  .000011
      2048	  300	    1169     .00057	  11.2	  .000005
      4096	  300	  2301.8    .000552	    26	  .000006
      8192	   40	   339.6    .000041	    21	  .000003
     16384	   40	  5661.7    .000345	  40.4	  .000002

    TS_LEN	 NRET	  STD_ET      RE_ET	STD_PT	    RE_PT
---------- ---------- ---------- ---------- ---------- ----------
	 1	  300	       1    .001025	    .9	  .000849
	 2	  300	     1.4    .000715	   1.3	  .000632
	 4	  300	     1.8    .000443	   1.5	  .000379
	 8	  300	     1.9    .000239	   1.8	  .000225
	16	  300	     2.1    .000133	   1.9	  .000116
	32	  298	     1.9     .00006	   1.7	  .000055
	64	  298	     2.3    .000036	   2.2	  .000034
       128	  298	     2.4    .000019	   2.3	  .000018
       128	  800	     3.2    .000025	   2.6	  .000021
       256	  294	     2.9    .000011	   2.7	  .000011
       512	  288	     3.5    .000007	     3	  .000006
      1024	  296	   122.6     .00012	   4.6	  .000004
      2048	  299	   168.1    .000082	   7.4	  .000004
      4096	  292	   778.5    .000187	    24	  .000006
      8192	   40	   339.6    .000041	    21	  .000003
     16384	   38	   229.8    .000014	  26.7	  .000002


--- SPEC
DROP TABLE FIND_SPEC_RUN_PROC_INFO CASCADE CONSTRAINTS;
CREATE TABLE FIND_SPEC_RUN_PROC_INFO AS
	SELECT * 
	FROM SPEC_RUN_PROC_INFO;
ALTER TABLE FIND_SPEC_RUN_PROC_INFO ADD PRIMARY KEY (algrunid, iternum, processname);

DROP TABLE FIND_SPEC_RUN_Stat CASCADE CONSTRAINTS;
CREATE TABLE FIND_SPEC_RUN_Stat AS
	SELECT *
	FROM SPEC_RUN_Stat;
ALTER TABLE FIND_SPEC_RUN_Stat ADD PRIMARY KEY (algrunid, exp_run_time);
-- 
DROP TABLE FIND_SPEC_CUTOFF_Info CASCADE CONSTRAINTS;
CREATE TABLE FIND_SPEC_CUTOFF_Info AS	
	SELECT * 
	FROM SPEC_CUTOFF_Info;
ALTER TABLE FIND_SPEC_CUTOFF_Info ADD PRIMARY KEY (exp_run_time, iternum);

DROP TABLE FIND_SPEC_RUN_Retained1 CASCADE CONSTRAINTS;
CREATE TABLE FIND_SPEC_RUN_Retained1 AS
	select  dpi.exp_run_time, 
		dpi.iternum,
		dpi.runtime as et,
		dpi.pt
	from FIND_SPEC_RUN_PROC_INFO dpi 
	where dpi.processname = 'specCpu'
	--and dpi.iternum <= 10 
	and dpi.iternum NOT IN (select distinct ild.iternum 
				from FIND_SPEC_CUTOFF_Info ild 
				where dpi.exp_run_time = ild.exp_run_time);
ALTER TABLE FIND_SPEC_RUN_Retained1 ADD PRIMARY KEY (exp_run_time, iternum);

DROP TABLE FIND_SPEC_RUN_Retained1_Stat CASCADE CONSTRAINTS;
CREATE TABLE FIND_SPEC_RUN_Retained1_Stat AS
	select  dpi.exp_run_time, 
		count(dpi.iternum) as numRetained1,
		round(avg(dpi.et),0) as avg_et, 
		round(stddev(dpi.et),1) as std_et, 
		round(avg(dpi.pt),0) as avg_pt, 
		round(stddev(dpi.pt),1) as std_pt,
		round(stddev(dpi.et)/avg(dpi.et),6) as re_et, 
		round(stddev(dpi.pt)/avg(dpi.pt),6) as re_pt
	from FIND_SPEC_RUN_Retained1 dpi 
	group by dpi.exp_run_time
	order by exp_run_time asc;
ALTER TABLE FIND_SPEC_RUN_Retained1_Stat ADD PRIMARY KEY (exp_run_time);

-- select exp_run_time as t_len, numtrials, std_et, re_et, std_pt, re_pt 
-- from FIND_SPEC_RUN_Stat where processName='specCpu' order by exp_run_time;
     T_LEN  NUMTRIALS	  STD_ET      RE_ET	STD_PT	    RE_PT
---------- ---------- ---------- ---------- ---------- ----------
       400	   40	    27.3    .059348	   2.1	  .004719
       401	   40	  5608.7    .010435	1161.4	  .002197
       403	   40	   158.8    .006087	 152.1	  .005929
       410	   40	    62.9    .007939	  20.8	  .002667
       416	   40	  1026.8    .001011	 980.8	  .000981
       429	   40	   622.8    .002641	 599.6	  .002582
       433	   40	   880.4    .001831	 866.8	  .001831
       434	   40	    75.1    .004553	   9.1	   .00056
       435	   40	  1007.1    .001017	1016.8	  .001042
       436	   40	  4104.4    .003535	3993.9	  .003493
       437	   40	    1581    .002719	1566.7	  .002736
       444	   40	     554    .000937	 542.4	  .000931
       445	   40	   146.5    .001735	  41.1	  .000494
       447	   40	   189.8    .000364	 124.7	  .000243
       450	   40	   144.8    .000425	  95.7	  .000285
       453	   40	   976.1    .003769	 946.7	  .003718
       454	   40	  5014.6    .002911	 660.6	   .00039
       456	   40	   135.2    .000329	  76.6	  .000189
       458	   40	   578.5    .000981	 546.9	  .000942
       459	   40	  2143.2    .002683	2131.6	  .002709
       462	   40	    4339    .007293	4272.7	  .007293
       464	   40	   895.7    .001378	 863.3	  .001349
       465	   40	  5148.8    .005743	 864.8	   .00098
       470	   40	   706.2    .002018	 689.5	  .002001
       471	   40	    6176    .016862	6079.8	  .016857
       473	   40	     743    .002049	 729.1	  .002041
       481	   40	  	?	?	?	?
       482	   40	  4351.1    .006663	4281.1	  .006658
       483	   40	  	?	?	?	?
       998	   40	      .7    .005469	    .7	  .005512
       999	   40	    23.9    .181061	    .9	  .007087
-- select exp_run_time as t_len, numRetained1, std_et, re_et, std_pt, re_pt from FIND_SPEC_RUN_Retained1_Stat order by exp_run_time;

     T_LEN NUMRETAINED1     STD_ET	RE_ET	  STD_PT      RE_PT
---------- ------------ ---------- ---------- ---------- ----------
       400	     40       27.3    .059346	     2.1    .004723
       401	     39     1184.6    .002208	  1153.4    .002182
       403	     40      158.8    .006086	   152.1    .005929
       410	     40       62.9    .007942	    20.8    .002661
       416	     37     1038.3    .001023	   990.7    .000991
       429	     39      629.5    .002669	   606.6    .002612
       433	     39      890.7    .001853	     877    .001853
       434	     40       75.1    .004555	     9.1    .000559
       435	     37     1013.8    .001024	    1050    .001076
       436	     36     4177.3    .003598	    4054    .003545
       437	     38     1584.3    .002724	  1573.2    .002747
       444	     39      559.3    .000946	   547.2     .00094
       445	     40      146.5    .001735	    41.1    .000495
       447	     31      184.3    .000353	   127.8    .000249
       450	     40      144.8    .000424	    95.7    .000285
       453	     40      976.1    .003769	   946.7    .003717
       454	     37        691    .000401	   680.1    .000401
       456	     40      135.2    .000329	    76.6    .000189
       458	     40      578.5    .000981	   546.9    .000942
       459	     36     2191.4    .002744	  2186.8     .00278
       462	     37       4400    .007397	  4336.1    .007402
       464	     38      916.5     .00141	   886.1    .001384
       465	     37      899.1    .001004	   871.9    .000988
       470	     40      706.2    .002018	   689.5    .002001
       471	     39     6251.1    .017069	  6153.8    .017064
       473	     40        743    .002049	   729.1    .002041
       481	     40	  	?	?	?	?
       482	     38     3992.1    .006111	    3919    .006092
       483	     40	  	?	?	?	?
       998	     40 	.7    .005534	      .7    .005349
       999	     40       23.9    .181279	      .9     .00699
