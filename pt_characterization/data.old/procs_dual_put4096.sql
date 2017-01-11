
SELECT 
    distinct proc.processname
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum IN (2,3,4,5,9,12,16,17,18,19,24,25,26,30,31,32,33,38,39,40,45,46,52,53,54,59,60,61,66,67,68,71,73,74,78,79,81,82,85,86,89,92,93,95,96,100,102,103,106,107,109,113,114,116,117,121,122,124,128,131,134,135,138,141,142,145,148,149,152,155,156,157,159,163,164,166,170,171,177,178,180,182,184,185,187,189,191,192,194,196,198,201,202,208,209,219,222,223,226,229,230,233,237,240,244,246,247,251,253,254,258,260,261,265,267,268,272,274,279,281,286,288,289,293,295,302,303,309,310,314,316,321,324,328,329,331,335,336,338,342,345,349,350,352,356,357,359,363,364,366,369,370,371,372,376,377,378,379,383,384,385,386,390,391,392,393,397,398,399,400,404,405,406,407,411,412,414,417,418,424,425,426,431,432,433,438,439,440,444,445,447,453,454,457,458,460,461,464,465,467,469,471,474,478,479,481,482,485,486,488,489,492,495,500)
order by proc.processname;

PROCESSNAME
--------------------------------
bash
grep
id
java
rhn_check
rhsmcertd-worke
sshd
uname

select round(avg(total_dt)/1000,2) as total_msecs
from 
	(SELECT arr.iternum, sum(proc.utime+proc.stime)*10 as total_dt
	FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and (proc.processname NOT IN ('incr_work', 'grep'))
	--and proc.processname <> 'incr_work'
	and (proc.utime+proc.stime) > 0
	and arr.algrunid = 9720 and arr.iternum IN (2,3,4,5,9,12,16,17,18,19,24,25,26,30,31,32,33,38,39,40,45,46,52,53,54,59,60,61,66,67,68,71,73,74,78,79,81,82,85,86,89,92,93,95,96,100,102,103,106,107,109,113,114,116,117,121,122,124,128,131,134,135,138,141,142,145,148,149,152,155,156,157,159,163,164,166,170,171,177,178,180,182,184,185,187,189,191,192,194,196,198,201,202,208,209,219,222,223,226,229,230,233,237,240,244,246,247,251,253,254,258,260,261,265,267,268,272,274,279,281,286,288,289,293,295,302,303,309,310,314,316,321,324,328,329,331,335,336,338,342,345,349,350,352,356,357,359,363,364,366,369,370,371,372,376,377,378,379,383,384,385,386,390,391,392,393,397,398,399,400,404,405,406,407,411,412,414,417,418,424,425,426,431,432,433,438,439,440,444,445,447,453,454,457,458,460,461,464,465,467,469,471,474,478,479,481,482,485,486,488,489,492,495,500)
group by arr.iternum);

3494.28

SELECT processname, round(avg((proc.utime+proc.stime)*10/1000),2)
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and (proc.processname NOT IN ('incr_work', 'grep'))
--and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum IN (2,3,4,5,9,12,16,17,18,19,24,25,26,30,31,32,33,38,39,40,45,46,52,53,54,59,60,61,66,67,68,71,73,74,78,79,81,82,85,86,89,92,93,95,96,100,102,103,106,107,109,113,114,116,117,121,122,124,128,131,134,135,138,141,142,145,148,149,152,155,156,157,159,163,164,166,170,171,177,178,180,182,184,185,187,189,191,192,194,196,198,201,202,208,209,219,222,223,226,229,230,233,237,240,244,246,247,251,253,254,258,260,261,265,267,268,272,274,279,281,286,288,289,293,295,302,303,309,310,314,316,321,324,328,329,331,335,336,338,342,345,349,350,352,356,357,359,363,364,366,369,370,371,372,376,377,378,379,383,384,385,386,390,391,392,393,397,398,399,400,404,405,406,407,411,412,414,417,418,424,425,426,431,432,433,438,439,440,444,445,447,453,454,457,458,460,461,464,465,467,469,471,474,478,479,481,482,485,486,488,489,492,495,500)
group by processname
order by processname

