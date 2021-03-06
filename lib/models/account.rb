require_relative './base_model'

require 'pry'

module Models
  class Account < BaseModel
    attr_accessor :id, :bank_code, :account_number, :account_branch

    table_name :accounts

    def self.build(bank_code:, account_number:, account_branch:, id: nil)
      ::Models::Account.new.tap do |account|
        account.id = id
        account.bank_code = bank_code
        account.account_number = account_number
        account.account_branch = account_branch
      end
    end

    def self.mount_from_result(result)
      ::Models::Account.build(id: result[0], bank_code: result[1], account_number: result[2], account_branch: result[3])
    end
  end
end
