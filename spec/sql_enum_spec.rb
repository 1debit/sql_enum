RSpec.describe SqlEnum do
  it "has a version number" do
    expect(SqlEnum::VERSION).not_to be_nil
  end

  describe '.sql_enum' do
    let(:statuses) { %w[pending started completed] }
    let(:priorities) { %w[low normal high] }

    before do
      SqlEnum.configure { |config| config.default_prefix = true }

      define_model('Task',
                   status: [:enum, limit: statuses, default: 'pending'],
                   priority: [:enum, limit: priorities]) do
        sql_enum :status
        sql_enum :priority, _prefix: false, _suffix: true

        sql_enum :status # duplicate should be no-op
      end
    end

    it 'exposes enum mapping' do
      expect(Task.statuses).to eq(statuses.index_by(&:itself))
      expect(Task.priorities).to eq(priorities.index_by(&:itself))
    end

    it 'exposes column limit value' do
      expect(Task.columns_hash['status'].limit).to eq(statuses)
      expect(Task.columns_hash['priority'].limit).to eq(priorities)
    end

    it 'provides enum functionality' do
      # default column values are set, nil enums are handled, global defaults are used
      expect(Task.new).to have_attributes(status: :pending, priority: nil) & be_status_pending

      # explicit _prefix/_suffix options are handled
      expect(Task.new(priority: :high)).to have_attributes(priority: :high) & be_high_priority
    end

    it 'returns symbols for attribute related methods' do
      task = Task.create
      expect(task).to have_attributes(status: :pending)

      task.update(status: :started)
      expect(task.status_before_last_save).to eq(:pending)

      expect(Task.find(task.id)).to have_attributes(status: :started)
      expect(Task.pluck(:status)).to eq([:started])
    end
  end
end
