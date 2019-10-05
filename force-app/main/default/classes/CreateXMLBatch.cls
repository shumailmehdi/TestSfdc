global class CreateXMLBatch implements Database.Batchable<sObject> {
	
	public string objName;
	public string recordAction;
	public Map<Id,sObject> oldMap;
	public Map<Id,sObject> newMap;
	private boolean pFlag;
	global CreateXMLBatch(Map<Id, sObject> nMap, Map<Id, sObject> oMap, string sObjType, string sRecAction) {
		this.newMap = nMap;
		if(oMap != null)
		{
            this.oldMap = oMap;
		}
        this.objName = sObjType;
        this.recordAction = sRecAction;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		string query = 'SELECT Id FROM Account LIMIT 1';
		
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> accountList) {
	
		List<String> xmlStringList = new List<String>();
		List<Log_XML__c> listOfLogXML = new List<Log_XML__c>();
		List<string> fieldsList = returnFields(objName);

		for(Id setofIds:newMap.keySet())
		{
			sObject newObj = newMap.get(setOfIds);
			pFlag = true;

			Dom.Document doc =new Dom.Document();
			dom.XmlNode xmlNodeObj;

			for(String fieldName:fieldsList)
			{
				if(oldMap == null &&  newMap != null)
				{

					if(pFlag == true)
					{
						xmlNodeObj = doc.createRootElement('object',null,null);
						dom.XmlNode cParams = xmlNodeObj.addChildElement('commonparam',null,null);
						cParams.addChildElement('Change_Made_By',null,null).addTextNode(String.valueOf(newObj.get('LastModifiedById')));
                        cParams.addChildElement('Date_Time',null,null).addTextNode(String.valueOf(newObj.get('LastModifiedDate')));
                        cParams.addChildElement('Record_ID',null,null).addTextNode(String.valueOf(setOfIds));
                        cParams.addChildElement('Type',null,null).addTextNode(objName);
                        cParams.addChildElement('Record_Action',null,null).addTextNode(recordAction);
						pFlag = False;
					}

					dom.XmlNode rec = xmlNodeObj.addChildElement('record',null,null);
					string fName = StringValue(fieldName);
					rec.addChildElement('Field_Api_Name',null,null).addTextNode(fName);
					rec.addChildElement('Field_Label',null,null).addTextNode(Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe().getLabel());
					if(newObj.get(fieldName) != null)
					{
						rec.addChildElement('New_Values',null,null).addTextNode(String.valueOf(newObj.get(fieldName)));
					}
					else
					{
						rec.addChildElement('New_Values',null,null).addTextNode('');
						rec.addChildElement('Old_Values',null,null).addTextNode('');
					}
				}
				else if(oldMap != null)
				{
					sObject oldObj = oldMap.get(setOfIds);
					if(pFlag == true)
					{
						xmlNodeObj = doc.createRootElement('object',null,null);
						dom.XmlNode cParams = xmlNodeObj.addChildElement('commonparam',null,null);
						cParams.addChildElement('Change_Made_By',null,null).addTextNode(String.valueOf(newObj.get('LastModifiedById')));
                        cParams.addChildElement('Date_Time',null,null).addTextNode(String.valueOf(newObj.get('LastModifiedDate')));
                        cParams.addChildElement('Record_ID',null,null).addTextNode(String.valueOf(setOfIds));
                        cParams.addChildElement('Type',null,null).addTextNode(objName);
                        cParams.addChildElement('Record_Action',null,null).addTextNode(recordAction);
						pFlag = false;
					}
					if(newObj.get(fieldName) != oldObj.get(fieldName))
                    {
                        string fName = StringValue(fieldName);
                        //System.debug('fname value is: '+fname);
                        dom.XmlNode rec = xmlNodeObj.addChildElement('record',null,null);
                        rec.addChildElement('Field_Api_Name',null,null).addTextNode(fName);
                        rec.addChildElement('Field_Label',null,null).addTextNode(Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe().getLabel());
                        if(newObj.get(fieldName) != null)
                            rec.addChildElement('New_Value',null,null).addTextNode(String.valueOf(newObj.get(fieldName)));
                        else
                            rec.addChildElement('New_Value',null,null).addTextNode('');
                        if(oldObj.get(fieldName) != null)
                            rec.addChildElement('Old_Value',null,null).addTextNode(String.valueOf(oldObj.get(fieldName)));
                        else
                            rec.addChildElement('Old_Value',null,null).addTextNode('');
                    }
				}
			}
			xmlStringList.add(doc.toXmlString());
		}

		for(String logXML:xmlStringList)
		{
			Log_XML__c objLogXml = new Log_XML__c();
			objLogXml.XML__c = logXml;
			listOfLogXML.add(objLogXml);
		}
		if(listOfLogXML.size() > 0)
		{
			insert listOfLogXML;
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	

	private list<String> returnFields (String ObjName)
    {
        
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(ObjName).getDescribe().Fields.getMap();
        list<string> listOfFields = new list<string>();
        for (Schema.SObjectField ftypes : fieldsMap.values())
        { 
            Schema.DescribeFieldResult fdatatype = ftypes.getDescribe();
            if (fdatatype.isCreateable() || fdatatype.isUpdateable())
            { 
                listOfFields.add(fdatatype.getName());
            }
        }
        return listOfFields; 
    }
	private String StringValue(String fName)
    {
        string str = '';
        str = String.valueOf(fName);
        if(str == '' || str == null)
            str = '';
        return str;
    }

}