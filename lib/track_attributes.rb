# frozen_string_literal: true

module TrackAttributes
  def attr_readers
    self.class.instance_variable_get('@attr_readers')
  end

  def attr_writers
    self.class.instance_variable_get('@attr_writers')
  end

  def attr_accessors
    self.class.instance_variable_get('@attr_accessors')
  end

  def self.included(klass)
    klass.send :define_singleton_method, :attr_reader, lambda { |*params|
      @attr_readers ||= []
      @attr_readers.concat params
      super(*params)
    }

    klass.send :define_singleton_method, :attr_writer, lambda { |*params|
      @attr_writers ||= []
      @attr_writers.concat params
      super(*params)
    }

    klass.send :define_singleton_method, :attr_accessor, lambda { |*params|
      @attr_accessors ||= []
      @attr_accessors.concat params
      super(*params)
    }
  end
end
