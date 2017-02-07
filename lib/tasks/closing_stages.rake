namespace :closing_stages do
    desc "set ids for expenses"

    task :expenses => [:environment] do
      previous_date = nil
      ClosingStage.all.each do |s|
        if !previous_date
          Expense.where('created_at <= ?', s.created_at).each do |d|
            d.closing_stage_id = s.id
            d.save
          end
        else
          Expense.where(created_at: previous_date..s.created_at).each do |d|
            d.closing_stage_id = s.id
            d.save
          end
        end
        previous_date = s.created_at
      end
    end
end
