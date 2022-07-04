# frozen_string_literal: true

require 'active_support/all'
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
    attributes[name] = args[0]
  end

  NON_PERSISTIBLE_ATTRIBUTES = %i[repeat_each repeat_times].freeze
  def process(uuid)
    instance = @factory_class.new
    instance.uuid = uuid

    @attributes.except(*NON_PERSISTIBLE_ATTRIBUTES).each do |attribute_name, value|
      instance.send("#{attribute_name}=", value)
    end

    return instance = instance.save unless @attributes[:repeat_times] && @attributes[:repeat_each]

    instances = [instance]

    @attributes[:repeat_times].times do
      new_instance = instances.last.dup
      new_instance.id = nil
      new_instance.pay_at = (Date.parse(new_instance.pay_at) + @attributes[:repeat_each]).to_s

      instances << new_instance.save
    end

    instances
  end
end

class BatchPaymentFactory
  def initialize
    @factory_class = ::Models::BatchPayment
    @attributes    = {}
  end

  attr_reader :factory_class, :attributes

  def method_missing(name, *args)
    attributes[name] = args[0]
  end

  def payment(&)
    factory = PaymentFactory.new

    factory.instance_eval(&) if block_given?

    attributes[:payments] ||= []
    attributes[:payments] << factory
  end

  def process(uuid)
    instance = @factory_class.new
    instance.uuid = uuid
    instance = instance.save

    @attributes[:payments].each do |payment_factory|
      payment_factory.from(@attributes[:from])
      payment_factory.pay_at(@attributes[:pay_at])
      payment_factory.currency(@attributes[:currency])
      payment_factory.batch_payment_id(instance.id)
      payment_factory.process(SecureRandom.uuid)
    end

    instance.save
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
    factory = registry[owner_identifier]
    results = factory.process(owner_identifier)

    (enqueued_to_process << results).flatten

    results
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
