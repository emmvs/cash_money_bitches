namespace :import do
  desc "Import Finanzguru TSV export"
  task :finanzguru, [:file_path] => :environment do |t, args|
    require 'csv'
    
    file_path = args[:file_path]
    
    unless file_path && File.exist?(file_path)
      puts "❌ Usage: rake import:finanzguru[path/to/export.tsv]"
      puts "❌ File not found: #{file_path}"
      exit 1
    end
    
    puts "📂 Importing from: #{file_path}"
    puts ""
    
    imported_count = 0
    updated_count = 0
    skipped_count = 0
    errors = []
    
    # Read file and skip comment lines
    lines = File.readlines(file_path, encoding: 'UTF-8').reject { |line| line.strip.start_with?('#') || line.strip.empty? }
    
    CSV.parse(lines.join, headers: true, col_sep: "\t") do |row|
      next if row['Buchungstag'].nil? || row['Buchungstag'].strip.empty?
      
      begin
        # Parse date (German format: DD.MM.YYYY)
        date = Date.strptime(row['Buchungstag'], '%d.%m.%Y')
        
        # Parse amount (German format: -1.234,56)
        amount_str = row['Betrag'].to_s.gsub('.', '').gsub(',', '.')
        amount_cents = (amount_str.to_f * 100).to_i
        
        # Determine direction
        direction = amount_cents >= 0 ? 'income' : 'expense'
        
        # Create unique external ID from date + description + amount
        external_id = "fg_#{date.strftime('%Y%m%d')}_#{row['Verwendungszweck']}_#{amount_cents}".parameterize
        
        # Find or create transaction
        transaction = MoneyTransaction.find_or_initialize_by(external_id: external_id)
        
        is_new = transaction.new_record?
        
        transaction.assign_attributes(
          date: date,
          description: row['Verwendungszweck'],
          amount_cents: amount_cents.abs,
          currency: row['Waehrung'] || 'EUR',
          direction: direction,
          source_file: File.basename(file_path),
          raw_tags: row['Tags']
        )
        
        if transaction.save
          # Parse and create tags
          if row['Tags'].present?
            tag_names = row['Tags'].split(';').map(&:strip).reject(&:blank?)
            tag_names.each do |tag_name|
              tag = Tag.find_or_create_by(name: tag_name)
              transaction.tags << tag unless transaction.tags.include?(tag)
            end
          end
          
          # Calculate deductible status
          transaction.calculate_deductible!
          
          if is_new
            imported_count += 1
            print "✅"
          else
            updated_count += 1
            print "🔄"
          end
        else
          skipped_count += 1
          errors << "#{date}: #{transaction.errors.full_messages.join(', ')}"
          print "❌"
        end
        
      rescue => e
        skipped_count += 1
        errors << "Row error: #{e.message}"
        print "❌"
      end
    end
    
    puts "\n"
    puts "=" * 60
    puts "📊 Import Summary"
    puts "=" * 60
    puts "✅ New transactions: #{imported_count}"
    puts "🔄 Updated transactions: #{updated_count}"
    puts "❌ Skipped/Errors: #{skipped_count}"
    puts ""
    
    if errors.any?
      puts "⚠️  Errors:"
      errors.first(10).each { |err| puts "   - #{err}" }
      puts "   ... and #{errors.size - 10} more" if errors.size > 10
      puts ""
    end
    
    # Review status
    needs_review = MoneyTransaction.needs_review.count
    deductible = MoneyTransaction.deductible_expenses.count
    non_deductible = MoneyTransaction.non_deductible.count
    
    puts "🔍 Review Status:"
    puts "   ⚠️  Needs review: #{needs_review}"
    puts "   ✅ Deductible: #{deductible}"
    puts "   ❌ Not deductible: #{non_deductible}"
    puts ""
    puts "💡 Next step: rails s and visit /transactions to review"
    puts "=" * 60
  end
end