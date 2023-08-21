require 'spec_helper'

class FakeAdapter
  def self.define_column_methods(*args)
    # no-op
  end

  include ActiveRecord::ConnectionAdapters::MySQL::ColumnMethods
end

module ActiveRecord
  module ConnectionAdapters
    module MySQL
      RSpec.describe ColumnMethods do
        it "correctly calls based on enum" do
          instance = FakeAdapter.new
          expect(instance).to receive(:column).with(:status, :enum, limit: [:active, :archived])
          instance.enum(:status, limit: [:active, :archived])
        end
      end
    end
  end
end