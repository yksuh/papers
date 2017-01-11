import random
import re
import sys, getopt
from sets import Set

def main(argv):	
	print 'Number of arguments:', len(sys.argv), 'arguments.'
  	#print 'Argument List:', str(sys.argv)
  	#if len(sys.argv) == 1:
	#	print '[Usage] python gen_subquery.py input_file_name'
	#	print 'Give an input query file.'
	#	sys.exit(-1);
   	#print '[Usage] python gen_subquery.py input1 input2 input3 input4'
	for i in range(0,len(sys.argv)-1):
		f = open(sys.argv[i+1], 'r')
		in_list = [];
		for line in f:
			line = line.replace('\n', '');
			in_list.append(str(line));
		in_pred = "";
		i = 0;
		for item in in_list:
			i+=1;
			in_pred += item;
			if i < len(in_list):
				in_pred+=",";
		finalStr = "IN (" + in_pred + ");";
		print finalStr;
if __name__ == "__main__":
   main(sys.argv[1:])
			
			
				
			
