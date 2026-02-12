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

      # Rails 7.1 drops the TYPE_MAP_WITH_BOOLEAN constant
      if SqlEnum.rails_version_match?("7.1")
          AbstractMysqlAdapter.register_enum_type(
            ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP
          )
      end

      if SqlEnum.rails_version_match?("7.2")
        AbstractMysqlAdapter.register_enum_type(
          ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP
        )
      end

      if SqlEnum.rails_version_match?("8.0")
        AbstractMysqlAdapter.register_enum_type(
          ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP
        )
      end

      if SqlEnum.rails_version_match?(".1")
        AbstractMysqlAdapter.register_enum_type(
          ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP
        )
      end
    end
  end
end
