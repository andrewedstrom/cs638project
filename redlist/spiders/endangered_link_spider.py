import scrapy

class RedlistEndangeredLinkSpider(scrapy.Spider):
    # Unique identifier for spider
    name = 'redlist-endangered-link'

    # knabbedcount = 0

    # Initiate a request and yield an iterable of request
    def start_requests(self):
        urls = []
        yield scrapy.Request(url="http://www.iucnredlist.org/search", callback=self.parse)
        for i in range(2,141):
            urls.append("http://www.iucnredlist.org/search?page={0}".format(i))
        for url in urls:
            yield scrapy.Request(url=url,
                                 cookies={'user_choice2':'return',
                                          '_newiucnredlist_session' : 'cebe1029de27b7b51c463650bd2f11ac;',
                                          '_gat':'1',
                                          '_ga': 'GA1.2.1229546810.1474666915'},
                                 callback=self.parse)

    # Handle response downloaded for each request
    # Saves raw html and finds new URLs to follow
    def parse(self, response):
        urlstublist = response.xpath('//li[(((count(preceding-sibling::*) + 1) > 0) and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "desc", " " ))]').css('a.title::attr(href)').extract()
        # knabbedcount += len(urlstublist)
        filename = 'redlist-endangered-misc/urls'
        with open(filename, 'ab') as f:
            for urlstub in urlstublist:
                f.write('http://www.iucnredlist.org' + urlstub + '\n')
        # self.log('Number of URLs knabbed thus far = ', knabbedcount)
