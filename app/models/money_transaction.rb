class MoneyTransaction < ApplicationRecord
  has_many :money_transaction_tags, dependent: :destroy
  has_many :tags, through: :money_transaction_tags

  # enum :direction, { income: "income", expense: "expense" }, _suffix: true

  scope :in_year, ->(y) { where(date: Date.new(y,1,1)..Date.new(y,12,31)) }
  scope :business, -> { where(is_business: true) }
  scope :needs_review, -> { where(deductible: nil) }
  scope :deductible_expenses, -> { where(deductible: true) }
  scope :non_deductible, -> { where(deductible: false) }

  # Calculate and update deductible status based on tags
  def calculate_deductible!
    tag_names = tags.pluck(:name).map(&:downcase)
    
    # Deductible = true if has EÜR, EST, or Spende
    if (tag_names & ['eür', 'est', 'spende']).any?
      update(deductible: true)
    # Not deductible if has Privat or Reimbursed (or legacy 1k5)
    elsif (tag_names & ['privat', 'reimbursed', '1k5']).any?
      update(deductible: false, reimbursed: tag_names.include?('reimbursed') || tag_names.include?('1k5'))
    # Needs review if has incomplete tagging
    elsif needs_review?
      update(deductible: nil)
    # Default to nil if no relevant tags
    else
      update(deductible: nil)
    end
  end

  # Check if transaction needs review
  def needs_review?
    tag_names = tags.pluck(:name).map(&:downcase)
    
    # No tags at all
    return true if tag_names.empty?
    
    # Has Geschäftlich or Eigenbeleg but missing EÜR/EST
    if (tag_names & ['geschäftlich', 'eigenbeleg']).any?
      return true unless (tag_names & ['eür', 'est']).any?
    end
    
    # Has work/receipt indicators but no tax status
    if (tag_names & ['freelance', 'receipt']).any?
      return true unless (tag_names & ['eür', 'est', 'privat']).any?
    end
    
    false
  end

  # Get human-readable review reason
  def review_reason
    return nil unless needs_review?
    
    tag_names = tags.pluck(:name).map(&:downcase)
    
    return "No tags" if tag_names.empty?
    return "Has Geschäftlich/Eigenbeleg but missing EÜR/EST" if (tag_names & ['geschäftlich', 'eigenbeleg']).any?
    return "Has work indicators but no tax status" if (tag_names & ['freelance', 'receipt']).any?
    return "Legacy 1k5 tag - update to Reimbursed" if tag_names.include?('1k5')
    
    "Incomplete tagging"
  end

  # Get budget category
  def budget_category
    tag_names = tags.pluck(:name).map(&:downcase)
    budget_tags = ['necessities', 'späß', 'sparen', 'invest', 'privat']
    
    (tag_names & budget_tags).first&.capitalize
  end

  # Check if has specific tag
  def has_tag?(tag_name)
    tags.where('LOWER(name) = ?', tag_name.downcase).exists?
  end

  # Format amount for display
  def amount_euro
    (amount_cents / 100.0).round(2)
  end
end
