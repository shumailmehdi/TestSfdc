public class MansoorAssignement2Ctrl {

    public Cont_Variable__c context { get; set; }
    public String selectedField {get; set;}
    public string objectVarName{get;set;}
    public String selectObj = 'Account';
    public String getsel()
    {
        return selectObj;
    }
    public String DataType;
    public String getDataType()
    {
        return DataType;
    }
    public String DefaultValue {get;set;}
    public String selectedObj {get; set;}
    public PageReference Cancel()
    {
        PageReference page = new PageReference('/a0R/o');
        page.setRedirect(true);
        return page;
    }
    //Method that will set selected object.
    public void ObjectValue()
    {
        if(selectedObj == 'Account')       
        {      
            selectObj = 'Account';     
        }
        if (selectedObj =='Opportunity')  
        {     
            selectObj = 'Opportunity';        
        }
        DataType = '' ;
    }
    //Method will return objects in Select list
    public List<SelectOption> getObjectNames() 
    {
        List<SelectOption> objNames = new List<SelectOption>();
        objNames.add(new SelectOption('Account','Account'));
        objNames.add(new SelectOption('Opportunity','Opportunity'));
        
        return objNames;
    }
    //Method will return object data types
    public List<SelectOption> getFieldsVal()
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get(selectObj);
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        
        List<SelectOption> fieldNames = new List<SelectOption>();
        for (String fieldName: fieldMap.keySet()) 
        {  
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType(); 
            if(fielddataType == Schema.DisplayType.String || fielddataType == Schema.DisplayType.Currency)
                fieldNames.add(new SelectOption(fieldName,fieldName));
        }
        return fieldNames;
        
    }
    //Method will set Data Type of selected field and Default value.
    public void ReturnFieldDataType()
    {
        String objectName = String.valueOf(selectObj); //Get object Name
        String fieldName = String.valueOf(selectedField); //Get Selected Field
        
        SObjectType objectType = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = objectType.getDescribe();
        DataType = String.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());
        DefaultValue=String.valueOf(d.fields.getMap().get(fieldName).getDescribe().getDefaultValueFormula()); 
        
    }
    public PageReference saveAndRedirect() {
      save();
      PageReference redirectPage = new PageReference('/a0R/o');  
      redirectPage.setRedirect(true);
      return redirectPage;
    }
    
    
    //Insert Cont Variable record.
    public void Save()               
    {
        String objectName = String.valueOf(selectObj);
        String fieldName = String.valueOf(selectedField);
        Cont_Variable__c contextvar = new Cont_Variable__c();
        contextvar.Name = objectVarName;
        contextvar.ObjName__c = objectName;
        contextvar.Variable_Value__c = fieldName;
        contextvar.DataType__c = DataType;
        contextvar.Default_Value__c = DefaultValue;
        insert contextvar;   
    }
}