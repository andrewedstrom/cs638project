import scrapy

class ArkiveCriticallyEndangeredHtmlSpider(scrapy.Spider):
    # Unique identifier for spider
    name = 'arkive-critically-endangered-html'

    # Initiate a request and yield an iterable of request
    def start_requests(self):
        urlfile = 'arkive-critically-endangered-misc/urls'
        f = open(urlfile, 'r')
        urls = f.read().split('\n')
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    # Handle response downloaded for each request
    # Saves raw html and finds new URLs to follow
    def parse(self, response):
        # Save raw html
        animal = response.url.split('/')[-2]
        filename = 'arkive-critically-endangered-html/%s.html' % animal
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Crikey! Looks like we caught us a wild %s!' % animal)

