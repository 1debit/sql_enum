module ActiveRecord
  module Type
    class Enum < Type::Value
      def type
        :enum
      end
    end
  end
end
