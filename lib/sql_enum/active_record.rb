ActiveSupport.on_load(:active_record) do
  extend SqlEnum::ClassMethods
end
