module SqlEnum
  module ClassMethods
    def sql_enum(column_name, options = {})
      # skip redefinitions
      return if defined_enums.key?(column_name.to_s)

      # Query values
      enum_column = EnumColumn.new(table_name, column_name)
      values_map = enum_column.values.to_h { |value| [value.to_sym, value.to_s] }

      # Check option defaults
      prefix = options.fetch(:_prefix, !!SqlEnum.configuration&.default_prefix)
      suffix = options.fetch(:_suffix, !!SqlEnum.configuration&.default_suffix)

      # Define enum using Rails enum
      enum(column_name, values_map, prefix: prefix, suffix: suffix)

      # Override reader to return symbols
      col_name = column_name.to_s
      decorate_attributes([col_name]) do |_name, subtype|
        subtype = subtype.subtype if ActiveRecord::Enum::EnumType === subtype
        EnumType.new(col_name, send(col_name.pluralize), subtype)
      end

      prefix_str = format_affix(column_name, prefix, suffix: '_')
      suffix_str = format_affix(column_name, suffix, prefix: '_')

      # Fix query methods to compare symbols to symbols
      values_map.each_value do |value|
        method_name = "#{prefix_str}#{value}#{suffix_str}?"
        define_method(method_name) { self[column_name] == value.to_sym }
      end
    end

    private

    def format_affix(column_name, affix, prefix: '', suffix: '')
      if affix == true
        "#{prefix}#{column_name}#{suffix}"
      elsif affix
        "#{prefix}#{affix}#{suffix}"
      end
    end
  end
end
