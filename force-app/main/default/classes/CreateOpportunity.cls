public class CreateOpportunity {
    
    //This methods returns active stagename values
    @AuraEnabled
    public static List<String> getStageName(){
       List<String> activeStages = new List<String>();
       
       List<OpportunityStage> stages = [select Id, ApiName from OpportunityStage where IsActive = true];
        for(OpportunityStage Os : stages){
            activeStages.add(Os.ApiName);
       }        
        return activeStages;
    }
    
    //This method returns general picklist values
    @AuraEnabled
    public static List<String> getPickListValues(String objectName, String fieldName) {
        List<String> picklistValueList=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
          for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            picklistValueList.add(a.getValue());//add the value  to our final list
          }
       return picklistValueList;
    }
    
    //This methods update and insert all fields
     @AuraEnabled 
    public static Opportunity saveOpportunity(Opportunity opportunity) {
        // Perform isUpdatable() checking first, then
        //upsert opportunity;
        insert opportunity;
        return opportunity;
    }
    
}