@isTest
public class TestVerifyDate {
    
    @isTest static void returnDate2(){
        
        Date vefTrueDate = VerifyDate.CheckDates(System.today(),System.today().addDays(10)); 
        system.assertEquals(date.newInstance(2018, 6, 07), vefTrueDate);
        
    }
    
    @isTest static void returnEndOfMonth(){
        
        Date vefTrueDate = VerifyDate.CheckDates(System.today(),System.today().addDays(35)); 
        system.assertEquals(date.newInstance(2018, 5, 31), vefTrueDate);
        
    }
    
  

}