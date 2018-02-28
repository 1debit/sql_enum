require 'active_record'

module SqlEnum
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :default_prefix, :default_suffix

    def initialize
      @default_prefix = false
      @default_suffix = false
    end
  end
end

require_relative 'active_record/enum/enum_type'
require_relative 'active_record/type/enum'
require_relative 'active_record/enum_override'
require_relative 'active_record/connection_adapters/mysql2'
require_relative 'active_record/connection_adapters/abstract_mysql'
require_relative 'active_record/connection_adapters/mysql/column_methods'
require_relative 'array'
require_relative "sql_enum/version"
