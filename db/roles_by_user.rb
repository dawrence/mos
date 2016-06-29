User.all.each do |u|
    u.roles=[]
    case u.role
    when 0
        u.roles << Role.all
    when 1
        u.roles << Role.where(identifier: [:bills_edition,:view_kitchen,:closing_stage_management,:expenses_management,
                                            :inventories_management,:supplies_history,:bills_pending_report,:bills_today_paid_report,
                                            :bills_z_report,:bills_print,:bills_pending,:bills_prepared,:bills_payment,:bills_nullify,
                                            :bills_reports_history])
    when 2
        u.roles << Role.where(identifier: [:bills_edition,:bills_nullify])
    end
    u.save
end