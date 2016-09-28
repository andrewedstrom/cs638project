import scrapy

class ArkiveHtmlSpider(scrapy.Spider):
    # Unique identifier for spider
    name = 'arkive-html'

    # Initiate a request and yield an iterable of request
    def start_requests(self):
        urlfile = 'arkive-endangered/urls'
        f = open(urlfile, 'r')
        urls = f.read().split('\n')
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    # Handle response downloaded for each request
    # Saves raw html and finds new URLs to follow
    def parse(self, response):
        # Save raw html
        animal = response.url.split('/')[-2]
        filename = 'arkive-endangered-html/%s.html' % animal
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Crikey! Looks like we caught us a wild %s!' % animal)

        # Extract atributes
        # animal_name = response.xpath('//h1/text()').extract_first()[:-2]

        # scientific_name = response.xpath('//i/text()').extract_first()
        # kingdom
        # phylum
        # class
        # order
        # family
        # genus
        # status
        # description
        # synonyms
        #
        #
        # size
        # weight
        # status
        # range (do we need this)
        # habitat (do we need this)
        #

