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

- Import financial transactions from Finanzguru (TSV format)
- Tag-based categorization system with custom tags
- Review untagged transactions to catch deductible expenses
- Track receipts and Eigenbelege
- Export summaries for EÜR and EST
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

Rails 8.0 • Ruby 3.3 • PostgreSQL • Terminal UI (for now)

---

## 🏷️ Tag System

Your Finanzguru tags are already set up! Here's how they work together:

### Budget Categories (Pick ONE - for 50/30/20 tracking)
- **`Necessities`** - Essential expenses (~€1,500/month target)
- **`Späß`** - Fun money (~€1,000/month target)
- **`Sparen`** - Savings (~€500/month target)
- **`Invest`** - Investments (~€500/month target)
- **`Privat`** - Private expenses (not for budget tracking)

### Tax Status (Add to mark deductibility)
- **`EÜR`** - Deductible for freelance (always itemize)
- **`EST`** - Deductible for employee work (app calculates if > €1,230 Pauschale)
- **`Privat`** - Explicitly NOT deductible
- **`Reimbursed`** - Employer paid you back (NOT deductible)
- **`Spende`** - Donation (deductible as Sonderausgaben)

### Receipt Tracking (Add if applicable)
- **`Receipt`** - Have a physical/digital receipt
- **`Eigenbeleg`** - Self-created receipt (for when you couldn't get one)

### Work Type (For categorization & analysis)
- **`Geschäftlich`** - Full-time job work expense
- **`Freelance`** - Freelance work expense
- **`Travel (Geschäftlich)`** - Work travel for full-time job
- **`Travel (Freelance)`** - Work travel for freelance
- **`Travel (Späß)`** - Personal travel

### Income Tracking
- **`Gehalt`** - Salary from full-time job
- **`Honorar`** - Freelance payment received
- **`Einkünfte aus Kapitalvermögen`** - Investment income (taxes auto-deducted)

### Tagging Examples:
- Laptop for freelancing: `Necessities`, `Freelance`, `EÜR`, `Receipt`
- Coffee with client: `Necessities`, `Freelance`, `EÜR`, `Receipt`
- Deutsche Bahn to office (reimbursed): `Necessities`, `Geschäftlich`, `Travel (Geschäftlich)`, `Reimbursed`, `Receipt`
- Work book: `Necessities`, `Geschäftlich`, `EST`, `Receipt`
- Netflix: `Späß`, `Privat`
- Vacation flight: `Späß`, `Travel (Späß)`, `Privat`
- Emergency fund: `Sparen`
- Freelance income: `Honorar`, `EÜR`

### Deductible Logic (Auto-calculated by app):
- ✅ **Deductible = true**: Has `EÜR` OR `EST` OR `Spende`
- ❌ **Deductible = false**: Has `Privat` OR `Reimbursed`
- ⚠️ **Needs Review = nil**: 
  - No tags at all
  - Has `Geschäftlich` or `Eigenbeleg` but missing `EÜR`/`EST`
  - Has budget category but no tax status

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
