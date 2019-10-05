public class AccountTrgHandler{
   
    public  void onBeforeInsert(List <Account> newList , Map<Id,Account> newMap )
    {
        //Calling Insert Account Method
        InsertAccountRecord( newList , newMap);
    }

    public  void OnAfterInsert(List <Account> newList, Map<Id,Account> newMap )
    {
        CreateXMLBatch callJob = new CreateXMLBatch(newMap, null, 'Account','insert');
        ID batchprocessid = Database.executeBatch(callJob);
    }
    
    public void onBeforeUpdate(List<Account> newlist,Map<Id,Account> oldMap, Map<Id,Account> newMap)
    {
        //Calliing Update Account Method
        UpdateAccountRecord(newList,oldMap,newMap);
    }

    public void onAfterUpdate(List<Account> oldList,List<Account> newlist,Map<Id,Account> oldMap, Map<Id,Account> newMap)
    {
        CreateXMLBatch callJob = new CreateXMLBatch(newMap, oldMap, 'Account','update');
        ID batchprocessid = Database.executeBatch(callJob);
    }
    
    
    
   private static void InsertAccountRecord(List<Account> newList , Map<Id,Account> newMap)
   {	      
       	for(Account Acc : newList)
        {
            //If Checkbox A,B or C is true on New Account
            if(Acc.GenericLookup__Checkbox_A__c == true){
           		Acc.GenericLookup__Text_Picklist_A__c = getPickListValuesIntoList(Account.GenericLookup__Picklist_A__c.getDescribe());
            }
            if(Acc.GenericLookup__Checkbox_B__c == true){
				Acc.GenericLookup__Text_Picklist_B__c = getPickListValuesIntoList(Account.GenericLookup__Picklist_B__c.getDescribe());
        	}
            if(Acc.GenericLookup__Checkbox_C__c == true){
           		Acc.GenericLookup__Text_Picklist_C__c = getPickListValuesIntoList(Account.GenericLookup__Picklist_A__c.getDescribe()) +','+getPickListValuesIntoList(Account.GenericLookup__Picklist_B__c.getDescribe());  
            }
		}    
        
   }
    
    private static void  UpdateAccountRecord(List<Account> newList, Map<Id,Account> oldMap, Map<Id,Account> newMap){
        for(Account Acc : newList)
        {
           
           	Account oldAcc = oldMap.get(Acc.Id);
            //Comparing values from old account to new account
            if( oldAcc.GenericLookup__Checkbox_A__c != Acc.GenericLookup__Checkbox_A__c )
            {
                
                if(Acc.GenericLookup__Checkbox_A__c == true)
                {
                    //Populating Picklist A values in Text Picklist A if Checkbox A is true
           			Acc.GenericLookup__Text_Picklist_A__c = getPickListValuesIntoList(Account.GenericLookup__Picklist_A__c.getDescribe());
                }
                else{
                    Acc.GenericLookup__Text_Picklist_A__c = '';
                }
            }
            if( oldAcc.GenericLookup__Checkbox_B__c != Acc.GenericLookup__Checkbox_B__c)
            {
                
                if(Acc.GenericLookup__Checkbox_B__c == true)
                { 
                    //Populating Picklist B values in Text Picklist B if Checkbox B is true
					Acc.GenericLookup__Text_Picklist_B__c = getPickListValuesIntoList(Account.GenericLookup__Picklist_B__c.getDescribe());
                }
                else{
                    Acc.GenericLookup__Text_Picklist_B__c = '';
                }
            }
            if(oldAcc.GenericLookup__Checkbox_C__c != Acc.GenericLookup__Checkbox_C__c)
            {
                
                if(Acc.GenericLookup__Checkbox_C__c == true ){
                    //To Populate the value of Picklist A and Picklist B in Text Picklist C field if Checkbox C is true
           			Acc.GenericLookup__Text_Picklist_C__c = getPickListValuesIntoList(Account.GenericLookup__Picklist_A__c.getDescribe()) +','+getPickListValuesIntoList(Account.GenericLookup__Picklist_B__c.getDescribe()) ;
                }  
             	else{
                    Acc.GenericLookup__Text_Picklist_C__c = '';
                }
            }
		}    
    }


    private static String getPickListValuesIntoList(Schema.DescribeFieldResult pickListDescribe)
    {
        //List to store picklist Values
        List<String> pickListValues= new List<String>();
		// String to return picklist schema
        String returnPicklistVal;
        
        Schema.DescribeFieldResult fieldValues = pickListDescribe;
        
        List<Schema.PicklistEntry> allPickListValues = fieldValues.getPicklistValues();
        //Storing picklist values into list
		for( Schema.PicklistEntry pickListVal : allPickListValues)
        {
			
            pickListValues.add(pickListVal.getLabel());

        }   
        //Joining values of picklist values in a string
       	returnPicklistVal = string.join(pickListValues,',');
        
        return returnPicklistVal;
    }
}