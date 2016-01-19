class BreatheIn::CLI

  @@zipcode = nil

  def self.zipcode
    @@zipcode
  end

  def run
    puts "*Data provided courtesy of AirNow.gov*"
    puts "How safe it is to breathe today?"
    puts ""
    get_information
    check_site_availability
    menu
  end

  def get_information
    get_zipcode
    scrape_data
    if BreatheIn::Scraper.city_name == nil
      puts "That zipcode is not recognized by Air.gov."
      get_information
    else
      new_city = BreatheIn::City.new({zipcode: self.class.zipcode})
      assign_attributes(new_city)
      display_information
    end
  end

  def check_site_availability
    if BreatheIn::Scraper.under_maintenance
      disclaimer = <<-Ruby
        ***AirNow.gov undergoes maintenance from midnight to 4am EST. 
        If information is currently unavailable, please try again later.***
        Ruby
      puts disclaimer
    end
  end

  def menu
    input = nil

    while input != 3
      puts ""
      puts "1. Learn more about the AQI values and the ranges."
      puts "2. Choose another zipcode."
      puts "3. Exit."
      puts "Please make a selection:"
      puts ""
      
      input = gets.strip.to_i
      case input
        when 1
          BreatheIn::Scraper.AQI_range_information
        when 2
          BreatheIn::City.reset
          get_information
          check_site_availability
        when 3
          puts "Breathe safely!"
        else
          puts "Please choose 1, 2, or 3."
      end
    end
  end

  def get_zipcode
    input = ""
    until input.match(/\b\d{5}\b/)
      puts "Please enter a valid zipcode and wait a few seconds:"
      puts ""
      input = gets.strip
    end
    @@zipcode = input.to_s.rjust(5, '0')
  end

  def scrape_data
    BreatheIn::Scraper.scraped_page(self.class.zipcode)
  end

  def assign_attributes(new_city)
    attributes = BreatheIn::Scraper.city_air_quality
    city_info_hash = new_city.add_city_air_quality(attributes)

    if !BreatheIn::Scraper.today_high
      city_info_hash
      new_city.today_high = "Today's high currently unavailable."

    elsif !BreatheIn::Scraper.current_conditions_value
      city_info_hash
      new_city.last_update_value = "Current AQI unavailable."

    elsif !BreatheIn::Scraper.index_level
      city_info_hash
      new_city.today_index = "Level information unavailable."

    elsif !BreatheIn::Scraper.current_conditions_time
      city_info_hash
      new_city.last_update_time = "Time unavailable."

    elsif !BreatheIn::Scraper.current_conditions_index 
      city_info_hash
      new_city.last_update_index = "Current level unavailable."

    else
      city_info_hash
    end
  end

  def display_information
    BreatheIn::City.cities.each do |city|
      puts "---------------------"
      puts "City/Area: #{city.city_name}, Zipcode: #{city.zipcode}"
      puts "---------------------"
      puts "Today's High AQI: #{city.today_high}"
      puts "Today's Index: #{city.today_index}"
      health_description(city.today_high) if city.today_high.is_a?(Integer)
      puts "---------------------"
      puts "Last #{city.last_update_time}"
      puts "Current AQI: #{city.last_update_value}"
      puts "Current Index: #{city.last_update_index}"
      health_description(city.last_update_value) if city.last_update_value.is_a?(Integer) 
       puts "---------------------"      
    end
  end

  def health_description(level)
      if level.between?(0,50)
        puts "#{BreatheIn::Scraper.index_good}"
      elsif level.between?(51,100)
        puts "#{BreatheIn::Scraper.index_moderate}"
      elsif level.between?(100,150)
        puts "#{BreatheIn::Scraper.index_sensitive}"
      elsif level.between?(151,200)
        puts "#{BreatheIn::Scraper.index_unhealthy}"
      elsif level.between?(201,300)
        puts "#{BreatheIn::Scraper.index_very_unhealthy}"
      elsif level.between?(301,500)
        puts "#{BreatheIn::Scraper.index_hazardous}"   
      end
  end
end