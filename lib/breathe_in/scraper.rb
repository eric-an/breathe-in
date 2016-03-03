class BreatheIn::Scraper
    
  @@air_quality_info = {}
  @@scraped = nil

  def self.air_quality
    @@air_quality_info
  end

  def self.scraped_pg
    @@scraped
  end

  def self.scraped_page(zipcode)
    begin
      @@scraped = Nokogiri::HTML(open("https://airnow.gov/?action=airnow.local_city&zipcode=#{zipcode}&submit=Go"))
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

  def self.index_good
    print "Air quality is considered satisfactory, and air pollution poses little or no risk."
  end

  def self.index_moderate
    print "Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution."
  end

  def self.index_sensitive
    print "Members of sensitive groups may experience health effects. The general public is not likely to be affected."
  end

  def self.index_unhealthy
    print "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects."
  end

  def self.index_very_unhealthy
    print "Health warnings of emergency conditions. The entire population is more likely to be affected."
  end

  def self.index_hazardous
    print "Health alert: everyone may experience more serious health effects."
  end

  def self.AQI_range_information
    information = <<-Ruby
      The Air Quality Index (AQI) translates air quality data into an easily understandable number to identify how clean or polluted the outdoor air is, along with possible health effects. 
      The U.S. Environmental Protection Agency, National Oceanic and Atmospheric Administration, National Park Service, tribal, state, and local agencies developed the AirNow system to provide the public with easy access to national air quality information. 

      "Good" AQI is 0 - 50. 
      Air quality is considered satisfactory, and air pollution poses little or no risk.
      ***************************
      "Moderate" AQI is 51 - 100. 
      Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people. For example, people who are unusually sensitive to ozone may experience respiratory symptoms.
      ***************************
      "Unhealthy for Sensitive Groups" AQI is 101 - 150. 
      Although general public is not likely to be affected at this AQI range, people with lung disease, older adults and children are at a greater risk from exposure to ozone, whereas persons with heart and lung disease, older adults and children are at greater risk from the presence of particles in the air. 
      ***************************
      "Unhealthy" AQI is 151 - 200. 
      Everyone may begin to experience some adverse health effects, and members of the sensitive groups may experience more serious effects.
      ***************************
      "Very Unhealthy" AQI is 201 - 300. 
      This would trigger a health alert signifying that everyone may experience more serious health effects.
      ***************************
      "Hazardous" AQI greater than 300. 
      This would trigger a health warnings of emergency conditions. The entire population is more likely to be affected.
      ***************************
      All descriptions, information, and data are provided courtesy of AirNow.gov. Visit the website to learn more.
    Ruby
    puts information
  end

  def self.under_maintenance #returns true if under maintenance 
    scraped_pg.css("#pageContent .TblInvisibleFixed tr p[style*='color:#F00;']").text.include?("maintenance")
  end

  # def self.unavailable_data #returns true if data is unavailable
  #   phrase = scraped_pg.css(".TblInvisibleFixed .AQData tr td[valign*='top']").text
  #   phrase.include?("Data Not Available")
  # end
end