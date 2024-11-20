module FuelPrice
  class Importer
    EXCHANGE_RATE_URL = 'https://api.nbp.pl/api/exchangerates/rates/A/EUR/?format=json'.freeze

    def self.fetch_eur_to_pln_exchange_rate
      response = URI.open(EXCHANGE_RATE_URL).read
      data = JSON.parse(response)
      data['rates'].first['mid'] # Mid rate for EUR to PLN
    rescue StandardError => e
      puts "Error fetching exchange rate: #{e.message}"
      nil
    end

    def self.import(file_path)
      file_path = file_path.to_s
      sheet = Roo::Spreadsheet.open(file_path).sheet(0)
      headers = sheet.row(1)

      indices = fetch_column_indices(headers)
      validate_indices(indices)

      poland_data = extract_poland_data(sheet, indices)
      handle_poland_data(poland_data)
    end

    def self.fetch_column_indices(headers)
      {
        country: headers.index('in EUR'),
        gasoline_95: headers.index('Euro-super 95  (I)'),
        diesel: headers.index('Gas oil automobile Automotive gas oil Dieselkraftstoff (I)'),
        lpg: headers.index('GPL pour moteur LPG motor fuel')
      }
    end

    def self.validate_indices(indices)
      return unless indices.values.any?(&:nil?)

        raise 'One or more required columns are missing in the spreadsheet!'
    end

    def self.extract_poland_data(sheet, indices)
      poland_data = {}
      sheet.each_with_index do |row, index|
        next if index < 2 # Skip the first two rows (units + headers)
        next unless row[indices[:country]]&.strip&.casecmp?('Poland')

        poland_data = calculate_prices(row, indices)
        break
      end
      poland_data
    end

    def self.calculate_prices(row, indices)
      exchange_rate = fetch_eur_to_pln_exchange_rate
      return {} if exchange_rate.nil?

      {
        country: row[indices[:country]],
        gasoline_95: convert_to_pln(row[indices[:gasoline_95]], exchange_rate),
        diesel: convert_to_pln(row[indices[:diesel]], exchange_rate),
        lpg: convert_to_pln(row[indices[:lpg]], exchange_rate)
      }
    end

    def self.convert_to_pln(price_in_eur, exchange_rate)
      ((price_in_eur.to_f * exchange_rate) / 1000).round(2)
    end

    def self.handle_poland_data(poland_data)
      if poland_data.empty?
        puts 'No data found for Poland!'
      else
        puts 'Extracted data for Poland:'
        puts poland_data

        Price.destroy_all # Remove existing data
        Price.create(poland_data) # Save new data
        puts 'Price data updated successfully.'
      end
    end
  end
end
