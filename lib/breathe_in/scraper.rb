class BreatheIn::Scraper
    
  @@air_quality_info = {}
  @@scraped = nil

  def self.air_quality
    @@air_quality_info
  end

  def self.scraped_pg
    @@scraped
  end

  def self.reset
    @@air_quality_info.clear
  end

  def self.scraped_page(zipcode)
    begin
      @@scraped = Nokogiri::HTML(open("http://airnow.gov/?action=airnow.local_city&zipcode=#{zipcode}&submit=Go"))
    rescue OpenURI::HTTPError => e
        if e.message == '404 Not Found'
          puts "The website is currently down. Pleaes try again later."
        else
          raise e
        end
    end
  end  

  def self.city_air_quality
    city_name
    today_high
    index_level
    current_conditions_time
    current_conditions_value
    current_conditions_index 
    air_quality
  end

  def self.under_maintenance #returns true if under maintenance 
    scraped_pg.css("#pageContent .TblInvisibleFixed tr p[style*='color:#F00;']").text.include?("maintenance")
  end

  def self.city_name
    city = scraped_pg.css("#pageContent .ActiveCity")
    #returns array of an object with attributes including city name
    city.empty? ? nil : air_quality[:city_name] = city.text.strip
  end

  def self.today_high 
    data = scraped_pg.css(".AQDataContent tr td .TblInvisible tr td")
    #returns array of data numbers (today's high, tomorrow's high, particles, etc.)
    data.empty? ? nil : air_quality[:today_high] = data[0].text.strip.to_i
  end

  def self.index_level 
    quality = scraped_pg.css(".AQDataContent .AQILegendText")
    #returns array of objects with attributes including quality
    quality.empty? ? nil : air_quality[:today_index] = quality.first.text
  end

  def self.current_conditions_time
    unformatted_info = scraped_pg.css(".AQData .AQDataSectionTitle .AQDataSectionTitle")
    #returns array of objects with attributes of title and date information
    current_info = unformatted_info.text.strip.split("\r\n                                       \t")
    # => returns array ["Air Quality Index (AQI)", "observed at 19:00 PST"]
    unformatted_info.empty? ? nil : air_quality[:last_update_time] = current_info[1]
  end

  def self.current_conditions_value 
    current_value = scraped_pg.css(".AQDataSectionTitle .TblInvisible .TblInvisible td")
    #returns array of an object with attributes including current condition value
    current_value.empty? ? nil : air_quality[:last_update_value] = current_value.text.strip.to_i
  end

  def self.current_conditions_index 
    current_index = scraped_pg.css(".AQDataSectionTitle .TblInvisible .AQDataLg")
    #returns array of an object with attributes including current condition index
    current_index.empty? ? nil : air_quality[:last_update_index] = current_index.text.strip
  end

  def self.unavailable_data #returns true if data is unavailable
    phrase = scraped_pg.css(".TblInvisibleFixed .AQData tr td[valign*='top']").text
    phrase.include?("Data Not Available")
  end
end
binding.pry
