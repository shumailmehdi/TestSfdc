({  
    initHandlers: function(component) {
        console.log('checking');
    	var ready = component.get("v.ready");
		console.log(ready);
        if (ready === false) {
            console.log('error');
           	return;
        }
        
        var ctx = component.getElement();
        
        $j(".autocomplete", ctx).autocomplete({
            minLength: 2,
            delay: 500,
            source: function(request, response) {
                var action = component.get("c.getSuggestions");
                var fieldsToGet = component.get("v.fields");
               	console.log('Test 1');
                action.setParams({
                    "sObjectType": component.get("v.sObjectType"),
                    "term": request.term,
                    "fieldsToGet": fieldsToGet.join(),
                    "limitSize": component.get("v.limit")
                });
                
                action.setCallback(this, function(a) {
                	var suggestions = a.getReturnValue();
                    suggestions.forEach(function(s) {
                        console.log('Test 2');
                        s["label"] = s.Name,
                        s["value"] = s.Id
                    });
                    response(suggestions);
                });
                
                $A.run(function() {
                    $A.enqueueAction(action); 
                });
            },
            select: function(event, ui) {  
                event.preventDefault();
                var ctx = component.getElement();
                $j(".autocomplete", ctx).val(ui.item.label);
                    
                var selectionEvent = component.getEvent("autocompleteEvt");
                selectionEvent.setParams({
                    selectedOption: ui.item 
                });
                selectionEvent.fire();
            }
        });
    }

})