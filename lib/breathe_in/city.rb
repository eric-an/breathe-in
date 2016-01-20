class BreatheIn::City
  attr_accessor :city_name, :zipcode, :today_high, :today_index, :last_update_time, :last_update_value, :last_update_index

  @@cities = []

  def initialize(city_hash={})
    city_hash.each { |key, value| self.send(("#{key}="), value) }
    @@cities << self
  end

  def add_city_air_quality(air_quality_hash)
    air_quality_hash.each { |key, value| self.send(("#{key}="), value) }
    self
  end

  def self.cities
    @@cities
  end

  def self.reset
    @@cities.clear
  end
end