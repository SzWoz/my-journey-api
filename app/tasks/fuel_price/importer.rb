module FuelPrice
  class Importer
    def self.import(file_path)
      # Convert Pathname to string if necessary
      file_path = file_path.to_s

      spreadsheet = Roo::Spreadsheet.open(file_path)
      sheet = spreadsheet.sheet(0)

      headers = sheet.row(1)
      country_column_index = headers.index('in EUR')
      gasoline_95_index = headers.index('Euro-super 95  (I)')
      diesel_index = headers.index('Gas oil automobile Automotive gas oil Dieselkraftstoff (I)')
      lpg_index = headers.index('GPL pour moteur LPG motor fuel')

      if [country_column_index, gasoline_95_index, diesel_index, lpg_index].any?(&:nil?)
        raise 'One or more required columns are missing in the spreadsheet!'
      end

      poland_data = {}
      sheet.each_with_index do |row, index|
        next if index < 2 # Skip the first two rows (units + headers)

        next unless row[country_column_index]&.strip&.casecmp?('Poland')

        poland_data = {
          country: row[country_column_index],
          gasoline_95: row[gasoline_95_index],
          diesel: row[diesel_index],
          lpg: row[lpg_index]
        }
        break
      end

      if poland_data.empty?
        puts 'No data found for Poland!'
      else
        puts 'Extracted data for Poland:'
        puts poland_data
      end
    end
  end
end
