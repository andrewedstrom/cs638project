import scrapy

class RedlistCriticallyEndangeredLinkSpider(scrapy.Spider):
    # Unique identifier for spider
    name = 'redlist-critically-endangered-link'

    # knabbedcount = 0

    # Initiate a request and yield an iterable of request
    def start_requests(self):
        urls = []
        for i in range(1,95):
            urls.append("http://www.iucnredlist.org/search?page={0}".format(i))
        for url in urls:
            yield scrapy.Request(url=url,
                                 cookies={'user_choice2': 'return',
                                     '_newiucnredlist_session': '74b8dfcd251e585666c792fc93977318',
                                     '_gat': '1',
                                     '_ga': 'GA1.2.1229546810.1474666915'},
                                 callback=self.parse)

    # Handle response downloaded for each request
    # Saves raw html and finds new URLs to follow
    def parse(self, response):
        urlstublist = response.xpath('//li[(((count(preceding-sibling::*) + 1) > 0) and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "desc", " " ))]').css('a.title::attr(href)').extract()
        # knabbedcount += len(urlstublist)
        filename = 'redlist-critically-endangered-misc/urls'
        with open(filename, 'ab') as f:
            for urlstub in urlstublist:
                f.write('http://www.iucnredlist.org' + urlstub + '\n')
        # self.log('Number of URLs knabbed thus far = ', knabbedcount)
