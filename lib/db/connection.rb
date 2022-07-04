# frozen_string_literal: true

require 'sqlite3'

module DB
  module Connection
    module_function

    def open
      @conn ||= SQLite3::Database.open('test.db')
    end

    def close
      return if @conn.nil?

      @conn.close
      @conn = nil
    end
  end
end
