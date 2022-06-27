require_relative '../../db/connection.rb'

module Payments
  class Create
    def call(uuid:, from:, to:, currency:, amount:, pay_at:, batch_payment_id: nil)
      db = ::DB::Connection.open

      stm = db.prepare <<-SQL
        insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
          values (?, ?, ?, ?, ?, ?, ?);
      SQL
      stm.bind_param 1, uuid
      stm.bind_param 2, from
      stm.bind_param 3, to
      stm.bind_param 4, currency
      stm.bind_param 5, amount
      stm.bind_param 6, pay_at
      stm.bind_param 7, batch_payment_id
      rs = stm.execute
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
    ensure
      stm.close if stm
      ::DB::Connection.close
    end
  end
end
