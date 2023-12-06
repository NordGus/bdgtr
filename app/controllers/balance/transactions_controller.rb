class Balance::TransactionsController < BalanceController
  before_action :set_transaction, only: %i[ show create update destroy ]

  def index
    @transactions = Transaction.includes(:from, :to).order("executed_at DESC NULLS FIRST")
  end

  def new
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.fetch(:balance_transaction_form, {})
          .permit(:from_id, :to_id, :amount, :issued_at, :executed_at)
  end
end
