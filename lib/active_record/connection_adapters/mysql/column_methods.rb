require 'active_record/connection_adapters/mysql/schema_definitions'

module ActiveRecord
  module ConnectionAdapters
    module MySQL
      module ColumnMethods
        def enum(*args, **options)
          args.each { |name| column(name, :enum, **options) }
        end
      end
    end
  end
end

