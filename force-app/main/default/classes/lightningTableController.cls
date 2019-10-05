public with sharing class lightningTableController {
   
 	@AuraEnabled
    public static List<Opportunity> getAllRecords()
    {   
        return [select Id, Name, Amount, CloseDate, Account.Name, Probability, StageName, Type, LeadSource FROM Opportunity LIMIT 10];    
    }
    
    @AuraEnabled
    public static String delRecord(String recId){
       
        try{
             Delete [select Id FROM Opportunity where id =:recId];
             return 'Record Deleted';
        }Catch(DMLException e) {
            return 'Error: '+e.getDmlMessage(0);
        }
    }
  
}