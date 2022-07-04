# frozen_string_literal: true

require 'date'
require 'securerandom'

require_relative './models/account'
require_relative './models/payment'
require_relative './models/batch_payment'

class PaymentFactory
  def initialize
    @factory_class = ::Models::Payment
    @attributes    = {}
  end

  attr_reader :factory_class, :attributes

  def method_missing(name, *args)
    value = name == 'pay_at' ? Date.parse(args[0]) : args[0]
    attributes[name] = value
  end
end

class BatchPaymentFactory
  def initialize
    @factory_class = BatchPayment
    @attributes    = {}
  end

  attr_reader :factory_class, :attributes

  def method_missing(name, *args)
    value = name == 'pay_at' ? Date.parse(args[0]) : args[0]
    attributes[name] = value
  end
end

class DefinitionProxy
  def payment(owner_identifier, &)
    factory = PaymentFactory.new

    factory.instance_eval(&) if block_given?

    Contract.registry[owner_identifier] = factory
  end

  def batch_payment(owner_identifier, &)
    factory = BatchPaymentFactory.new

    factory.instance_eval(&) if block_given?

    Contract.registry[owner_identifier] = factory
  end
end

module Contract
  @registry = {}
  @enqueued_to_process = []

  def self.registry
    @registry
  end

  def self.enqueued_to_process
    @enqueued_to_process
  end

  def self.define(&)
    definition_proxy = DefinitionProxy.new
    definition_proxy.instance_eval(&)
  end

  def self.process(owner_identifier)
    factory  = registry[owner_identifier]
    instance = factory.factory_class.new

    factory.attributes.each do |attribute_name, value|
      instance.send("#{attribute_name}=", value)
    end

    enqueued_to_process << instance

    instance
  end
end

# example

# payment_identifier = SecureRandom.uuid

# Contract.define do
#   payment payment_identifier do
#     from      bank_code: 1, account_number: 123, account_branch: 123
#     to        bank_code: 2, account_number: 321, account_branch: 321
#     currency  'USD'
#     amount    '100'
#     pay_at    '2022-10-20'
#   end
# end

# Contract.process(payment_identifier)
