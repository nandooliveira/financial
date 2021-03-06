# frozen_string_literal: true

module Financial
  class << self
    attr_accessor :config

    def configure(&)
      self.config ||= Config.new
      instance_eval(&)
    end
  end

  class Config
    attr_accessor :some_configurable_variable
  end
end

# How to use it
#
# SomeGem.configure do
#   config.api_key = 'key'
#   config.app_name = 'name'
# end
#
# SomeGem.config.api_key # => 'key'
# SomeGem.config.app_name # => 'name'
