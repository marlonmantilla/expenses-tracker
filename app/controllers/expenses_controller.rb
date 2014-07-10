class ExpensesController < ApplicationController
  def index
  	@expenses = Expense.all
  	render json: @expenses, status: :ok
  end
end
