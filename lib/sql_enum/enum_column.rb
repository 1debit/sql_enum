# frozen_string_literal: true

module SqlEnum
  EnumColumn = Struct.new(:table_name, :column_name) do
    def values
      schema_values.to_s.scan(/\w+/).reject { |v| v == 'enum' }
    end

    private

    def schema_values
      if ActiveRecord::Base.respond_to?(:with_connection)
        ActiveRecord::Base.with_connection { |conn| conn.exec_query(schema_values_query).rows.dig(0, 0) }
      else
        ActiveRecord::Base.connection.exec_query(schema_values_query).rows.dig(0, 0)
      end
    end

    def database_name
      ActiveRecord::Base.connection_db_config.configuration_hash[:database]
    end

    def schema_values_query
      <<~SQL
        SELECT column_type
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = '#{database_name}'
        AND TABLE_NAME = '#{table_name}'
        AND COLUMN_NAME = '#{column_name}'
      SQL
    end
  end
end
