$(function(){
    $("body").delegate("focus",".dsc_var",function(e){
        var element = $(e.currentTarget);
        $("#discount_"+element.data("id")).prop("checked",true);
    });
});
