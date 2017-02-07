jQuery(function(){

	$('.label-container a.trigger').click(function(e){
		e.preventDefault();
		console.log("Opening label");
		$(this).closest('.label-container').toggleClass('open');
	})

	$('div.bill-notes a').click(function(e){
		e.preventDefault();
		$(this).closest(".bill-notes").toggleClass("editable");
	})

 $(".prepare_bill").on('click',function(e){
 	e.preventDefault();
 	if(confirm("¿Desea colocar este pedido como terminado?") == true){
 		$(this).hide();
 	}
 	else{
 		e.stopPropagation();
 	}
 });

  $("#customization").delegate('.ok_ingredients',"click",ok_ingredients);
  $("#customization").delegate('.close_ingredients',"click",close_ingredients);
  $("#additionals").delegate('.close_additionals',"click",close_additionals);
  $("#customization").delegate('.ingredient_to_add',"click",set_quantity);



	$(window).bind("pageshow",function(){
		$("#bill_price").val($("#bill_price").attr("value"));
	});

	$("body").delegate('.mod_btn',"click",function(e){

			parent = $(this).closest('tr');
			$(".product_to_order").each(function(){$(this).removeClass("modifying_product");});
			parent.addClass("modifying_product")
			ings = parent.find(".show_ingredients");
			if(ings.length > 0){
				e.preventDefault();
			    e.stopPropagation();
				copy = ings.clone();
				$("#products_selection").fadeOut();
				$("#additionals").fadeOut();
				$("#customization").fadeOut(function(){
					$("#customization").html(copy).fadeIn();
					copy.fadeIn();
				});
				$('#botActions .scope').addClass('fixed-bug');
			}


	 });

	$("body").delegate('.additional_btn',"click",function(e){
		  e.preventDefault();
		  e.stopPropagation();
		  $(".product_to_order[data-additional='true']").attr('data-additional','false');
		  parent = $(this).parent().parent();
		  parent.attr("data-additional","true");
	  	copy = $("#additionals_content").find(".show_additionals").clone();
	  	$("#products_selection").fadeOut();
			$("#customization").fadeOut();
			$("#additionals").fadeOut(function(){
				$("#additionals").html(copy).fadeIn();
				copy.fadeIn();
				$('#botActions .scope').addClass('fixed-bug');
			});
	 });

	$('#products_selection .nav li a').click(function(){
		tabs = $(this).closest('#products_selection');
		tabs_scope = tabs.parent('.scope')
		liparent = $(this).closest('li');
		console.log('yes');
		console.log(tabs);
		console.log(liparent);
		if ((tabs.hasClass('shown')) && (liparent.hasClass('active'))) {
			tabs.find('li').removeClass('movedRight');
			tabs.find('li').removeClass('movedLeft');
			tabs.removeClass('shown');
		}
		else {
			tabs.addClass('shown');
			liparent.nextAll('li').addClass('movedRight');
			liparent.prevAll('li').addClass('movedLeft');
		}

	});

	$('.scope > ul li').click(function(){
		$(this).siblings('li').removeClass('active');
		tab = $('.tab-content #' + $(this).data('target'));
		console.log(tab);
		tab.siblings('.tab-pane').removeClass('active');
		tab.addClass('active');
		$(this).addClass('active');
	});

});

function rmv_bil_prd(link,pid,price){
	//retrieve data fields
	event.preventDefault();
	q = parseInt($(link).parent().siblings(".order_quantity").children("input[type=hidden]").val());
	//
	if(q > 1 ){
		$(link).parent().siblings(".order_quantity").children("input[type=hidden]").val(q-1);
		$(link).parent().siblings(".order_quantity").children("span").html("x "+(q-1));
	}
	else if (q==1){
		$(link).parent().parent().remove();
	}
	add_price = 0;
	$(link).parent().siblings(".additionals_attributes").find("tr.product_additional").each(function(index){
	  quantity = parseInt($(this).find("td.add_quantity input[type=hidden]").val());
	  add_price += (parseFloat($(this).data("price"))*quantity);

	});
	$("#bill_price").val(parseInt($("#bill_price").val()) - (parseInt(price)+add_price));
}



