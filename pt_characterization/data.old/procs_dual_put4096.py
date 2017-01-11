import random
import re
import sys, getopt
from sets import Set

def main(argv):	
	#print 'Number of arguments:', len(sys.argv), 'arguments.'
	flag = 0;
	if flag:
		for i in range(0,len(sys.argv)-1):
			f = open(sys.argv[i+1], 'r')
			in_list = [];
			for line in f:
				line = line.replace('\n', '');
				in_list.append(str(line));
				j = 0;
				finalStr = "";
				for item in in_list:
					j+=1;
					item = item.replace('_', '\_');
					finalStr += "{\\tt " + item + "}";
					#finalStr += item;
					if j < len(in_list):
						finalStr+=", ";
			print finalStr, "\n";
	else:
		daemon_map = {} 			
		for i in range(0,len(sys.argv)-1):
			f = open(sys.argv[i+1], 'r')
			in_list = [];
			for line in f:
				line = line.replace('\n', '');
				in_list.append(str(line));
			for item in in_list:
				if item not in daemon_map:
					daemon_map.setdefault(item, []);
				daemon_map[item].append(str(i+1))
	  	for key in sorted(daemon_map):
			size = 0;
			strVal ="";			
			for val in daemon_map[key]:
				#print "Size: ", len(daemon_map[key]);
				strVal += val;
				size+=1;
				if (size < len(daemon_map[key])):
					strVal += ",";
			key2 = key.replace('_', '\_');
			print "{\\tt %s} & %s \\\\ \hline" % (key2, strVal)
				#print daemon_map;
if __name__ == "__main__":
   main(sys.argv[1:])
