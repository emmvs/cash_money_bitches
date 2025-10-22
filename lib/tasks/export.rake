# lib/tasks/export.rake
require "csv"

namespace :export do
  desc "Export yearly CSV snapshots (money_transactions, tags, join table)"
  task :year, [:year] => :environment do |_t, args|
    year = Integer(args[:year] || Time.now.year)
    export_dir = Rails.root.join("tmp/exports", year.to_s)
    FileUtils.mkdir_p(export_dir)

    puts "📦 Exporting year #{year} to #{export_dir}"

    # --- MoneyTransactions ---
    scope = MoneyTransaction.where(date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
    file = export_dir.join("money_transactions.csv")

    CSV.open(file, "w", col_sep: ";") do |csv|
      csv << %w[
        id external_id date description amount_cents currency direction
        source_file raw_tags elster_bucket is_business receipt eigenbeleg
        reviewed created_at updated_at
      ]
      scope.find_each do |t|
        csv << [
          t.id, t.external_id, t.date, t.description, t.amount_cents,
          t.currency, t.direction, t.source_file, t.raw_tags, t.elster_bucket,
          t.is_business, t.receipt, t.eigenbeleg, t.reviewed,
          t.created_at, t.updated_at
        ]
      end
    end
    puts "✅ money_transactions.csv (#{scope.count} rows)"

    # --- Tags ---
    tag_file = export_dir.join("tags.csv")
    CSV.open(tag_file, "w", col_sep: ";") do |csv|
      csv << %w[id name created_at updated_at]
      Tag.find_each do |tag|
        csv << [tag.id, tag.name, tag.created_at, tag.updated_at]
      end
    end
    puts "✅ tags.csv (#{Tag.count} rows)"

    # --- Join table ---
    join_file = export_dir.join("money_transaction_tags.csv")
    CSV.open(join_file, "w", col_sep: ";") do |csv|
      csv << %w[id money_transaction_id tag_id created_at updated_at]
      MoneyTransactionTag.find_each do |j|
        csv << [j.id, j.money_transaction_id, j.tag_id, j.created_at, j.updated_at]
      end
    end
    puts "✅ money_transaction_tags.csv (#{MoneyTransactionTag.count} rows)"

    puts "\n🎉 Export finished for year #{year}."
    puts "Files written to: #{export_dir}\n"
  rescue StandardError => e
    warn "💥 Export failed: #{e.class} - #{e.message}"
    warn e.backtrace.first(5).join("\n")
    exit(1)
  end
end
