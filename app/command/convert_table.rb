class ConvertTable
  def self.run
    connection = ActiveRecord::Base.connection

    tables = connection.tables

    tables.each_with_index do |table, idx|
      next if %w{some_view some_other_view}.include? table # views.
      # next if table != "references"
      
      puts "Processing #{table} (#{idx + 1} of #{tables.count})"
      column_conversion = []

      columns = connection.columns(table)


      columns.each do |column|
        if column.sql_type.downcase.include? 'text'
          column_conversion << "MODIFY `#{column.name}` #{column.sql_type} CHARACTER SET utf8 #{column.null ? '' : 'NOT NULL'}"
        end
      end

      puts "Converting #{table}..."
      column_conversion << "CONVERT TO CHARACTER SET UTF8"
      connection.execute "ALTER TABLE `#{table}` #{column_conversion.join(', ')}"
    end
  end
end