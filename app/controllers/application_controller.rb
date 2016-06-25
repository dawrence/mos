class ApplicationController < ActionController::Base
  	protect_from_forgery
	before_filter :set_locale
	before_filter :authenticate_user!, :allowed?
	
	#before_filter :has_permission (current_user.id)
	helper_method :is_admin, :is_owner, :is_waiter

    def privileges
    	[{generic:[]}]
    end

    def allowed?(role=nil)
    	return !current_user.forbidden?(role) if role
    	current_uri = request.env['PATH_INFO']
        custom_validation = privileges.select{|d| d[:action] == "#{action_name}"}
        validations = ((custom_validation.first && !custom_validation.empty?) ? custom_validation.first[:validations] : privileges.first[:generic])
    	validations.each{|p| 
    		redirect_to (root_path != current_uri ? root_path : my_data_path) if current_user.forbidden?(p)
    		}
    end

	def set_locale
	  I18n.locale = "es-CO"
	end

	def has_owner_permission
		unless current_user.role == 0
			redirect_to bills_path
		end
	end

	def has_admin_permission
		unless current_user.role == 1
			redirect_to bills_path
		end
	end

	def has_owner_or_admin_permission
		if current_user.role != 0 and current_user.role != 1
			redirect_to bills_path
		end
	end

	def validate_user_actions
		if current_user
			current_user.bills.where(updated_mk: true).each do |b|
				b.updated_mk = false
				b.save
			end
		end
	end

	def get_today_default_range
		current_time = Time.now.in_time_zone("America/Bogota")
    	setting=Setting.getSetting()
    	cutoff_hour = setting ? setting.cutoff_date.hour : Time.now.hour
    	now = Time.now - cutoff_hour.hours
    	first_date = now.change(hour: cutoff_hour)
    	last_date = now.change(hour: cutoff_hour) + 1.day  
    	return {init_date: first_date, end_date: last_date}
	end

	protected
	
	def is_waiter
		user_signed_in? and current_user.role == 2
	end

	def is_admin
		user_signed_in? and current_user.role == 1
	end

	def is_owner
		user_signed_in? and current_user.role == 0
	end

end
