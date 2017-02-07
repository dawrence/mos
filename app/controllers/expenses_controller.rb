class ExpensesController < ApplicationController
	def privileges
    [{generic: [:expenses_management]}]
  end

  def index
  	@today_expenses = Expense.uncounted
  end

  def show
  end

  def new
  	@expense = Expense.new
  end

  def create
  	current_user.expenses.create(params[:expense])
  	redirect_to expenses_path
  end
end
