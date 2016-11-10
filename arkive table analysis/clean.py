import os.path
import requests
import time
from bs4 import BeautifulSoup
from string import punctuation
from collections import Counter
import sys

def main():
	f = open('finalOutput.txt', "wb")
	with open('output.txt', "rb") as fd:
		for line in fd:
			line = line.lstrip().rstrip()

			line = line.replace('\n','')
			
			list = line.split(",")
			check = str(list[0])
			print check
			partOne = False
			if check == 'Plantae':
				partOne = False
			if check == 'Animalia':
				partOne = False
			
			
				f.write(line + '\n')
				print(line)
	fd.close()
	f.close




main()