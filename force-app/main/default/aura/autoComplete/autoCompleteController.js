({
    
    init: function(component, event, helper) {       
        if (typeof jQuery !== "undefined" && typeof $j === "undefined") {
            $j = jQuery.noConflict(true);
        }        
        console.log('HAmza');
       	component.set("v.ready", true);
        console.log(component);
       	helper.initHandlers(component);
    }
    
})