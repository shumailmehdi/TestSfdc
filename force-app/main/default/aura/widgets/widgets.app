<aura:application >
    <ltng:require styles="{!$Resource.autoComplete_js + '/css/jquery-ui.min.css'}"      
      	    scripts="{!join(',', 
    				 $Resource.autoComplete_js + '/js/jquery-2.2.4.min.js', 
                     $Resource.autoComplete_js + '/js/jquery-ui.min.js')}"
	/>
    <c:autoComplete sObjectType="Account" autocompleteEvent="{!c.handleAutocomplete}" fields="Phone,AccountNumber" />
    <c:autoComplete sObjectType="Contact" autocompleteEvent="{!c.handleAutocomplete}" fields="Email,Phone"/>
    <div id="result"></div>
</aura:application>