namespace :fuel_price do
  desc 'Fetch and migrate fuel prices from the Weekly Oil Bulletin'
  task import: :environment do
    # Step 1: Scrape the page and download the XLSX file
    latest_xlsx_url = FuelPrice::Scraper.fetch_latest_xlsx
    file_path = Rails.root.join('tmp/fuel_prices.xlsx')

    # Write the file in binary mode to handle encoding issues
    File.binwrite(file_path, HTTParty.get(latest_xlsx_url).body)

    puts "Downloaded the XLSX file to #{file_path}"

    # Step 2: Import the data into the database
    FuelPrice::Importer.import(file_path)

    puts 'Fuel prices imported successfully!'
  end
end
