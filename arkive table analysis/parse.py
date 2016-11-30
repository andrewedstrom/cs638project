import os.path
import requests
import time
from bs4 import BeautifulSoup
from geotext import GeoText as gt
from string import punctuation
from collections import Counter
import re
import sys


reload(sys)
sys.setdefaultencoding("utf-8")



threats = ['loss', 'fragmentation', 'hunting', 'poaching', 'fishing', 'overfishing', 'environmental', 'environment', 'invasive', 'disease', 'pet', 'pollution']

conservation = ['cites', 'protection law', 'captive breeding', 'protected', 'endangered species act', 'wwf', 'wcs']

conservationString = ''
threatString = ''
def findConservation(string): 
    consFound = []
    string = string.lower()
    string = string.replace("<p>", "")
    global conservation
    
    for word in conservation:
        if word in string:
            consFound.append(word)
    return consFound

def findThreats(string): 
    threatsFound = []
    string = string.lower()
    string = string.replace("<p>", "")
    global threats
    
    for word in threats:
        if word in string:
            threatsFound.append(word)
            index = string.index(word)
    return threatsFound
    
def parseThrough(string):
    
    string = string.replace(',','')
    s = '<p>'
    if s in string:
        string = string.split(s)[1]

        
    s = '</p>'
    if s in string:
        string = string.split(s)[0]
    return string
    
def urlNeeded():
    global threats
    global conservationString
    global threatString

    allThreats = []
    global conservation
    allCons = []
    f = open('output.txt', "w")
    f.write('Scientific Name, Nickname, Common Name, Kingdom, Phylum, Class, Order, Family, Genus, Size, Threats, Conservation, Threat Keywords, Conservation Keywords, status, countries, country_count' + '\n')
    with open('test.txt', "rb") as fd:
        for line in fd:
            line = line.lstrip().rstrip()
            url = line
            r = requests.get(url)
            soup = BeautifulSoup(r.text.encode('utf-8'), 'html.parser')
            newName = soup.find('td').text
            newName = newName.lstrip().rstrip()
            newName = str(newName)
            newName = newName.replace(',',';')
            f.write(newName + ',')
            for t in soup.findAll('h1'):
                name = t.text
                s = '('
                if s in name:
                    commonName = name.split(s)[0]
                    scienceName = name.split(s)[1]
                    scienceName = scienceName.replace(')','')
                    
                    f.write(scienceName + ',')
                    print scienceName
                    f.write(name + ',')

            soupsup = soup.findAll('td', align="left")
            for node in soupsup:
                waant = ''.join(node.findAll(text=True))
                waant = str(waant)
                waant = waant.replace('\n', '')
                f.write(waant + ',')
                if "(" in node:
                    break

            items = []
            for t in soup.findAll('td'):
                    items.append(t.text)
            check = 9 
            badge = len(items)
            if badge > 6:
            	f.write(items[badge - 1] + ',')
            else:
            	f.write(',')

            badges = soup.findAll("p", class_="Threats")
            ofInterest = str(badges)
            
            foundThreats = findThreats(ofInterest)
           
            ofInterest = parseThrough(ofInterest)
            threatString = threatString + ofInterest
            
            if ofInterest:
                f.write(ofInterest)
                f.write(',')
            else:
                f.write(' ,')

            badges = soup.findAll("p", class_="Conservation")
            ofInterest = str(badges)
            
            foundCons = findConservation(ofInterest)
            

            ofInterest = parseThrough(ofInterest)
            conservationString = conservationString + ofInterest

            badges = soup.findAll("p", class_="Range")
            badges = str(badges)
            countries = gt(badges).country_mentions
            countries = str(countries)
            #countries = re.sub('[^A-Z]', '', s)
            countries = countries.replace(',', '')
            
            cCount = sum(c.isdigit() for c in countries)
            cCount = str(cCount)
            print cCount

            status = soup.findAll("p", class_="Status")
            status = str(status)
            if 'Critically' in status:
                status = 'Critically Endangered'

            else:
                status = 'Endangered'



            if ofInterest:
                f.write(ofInterest)
                f.write(' ,' + '')

            else:
                f.write(' ,')

            
            for node in foundThreats:
                f.write(node)
                f.write(';')
            f.write(' ,')


            for node in foundCons:
                f.write(node)
                f.write(';')
            f.write(' ,')

            f.write(status)
            f.write(',')
            f.write(countries)
            f.write(',')
            f.write(cCount)
            f.write('\n')
            

    fd.close()
    f.close()

def main():
    urlNeeded()
main()