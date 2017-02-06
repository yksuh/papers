select count(*)
from nsoexpl_s4_ctqatc 
where (
    (runid = 2060 and querynum = 7 and card = 30000) 
or  (runid = 2060 and querynum = 52 and card = 30000) 
or  (runid = 2120 and querynum = 17 and card = 30300) 
or  (runid = 2120 and querynum = 54 and card = 30300) 
or  (runid = 2120 and querynum = 61 and card = 30300) 
or  (runid = 2120 and querynum = 97 and card = 30300) 
or  (runid = 2257 and querynum = 3 and card = 30300)
or  (runid = 2257 and querynum = 31 and card = 30300) 
or  (runid = 2257 and querynum = 49 and card = 30300) 
or  (runid = 2257 and querynum = 49 and card = 30000) 
or  (runid = 2257 and querynum = 60 and card = 31200) 
or  (runid = 2257 and querynum = 79 and card = 30600) 
or  (runid = 2257 and querynum = 95 and card = 30300) 
or  (runid = 2257 and querynum = 98 and card = 30000) 
or  (runid = 2297 and querynum = 54 and card = 30600) 
)


      2060	    7	   30300 7.3956E+18
      2060	   52	   30300 -2.741E+18
      2060	   52	   30000 -8.659E+18
      2120	   17	   30600 6.7722E+18
      2120	   17	   30300 -6.914E+18
      2120	   17	   30300 6.7722E+18
      2120	   17	   30000 -6.914E+18
      2120	   17	   29400 6.7722E+18
      2120	   17	   29100 -6.914E+18
      2120	   17	   28800 -6.919E+18
      2120	   54	   30600 -8.113E+18
      2120	   54	   30300 -4.465E+18
      2120	   54	   30300 -8.113E+18
      2120	   54	   30000 -4.464E+18
      2120	   54	   29700 -4.465E+18
      2120	   54	   29100 -4.465E+18
      2120	   54	   28800 -4.464E+18

