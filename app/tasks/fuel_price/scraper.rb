require 'nokogiri'
require 'httparty'

module FuelPrice
  class Scraper
    URL = 'https://energy.ec.europa.eu/data-and-analysis/weekly-oil-bulletin_en'

    def self.fetch_latest_xlsx
      response = HTTParty.get(URL)
      raise 'Failed to fetch the webpage' unless response.code == 200

      doc = Nokogiri::HTML(response.body)
      xlsx_divs = doc.css('div.ecl-file')

      xlsx_divs.each do |div|
        title = div.at_css('.ecl-file__title')&.text
        next unless title&.include?('Prices with taxes latest prices') # Adjust criteria

        link = div.at_css('.ecl-file__download')&.[]('href')
        return URI.join(URL, link).to_s if link
      end

      raise 'No valid XLSX file link found'
    end
  end
end
