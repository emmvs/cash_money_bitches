#!/usr/bin/env ruby


# TODO
# 1. Extract your 2024 entries
# 2. Split into two universes (Est & EUR)
# 3. Map your tags to Elster categories
# 4. Generate totals

# ```ruby
# - You are my tax person, make sure I dont have to pay any fees
# - I want to use the script and make sure that there are no expenses that I have missed and could have deducted
# - so Ideally I want to use the script to create real instances in my database and check each instance that does not have any tags
# - Ask me questions if you need to clarify anything
# ```

# ### Tags

# All my finances are separated into these main tags:

# - `Geschäftlich` → Always Deductible
# - `Necessities` → May be Privat or Deductible
# - `Späß` → Always Privat
# - `Privat` → Always Privat

# Then I have:

# - `Sparen` → Always Privat
# - `Spende` → Always Deductible
# - `Invest`→ Always Privat
# - `Privat`

# If I have a receipt I will tag the expense with

# - `Receipt` → May be Privat or Deductible (but usually Deductible)
# - `Eigenbeleg`  (If I need to add a receipt myself as it was not possible for me to get one) → → Always Deductible (I would not do this is it wasny)

# For my full time job

# - `1K5°`  → May be deductable I guess but I think this tag is more for when they deduct something for me and I get the money back)
# - `Geschäftlich` → Always Deductible
# - `Travel (Geschäftlich)` → Always Deductible
# - `Gehalt` → I deed to track for Est
# - `Est` → Is important for Est (duh)

# For my freelance work

# - `Freelance` → Is important for EUR / Always Deductible
# - `Travel (Freelance)` → Is important for EUR / Always Deductible
# - `Honorar` → I deed to track for EUR
# - `EÜR` → same

# More

# - `Einkünfte aus Kapitalvermögen` → which basically means my App already makes sure taxes are deducted
# - `Travel (Späß)` → Privat

# ### **Taxes (The Guilt Monster)**

# - [ ]  Open Elster/Finanzguru tab without instantly alt-tabbing
# - [ ]  Sort income: freelance gigs + full-time job
# - [ ]  Add expenses you actually remember (travel, home office, Bahn, client lunches)
# - [ ]  Check Finanzguru tags for missing receipts
# - [ ]  Draft return and save it. Don’t you dare “close without saving.”
# - **Reward:** Monster shrinks, you can sleep at night, no Finanzamt anxiety dreams


require 'roo'
require 'date'
require 'zip' # Suppress ZIP warnings
Zip.warn_invalid_date = false

# Load the .xlsx file
xlsx = Roo::Excelx.new('20250623-Export-Alle_Buchungen.xlsx')

# Read header row and remaining data
header = xlsx.row(1)
rows = (2..xlsx.last_row).map do |i|
  header.zip(xlsx.row(i)).to_h
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
  monthly_by_tag[year_month][tag] += amount if type == "Ausgaben" && %w[Späß Investieren Necessities].include?(tag)

  # ➕ Tax-relevant tracking
  tax_relevant_totals[year] += amount if %w[ESt EÜR Freelance Necessities].any? { |k| tag&.include?(k) }
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
