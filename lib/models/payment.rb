# frozen_string_literal: true

require 'sqlite3'

require_relative '../db/connection'

module Models
  class Payment
    attr_reader :uuid, :id, :amount, :currency

    def get(id:)
      db = ::DB::Connection.open

      stm = db.query 'SELECT * FROM payments WHERE id = ?', id

      rs.next
    rescue SQLite3::Exception => e
      puts 'Exception occurred'
      puts e
    ensure
      stm&.close
      ::DB::Connection.close
    end
  end
end
