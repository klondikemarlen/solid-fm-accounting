module Api
  class TransactionsController < Api::BaseController
    before_action :set_transaction, only: [ :show, :update, :destroy ]

    def index
      transactions = current_user.transactions
        .includes(:account, :category, :payment_method)
        .with_attached_receipts
        .order(transaction_date: :desc, id: :desc)

      render json: transactions.map { |transaction| transaction_json(transaction) }
    end

    def show
      render json: transaction_json(@transaction)
    end

    def create
      transaction = current_user.transactions.new(transaction_params)

      if transaction.save
        render json: transaction_json(transaction), status: :created
      else
        render_validation_errors(transaction)
      end
    end

    def update
      if @transaction.update(transaction_params)
        render json: transaction_json(@transaction)
      else
        render_validation_errors(@transaction)
      end
    end

    def destroy
      @transaction.destroy!
      head :no_content
    end

    private

    def set_transaction
      @transaction = current_user.transactions.with_attached_receipts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Transaction not found" }, status: :not_found
    end

    def transaction_params
      params.require(:transaction).permit(
        :account_id,
        :amount,
        :category_id,
        :description,
        :payment_method_id,
        :transaction_date,
        :transaction_type,
        :vendor,
        receipts: []
      )
    end

    def transaction_json(transaction)
      {
        id: transaction.id,
        transactionDate: transaction.transaction_date.iso8601,
        transactionType: transaction.transaction_type,
        amount: transaction.amount.to_s("F"),
        vendor: transaction.vendor,
        description: transaction.description,
        account: account_json(transaction.account),
        category: category_json(transaction.category),
        paymentMethod: payment_method_json(transaction.payment_method),
        receipts: transaction.receipts.map { |receipt| receipt_json(receipt) }
      }
    end

    def account_json(account)
      {
        id: account.id,
        name: account.name,
        accountType: account.account_type
      }
    end

    def category_json(category)
      {
        id: category.id,
        code: category.code,
        name: category.name,
        transactionType: category.transaction_type
      }
    end

    def payment_method_json(payment_method)
      {
        id: payment_method.id,
        name: payment_method.name
      }
    end

    def receipt_json(receipt)
      blob = receipt.blob

      {
        id: blob.id,
        filename: blob.filename.to_s,
        contentType: blob.content_type,
        byteSize: blob.byte_size
      }
    end

    def render_validation_errors(transaction)
      errors = transaction.errors.to_hash.transform_keys do |attribute|
        attribute.to_s.camelize(:lower)
      end

      render json: { errors: }, status: :unprocessable_entity
    end
  end
end
