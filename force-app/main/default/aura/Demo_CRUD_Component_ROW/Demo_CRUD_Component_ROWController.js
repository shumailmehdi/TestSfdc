({
	callDeleteRecord : function(component, event, helper) {		
        var currentRecordId = component.get("v.view.Id");
     // alert ('Current Record Id ' + currentRecordId + '. Now you could pass the current record Id to server to delete the record.' )
        var action = component.get("c.delRecord");
        action.setParams({
            recId: currentRecordId
        });
        action.setCallback(this, function(response){
			var state = response.getState();
            if(state === "SUCCESS"){
                console.log("Delrecord found");
                component.set("v.delMsg", response.getReturnValue());                
            }
            else{
                component.set("v.delMsg", "Some Error Occured");
            }
        });
         $A.enqueueAction(action);
	},
    callUpdateRecord : function(component, event, helper) {		
        var currentRecordId = component.get("v.view.Id");
        var currentRecord = component.get("v.view");
        alert ('Current Record Id ' + currentRecordId + ' and Current Record Object is ' + component.get('v.view') +'. Now you could pass the current object to a modal popup and show the fields accordingly to update the record.' )
	}
})