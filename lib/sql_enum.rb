require 'active_record'

require_relative 'active_record/enum/enum_type'
require_relative 'active_record/type/enum'
require_relative 'active_record/enum_override'
require_relative 'active_record/connection_adapters/mysql2'
require_relative 'active_record/connection_adapters/abstract_mysql'
require_relative 'active_record/connection_adapters/mysql/column_methods'
require_relative "sql_enum/version"

module SqlEnum
end
