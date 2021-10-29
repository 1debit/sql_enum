module SqlEnum
  # EnumType that always returns a symbol
  class EnumType < ActiveRecord::Enum::EnumType
    def cast(arg)
      super&.to_sym
    end

    def deserialize(arg)
      super&.to_sym
    end
  end
end
