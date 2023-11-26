class Finances::AccountsController < FinancesController
  # TODO: Implement turbo_stream format in all actions
  before_action :set_account, only: %i[ show update destroy ]

  # GET /finances/accounts
  def index
    @accounts = []
    command = ::Finances::Account::GetAll.new
    command_response = command.execute

    @accounts = command_response.args.first.scope if command_response.success?
  end

  # GET /finances/accounts/new
  def new
    @account = ::Finances::AccountForm.new(
      name: "New Account",
      url: finances_accounts_path,
      http_method: :post
    )
  end

  # GET /finances/accounts/1
  def show
    @account = ::Finances::AccountForm.new(
      id: @account.id,
      name: @account.name,
      url: finances_account_path(@account),
      http_method: :patch
    )
  end

  # POST /finances/accounts
  def create
    @account = ::Finances::AccountForm.new(name: account_params[:name], url: finances_accounts_path, http_method: :post)
    command = ::Finances::Account::Create.new(name: @account.name)
    command_response = command.execute

    respond_to do |format|
      if @account.valid? && command_response.success?
        record = command_response.args.first
        @account = ::Finances::AccountForm.new(
          **record
              .attributes
              .deep_symbolize_keys
              .slice(:id, :name)
              .merge(url: finances_account_path(record), http_method: :patch)
        )

        format.html { redirect_to finances_accounts_path, notice: "Account was successfully created." }
      else
        if command_response.args.last == Finances::Account::Create::NAME_NOT_UNIQUE_ERROR_MESSAGE
          @account.errors.add(:name, :uniqueness, message: "already exists")
        end

        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finances/accounts/1
  def update
    @account = ::Finances::AccountForm.new(
      id: @account.id,
      name: account_params[:name],
      url: finances_account_url(@account),
      http_method: :patch
    )
    command = ::Finances::Account::Update.new(id: @account.id, name: @account.name)
    command_response = command.execute

    respond_to do |format|
      if @account.valid? && command_response.success?
        record = command_response.args.first
        @account = ::Finances::AccountForm.new(
          **record
              .attributes
              .deep_symbolize_keys
              .slice(:id, :name)
              .merge(url: finances_account_url(record), http_method: :patch)
        )

        format.html { redirect_to finances_accounts_path, notice: "Account was successfully updated." }
      else
        if command_response.args.last == Finances::Account::Update::NOT_FOUND_ERROR_MESSAGE
          @account.errors.add(:id, :invalid, message: "not found")
        end

        if command_response.args.last == Finances::Account::Update::NAME_NOT_UNIQUE_ERROR_MESSAGE
          @account.errors.add(:name, :uniqueness, message: "already exists")
        end


        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finances/accounts/1
  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to finances_accounts_url, notice: "Account was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = ::Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.fetch(:finances_account_form, {}).permit(:name)
    end
end
