require "active_record"

# Taken from factory_bot
# https://github.com/thoughtbot/factory_bot/blob/main/spec/support/macros/define_constant.rb

module DefineConstantMacros
  def define_class(path, base = Object, &block)
    stub_const(path, Class.new(base)).tap do |const|
      const.class_eval(&block) if block
    end
  end

  def define_model(name, columns = {}, &block)
    create_table(name.tableize) do |table|
      columns.each do |column_name, value|
        safe_values = Array(value)
        type = safe_values[0]
        options = safe_values[1] || {}
        table.column(column_name, type, **options)
      end
    end

    define_class(name, ActiveRecord::Base, &block)
  end

  def create_table(table_name, &block)
    connection = ActiveRecord::Base.connection

    begin
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      connection.create_table(table_name, &block)
      created_tables << table_name
      connection
    rescue Exception => e # rubocop:disable Lint/RescueException
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      raise e
    end
  end

  def clear_generated_tables
    created_tables.each do |table_name|
      clear_generated_table(table_name)
    end
    created_tables.clear
  end

  def clear_generated_table(table_name)
    ActiveRecord::Base
      .connection
      .execute("DROP TABLE IF EXISTS #{table_name}")
  end

  private

  def created_tables
    @created_tables ||= []
  end
end
