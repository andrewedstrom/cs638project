import os.path
import requests
import time
from bs4 import BeautifulSoup
from string import punctuation
from collections import Counter
import sys

def main():
	count = 0
	f = open('finalOutput.txt', "wb")
	f.write('id, scientific_name, nickname, common_name, kingdom, phylum, class, order, family, genus, size, threats, conservation, threat_keywords, conservation_keywords, status, countries, country_count' + '\n')
	with open('output.txt', "rb") as fd:
		for line in fd:
			line = line.lstrip().rstrip()

			line = line.replace('\n','')
			
			list = line.split(",")
			check = str(list[0])
			print check
			partOne = True
			

			checker = str(list[9])
			
			if 'kg' in checker:
				if partOne:
					f.write(str(count) + ',')
					f.write(line +','+'\n')
					count = count + 1


			if ' g' in checker:
				if partOne:
					f.write(str(count) + ',')
					f.write(line +','+'\n')
					count = count + 1

			if ' m' in checker:
				if partOne:
					f.write(str(count) + ',')
					f.write(line +','+'\n')
					count = count + 1

			if 'cm' in checker:
				if partOne:
					f.write(str(count) + ',')
					f.write(line +','+'\n')
					count = count + 1

			if 'mm' in checker:
				if partOne:
					f.write(str(count) + ',')
					f.write(line +','+'\n')
					count = count + 1


	fd.close()
	f.close




main()