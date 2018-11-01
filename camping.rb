require 'httparty'
require 'pry'

CAMPGROUND_IDS = [
  232449, # North Pines (https://www.recreation.gov/camping/campgrounds/232449)
  232447, # Upper Pines (https://www.recreation.gov/camping/campgrounds/232447/availability)
].freeze

RESERVED_LABELS = [
  "Reserved",
  "Not Available"
].freeze

BASE_URL = "https://www.recreation.gov/api/camps/availability/campground"
DATE_PARAMS = "start_date=2018-11-09T00%3A00%3A00.000Z&end_date=2018-11-11T00%3A00%3A00.000Z"

VERBOSE = false

SLEEP_TIME = 3

def campground_urls
  CAMPGROUND_IDS.map do |campground_id|
    campground_url(campground_id)
  end
end

def campground_url(id)
  "#{BASE_URL}/#{id}?#{DATE_PARAMS}"
end

def campground_availability_url
  "#{BASE_URL}/#{id}/availability"
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
          50.times do
            puts "OMG IT IS AVAILABLE!"
          end
        end
      end

      puts output if verbose?
    end
  end

  sleep SLEEP_TIME
end

