public with sharing class CommercialSlotTrgHandler {
	
	public  void onBeforeInsert(List <Commercial_Slot__c> newList, Map<Id,Commercial_Slot__c> newMap )
    {

    }

    public  void OnAfterInsert(List <Commercial_Slot__c> newList, Map<Id,Commercial_Slot__c> newMap )
    {
        //To update the values of commercial list Broadcast Schedule
        insertSumOnParentObject(newlist);
    }
    
    public void onBeforeUpdate(List<Commercial_Slot__c> newlist,Map<Id,Commercial_Slot__c> oldMap, Map<Id,Commercial_Slot__c> newMap)
    {

    }

    public void onAfterUpdate(List<Commercial_Slot__c> oldList,List<Commercial_Slot__c> newlist,Map<Id,Commercial_Slot__c> oldMap, Map<Id,Commercial_Slot__c> newMap)
    {
        //To update the values of commercial list Broadcast Schedule
        updateSumOnParentObject(newlist,oldMap);
    
    }

    public void OnBeforeDelete(List<Commercial_Slot__c> oldList) 
    {
        deleteSumOnParentObject(oldList);
    }

    public void OnAfterUndelete(List<Commercial_Slot__c> newList)
    {
        undeleteSumOnParentObject(newList);
    }


/*
@Shumail Mehdi
Desc : This method will update the broadcast scheduled values on Commercial Object with the sum of associated Commercial Slots 'Number of Broadcast' values on After insert event.
Date : 12/10/2018
*/

    private static void insertSumOnParentObject(List<Commercial_Slot__c> newlist)
	{

        //Set for commercial Ids
        set<id> commercialIds=new set<id>();
        //Set for Timeslot Ids
        set<id> timeslotIds = new set<id>();

        for(Commercial_Slot__c comSlotLst: newlist)
		{
            if(comSlotLst.GenericLookup__Commercial_fld__c != null)
            {
            commercialIds.add(comSlotLst.GenericLookup__Commercial_fld__c);
            }
            if(comSlotLst.GenericLookup__Timeslot_fld__c != null)
            {
             timeslotIds.add(comSlotLst.GenericLookup__Timeslot_fld__c);
            }
        }

        //Map to store commercial to update id and broadcast schedule value
        Map<Id, Commercial__c> commMap = new Map<Id, Commercial__c>([Select Id, GenericLookup__Broadcasts_Scheduled__c from Commercial__c where Id in:commercialIds]);

        //Map to store timeslot to update id and scheduled commercial time value
        Map<Id, Timeslot__c> timeSlotMap = new Map<Id, Timeslot__c>([Select Id, GenericLookup__Scheduled_Commercial_Time__c from Timeslot__c where Id in:timeslotIds]);

        //List to store Aggregate Result where commercialId is in the set
        List<AggregateResult> aggregateListForCommercial = new List<AggregateResult>();
        aggregateListForCommercial = [Select Commercial_fld__c, Sum(Number_of_Broadcasts__c) Csum from Commercial_Slot__c Where Commercial_fld__r.Id in:commercialIds group by Commercial_fld__c];
        
        //List to store Aggregate Result where timeslotIds is in the set
        List<AggregateResult> aggregateListForTimeslot = new List<AggregateResult>();
        aggregateListForTimeslot =  [Select Timeslot_fld__c, Sum(Total_Broadcast_Time_Text__c) Tsum from Commercial_Slot__c Where Timeslot_fld__r.Id in:timeslotIds group by Timeslot_fld__c];
        
        //List to store updated values of broadcast scheduled fields
        List<Commercial__c> updatedCommercialVals = new  List<Commercial__c>();

        //List to store updated values of schedule commercial time fields
        List<Timeslot__c> updatedTimeslotVals = new List<Timeslot__c>();

        for(AggregateResult CommSlot : aggregateListForCommercial)
        {

            Id CommId = (Id) CommSlot.get('GenericLookup__Commercial_fld__c');

            Commercial__c commObj = commMap.get(CommId);

            Decimal sumScheduled = (Decimal)CommSlot.get('CSum');

            commObj.GenericLookup__Broadcasts_Scheduled__c = sumScheduled;

            updatedCommercialVals.add(commObj);
        
        }

        for(AggregateResult CommSlotTime : aggregateListForTimeslot)
        {
            Id TimeSlotId = (Id) CommSlotTime.get('GenericLookup__Timeslot_fld__c');

            Timeslot__c timeslotObj = timeSlotMap.get(TimeSlotId);

            timeslotObj.GenericLookup__Scheduled_Commercial_Time__c = (Decimal)CommSlotTime.get('TSum');
            system.debug('Insert Sum : ' + (Decimal)CommSlotTime.get('TSum'));

            updatedTimeslotVals.add(timeslotObj);

        }
        
        if(updatedCommercialVals.size() > 0)
        {
            Database.SaveResult[] srCommercialList = Database.update(updatedCommercialVals, false);
            for (Database.SaveResult srComm : srCommercialList) {
                if (srComm.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Commercial. Commercial ID: ' + srComm.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : srComm.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Commercial fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        if(updatedTimeslotVals.size() > 0)
        {

            Database.SaveResult[] srTimeslotList = Database.update(updatedTimeslotVals, false);
            for (Database.SaveResult srTimeslot : srTimeslotList) {
                if (srTimeslot.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Timeslot. Timeslot ID: ' + srTimeslot.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error errTs : srTimeslot.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(errTs.getStatusCode() + ': ' + errTs.getMessage());
                        System.debug('Timeslot fields that affected this error: ' + errTs.getFields());
                    }
                }
            }
        }
	}



    /*
    @Shumail Mehdi
    Desc : This method will update the broadcast scheduled values on Commercial Object with the sum of associated Commercial Slots 'Number of Broadcast' values on After update event.
    Date : 12/10/2018
    */

	private static void updateSumOnParentObject(List<Commercial_Slot__c> newlist, Map<Id,Commercial_Slot__c> oldMap)
	{

        //Set for commercial Ids
        set<id> commercialIds=new set<id>();
        //Set for Timeslot Ids
        set<id> timeslotIds = new set<id>();

        for(Commercial_Slot__c comSlotLst: newlist)
		{
            Commercial_Slot__c  oldCommSlot = oldMap.get(comSlotLst.Id);
            
            if(oldCommSlot.GenericLookup__Commercial_fld__c != comSlotLst.GenericLookup__Commercial_fld__c || oldCommSlot.Number_of_Broadcasts__c != comSlotLst.Number_of_Broadcasts__c)
            {
                commercialIds.add(comSlotLst.GenericLookup__Commercial_fld__c);
            }

            if(oldCommSlot.GenericLookup__Timeslot_fld__c != comSlotLst.GenericLookup__Timeslot_fld__c || oldCommSlot.GenericLookup__Number_of_Broadcasts__c != comSlotLst.GenericLookup__Number_of_Broadcasts__c || oldCommSlot.GenericLookup__Commercial_fld__r.GenericLookup__Running_Time__c != comSlotLst.GenericLookup__Commercial_fld__r.GenericLookup__Running_Time__c )
            {
             timeslotIds.add(comSlotLst.GenericLookup__Timeslot_fld__c);
            }
        }            

        //Map to store commercial to update id and broadcast schedule value
        Map<Id, Commercial__c> commMap = new Map<Id, Commercial__c>([Select Id, GenericLookup__Broadcasts_Scheduled__c from Commercial__c where Id in:commercialIds]);

        //Map to store timeslot to update id and scheduled commercial time value
        Map<Id, Timeslot__c> timeSlotMap = new Map<Id, Timeslot__c>([Select Id, GenericLookup__Scheduled_Commercial_Time__c from Timeslot__c where Id in:timeslotIds]);



        //List to store Aggregate Result where commercialId is in the set
        List<AggregateResult> aggregateListForCommercial = new List<AggregateResult>();
        aggregateListForCommercial = [Select Commercial_fld__c, Sum(Number_of_Broadcasts__c) Csum from Commercial_Slot__c Where Commercial_fld__r.Id in:commercialIds group by Commercial_fld__c ];
        
        //List to store Aggregate Result where timeslotIds is in the set
        List<AggregateResult> aggregateListForTimeslot = new List<AggregateResult>();
        aggregateListForTimeslot =  [Select Timeslot_fld__c, Sum(Total_Broadcast_Time_Text__c) Tsum from Commercial_Slot__c Where Timeslot_fld__r.Id in:timeslotIds group by Timeslot_fld__c];
        

        //List to store updated values of broadcast scheduled fields
        List<Commercial__c> updatedCommercialVals = new  List<Commercial__c>();

        //List to store updated values of schedule commercial time fields
        List<Timeslot__c> updatedTimeslotVals = new List<Timeslot__c>();

        for(AggregateResult CommSlot : aggregateListForCommercial)
        {

            Id CommId = (Id) CommSlot.get('GenericLookup__Commercial_fld__c');

            Commercial__c commObj = commMap.get(CommId);

            Decimal sumScheduled = (Decimal)CommSlot.get('CSum');

            commObj.GenericLookup__Broadcasts_Scheduled__c = sumScheduled;

            updatedCommercialVals.add(commObj);
        
        }

        for(AggregateResult CommSlotTime : aggregateListForTimeslot)
        {
            Id TimeSlotId = (Id) CommSlotTime.get('GenericLookup__Timeslot_fld__c');

            Timeslot__c timeslotObj = timeSlotMap.get(TimeSlotId);

            timeslotObj.GenericLookup__Scheduled_Commercial_Time__c = (Decimal)CommSlotTime.get('TSum');

            system.debug('Update Sum : ' + (Decimal)CommSlotTime.get('TSum'));

            updatedTimeslotVals.add(timeslotObj);

        }
        
        if(updatedCommercialVals.size() > 0)
        {
            Database.SaveResult[] srCommercialList = Database.update(updatedCommercialVals, false);
            for (Database.SaveResult srComm : srCommercialList) {
                if (srComm.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Commercial. Commercial ID: ' + srComm.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : srComm.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Commercial fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        if(updatedTimeslotVals.size() > 0)
        {

            Database.SaveResult[] srTimeslotList = Database.update(updatedTimeslotVals, false);
            for (Database.SaveResult srTimeslot : srTimeslotList) {
                if (srTimeslot.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Timeslot. Timeslot ID: ' + srTimeslot.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error errTs : srTimeslot.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(errTs.getStatusCode() + ': ' + errTs.getMessage());
                        System.debug('Timeslot fields that affected this error: ' + errTs.getFields());
                    }
                }
            }
        }    
	}

    private static void deleteSumOnParentObject(List<Commercial_Slot__c> oldList)
    {
        set<id> commercialIds = new set<id>();
        set<id> commercialSlotIds = new set<id>();
        set<id> timeslotIds = new set<id>();

        for(Commercial_Slot__c commslot: oldList)
        {
            commercialIds.add(commslot.GenericLookup__Commercial_fld__c);
            commercialSlotIds.add(commslot.ID);
            timeslotIds.add(commslot.GenericLookup__Timeslot_fld__c);
        }

        //Map to store commercial to update id and broadcast schedule value
        Map<Id, Commercial__c> commMap = new Map<Id, Commercial__c>([Select Id, GenericLookup__Broadcasts_Scheduled__c from Commercial__c where Id in:commercialIds]);

        //Map to store timeslot to update id and scheduled commercial time value
        Map<Id, Timeslot__c> timeSlotMap = new Map<Id, Timeslot__c>([Select Id, GenericLookup__Scheduled_Commercial_Time__c from Timeslot__c where Id in:timeslotIds]);

        //List to store Aggregate Result where commercialId is in the set and Commercial slot id is not in set
        List<AggregateResult> aggregateListForCommercial = new List<AggregateResult>();
        aggregateListForCommercial = [Select Commercial_fld__c, Sum(Number_of_Broadcasts__c) Csum from Commercial_Slot__c Where Commercial_fld__r.Id in:commercialIds AND Id not in:commercialSlotIds group by Commercial_fld__c ];

        //List to store Aggregate Result where timeslotIds is in the set
        List<AggregateResult> aggregateListForTimeslot = new List<AggregateResult>();
        aggregateListForTimeslot =  [Select Timeslot_fld__c, Sum(Total_Broadcast_Time_Text__c) Tsum from Commercial_Slot__c Where Timeslot_fld__r.Id in:timeslotIds AND Id not in:commercialSlotIds group by Timeslot_fld__c];
        


        //List to store updated values of broadcast scheduled fields
        List<Commercial__c> updatedCommercialVals = new  List<Commercial__c>();

        //List to store updated values of schedule commercial time fields
        List<Timeslot__c> updatedTimeslotVals = new List<Timeslot__c>();

        for(AggregateResult CommSlot : aggregateListForCommercial)
        {

            Id CommId = (Id) CommSlot.get('GenericLookup__Commercial_fld__c');

            Commercial__c commObj = commMap.get(CommId);

            Decimal sumScheduled = (Decimal)CommSlot.get('CSum');

            commObj.GenericLookup__Broadcasts_Scheduled__c = sumScheduled;

            updatedCommercialVals.add(commObj);
        }

        for(AggregateResult CommSlotTime : aggregateListForTimeslot)
        {
            Id TimeSlotId = (Id) CommSlotTime.get('GenericLookup__Timeslot_fld__c');

            Timeslot__c timeslotObj = timeSlotMap.get(TimeSlotId);

            timeslotObj.GenericLookup__Scheduled_Commercial_Time__c = (Decimal)CommSlotTime.get('TSum');

            system.debug('Delete Sum : ' + (Decimal)CommSlotTime.get('TSum'));

            updatedTimeslotVals.add(timeslotObj);
        }
        
        if(updatedCommercialVals.size() > 0)
        {
            Database.SaveResult[] srCommercialList = Database.update(updatedCommercialVals, false);
            for (Database.SaveResult srComm : srCommercialList) {
                if (srComm.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Commercial. Commercial ID: ' + srComm.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : srComm.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Commercial fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        if(updatedTimeslotVals.size() > 0)
        {

            Database.SaveResult[] srTimeslotList = Database.update(updatedTimeslotVals, false);
            for (Database.SaveResult srTimeslot : srTimeslotList) {
                if (srTimeslot.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Timeslot. Timeslot ID: ' + srTimeslot.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error errTs : srTimeslot.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(errTs.getStatusCode() + ': ' + errTs.getMessage());
                        System.debug('Timeslot fields that affected this error: ' + errTs.getFields());
                    }
                }
            }
        }
    }

    private static void undeleteSumOnParentObject(List<Commercial_Slot__c> newList)
    {
        //Set to store Id's of recovered commercial slots associated commercial ID
        set<id> commercialIds=new set<id>();

        set<id> timeslotIds = new set<id>();

        for(Commercial_Slot__c commslot: newList)
        {
            commercialIds.add(commslot.GenericLookup__Commercial_fld__c);
            timeslotIds.add(commslot.GenericLookup__Timeslot_fld__c);
        }

        //Map to store commercial to update id and broadcast schedule value
        Map<Id, Commercial__c> commMap = new Map<Id, Commercial__c>([Select Id, GenericLookup__Broadcasts_Scheduled__c from Commercial__c where Id in:commercialIds]);

        //Map to store timeslot to update id and scheduled commercial time value
        Map<Id, Timeslot__c> timeSlotMap = new Map<Id, Timeslot__c>([Select Id, GenericLookup__Scheduled_Commercial_Time__c from Timeslot__c where Id in:timeslotIds]);

        //List to store Aggregate Result where commercialId is in the set
        List<AggregateResult> aggregateListForCommercial = new List<AggregateResult>();
        aggregateListForCommercial = [Select Commercial_fld__c, Sum(Number_of_Broadcasts__c) Csum from Commercial_Slot__c Where Commercial_fld__r.Id in:commercialIds group by Commercial_fld__c ];
        
        //List to store Aggregate Result where timeslotIds is in the set
        List<AggregateResult> aggregateListForTimeslot = new List<AggregateResult>();
        aggregateListForTimeslot =  [Select Timeslot_fld__c, Sum(Total_Broadcast_Time_Text__c) Tsum from Commercial_Slot__c Where Timeslot_fld__r.Id in:timeslotIds group by Timeslot_fld__c];
        

        //List to store updated values of broadcast scheduled fields
        List<Commercial__c> updatedCommercialVals = new  List<Commercial__c>();

        //List to store updated values of schedule commercial time fields
        List<Timeslot__c> updatedTimeslotVals = new List<Timeslot__c>();

        for(AggregateResult CommSlot : aggregateListForCommercial)
        {

            Id CommId = (Id) CommSlot.get('GenericLookup__Commercial_fld__c');

            Commercial__c commObj = commMap.get(CommId);

            Decimal sumScheduled = (Decimal)CommSlot.get('CSum');

            commObj.GenericLookup__Broadcasts_Scheduled__c = sumScheduled;

            updatedCommercialVals.add(commObj);
        }

        for(AggregateResult CommSlotTime : aggregateListForTimeslot)
        {
            Id TimeSlotId = (Id) CommSlotTime.get('GenericLookup__Timeslot_fld__c');

            Timeslot__c timeslotObj = timeSlotMap.get(TimeSlotId);

            timeslotObj.GenericLookup__Scheduled_Commercial_Time__c = (Decimal)CommSlotTime.get('TSum');

            system.debug('Undelete Sum : ' + (Decimal)CommSlotTime.get('TSum'));

            updatedTimeslotVals.add(timeslotObj);
        }
        
        if(updatedCommercialVals.size() > 0)
        {
            Database.SaveResult[] srCommercialList = Database.update(updatedCommercialVals, false);
            for (Database.SaveResult srComm : srCommercialList) {
                if (srComm.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Commercial. Commercial ID: ' + srComm.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : srComm.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Commercial fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        if(updatedTimeslotVals.size() > 0)
        {

            Database.SaveResult[] srTimeslotList = Database.update(updatedTimeslotVals, false);
            for (Database.SaveResult srTimeslot : srTimeslotList) {
                if (srTimeslot.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Timeslot. Timeslot ID: ' + srTimeslot.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error errTs : srTimeslot.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(errTs.getStatusCode() + ': ' + errTs.getMessage());
                        System.debug('Timeslot fields that affected this error: ' + errTs.getFields());
                    }
                }
            }
        }


    }

}