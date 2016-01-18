class BreatheIn::Scraper

#conditions to consider:
  # if website doesn't load (404 error)
  # if website doesn't recognize zipcode ("city not found")
  # if website loads, but no data numbers exist (ie. 92102)
  # if current conditions aren't available
  # if under scheduled maintenance from 12am - 4am EST
  # if data is unavailable (for tomorrow)

#methods to be defined:
  # city name
  # data numbers
  # description (scale keyword)
  # current conditions (time)
  # current conditions (date)
  # if going under maintenance
  # if tomorrow's forecast is not available

end