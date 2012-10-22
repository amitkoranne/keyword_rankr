# KeywordRankr

Provide a simple way for checking keyword ranking from Google, Yahoo, Bing. List of countries currently available are 
USA, France, Canada, India
## Installation

Add this line to your application's Gemfile:

    gem 'keyword_rankr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install keyword_rankr

## Usage
just provide the "keyword", "Domain" and "page limit", by default page limit will be 100.
For Google UK.

    Ranking.new(:keyword => user.key_word, :url => "www.example.com", :limit =>100).from_google
    
For Google USA.

    Ranking.new(:keyword =>"your keyword", :url => "www.example.com", :limit =>100).from_googleUS
    
For Google CA.

    Ranking.new(:keyword => "your keyword", :url => "www.example.com", :limit =>100).from_googleCA
    
For Google France.

    Ranking.new(:keyword =>"your keyword", :url =>  "www.example.com", :limit =>100).from_googleFR
    
For Google India.

    Ranking.new(:keyword =>"your keyword", :url =>  "www.example.com", :limit =>100).from_googleIND
    
Bing USA.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_bing
    
Bing India.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_bingIND
    
Bing Canada.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_bingCA
    
Bing France.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_bingFR
    
Bing UK.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_bingUK
    
Yahoo USA.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_yahoo
    
Yahoo  India.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_yahooIND
    
Yahoo Canada.

    Ranking.new(:keyword => "your keyword", :url =>  "www.example.com", :limit =>100).from_yahooCA
    
Yahoo France.

    Ranking.new(:keyword => "your keyword", :url =>  user.domain, :limit =>100).from_yahooFR
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
