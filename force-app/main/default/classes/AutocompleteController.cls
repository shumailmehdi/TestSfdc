public class AutocompleteController {

    @AuraEnabled
    public static List<sObject> getSuggestions(String sObjectType, String term, String fieldsToGet, Integer limitSize) {
        // could add in logic to remove possible duplicate fields
        String fields = fieldsToGet.length() > 0 ? ',' + fieldsToGet : ''; 
    	String soql = 
            ' SELECT Name, Id ' + String.escapeSingleQuotes(fields) +
            ' FROM '   + String.escapeSingleQuotes(sObjectType) +
            ' WHERE Name Like \'' + String.escapeSingleQuotes(term) + '%\'' +
            ' LIMIT ' + limitSize;
        
       /* String soql = 
            ' SELECT Name, Id FROM Account WHERE Name Like \'' + String.escapeSingleQuotes(term) + '%\'' +
            ' LIMIT ' + limitSize;*/
        return Database.query(soql);
    }
}