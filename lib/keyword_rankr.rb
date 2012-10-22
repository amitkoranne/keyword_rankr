require 'rubygems'
require 'nokogiri'
require 'net/http'

class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

class Ranking
  @@default_options = { :limit => 200, :res_per_page => 10, :supported_engines => [:bing, :bingIND, :bingCA ,:bingUK,:bingFR , :google, :googleUS, :yahoo, :googleUSA, :googleIND, :googleFR, :googleCA, :yahooIND, :yahooFR, :yahooCA  ] } #careful, res_per_page doesn't work with more than 10 for all search engines!

  attr_reader :options

  def initialize(*options) # keyword, url, limit
    self.options = options.extract_options!
  end

  def options=(options)
    @options = @@default_options.merge(options)
    @options[:url].gsub!(/(http:\/\/|https:\/\/)/, '')
    @options[:url].gsub!(/^www/, '')
  end

  def from
    validate_options
    @finder ||= Finder.new
    @finder.find(@options)
  end

  def method_missing(method, *args, &block)
    engine = @@default_options[:supported_engines].find{ |name| ("from_" << name.to_s).match /#{method}/ }
    if engine
      @options.merge!({:engine => engine})
      send("from")
    else
      super(method, *args, &block)
    end
  end

  protected
  def validate_options
    raise "Keyword and site parameters must be Strings" unless @options[:keyword].is_a?(String) and @options[:url].is_a?(String)
    raise "Engine should be 'bing', 'google' or 'yahoo'" unless @@default_options[:supported_engines].include?(@options[:engine].to_sym)
  end

end

class Finder

  def find(options) #keyword, url, limit, engine, res_per_page
    options[:keyword].gsub!(/\s/, '+')
    request_url, results_selector, cite_selector = case options[:engine].to_sym
    when :bing
      ["http://www.bing.com/search?q=#{options[:keyword]}&count=#{options[:res_per_page]}&first=", '#wg0 > li', 'cite']
    when :google
      ["http://www.google.co.uk/search?q=#{options[:keyword]}&num=#{options[:res_per_page]}&start=", '#ires > ol > li', 'cite']
    when :googleUS
      ["http://www.google.com/search?q=#{options[:keyword]}&num=#{options[:res_per_page]}&start=", '#ires > ol > li', 'cite']
    when :yahoo
      ["http://search.yahoo.com/search?p=#{options[:keyword]}&n=#{options[:res_per_page]}&b=", '#web > ol > li', 'span']
    when :googleIND
      ["http://www.google.co.in/search?q=#{options[:keyword]}&num=#{options[:res_per_page]}&start=", '#ires > ol > li', 'cite']
    when :googleFR
      ["http://www.google.fr/search?q=#{options[:keyword]}&num=#{options[:res_per_page]}&start=", '#ires > ol > li', 'cite']
    when :googleUSA
      ["http://www.google.com/search?q=#{options[:keyword]}&num=#{options[:res_per_page]}&start=", '#ires > ol > li', 'cite']
    when :googleCA
      ["http://www.google.ca/search?q=#{options[:keyword]}&num=#{options[:res_per_page]}&cc=ca&start=", '#ires > ol > li', 'cite']
    when :bingIND
      ["http://www.bing.com/search?q=#{options[:keyword]}&count=#{options[:res_per_page]}&cc=in&first=", '#wg0 > li', 'cite'] 
    when :bingCA
      ["http://www.bing.com/search?q=#{options[:keyword]}&count=#{options[:res_per_page]}&cc=ca&first=", '#wg0 > li', 'cite']
    when :bingFR
      ["http://www.bing.com/search?q=#{options[:keyword]}&count=#{options[:res_per_page]}&cc=fr&first=", '#wg0 > li', 'cite']
    when :bingUK
      ["http://www.bing.com/search?q=#{options[:keyword]}&count=#{options[:res_per_page]}&cc=uk&first=", '#wg0 > li', 'cite']
    when :yahooIND
      ["http://in.search.yahoo.com/search?p=#{options[:keyword]}&n=#{options[:res_per_page]}&b=", '#web > ol > li', 'span']
    when :yahooFR
      ["http://fr.search.yahoo.com/search?p=#{options[:keyword]}&n=#{options[:res_per_page]}&b=", '#web > ol > li', 'span']
    when :yahooCA
      ["http://ca.search.yahoo.com/search?p=#{options[:keyword]}&n=#{options[:res_per_page]}&b=", '#web > ol > li', 'span']
    when :yahoo
      ["http://search.yahoo.com/search?p=#{options[:keyword]}&n=#{options[:res_per_page]}&b=", '#web > ol > li', 'span']
    end
 

    count, rank = 0, nil

    loop {
      html_response = Net::HTTP.get_response(URI.parse("#{request_url}#{count}")).body
      html_results = Nokogiri.parse(html_response).css(results_selector)
      @var = html_results.detect{ |result| result.css("#productbox") }
     
     if @var == "#productbox"
     #if html_results.index(html_results.detect{ |result| result.css(cite_selector).text.match Regexp.new(options[:url]) })
            
       rank = html_results.index(html_results.detect{ |result| result.css(cite_selector).text.match Regexp.new(options[:url]) })

       if count > options[:limit]
          break
       elsif rank
          rank += count - 1
          break
       end
        count += options[:res_per_page]
        
     else
       rank = html_results.index(html_results.detect{ |result| result.css(cite_selector).text.match Regexp.new(options[:url]) })

       if count > options[:limit]
         break
       elsif rank
         rank += count
         break
       end
       count += options[:res_per_page]
    end#If HTML
    }
    rank ? rank.next : nil
   end

end