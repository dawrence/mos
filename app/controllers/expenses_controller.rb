class ExpensesController < ApplicationController
	def privileges
    [{generic: [:expenses_management]}]
  end

  def index
    condition ={}
    if allowed?(:filter_expenses)
      setting=Setting.getSetting()
      cutoff_hour = setting.cutoff_date.hour
      init_date = params[:init_date].present? ? DateTime.strptime(params[:init_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0) : nil
      end_date  = params[:end_date].present? ? DateTime.strptime(params[:end_date], "%m/%d/%Y").change(hour: cutoff_hour, min: 0, sec:0) : nil
      condition[:created_at] = init_date..end_date if init_date && end_date
      condition[:closing_stage_id] = params[:closing_stage_id] if params[:closing_stage_id] && !params[:closing_stage_id].empty?
    end
  	@expenses = expense
      .where(condition)
      .page(params[:page])
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

  private
  def expense
    return Expense if params[:init_date] && params[:end_date] && params[:closing_stage_id] && allowed?(:filter_expenses)
    Expense.uncounted
  end
end
