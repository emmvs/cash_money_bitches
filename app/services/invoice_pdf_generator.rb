class InvoicePdfGenerator
  def initialize(invoice)
    @invoice = invoice
  end

  def call
    Prawn::Document.new do |pdf|
      pdf.text "Invoice ##{@invoice.id}", size: 20, style: :bold
    end
  end
end
