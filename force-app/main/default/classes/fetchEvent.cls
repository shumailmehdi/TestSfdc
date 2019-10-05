public class fetchEvent {
    
 @AuraEnabled
 public static list<Event> getAllEvent(string startDate, string endDate){
     
     date eventStart = date.valueOf(startDate);
     date eventEnd = date.valueOf(endDate);
      //date.parse(endDate);
     //system.debug('::'+[SELECT ActivityDate, Subject FROM Event where ActivityDate >:eventStart AND ActivityDate <:eventEnd]);
        return [SELECT ActivityDate, Subject FROM Event where ActivityDate >:eventStart AND ActivityDate <:eventEnd];
            //[SELECT ActivityDate, Subject FROM Event ];
    }



}