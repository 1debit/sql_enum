module SqlEnum
  class Configuration
    attr_accessor :default_prefix, :default_suffix

    def initialize
      @default_prefix = false
      @default_suffix = false
    end
  end
end
