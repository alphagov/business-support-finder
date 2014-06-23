#!/usr/bin/env ruby

require "json"
require "open-uri"
require "date"

TODAY = Date.today.strftime("%Y-%m-%d")
CSV_HEADERS = "id|title|web_url|short_description"

def write_csv_file(filename, data)
	 File.open(filename, "w") do |data_file|
 		 data_file.puts(CSV_HEADERS)
 		 data_file.puts(data)
 	end
end

def all_schemes_for_location(location_name, location_query_string, ids_to_remove = [])
	 url = "https://imminence.production.alphagov.co.uk/business_support_schemes.json?locations=" + location_query_string
	 json_data = JSON.parse(open(url).read)
	 id_arr = json_data["results"].map { |s| s["business_support_identifier"] }
	 id_arr_final = id_arr - ids_to_remove
	 id_list = id_arr_final.join(",")
	 total = id_arr_final.length
	 all_schemes_url = "https://www.gov.uk/api/business_support_schemes.json?identifiers=" + id_list
	 all_schemes_json = JSON.parse(open(all_schemes_url).read)
	 published_schemes_csv = all_schemes_json["results"].map { |s| s["identifier"] + "|" + s["title"] + "|" + s["web_url"] + "|" + s["short_description"] }
	 filename = location_name + TODAY + ".csv"
	 puts (filename + ":" + total.to_s)
	 write_csv_file(filename, published_schemes_csv)
end

all_schemes_for_location("Scotland", "scotland")
all_schemes_for_location("Wales", "wales")
all_schemes_for_location("NorthernIreland", "northern-ireland")
all_schemes_for_location("England", "england,london,north-east,north-west,east-midlands,west-midlands,yorkshire-and-the-humber,south-west,east-of-england,south-east")
all_schemes_for_location("AllOfEngland", "england")

json_all_england = JSON.parse(open("https://imminence.production.alphagov.co.uk/business_support_schemes.json?locations=england").read)
ids_all_england = json_all_england["results"].map { |s| s["business_support_identifier"] }

all_schemes_for_location("London", "london", ids_all_england)
all_schemes_for_location("NorthEastEngland", "north-east", ids_all_england)
all_schemes_for_location("NorthWestEngland", "north-west", ids_all_england)
all_schemes_for_location("EastMidlands", "east-midlands", ids_all_england)
all_schemes_for_location("WestMidlands", "west-midlands", ids_all_england)
all_schemes_for_location("YorkshireAndTheHumber", "yorkshire-and-the-humber", ids_all_england)
all_schemes_for_location("SouthWest", "south-west", ids_all_england)
all_schemes_for_location("EastOfEngland", "east-of-england", ids_all_england)
all_schemes_for_location("SouthEast", "south-east", ids_all_england)
