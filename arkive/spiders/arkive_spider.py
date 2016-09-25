import scrapy

class ArkiveSpider(scrapy.Spider):
    # Unique identifier for spider
    name = 'arkive'
    start_urls = [
        'http://www.arkive.org/abbotts-duiker/cephalophus-spadix/factsheet',
        'http://www.arkive.org/abbotts-booby/papasula-abbotti/factsheet',
        'http://www.arkive.org/abronia/abronia-graminea/factsheet'
    ]

    # Initiate a request and yield an iterable of request
    # def start_request(self):
    #     urls = [
    #         'http://www.arkive.org/abbotts-duiker/cephalophus-spadix/factsheet',
    #         'http://www.arkive.org/abbotts-booby/papasula-abbotti/factsheet',
    #         'http://www.arkive.org/abronia/abronia-graminea/factsheet',
    #     ]
    #     for url in urls:
    #         yield scrapy.Request(url=url, callback=self.parse)

    # Handle response downloaded for each request
    # Saves raw html and finds new URLs to follow
    def parse(self, response):
        page = response.url.split("/")[-2]
        filename = 'arkive-endangered/%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)
