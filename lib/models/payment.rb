# frozen_string_literal: true

require_relative './base_model'
require_relative './account'

module Models
  class Payment < BaseModel
    attr_accessor :uuid, :id, :amount, :currency, :from_account_id, :to_account_id, :pay_at, :batch_payment_id

    table_name :payments

    def self.build(uuid:, amount:, currency:, from_account_id:, to_account_id:, pay_at:, batch_payment_id:, id: nil)
      ::Models::Payment.new.tap do |payment|
        payment.id = id
        payment.uuid = uuid
        payment.currency = currency
        payment.from_account_id = from_account_id
        payment.to_account_id = to_account_id
        payment.pay_at = pay_at
        payment.batch_payment_id = batch_payment_id
      end
    end

    def self.mount_from_result(result)
      ::Models::Payment.build(
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

    def from_account
      ::Models::Account.find_by(from_account_id: @from_account_id)
    end

    def to_account
      ::Models::Account.find_by(to_account_id: @to_account_id)
    end

    def from=(params)
      account = ::Models::Account.create(params)
      self.from_account_id = account.id
    end

    def to=(params)
      account = ::Models::Account.create(params)
      self.to_account_id = account.id
    end
  end
end
