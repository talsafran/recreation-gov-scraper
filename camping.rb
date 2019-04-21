require 'httparty'
require 'pry'

CAMPGROUND_IDS = [
  232449, # North Pines (https://www.recreation.gov/camping/campgrounds/232449)
  232447, # Upper Pines (https://www.recreation.gov/camping/campgrounds/232447/availability)
].freeze
START_DATE = "2019-05-03"
END_DATE = "2019-05-06"

BASE_URL = "https://www.recreation.gov/api/camps/availability/campground"

RESERVED_LABELS = [
  "Reserved",
  "Not Available"
].freeze


VERBOSE = false

SLEEP_TIME = 10

def campground_urls
  CAMPGROUND_IDS.map do |campground_id|
    campground_url(campground_id)
  end
end

def campground_url(id)
  "#{BASE_URL}/#{id}?#{date_params}"
end

def campground_availability_url
  "#{BASE_URL}/#{id}/availability"
end

def date_params
  start_date="#{START_DATE}T00%3A00%3A00.000Z"
  end_date="#{END_DATE}T00%3A00%3A00.000Z"

  "start_date=#{start_date}&end_date=#{end_date}"
end

def verbose?
  VERBOSE
end

loop do 
  print '.'

  campground_urls.each do |url| 
    response = HTTParty.get(url)

    response['campsites'].each do |campsite|
      output = "Campsite #{campsite[0]}: "

      campsite[1]['availabilities'].each do |availability_hash|
        date = availability_hash[0]
        reservation_status = availability_hash[1]
        
        output << "#{date} - #{reservation_status}  "

        unless RESERVED_LABELS.include?(reservation_status)
          puts "OMG IT IS AVAILABLE! #{url}"
        end
      end

      puts output if verbose?
    end
  end

  sleep SLEEP_TIME
end

