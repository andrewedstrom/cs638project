import os.path
import requests
import time
from bs4 import BeautifulSoup
from string import punctuation
import sys

reload(sys)

sys.setdefaultencoding("utf-8")

threats = ['loss', 'fragmentation', 'hunting', 'poaching', 'fishing', 'overfishing', 'environmental', 'environment', 'invasive', 'disease', 'pet', 'pollution']

def findThreats(string): 
    threatsFound = []
    string = string.lower()
    string = string.lstrip(punctuation)
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
    allThreats = []
    f = open('output.txt', "wb")
    f.write('Name, Kingdom, Phylum, Class, Order, Phylum, Genus, Size, Threats, Conservation' + '\n')
    with open('test.txt', "rb") as fd:
        for line in fd:
            f.write('\n')
            line = line.lstrip().rstrip()
            url = line
            r = requests.get(url)
            soup = BeautifulSoup(r.text.encode('utf-8'), 'html.parser')
            soupsup = soup.findAll('td')
            for node in soupsup:
                waant = ''.join(node.findAll(text=True))
                f.write(waant + ',')
                if "(" in node:
                    break
            badges = soup.findAll("p", class_="Threats")
            ofInterest = str(badges)
            
            found = findThreats(ofInterest)
            allThreats.extend(found)
            
            ofInterest = parseThrough(ofInterest)
            
            if ofInterest:
                f.write(ofInterest)
                f.write(',')
            else:
                f.write(',')
                
            badges = soup.findAll("p", class_="Conservation")
            ofInterest = str(badges)
            
            ofInterest = parseThrough(ofInterest)
            print ofInterest
            
            if ofInterest:
                f.write(ofInterest)
                f.write('\n')
            else:
                f.write('\n')
        for word in threats:
            howMany = allThreats.count(word)
            f.write(' ' + word + ': ')
            f.write(str(howMany)) 
    fd.close()
    f.close()

def main():
    urlNeeded()

main()