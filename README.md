# 💰 Cash Money Bitches

A Rails-based terminal app for freelancers to manage financial data, categorize expenses, and prepare tax returns (EÜR & EST) for Elster.

**Current Goal:** Get 2024 tax data organized and ready for Elster submission.

---

## 🎯 Why This Exists

I'm a freelancer with a full-time job, which means filing both EÜR and EST. The Elster website is traumatic. 😱

**This app:**
1. Imports transactions from Finanzguru
2. Categorizes expenses into Elster buckets
3. Tracks receipts and Eigenbelege
4. Exports clean data for copy-pasting into Elster

**Future plans:** Invoice generation → Elster XML export → World domination

---

## ✨ Key Features

- Import financial transactions from Finanzguru (CSV)
- Tag-based categorization system
- Track transaction metadata:
  - `elster_bucket` - Tax category (e.g., "Arbeitsmittel", "Bürobedarf")
  - `is_business` - Business vs. personal
  - `receipt` - Have a receipt?
  - `eigenbeleg` - Created self-made receipt?
  - `reviewed` - Processed?
- Export summaries by Elster category
- Invoice generation (future)
- Elster XML integration (dream)

---

## 🗄️ Data Model

### MoneyTransaction
The core of everything - represents one financial transaction.

```ruby
external_id       # Unique ID from source (Finanzguru, bank, etc.)
date              # Transaction date
description       # What was this for?
amount_cents      # Amount in cents (using Money gem pattern)
currency          # EUR, USD, etc.
direction         # "in" or "out"
source_file       # Which import file did this come from?
raw_tags          # Original tags from import
elster_bucket     # Tax category (e.g., "Büromaterial", "Fortbildung")
is_business       # Boolean: business expense?
receipt           # Boolean: do I have a receipt?
eigenbeleg        # Boolean: did I create a self-made receipt?
reviewed          # Boolean: have I categorized this?
```

### Tag
Flexible categorization system - one transaction can have multiple tags.

```ruby
name              # Tag name (e.g., "Software", "Travel", "Client: ACME Corp")
```

### MoneyTransactionTag
Join table for many-to-many relationship between transactions and tags.

### Invoice
For tracking freelance invoices (future feature).

```ruby
invoice_number
issue_date
due_date
total_amount
client_id
company_id
# ... more fields for line items, tax calculations, etc.
```

---

## 🛠️ Getting Started

### Prerequisites
- Ruby 3.x
- PostgreSQL
- Rails 7.1

### Setup

```bash
# Clone the repo
git clone https://github.com/emmvs/cash_money_bitches.git
cd cash_money_bitches

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate

# Optional: Seed with sample data
rails db:seed
```

---

## 📖 Usage

```bash
# Import Finanzguru CSV
rake import:finanzguru[path/to/export.csv]

# Review & categorize
rake review:transactions

# Export for Elster
rake export:elster_summary

# Reports
rake reports:expenses_by_category[2024]
rake reports:missing_receipts
```

---

## 🔒 Security & Privacy

**⚠️ This repo is PUBLIC - sensitive data is strictly gitignored!**

### What's Protected:
- ✅ All CSV/Excel files (`*.csv`, `*.xlsx`, `*.numbers`)
- ✅ Database dumps and backups
- ✅ All files in `db/data/` (real transaction data)
- ✅ Environment files and secrets
- ✅ Elster XML exports
- ✅ PDF invoices and reports

### What You Can Safely Commit:
- ✅ Code, migrations, models
- ✅ Empty schema examples in `db/data/schema_samples/`
- ✅ Tests (no real data!)
- ✅ Documentation

### Best Practices:
- Never commit real financial data
- Check `git status` before committing
- Use `git diff` to review changes
- When in doubt, don't commit it!

---

## 🧰 Tech Stack

Rails 7.1 • PostgreSQL • Terminal UI (for now)

---

## 📝 Common Elster Categories

- `Arbeitsmittel` - Work equipment
- `Bürobedarf` - Office supplies  
- `Fortbildung` - Professional development
- `Reisekosten` - Travel expenses
- `Bewirtungskosten` - Business meals
- `Telekommunikation` - Phone/Internet
- `Miete` - Rent (home office)
- `Versicherungen` - Insurance
- `Fachliteratur` - Books/subscriptions

---

*"Because adulting is hard and taxes are harder."* 💸
