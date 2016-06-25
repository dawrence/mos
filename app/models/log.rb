#encoding: utf-8
class Log
	def initialize target, author, action, opts={}
		@target = target
		@author = author
		@action = action
		@opts = opts
	end

	def report mail=false
		File.open("log.txt", "a") do |file|
			file.puts "#{@author} realizó la acción #{@action} el día #{Date.today}. #{@opts.inspect}"
		end

		GeneralMailer.report(@target, @author, @action, @opts).deliver if mail

	end
end