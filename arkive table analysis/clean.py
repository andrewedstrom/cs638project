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

			list = line.split(",")
			check = str(list[0])
			if check == 'Plantae':
				print('yes')
			elif check == 'Animalia':
				print('yes')
			else:
				f.write(line + '\n')
	fd.close()
	f.close




main()