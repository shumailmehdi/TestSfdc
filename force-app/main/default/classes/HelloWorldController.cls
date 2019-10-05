public with sharing class HelloWorldController {
 
    
    
 @AuraEnabled
 public static User getCurrentUser(){
        return [SELECT Id, FirstName, LastName FROM User where Id = :UserInfo.getUserId() LIMIT 1];
    }


}