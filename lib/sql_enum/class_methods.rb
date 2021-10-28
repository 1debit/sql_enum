module SqlEnum
  module ClassMethods
    def sql_enum(column_name, options = {})
      # Query values
      enum_column = EnumColumn.new(table_name, column_name)
      values = enum_column.values.to_h { |value| [value.to_sym, value.to_s] }

      # Check option defaults
      prefix = options.fetch(:_prefix, !!SqlEnum.configuration&.default_prefix)
      suffix = options.fetch(:_suffix, !!SqlEnum.configuration&.default_suffix)

      # Define enum using Rails enum
      enum(column_name => values, _prefix: prefix, _suffix: suffix)

      # Override reader to return symbols
      concerning "SqlEnum#{column_name.to_s.camelize}" do
        define_method(column_name) { super()&.to_sym }
      end
    end
  end
end
