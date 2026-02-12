module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      class << self
        def register_enum_type(mapping)
          mapping.register_type(%r(enum)i) do |sql_type|
            Type::Enum.new(limit: sql_type.to_s.scan(/'(.*?)'/).flatten)
          end
        end
      end

      # Rails 7.1+ uses a single TYPE_MAP constant on the adapter class
      AbstractMysqlAdapter.register_enum_type(
        ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP
      )
    end
  end
end
