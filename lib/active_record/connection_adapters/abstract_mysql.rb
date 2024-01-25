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

      [
        ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP,
        ActiveRecord::ConnectionAdapters::Mysql2Adapter::TYPE_MAP_WITH_BOOLEAN
      ].each do |m|
        AbstractMysqlAdapter.register_enum_type(m)
      end
    end
  end
end
