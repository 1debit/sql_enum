module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      def initialize_type_map_with_enum(m = type_map)
        initialize_without_enum(m)
        register_enum_type(m)
      end

      alias_method :initialize_without_enum, :initialize_type_map
      alias_method :initialize_type_map, :initialize_type_map_with_enum

      def register_enum_type(mapping)
        mapping.register_type(%r(enum)i) do |sql_type|
          Type::Enum.new(limit: sql_type.scan(/'(.*?)'/).flatten)
        end
      end
    end
  end
end
