# frozen_string_literal: true

require_relative './base_model'

module Models
  class BatchPayment < BaseModel
    attr_accessor :uuid, :id

    table_name :batch_payments

    def self.build(uuid:, id: nil)
      ::Models::BatchPayment.new.tap do |batch_payment|
        batch_payment.id = id
        batch_payment.uuid = uuid
      end
    end

    def self.mount_from_result(result)
      ::Models::BatchPayment.build(
        id: result[0],
        uuid: result[1]
      )
    end

    def payments
      ::Models::Payment.find_by(batch_payment_id: @id)
    end
  end
end
