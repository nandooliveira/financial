require 'sqlite3'

module Models
  class Payment
    def initialize
      @db = SQLite3::Database.open("test.db")
    end

  end
end
