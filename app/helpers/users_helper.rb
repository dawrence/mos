module UsersHelper
	def allowed?(role)
		!current_user.forbidden?(role)
	end
end
