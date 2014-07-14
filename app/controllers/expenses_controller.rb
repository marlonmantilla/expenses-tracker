class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
  	@expenses = Expense.all
  	filter_expenses
  	respond_to do |format|
  		format.html
  		format.json { render json: @expenses, status: :ok }
  	end
  end

  def show
  	@expense = Expense.find_by(id: params[:id])
  	if @expense
  		render json: @expense, status: 200
  	else
  		render json: @expense, status: 404
  	end
  end

  def create
  	@expense = Expense.new(expense_params)
  	if @expense.save
  		render json: @expense, status: 201, location: @contact
  	else
  		render json: @expense.errors, status: :unprocessable_entity
  	end
  end

  def update
  	@expense = Expense.find_by(id: params[:id])
  	if @expense && @expense.update_attributes(expense_params)
  		render json: @expense, status: 200
  	else
  		render json: @expense.try(:errors), status: 404
  	end
  end

  def destroy
  	@expense = Expense.find_by(id: params[:id])
  	@expense.destroy if @expense
  	render nothing: true
  end

  private
  def expense_params
  	params.require(:expense).permit(:start_date, :description, :comment, :amount)
  end

  def filter_expenses
  	if params[:filters]
  		@expenses = @expenses.where("description like ? or comment like ?", "%#{params[:filters][:description]}%", "%#{params[:filters][:comment]}%") #if params[:filters][:description]
  		@expenses = @expenses.where("amount <= ?", params[:filters][:amount]) if params[:filters][:amount]
  		start_date = Time.parse(params[:filters][:start_date]) rescue Time.now
  		end_date = Time.parse(params[:filters][:end_date]) rescue Time.now
  		@expenses = @expenses.where(start_date: start_date..end_date) if params[:filters][:start_date] && params[:filters][:end_date]
  	end
  end

end
