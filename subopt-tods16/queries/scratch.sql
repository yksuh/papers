SELECT expName, dbms, runid, count(*) as queries -- queries 
FROM (SELECT distinct experimentname as expName, dbms, runid, querynum
     FROM NSOCnfm_S0_AQE);
