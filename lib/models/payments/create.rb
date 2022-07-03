# frozen_string_literal: true

require_relative '../../db/connection'

module Payments
  class Create
    INSERT = <<-SQL
      insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
        values (?, ?, ?, ?, ?, ?, ?);
    SQL

    def call(uuid:, from:, to:, currency:, amount:, pay_at:, batch_payment_id: nil)
      db = ::DB::Connection.open

      db.execute INSERT, uuid, from, to, currency, amount, pay_at, batch_payment_id
    rescue SQLite3::Exception => e
      puts e
    ensure
      ::DB::Connection.close
    end
  end
end
