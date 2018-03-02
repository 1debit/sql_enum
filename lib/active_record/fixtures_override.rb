require 'active_record/fixtures'

module ActiveRecord
  class FixtureSet
    def table_rows
      now = config.default_timezone == :utc ? Time.now.utc : Time.now

      # allow a standard key to be used for doing defaults in YAML
      fixtures.delete('DEFAULTS')

      # track any join tables we need to insert later
      rows = Hash.new { |h,table| h[table] = [] }

      rows[table_name] = fixtures.map do |label, fixture|
        row = fixture.to_hash

        if model_class
          # fill in timestamp columns if they aren't specified and the model is set to record_timestamps
          if model_class.record_timestamps
            timestamp_column_names.each do |c_name|
              row[c_name] = now unless row.key?(c_name)
            end
          end

          # interpolate the fixture label
          row.each do |key, value|
            row[key] = value.gsub("$LABEL", label.to_s) if value.is_a?(String)
          end

          # generate a primary key if necessary
          if has_primary_key_column? && !row.include?(primary_key_name)
            row[primary_key_name] = ActiveRecord::FixtureSet.identify(label, primary_key_type)
          end

          # Resolve enums
          # model_class.defined_enums.each do |name, values|
          #   if row.include?(name)
          #     row[name] = values.fetch(row[name], row[name])
          #   end
          # end

          # If STI is used, find the correct subclass for association reflection
          reflection_class =
            if row.include?(inheritance_column_name)
              row[inheritance_column_name].constantize rescue model_class
            else
              model_class
            end

          reflection_class._reflections.each_value do |association|
            case association.macro
            when :belongs_to
              # Do not replace association name with association foreign key if they are named the same
              fk_name = (association.options[:foreign_key] || "#{association.name}_id").to_s

              if association.name.to_s != fk_name && value = row.delete(association.name.to_s)
                if association.polymorphic? && value.sub!(/\s*\(([^\)]*)\)\s*$/, "")
                  # support polymorphic belongs_to as "label (Type)"
                  row[association.foreign_type] = $1
                end

                fk_type = reflection_class.type_for_attribute(fk_name).type
                row[fk_name] = ActiveRecord::FixtureSet.identify(value, fk_type)
              end
            when :has_many
              if association.options[:through]
                add_join_records(rows, row, HasManyThroughProxy.new(association))
              end
            end
          end
        end

        row
      end
      rows
    end
  end
end

