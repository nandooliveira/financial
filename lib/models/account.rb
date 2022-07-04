require_relative './base_model'

require 'pry'

module Models
  class Account < BaseModel
    attr_reader :id, :bank_code, :account_number, :account_branch

    table_name :accounts

    def initialize(bank_code:, account_number:, account_branch:, id: nil)
      @id             = id
      @bank_code      = bank_code
      @account_number = account_number
      @account_branch = account_branch
    end

    def self.mount_from_result(result)
      ::Models::Account.new(id: result[0], bank_code: result[1], account_number: result[2], account_branch: result[3])
    end
  end
end
