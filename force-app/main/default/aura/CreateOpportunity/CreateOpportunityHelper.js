({
	createOpportunity : function(component, newOpportunity) {
        console.log(" Helper Method Create Opportunity: " + JSON.stringify(newOpportunity));
		var action = component.get("c.saveOpportunity");
        action.setParams({
            opportunity : newOpportunity
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var opportunities = component.get("v.opportunities");
                opportunities.push(response.getReturnValue());
                component.set("v.opportunities", opportunities);
            }
        });
         $A.enqueueAction(action);
    }
})