SELECT 
    distinct proc.processname
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum IN (6,11,13,20,27,34,36,41,43,47,48,50,55,57,62,64,69,75,76,83,88,90,97,99,104,110,111,118,120,125,127,129,132,136,139,143,146,150,153,160,162,167,169,174,176,181,183,188,190,195,197,199,204,205,206,211,213,215,216,218,220,225,227,232,234,241,243,248,255,257,262,264,269,271,275,276,282,283,285,290,292,297,299,300,304,306,311,313,318,320,325,327,332,339,341,343,346,353,355,360,362,367,373,374,380,381,387,388,394,395,401,402,408,409,415,416,422,423,429,430,436,437,443,450,451,452,455,462,468,472,476,483,490,493,497,498,499)order by proc.processname;

PROCESSNAME
--------------------------------
grep
id
java
rhn_check
rhsmcertd-worke
sshd

select round(avg(total_dt)/1000,2) as total_msecs
from 
	(SELECT arr.iternum, sum(proc.utime+proc.stime)*10 as total_dt
	FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and (proc.processname NOT IN ('incr_work', 'grep'))
	--and proc.processname <> 'incr_work'
	and (proc.utime+proc.stime) > 0
	and arr.algrunid = 9720 and arr.iternum IN (6,11,13,20,27,34,36,41,43,47,48,50,55,57,62,64,69,75,76,83,88,90,97,99,104,110,111,118,120,125,127,129,132,136,139,143,146,150,153,160,162,167,169,174,176,181,183,188,190,195,197,199,204,205,206,211,213,215,216,218,220,225,227,232,234,241,243,248,255,257,262,264,269,271,275,276,282,283,285,290,292,297,299,300,304,306,311,313,318,320,325,327,332,339,341,343,346,353,355,360,362,367,373,374,380,381,387,388,394,395,401,402,408,409,415,416,422,423,429,430,436,437,443,450,451,452,455,462,468,472,476,483,490,493,497,498,499) group by arr.iternum);

6954.26

SELECT processname, round(avg((proc.utime+proc.stime)*10/1000),2)
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and (proc.processname NOT IN ('incr_work', 'grep'))
--and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum IN (6,11,13,20,27,34,36,41,43,47,48,50,55,57,62,64,69,75,76,83,88,90,97,99,104,110,111,118,120,125,127,129,132,136,139,143,146,150,153,160,162,167,169,174,176,181,183,188,190,195,197,199,204,205,206,211,213,215,216,218,220,225,227,232,234,241,243,248,255,257,262,264,269,271,275,276,282,283,285,290,292,297,299,300,304,306,311,313,318,320,325,327,332,339,341,343,346,353,355,360,362,367,373,374,380,381,387,388,394,395,401,402,408,409,415,416,422,423,429,430,436,437,443,450,451,452,455,462,468,472,476,483,490,493,497,498,499) group by processname
order by processname

SELECT arr.iternum, processname, (proc.utime+proc.stime)*10/1000
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and proc.processname = 'rhn_check'
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720

SELECT 
    distinct proc.processname
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum IN (1,7,8,14,15,21,22,28,35,37,42,49,56,58,63,65,70,72,77,80,84,87,91,94,98,101,105,108,112,115,119,123,126,130,133,137,140,144,147,151,154,158,161,165,168,172,175,179,186,193,200,203,207,210,212,214,217,221,224,228,231,235,236,238,242,245,249,252,256,259,263,266,270,273,277,278,284,287,291,294,296,298,301,305,307,308,312,315,317,319,322,323,326,330,333,337,340,347,351,354,358,361,365,368,375,382,389,396,403,410,413,419,420,421,427,428,434,435,442,446,449,463,470,475,477,484,494,496)
order by proc.processname;

PROCESSNAME
--------------------------------
grep
java
rhn_check
rhsmcertd-worke
sshd

