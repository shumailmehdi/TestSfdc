<aura:application extends="force:slds"  access="GLOBAL" > <!-- extends="ltng:outApp" -->
   	       
        <div class="slds-page-header">
            <c:OpportunityHeader />
            <!-- <aura:dependency resource="c:OpportunityHeader" /> -->
        </div>
    
    	<lightning:layout class="slds-m-top_small slds-m-left_medium">
           <c:CreateOpportunity />
    	</lightning:layout>
     
    	<c:OpportunityLightningDataTable />
    
</aura:application>