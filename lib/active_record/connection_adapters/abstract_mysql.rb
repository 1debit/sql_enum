module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      class << self
        def register_enum_type(mapping)
          mapping.register_type(%r(enum)i) do |sql_type|
            Type::Enum.new(limit: sql_type.scan(/'(.*?)'/).flatten)
          end
        end
      end

      # In Rails 6.1, registering the enum type is an instance method and is
      # done on initialization, In Rails 7.0 it is a class method and
      # the registration happens when the class is loaded. So, in Rails 6.1,
      # we can override the `initialize_type_map` method to register the enum
      # but in Rails 7.1, we need to call register_enum_type explicitly.

      if SqlEnum.rails_version_match?("6.1")
        module SqlEnumMapper
          def initialize_type_map(m = type_map)
            super(m)
            AbstractMysqlAdapter.register_enum_type(m)
          end
        end

        ActiveRecord::ConnectionAdapters::Mysql2Adapter.prepend(SqlEnumMapper)
      end


      if SqlEnum.rails_version_match?("7.0")
        [
          ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP,
          ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP_WITH_BOOLEAN
        ].each do |m|
          AbstractMysqlAdapter.register_enum_type(m)
        end
      end

      # Rails 7.1 drops the TYPE_MAP_WITH_BOOLEAN constant
      if SqlEnum.rails_version_match?("7.1")
          AbstractMysqlAdapter.register_enum_type(
            ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP
          )
      end
    end
  end
end
