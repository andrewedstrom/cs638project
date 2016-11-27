import os.path
import requests
import time
from bs4 import BeautifulSoup
from string import punctuation
from collections import Counter
import sys

def main():
	f = open('finalOutput.txt', "wb")
	f.write('id, Nickname, Common Name, Kingdom, Phylum, Class, Order, Family, Genus, Size, Threats, Conservation, Threat Keywords, Conservation Keywords, tCount, cCount' + '\n')
	with open('output.txt', "rb") as fd:
		count = 0
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
					f.write(str(count))
					count = count + 1
					f.write(line +','+'\n')


			if ' g' in checker:
				if partOne:
					f.write(str(count) + ',')
					count = count + 1
					f.write(line +','+'\n')

			if ' m' in checker:
				if partOne:
					f.write(str(count) + ',')
					count = count + 1
					f.write(line + ',' + '\n')

			if 'cm' in checker:
				if partOne:
					f.write(str(count) + ',')
					count = count + 1
					f.write(line + ',' + '\n')

			if 'mm' in checker:
				if partOne:
					f.write(str(count) + ',')
					count = count + 1
					f.write(line + ',' + '\n')


	fd.close()
	f.close




main()