require 'active_record/connection_adapters/mysql2_adapter'

module ActiveRecord
  module ConnectionAdapters
    class Mysql2Adapter
      def native_database_types
        self.class::NATIVE_DATABASE_TYPES.merge(enum: {name: "enum"})
      end

      def type_to_sql_with_enum(type, limit: nil, precision: nil, scale: nil, unsigned: nil, **)
        if type.to_sym == :enum
          "#{type}(#{limit.map{|n| "'#{n}'"}.join(",")})"
        else
          type_to_sql_without_enum(type, limit: limit, precision: precision, scale: scale, unsigned: unsigned)
        end
      end

      alias_method :type_to_sql_without_enum, :type_to_sql
      alias_method :type_to_sql, :type_to_sql_with_enum
    end
  end
end
