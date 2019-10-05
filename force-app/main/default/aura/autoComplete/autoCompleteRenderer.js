({
    
	afterRender: function(component, helper) {
        
	    this.superAfterRender();
        console.log('checking rendered');
        helper.initHandlers(component);
	}
})