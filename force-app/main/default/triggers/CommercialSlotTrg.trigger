trigger CommercialSlotTrg on GenericLookup__Commercial_Slot__c (before update, before insert, after insert, after update, before delete, after undelete) {

    Trigger_Active_Inactive_Flag__mdt objTrgActive = [Select Flag__c from GenericLookup__Trigger_Active_Inactive_Flag__mdt where MasterLabel = 'CommercialSlotTrg'];
    if(!objTrgActive.Flag__c ) return ;

    CommercialSlotTrgHandler handler = new CommercialSlotTrgHandler();

    //Before Insert
    If(Trigger.isInsert && Trigger.isBefore)
    {
        handler.onBeforeInsert(Trigger.new , Trigger.newMap);
    }

    //After Insert
    If(Trigger.isInsert && Trigger.isAfter)
    {
        handler.OnAfterInsert(Trigger.new, Trigger.newMap);
    }

    //Before Update
    If(Trigger.isUpdate && Trigger.isBefore)
    {
        handler.onBeforeUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
    }

    //After Update
    If(Trigger.isUpdate && Trigger.isAfter)
    {
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }

    If(Trigger.isDelete && Trigger.isBefore)
    {
        handler.OnBeforeDelete(Trigger.old);
    }
    If(Trigger.isUndelete && Trigger.isAfter)
    {
        handler.OnAfterUndelete(Trigger.new);
    }
}