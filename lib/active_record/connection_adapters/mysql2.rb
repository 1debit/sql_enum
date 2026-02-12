require 'active_record/connection_adapters/mysql2_adapter'

module ActiveRecord
  module ConnectionAdapters
    class Mysql2Adapter
      def native_database_types
        self.class::NATIVE_DATABASE_TYPES.merge(enum: {name: "enum"})
      end

      module SqlEnumTypeToSql
        def type_to_sql(type, limit: nil, **)
          if type.to_sym == :enum
            "#{type}(#{limit.map { |n| "'#{n}'" }.join(",")})"
          else
            super
          end
        end
      end

      prepend SqlEnumTypeToSql
    end
  end
end