function ok_ingredients(e){
	e.preventDefault();
	parent = $(this).closest(".show_ingredients");
	copy = parent.clone();
	set_products_ing();
	copy.find(".product_information").empty().remove();
	$(".product_to_order.modifying_product").find(".show_ingredients").empty().remove();
    $(".product_to_order.modifying_product > td.ingredients_attributes").append(copy);
    $(".product_to_order.modifying_product").children("td").children(".mod_btn").removeAttr("data-remote");
    copy.hide();
    close_ingredients(e);
}

function close_ingredients(e){
	e.preventDefault();
	parent = $(this).closest(".show_ingredients");
	$(".product_to_order.modifying_product").removeClass('modifying_product');
	$("#additionals").fadeOut();
	$("#customization").fadeOut(function(){
		parent.empty();
		parent.remove();
		$("#products_selection").fadeIn();
		$('#botActions .scope').removeClass('fixed-bug');
	});
}

function set_products_ing(){
	ul = $(".product_to_order.modifying_product").find(".product_custom_ing");
	ul.empty();
	$("#customization").find(".ingredient_to_add:not(:checked)").each(function(index,element){
		name = $(element).siblings(".ingredient_name").html();
		ul.append("<li>"+"Sin "+name+" </li>");
	});

}

function close_additionals(e){
	e.preventDefault();
	parent = $(this).closest(".show_additionals");
  $(".product_to_order[data-additional='true']").attr('data-additional','false');
	$("#additionals").fadeOut(function(){
		parent.empty();
		parent.remove();
		$("#products_selection").fadeIn();
		$('#botActions .scope').removeClass('fixed-bug');
	});
}

function add_ingredient(ht,item){
	$(item).append(ht);
}

function delete_ingredients(e){
	e.preventDefault();
	//
	product_id = parseInt($("#product_temp_id").val());
}




function set_quantity(){
	quantity  = $(this).parent().data("quantity");
	if($(this).is(":checked")){
		$(this).siblings(".ingredient_quantity").val(quantity);
	}
	else{
    $(this).siblings(".ingredient_quantity").val(0);
	}
}

function additional_to_product(html,add_id,price){
  p_to_or = $(".product_to_order[data-additional='true']");
  additional = p_to_or.find(".product_additional[data-additional-id="+add_id+"]");
  price  =parseInt(price);
  $("#bill_price").val(parseInt($("#bill_price").val()) + parseInt(price));

  if(additional.length > 0){
 		q = parseInt(additional.find("td.add_quantity").children("input[type=hidden]").val());
 		additional.find("td.add_quantity").children("span").html("x "+(q+1));
 		additional.find("td.add_quantity").children("input[type=hidden]").val(q+1);
  }
  else{
  	p_to_or.find("table.additionals").find("tbody").append(html);
  }
}


function delete_additional (element,price) {
	tr = $(element).parent().parent();
	price  = parseInt(price);
	new_price = parseInt($("#bill_price").val()) - parseInt(price);
  $("#bill_price").val(new_price < 0 ? 0: new_price);

	value = parseInt(tr.find(".add_quantity").find("input[type=hidden]").val());
	if(value > 1){
		tr.find(".add_quantity").find("input[type=hidden]").val(value-1);
		tr.find(".add_quantity").find("span").html("x "+(value-1));
	}
	else{
		tr.empty().remove();
	}
}

/*-----------------------------------*/
function bindBills(){
	$('select#tables').change(function(){
		$(this).siblings('div.table').removeClass("shown");
		$('#' + $(this).val()).addClass("shown");
	})

	$('div.tab-links a.binded').click(function(e){
		e.preventDefault();
		$(this).siblings('a.active').removeClass("active");
		$(this).addClass("active");
		$("div.contents div.content.shown").removeClass("shown")
		$("div.contents div#" + $(this).data("tab")).addClass("shown")
	})
}


