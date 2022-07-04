# frozen_string_literal: true

require_relative '../db/connection'
require_relative '../track_attributes'

module Models
  class BaseModel
    include ::TrackAttributes

    class << self
      def open_connection
        ::DB::Connection.open
      end

      def mount_from_result(result)
        raise ::NotImplementedError
      end

      def table_name(table_name)
        @table_name = table_name
      end

      def close_connection
        ::DB::Connection.close
      end

      def get(id:)
        results = open_connection.query "SELECT * FROM #{@table_name} WHERE id = ?", id

        mount_from_result(results.next)
      rescue SQLite3::Exception => e
        puts 'Exception occurred'
        puts e
      ensure
        results&.close
        ::DB::Connection.close
      end

      def find_by(**params)
        where = params.map { |key, value| " #{key} = '#{value}' " }.join(' AND ')
        results = open_connection.query "SELECT * FROM #{@table_name} where #{where} order by id desc"

        results.map { |row| mount_from_result(row) }
      rescue SQLite3::Exception => e
        puts 'Exception occurred'
        puts e
      ensure
        results&.close
        close_connection
      end

      def list
        results = open_connection.query "SELECT * FROM #{@table_name} order by id desc"

        results.map { |row| mount_from_result(row) }
      rescue SQLite3::Exception => e
        puts 'Exception occurred'
        puts e
      ensure
        results&.close
        close_connection
      end

      def create(**params)
        conn = open_connection
        conn.execute("INSERT INTO #{@table_name} (#{params.keys.join(', ')}) VALUES (?, ?, ?)", params.values)

        get(id: conn.last_insert_row_id)
      rescue SQLite3::Exception => e
        puts 'Exception occurred'
        puts e
      ensure
        close_connection
      end

      def update(instance, **params)
        conn = open_connection
        update_fields = params.map { |k, v| " #{k} = '#{v}' " }.join(', ')
        conn.execute("UPDATE #{@table_name} SET #{update_fields} WHERE id = #{instance.id}")

        instance = get(id: instance.id)
      rescue SQLite3::Exception => e
        puts 'Exception occurred'
        puts e
      ensure
        close_connection
      end

      def save(instance)
        conn = open_connection
        input = instance.attr_accessors.except(:id).each { |field| params[field] = instance.send(field) }

        id.nil? ? create(input) : update(input)
      end
    end
  end
end
