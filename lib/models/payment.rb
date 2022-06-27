require 'sqlite3'

require_relative '../db/connection.rb'

module Models
  class Payment
    attr_reader :uuid, :id, :amount, :currency

    def get(id:)
      begin
        db = ::DB::Connection.open

        stm = db.prepare "SELECT * FROM payments WHERE Id=?"
        stm.bind_param 1, id
        rs = stm.execute

        row = rs.next

        @id       = id
        @uuid     = rs['uuid']
        @amount   = rs['amount']
        @currency = rs['currency']

        puts row.join "\s"
      rescue SQLite3::Exception => e
        puts "Exception occurred"
        puts e
      ensure
        stm.close if stm
        ::DB::Connection.close
      end
    end
  end
