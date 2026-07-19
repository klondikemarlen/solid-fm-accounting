module Api
  class AccountsController < Api::BaseController
    before_action :set_account, only: [ :update, :destroy ]

    def index
      accounts = current_user.accounts.order(:name)
      render json: accounts.map { |account| account_json(account) }
    end

    def create
      account = current_user.accounts.new(account_params)

      if account.save
        render json: account_json(account), status: :created
      else
        render_validation_errors(account)
      end
    end

    def update
      if @account.update(account_params)
        render json: account_json(@account)
      else
        render_validation_errors(@account)
      end
    end

    def destroy
      @account.destroy!
      head :no_content
    rescue ActiveRecord::DeleteRestrictionError
      render json: { errors: { base: [ "cannot be deleted while transactions exist" ] } },
        status: :unprocessable_entity
    end

    private

    def set_account
      @account = current_user.accounts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Account not found" }, status: :not_found
    end

    def account_params
      params.require(:account).permit(:name, :account_type)
    end

    def account_json(account)
      {
        id: account.id,
        name: account.name,
        accountType: account.account_type
      }
    end

    def render_validation_errors(account)
      errors = account.errors.to_hash.transform_keys do |attribute|
        attribute.to_s.camelize(:lower)
      end

      render json: { errors: }, status: :unprocessable_entity
    end
  end
end
