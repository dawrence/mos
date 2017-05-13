$(function(){
	$(".m-i-checkbox").on("change",function(e){
		var id = $(this).val();		
		if($(this).is(":checked")) {
			$("#type_"+id+"_").removeAttr("disabled");
			$("#quantity_"+id+"_").removeAttr("disabled");
			$("#adjustment_"+id+"_").removeAttr("disabled");
		}
		else{
			$("#type_"+id+"_").attr("disabled",true);
			$("#quantity_"+id+"_").attr("disabled",true);
			$("#adjustment"+id+"_").attr("disabled",true);
		}
	});

});