({
    doInit : function(component, event, helper) {
        var startDate = new Date();
        var endDate = new Date();
        component.set('v.startDate', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
        component.set('v.endDate', endDate.getFullYear() + "-" + (endDate.getMonth() + 1) + "-" + endDate.getDate());
        
        component.set('v.mycolumns', [
            {label: 'ActivityDate', fieldName: 'ActivityDate', type: 'Date'},
            {label: 'Subject', fieldName: 'Subject', type: 'text'}
        ]);
    },
    setOutput : function(component, event, helper) {
        
        
        var expdate = component.find("expdate").get("v.value");
        var expdate2 = component.find("expdate2").get("v.value");
        //console.log('++'+component.get("v.startDate"));
        var action = component.get('c.getAllEvent');
        action.setParams({
            startDate:component.get("v.startDate"),
            endDate:component.get("v.endDate")
        }); 
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.mydata', response.getReturnValue());
                component.set('v.showTable',true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
    }
})