#!/usr/bin/env ruby
require 'roo'
require 'date'
require 'zip' # Suppress ZIP warnings
Zip.warn_invalid_date = false

# Load the .xlsx file
xlsx = Roo::Excelx.new('20250623-Export-Alle_Buchungen.xlsx')

# Read header row and remaining data
header = xlsx.row(1)
rows = (2..xlsx.last_row).map do |i|
  Hash[header.zip(xlsx.row(i))]
end

# Group by year + type + tag
yearly_totals = Hash.new { |h, k| h[k] = Hash.new(0) }

# ➕ Additional groups
monthly_by_tag = Hash.new { |h, k| h[k] = Hash.new(0) }
tax_relevant_totals = Hash.new(0)

rows.each do |row|
  date = row["Buchungstag"]
  next unless date

  parsed_date = begin
    Date.parse(date.to_s)
  rescue StandardError
    nil
  end
  next unless parsed_date && [2024, 2025].include?(parsed_date.year)

  amount = row["Betrag"].to_f
  type = row["Analyse-Betrag"] || "Unbekannt"
  tag  = row["Tags"] || "Untagged"

  key = "#{type} - #{tag}"
  year = parsed_date.year
  year_month = parsed_date.strftime("%Y-%m")

  yearly_totals[year][key] += amount

  # ➕ Personal spending summary
  if type == "Ausgaben" && %w[Späß Investieren Necessities].include?(tag)
    monthly_by_tag[year_month][tag] += amount
  end

  # ➕ Tax-relevant tracking
  if %w[ESt EÜR Freelance Necessities].any? { |k| tag&.include?(k) }
    tax_relevant_totals[year] += amount
  end
end

# ✅ Original yearly breakdown
puts "\n💸 Finanzguru Summary by Category and Year:\n\n"
yearly_totals.sort.each do |year, totals|
  puts "📆 Year: #{year}"
  totals.sort.each do |category, total|
    printf "   %-40s %10.2f €\n", category, total
  end
  puts "\n"
end

# ➕ Monthly tag breakdown
puts "\n🧾 Monthly Spending Breakdown (Späß / Investieren / Necessities)\n\n"
monthly_by_tag.sort.each do |ym, tags|
  puts "📅 #{ym}"
  tags.sort.each do |tag, sum|
    printf "   %-15s %10.2f €\n", tag, sum
  end
  puts ""
end

# ➕ Tax-relevant totals
puts "\n📊 Tax-Relevant Totals (ESt / EÜR / Freelance / Necessities):\n\n"
tax_relevant_totals.sort.each do |year, total|
  printf "   %-10s %10.2f €\n", year, total
end
