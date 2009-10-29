$(document).ready(function() {

	// http://www.dailycoding.com/Posts/default_text_fields_using_simple_jquery_trick.aspx
	
	$(".watermarkable").focus(function(srcc)
	{
	    if ($(this).val() == $(this)[0].title)
	    {
	        $(this).removeClass("watermark");
	        $(this).val("");
	    }
	});

	$(".watermarkable").blur(function()
	{
	    if ($(this).val() == "")
	    {
	        $(this).addClass("watermark");
	        $(this).val($(this)[0].title);
	    }
	});

	$(".watermarkable").blur();   
	
});
