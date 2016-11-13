import os.path
import requests
import time
from bs4 import BeautifulSoup
from string import punctuation
from collections import Counter
import sys

def main():
	f = open('finalOutput.txt', "wb")
	f.write('Scientific Name, Nickname, Common Name, Kingdom, Phylum, Class, Order, Family, Genus, Size, Threats, Conservation, Threat Keywords, Conservation Keywords, tCount, cCount' + '\n')
	with open('output.txt', "rb") as fd:
		for line in fd:
			line = line.lstrip().rstrip()

			line = line.replace('\n','')
			
			list = line.split(",")
			check = str(list[0])
			print check
			partOne = True
			if check == 'Plantae':
				partOne = False
			elif check == 'Animalia':
				partOne = False

			checker = str(list[9])
			
			if 'kg' in checker:
				if partOne:
					f.write(line +','+'\n')


			if ' g' in checker:
				if partOne:
					f.write(line +','+'\n')

			if ' m' in checker:
				if partOne:
					f.write(line + ',' + '\n')

			if 'cm' in checker:
				if partOne:
					f.write(line + ',' + '\n')

			if 'mm' in checker:
				if partOne:
					f.write(line + ',' + '\n')


	fd.close()
	f.close




main()