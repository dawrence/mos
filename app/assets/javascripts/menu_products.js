 function add_number(field, limit){
 	
 	if(parseFloat(field.val()) + 0.5 <= parseFloat(limit)){
 		 field.val(parseFloat(field.val()) + 0.5);
 	}
 }

 function add_number(field){
 		 field.val(parseFloat(field.val()) + 0.5);
 }

 function sub_number(field){
 	
 	if(parseFloat(field.val())- 0.5 >= 0){
 		 field.val(parseFloat(field.val()) - 0.5);
 	}
 } 