select round(avg(total_dt)/1000,2) as total_msecs
from 
	(SELECT arr.iternum, sum(proc.utime+proc.stime)*10 as total_dt
	FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and (proc.processname NOT IN ('incr_work', 'grep'))
	--and proc.processname <> 'incr_work'
	and (proc.utime+proc.stime) > 0
	and arr.algrunid = 9720 and arr.iternum IN (1,7,8,14,15,21,22,28,35,37,42,49,56,58,63,65,70,72,77,80,84,87,91,94,98,101,105,108,112,115,119,123,126,130,133,137,140,144,147,151,154,158,161,165,168,172,175,179,186,193,200,203,207,210,212,214,217,221,224,228,231,235,236,238,242,245,249,252,256,259,263,266,270,273,277,278,284,287,291,294,296,298,301,305,307,308,312,315,317,319,322,323,326,330,333,337,340,347,351,354,358,361,365,368,375,382,389,396,403,410,413,419,420,421,427,428,434,435,442,446,449,463,470,475,477,484,494,496)
 group by arr.iternum);

16350.63

SELECT processname, round(avg((proc.utime+proc.stime)*10/1000),2)
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and (proc.processname NOT IN ('incr_work', 'grep'))
--and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum IN (1,7,8,14,15,21,22,28,35,37,42,49,56,58,63,65,70,72,77,80,84,87,91,94,98,101,105,108,112,115,119,123,126,130,133,137,140,144,147,151,154,158,161,165,168,172,175,179,186,193,200,203,207,210,212,214,217,221,224,228,231,235,236,238,242,245,249,252,256,259,263,266,270,273,277,278,284,287,291,294,296,298,301,305,307,308,312,315,317,319,322,323,326,330,333,337,340,347,351,354,358,361,365,368,375,382,389,396,403,410,413,419,420,421,427,428,434,435,442,446,449,463,470,475,477,484,494,496)
group by processname
order by processname


SELECT 
    distinct proc.processname
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and (proc.utime+proc.stime) > 0
and (proc.processname NOT IN ('incr_work', 'grep'))
and arr.algrunid = 9720 and arr.iternum IN 
(10,23,29,44,51,173,239,250,280,334,344,348,441,448,456,459,466,473,480,487,491)
order by proc.processname;

PROCESSNAME
--------------------------------
grep
java
rhn_check
rhsmcertd-worke
sshd

select round(avg(total_dt)/1000,2) as total_msecs
from 
	(SELECT arr.iternum, sum(proc.utime+proc.stime)*10 as total_dt
	FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
	WHERE arr.algrunid = proc.algrunid
	and arr.datanum = proc.DATANUM
	and arr.iternum = proc.iternum 
	and (proc.processname NOT IN ('incr_work', 'grep'))
	--and proc.processname <> 'incr_work'
	and (proc.utime+proc.stime) > 0
	and arr.algrunid = 9720 and arr.iternum IN (10,23,29,44,51,173,239,250,280,334,344,348,441,448,456,459,466,473,480,487,491)
 group by arr.iternum);

2130


SELECT processname, round(avg((proc.utime+proc.stime)*10/1000),2)
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and (proc.processname NOT IN ('incr_work', 'grep'))
--and proc.processname <> 'incr_work'
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum IN (10,23,29,44,51,173,239,250,280,334,344,348,441,448,456,459,466,473,480,487,491)
group by processname
order by processname

SELECT processname, min((proc.utime+proc.stime)*10), median((proc.utime+proc.stime)*10), max((proc.utime+proc.stime)*10)
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and proc.processname = 'incr_work'
--and proc.processname <> 'incr_work'
--and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and proc.utime+proc.stime < 6972778
group by processname
order by processname

SELECT arr.iternum, arr.runtime
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and proc.processname = 'incr_work'
--and proc.processname <> 'incr_work'
--and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and (proc.utime+proc.stime = 410257)

SELECT arr.iternum, arr.runtime, processname, proc.utime+proc.stime
FROM AZDBLab_NewAlgRunResult2 arr, AZDBLab_ProcInfo2 proc
WHERE arr.algrunid = proc.algrunid
and arr.datanum = proc.DATANUM
and arr.iternum = proc.iternum 
and (proc.utime+proc.stime) > 0
and arr.algrunid = 9720 and arr.iternum = 486

5490,000



