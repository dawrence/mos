module ApplicationHelper
	def get_add
		result = link_to(raw("<i class='icon-remove'></i>"),"#")
		return result
	end

	def get_mod
		result = link_to(raw("<i class='icon-cog'></i>"),"#")
		return result
	end

	def get_sub
		result = link_to(raw("<i class='icon-plus'></i>"),"#")
		return result
	end

	def link_to_edit path, method, opts={remote: false, html_class: ""}
		if opts[:function]
			link_to_function(raw('<i class="icon-edit"></i>'), path, class: "icon-button green #{opts[:html_class]}")
		else
			link_to(raw('<i class="icon-edit"></i>'), path, remote: opts[:remote] ,method: method, class: "icon-button green #{opts[:html_class]}")
		end
	end

	def link_to_cancel path, method, opts={remote: false, html_class: ""}
		if opts[:function]
			link_to_function(raw('<i class="icon-ban-circle"></i>'), path, class: "icon-button red #{opts[:html_class]}")
		else
			link_to(raw('<i class="icon-ban-circle"></i>'), path, remote: opts[:remote], method: method, class: "icon-button red #{opts[:html_class]}")
		end
	end

	def link_to_cart path, method, opts={remote: false, html_class: ""}
		if opts[:function]
			link_to_function(raw('<i class="icon-shopping-cart icon-white"></i>'), path, class: "icon-button blue #{opts[:html_class]}")
		else
			link_to(raw('<i class="icon-shopping-cart icon-white"></i>'), path, method: method, remote: opts[:remote] , class: "icon-button blue #{opts[:html_class]}")
		end
	end

	def link_to_random path, method, opts={remote: false, html_class: ""}
		if opts[:function]
			link_to_function(raw('<i class="icon-random icon-white"></i>'), path, class: "icon-button yellow #{opts[:html_class]}")
		else
			link_to(raw('<i class="icon-random icon-white"></i>'), path, method: method, remote: opts[:remote] , class: "icon-button yellow #{opts[:html_class]}")
		end
	end

	def link_to_add path, method, opts={remote: false, html_class: ""}
		if opts[:function]
			link_to_function(raw('<i class="icon-plus"></i>'), path, class: "icon-button blue #{opts[:html_class]}")
		else
			link_to(raw('<i class="icon-plus"></i>'), path, remote: opts[:remote] ,method: method, class: "icon-button blue #{opts[:html_class]}")
		end
	end
	



	def return_deleted_ingredients(p_original,p_ordered)
	    ing = Array.new(0)
	    o_ing = p_original.ingredients
	    ordered_ing = p_ordered.ingredients
	    o_ing.each do |i| 
	      if (ordered_ing.find{|j| j.supply_id.to_s == i.supply_id.to_s && j.quantity.to_i == i.quantity.to_i} == nil)
	        ing += [i]
	      end
	    end
	    return ing
	end

	def timepicker_tag (name, placeholder=nil,value=nil, time=true)
		return content_tag(:div, 
			text_field_tag(name,value,data:{format: time ? "dd/MM/yyyy hh:mm:ss" : "dd/MM/yyyy"},placeholder:placeholder)+
			content_tag(:span,content_tag(:i,nil,data:{:"time-icon"=> "icon-time", :"date-icon" => "icon-calendar"}),class: "add-on"),
			class: "datetimepicker input-append date",
			)
	end

	def body_class
		"#{controller.controller_name} #{controller.action_name}"
	end


	def colombian_currency value
		number_to_currency value, unit: "$", delimiter: ".", precision: 0
	end

end
