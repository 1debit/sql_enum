module SqlEnum
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

require 'active_record'
require 'active_support/core_ext/module/concerning'

require_relative 'active_record/type/enum'
require_relative 'active_record/connection_adapters/mysql2'
require_relative 'active_record/connection_adapters/abstract_mysql'
require_relative 'active_record/connection_adapters/mysql/column_methods'

require_relative 'sql_enum/version'
require_relative 'sql_enum/configuration'
require_relative 'sql_enum/enum_column'
require_relative 'sql_enum/enum_type'
require_relative 'sql_enum/class_methods'
require_relative 'sql_enum/active_record'
