require 'sqlite3'

module DB
  module Connection
    extend self

    def open
      @conn ||= SQLite3::Database.open("test.db")
    end

    def close
      @conn.close
      @conn = nil
    end
  end
end
