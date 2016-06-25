class ClosingStagesController < ApplicationController
  def privileges
    [{generic: [:closing_stage_management]}]
  end
  
  def index
    init_date = params[:init_date] && !params[:init_date].empty? ? DateTime.strptime(params[:init_date], "%m/%d/%Y") : nil
    end_date  = params[:end_date] && !params[:end_date].empty? ?  DateTime.strptime(params[:end_date], "%m/%d/%Y") : nil
  	@closing_stages = ClosingStage.where(
      init_date && end_date ? {created_at: init_date..end_date} : nil)
    .order("created_at DESC")
    .page(params[:page] || 1)
  end

  def create
  	closing_stage = ClosingStage.create(closing_stage_params)
  	Expense.uncounted.mark_as_counted
  	redirect_to bills_path
  end


  protected

  def closing_stage_params
  	params[:closing_stage][:system_expenses] = Expense.uncounted.each.sum(&:value)
    params[:closing_stage][:system_sales] = Bill.get_current_paid.sum(&:total)
  	params[:closing_stage][:tips_total] = Bill.get_current_paid.sum(&:tip)
    params[:closing_stage][:total_discount] = Bill.get_current_paid.sum(&:discount_value)
  	params[:closing_stage]
  end
end
