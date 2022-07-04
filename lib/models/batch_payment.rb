# frozen_string_literal: true

require_relative './base_model'

module Models
  class BatchPayment < BaseModel
    attr_reader :uuid, :id

    table_name :batch_payments

    def initialize(uuid:, id: nil)
      @id               = id
      @uuid             = uuid
    end

    def self.mount_from_result(result)
      ::Models::BatchPayment.new(
        id: result[0],
        uuid: result[1]
      )
    end

    def payments
      ::Models::Payment.find_by(batch_payment_id: @id)
    end
  end
end
