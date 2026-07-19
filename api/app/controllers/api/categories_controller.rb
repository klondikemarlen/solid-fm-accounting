module Api
  class CategoriesController < Api::BaseController
    def index
      categories = Category.order(:name)

      render json: categories.map { |category| category_json(category) }
    end

    private

    def category_json(category)
      {
        id: category.id,
        code: category.code,
        name: category.name,
        transactionType: category.transaction_type
      }
    end
  end
end
