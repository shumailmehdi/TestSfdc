({
	initTypeahead : function(component, event, helper){
    try{
        //first load the current value of the lookup field and then
        //creates the typeahead component
        helper.loadFirstValue(component);
    }catch(ex){
        console.log(ex);
    }
}
})