
desc "Import all business support options"
task :import => :environment do
  File.open(Rails.root.join("data", "business-support-options.json")).each_line do |line|
    item = JSON.parse(line)
    BusinessSupport.safely.create!(
      title: item['title'],
      description: "Invalid description", # this will be filled in when we get the full schema through
      business_stages: item['business_stages'],
      business_types: item['business_types'],
      purposes: item['purposes'],
      support_types: item['support_types'],
      business_sectors: item['business_sectors']
    )
  end
end
