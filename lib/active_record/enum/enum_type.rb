module ActiveRecord
  module Enum
    class EnumType < Type::Value # :nodoc:
      delegate :type, to: :subtype

      def initialize(name, mapping, subtype)
        @name = name
        @mapping = mapping
        @subtype = subtype
      end

      def cast(value)
        return if value.blank?

        if valid?(value)
          value.to_sym
        else
          assert_valid_value(value)
        end
      end

      def deserialize(value)
        value&.to_sym
      end

      def serialize(value)
        value.to_s
      end

      def valid?(value)
        mapping.include?(value.to_s)
      end

      def assert_valid_value(value)
        unless value.blank? || valid?(value)
          raise ArgumentError, "'#{value}' is not a valid #{name}"
        end
      end
    end
  end
end
