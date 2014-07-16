class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
  	@expenses = current_user.expenses
  	filter_expenses
  	respond_to do |format|
  		format.html
  		format.json { render json: @expenses, status: :ok }
  	end
  end

  def show
  	@expense = current_user.expenses.find_by(id: params[:id])
  	if @expense
  		render json: @expense, status: 200
  	else
  		render json: @expense, status: 404
  	end
  end

  def create
  	@expense = current_user.expenses.build(expense_params)
  	if @expense.save
  		render json: @expense, status: 201, location: @contact
  	else
  		render json: @expense.errors, status: :unprocessable_entity
  	end
  end

  def update
  	@expense = current_user.expenses.find_by(id: params[:id])
  	if @expense && @expense.update_attributes(expense_params)
  		render json: @expense, status: 200
  	else
  		render json: @expense.try(:errors), status: 404
  	end
  end

  def destroy
  	@expense = current_user.expenses.find_by(id: params[:id])
  	@expense.destroy if @expense
  	render nothing: true
  end

  private
  def expense_params
  	params.require(:expense).permit(:start_date, :description, :comment, :amount)
  end

  def filter_expenses
  	if params[:filters]
  		@expenses = @expenses.where("description like ?", "%#{params[:description]}%") #if params[:description]
      @expenses = @expenses.where("comment like ?", "%#{params[:comment]}%")
  		@expenses = @expenses.where("amount <= ?", params[:amount]) if params[:amount]
  		start_date = Time.parse(params[:start_date]) rescue Time.now
  		end_date = Time.parse(params[:end_date]) rescue Time.now
  		@expenses = @expenses.where(start_date: start_date..end_date) if params[:start_date] && params[:end_date]
  	end
  end

end
