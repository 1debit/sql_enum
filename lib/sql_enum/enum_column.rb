# frozen_string_literal: true

module SqlEnum
  EnumColumn = Struct.new(:table_name, :column_name) do
    def values
      schema_values.to_s.scan(/\w+/).reject { |v| v == 'enum' }
    end

    private

    def schema_values
      ActiveRecord::Base.connection.exec_query(schema_values_query).rows.dig(0, 0)
    end

    def database_name
      if ActiveRecord::Base.respond_to?(:connection_db_config)
        ActiveRecord::Base.connection_db_config.configuration_hash[:database]
      else
        ActiveRecord::Base.connection_config.values_at(:database, :database_name).find(&:present?)
      end
    end

    def schema_values_query
      <<~EOSQL
      SELECT column_type
      FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = '#{database_name}'
      AND TABLE_NAME = '#{table_name}'
      AND COLUMN_NAME = '#{column_name}'
      EOSQL
    end
  end
end
