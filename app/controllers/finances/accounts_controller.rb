class Finances::AccountsController < FinancesController
  # TODO: Implement turbo_stream format in all actions
  before_action :set_account, only: %i[ edit update destroy ]

  # GET /finances/accounts
  def index
    @accounts = []
    command = ::Finances::Account::GetAll.new
    command_response = command.execute

    @accounts = response.args.first.scope if command_response.success?
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
    form_parameters = account_params.merge(url: finances_accounts_path, http_method: :post)

    @account = ::Finances::AccountForm.new(form_parameters)
    command = ::Finances::Account::Create.new(name: @account.name)
    command_response = command.execute

    respond_to do |format|
      if @account.valid? && command_response.success?
        record = command_response.args.first
        @account = ::Finances::AccountForm.new(
          record.attributes.deep_symbolize_keys.slice(:id, :name)
                .merge(url: finances_account_path(record), http_method: :patch)
        )

        format.html { redirect_to finances_account_url(@account), notice: "Account was successfully created." }
      else
        # TODO: Create a method to map command_errors to form errors. Right now hard-coding it is enough.
        if command_response.args.last == Finances::Account::Create::NAME_NOT_UNIQUE_ERROR_MESSAGE
          @account.errors.add(:name, :uniqueness, message: "already exists")
        end

        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finances/accounts/1
  def update
    form_parameters = account_params.merge(id: @account.id, url: finances_account_url(@account), http_method: :patch)

    @account = ::Finances::AccountForm.new(form_parameters)
    command = ::Finances::Account::Update.new(id: @account.id, name: @account.name)
    command_response = command.execute

    respond_to do |format|
      if @account.valid? && command_response.success?
        record = command_response.args.first
        @account = ::Finances::AccountForm.new(
          record.attributes.deep_symbolize_keys.slice(:id, :name)
                .merge(url: finances_account_url(command_response.args.first), http_method: :patch)
        )

        format.html { redirect_to finances_account_url(@account), notice: "Account was successfully updated." }
      else
        # TODO: Merge command errors into form

        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finances/accounts/1
  def destroy
    @finances_account.destroy!

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
      params.fetch(:account, {}).permit(:name)
    end
end
