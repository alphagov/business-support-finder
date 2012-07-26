
desc "Import all business support options"
task :import => :environment do
  counter = 0
  File.open(Rails.root.join("data", "business-support-options.json")).each_line do |line|
    item = JSON.parse(line)
    begin
    BusinessSupport.safely.create!(
      title: item['title'],
      description: "Invalid description", # this will be filled in when we get the full schema through
      business_stages: item['business_stages'],
      business_types: item['business_types'],
      purposes: item['purposes'],
      support_types: item['support_types'],
      business_sectors: item['business_sectors'],
      website_url: item["website_url"],
      contact_details: item["contact_details"],
      organiser: item["organiser"],
      min_turnover: item["min_turnover"],
      max_turnover: item["max_turnover"],
      min_grant_value: item["minimum_grant_value"],
      max_grant_value: item["maximum_grant_value"],
      min_age: item["minimum_age"],
      max_age: item["maximum_age"],
      min_employees: item["minimum_employees"],
      max_employees: item["maximum_employees"]
    )
    counter += 1
    print("#{counter}\r")
    rescue
    end
  end
end
