# frozen_string_literal: true

require_relative './base_model'

module Models
  class Payment < BaseModel
    attr_reader :uuid, :id, :amount, :currency

    table_name :payments

    def initialize(uuid:, amount:, currency:, from_account_id:, to_account_id:, pay_at:, batch_payment_id:, id: nil)
      @id               = id
      @uuid             = uuid
      @amount           = amount
      @currency         = currency
      @from_account_id  = from_account_id
      @to_account_id    = to_account_id
      @pay_at           = pay_at
      @batch_payment_id = batch_payment_id
    end

    def self.mount_from_result(result)
      ::Models::Payment.new(
        id: result[0],
        uuid: result[1],
        from_account_id: result[2],
        to_account_id: result[3],
        currency: result[4],
        amount: result[5],
        pay_at: result[6],
        batch_payment_id: result[7]
      )
    end
  end
end
