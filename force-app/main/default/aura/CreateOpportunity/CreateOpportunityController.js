({
    doInit : function (component, event, helper){
     	//Fetching type picklist values   
    	 const typePicklistAction = component.get("c.getPickListValues");
        typePicklistAction.setParams({
            objectName : "Opportunity",
            fieldName  : "Type"
        });
        typePicklistAction.setCallback(this, function(response) {
            const state = response.getState();
            if(state === "SUCCESS") {
 					component.set("v.typeList",response.getReturnValue());
               //need to handle in case the list is null
            }
            else { //handle other errors
 
            }
        })
        
     	//Fetching StageName picklist values   
      	 const stageNamePicklistAction = component.get("c.getStageName");
        stageNamePicklistAction.setCallback(this, function(response) {
            const state = response.getState();
            if(state === "SUCCESS") {
 					component.set("v.stageNameList",response.getReturnValue());
               //need to handle in case the list is null
            }
            else { //handle other errors
 
            }
        })
        
        //Fetching LeadSource picklist values   
      	 const leadSourcePicklistAction = component.get("c.getPickListValues");
        leadSourcePicklistAction.setParams({
            objectName : "Opportunity",
            fieldName  : "LeadSource"
        });
        leadSourcePicklistAction.setCallback(this, function(response) {
            const state = response.getState();
            if(state === "SUCCESS") {
 					component.set("v.leadSourceList",response.getReturnValue());
               //need to handle in case the list is null
            }
            else { //handle other errors
 
            }
        })
        
        $A.enqueueAction(typePicklistAction);
        $A.enqueueAction(stageNamePicklistAction);
        $A.enqueueAction(leadSourcePicklistAction);
	        
    },
	saveBtn : function(component, event, helper) {
		
        var childCmp = component.find("lookup_account");
        var childCmp2 = component.find("lookup_campaign");
        
        var lookUpID = childCmp.lookUpMethod();
        var lookUpID2 = childCmp2.lookUpMethod();
        
        //Checking while account field is undefined and empty or not
        if(lookUpID == '' || lookUpID == undefined){
            
            console.log("Account field must not be empty");
        }
        else{
            component.set("v.newOpportunity.AccountId", lookUpID);
              console.log("Lookup Id In Parent Component: " + lookUpID);
        }
        
        //Checking while campaign field is undefined and empty or not
        if(lookUpID2 == '' || lookUpID2 == undefined){
            
             console.log("Campaign field must not be empty");
 		}
        else{
            component.set("v.newOpportunity.CampaignId", lookUpID2);
        	  console.log("Lookup Id 2 In Parent Component: " + lookUpID2);
        }     
        
        
        
         var validOpportunity = component.find('opportunityform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validOpportunity){
            // Create the new opportunity
            var newOpportunity = component.get("v.newOpportunity");
            console.log("Create Opportunity: " + JSON.stringify(newOpportunity));
            helper.createOpportunity(component, newOpportunity);
        }

	},
    newBtn :  function(component, event, helper) {
    
    },
    cancelBtn :  function(component, event, helper) {
    
    }
})