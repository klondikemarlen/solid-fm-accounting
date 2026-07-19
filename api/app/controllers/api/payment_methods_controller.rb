module Api
  class PaymentMethodsController < Api::BaseController
    def index
      payment_methods = PaymentMethod.order(:name)

      render json: payment_methods.map { |payment_method| payment_method_json(payment_method) }
    end

    private

    def payment_method_json(payment_method)
      {
        id: payment_method.id,
        name: payment_method.name
      }
    end
  end
end
