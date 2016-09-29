import scrapy

class RedlistLinkSpider(scrapy.Spider):
    # Unique identifier for spider
    name = 'redlist-link'

    # Initiate a request and yield an iterable of request
    def start_requests(self):
        urls = []
        yield scrapy.Request(url="http://www.iucnredlist.org/search", callback=self.parse)
        for i in range(2,141):
            urls.append("http://www.iucnredlist.org/search?page={0}".format(i))
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    # Handle response downloaded for each request
    # Saves raw html and finds new URLs to follow
    def parse(self, response):
        htmllist = response.xpath('//li/h2/a/@href').extract()
        filename = 'arkive-endangered-misc/urls'
        with open(filename, 'ab') as f:
            for html in htmllist:
                f.write("http://www.arkive.org" + html + "factsheet\n")
        self.log('Knabbed urls from page %s' % response.url.split('/')[-1])
