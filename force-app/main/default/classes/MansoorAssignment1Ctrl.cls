public class MansoorAssignment1Ctrl {

    
     public MansoorAssignment1Ctrl(ApexPages.StandardController controller) {       
                   
        
    }
    
    public void getAllAccount(){
       List<Account> allAccountList = new List<Account>();
       allAccountList = [Select Id, Name, BillingStreet, BillingPostalCode, BillingCity, BillingState, BillingCountry From Account Where BillingStreet != Null Limit 1000];
            
       System.debug(allAccountList);
    }
}