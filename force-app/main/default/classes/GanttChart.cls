global with sharing class GanttChart {
    
    public String accountName { get; set; }
    public static Account account { get; set; }
    public GanttChart() { } // empty constructor
    
    @RemoteAction
    global static Account getAccounts(String accountName) {
    
        Map<Id, List<Contact>> m = new Map<Id, List<Contact>>();
        
        account = [Select Id, name, (Select Id, Name from Contacts where GenericLookup__Test_Start_Date__c != null AND GenericLookup__Test_End_Date__c != null)
                   from Account where name =:accountName];
        
       /* for (Account p : [Select Id, name, (Select Id, Name from Contacts where
						  GenericLookup__Test_Start_Date__c != null AND 
					      GenericLookup__Test_End_Date__c != null) from Account])
        {
            m.put(p.Id, p.Contacts);
        } */
        return account;
    }
    
}