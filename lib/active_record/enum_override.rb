require 'active_record/enum'

module ActiveRecord
  module Enum
    def sql_enum(name, options={})
      enum_prefix = options.delete(:_prefix)
      enum_suffix = options.delete(:_suffix)
      klass       = self
      enum_values = Array.new
      name        = name.to_sym

      detect_enum_conflict!(name, name.to_s.pluralize, true)
      klass.singleton_class.send(:define_method, name.to_s.pluralize) { enum_values }

      detect_enum_conflict!(name, name)
      detect_enum_conflict!(name, "#{name}=")

      attr = attribute_alias?(name) ? attribute_alias(name) : name
      decorate_attribute_type(attr, :enum) do |subtype|
        EnumType.new(attr, enum_values, subtype)
      end

      enum_values = values(name)
      enum_values.each do |value|
        if enum_prefix == true
          prefix = "#{name}_"
        elsif enum_prefix
          prefix = "#{enum_prefix}_"
        end
        if enum_suffix == true
          suffix = "_#{name}"
        elsif enum_suffix
          suffix = "_#{enum_suffix}"
        end

        value_method_name = "#{prefix}#{value}#{suffix}"

        # def active?() status == 0 end
        klass.send(:detect_enum_conflict!, name, "#{value_method_name}?")
        define_method("#{value_method_name}?") { self[attr] == value.to_s }

        # def active!() update! status: :active end
        klass.send(:detect_enum_conflict!, name, "#{value_method_name}!")
        define_method("#{value_method_name}!") { update!(attr => value) }

        # scope :active, -> { where status: 0 }
        klass.send(:detect_enum_conflict!, name, value_method_name, true)
        klass.scope value_method_name, -> { where(attr => value) }
      end
      defined_enums[name.to_s] = enum_values
    end

    def values(name)
      schema_values(name).scan(/\w+/).reject{|v| v == 'enum'}
    end

    def schema_values(name)
      ActiveRecord::Base.connection.exec_query(schema_values_query(name)).rows[0][0]
    end

    def schema_values_query(name)
      %{
        SELECT column_type
        FROM information_schema.COLUMNS
        WHERE TABLE_NAME = '#{self.table_name}'
        AND COLUMN_NAME = '#{name}'
      }
    end
  end
end
