trigger AccountTrg on Account (before update, before insert, after insert, after update)
{   
    Trigger_Active_Inactive_Flag__mdt objTrgActive = [Select Flag__c from GenericLookup__Trigger_Active_Inactive_Flag__mdt where MasterLabel = 'AccountTrg'];
    if(!objTrgActive.Flag__c ) return ;
    
    AccountTrgHandler handler = new AccountTrgHandler();
    // Before Insert
    if(Trigger.isInsert && Trigger.isBefore)
    {
        handler.onBeforeInsert(Trigger.new , Trigger.newMap);
    }

    //After Insert
    if(Trigger.isInsert && Trigger.isAfter)
    { 
        handler.OnAfterInsert(Trigger.new, Trigger.newMap);
    }
    
	// Before Update
    if(Trigger.isUpdate && Trigger.isBefore)
    {
        handler.onBeforeUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
    }

    // After Update
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        
    }
    
}