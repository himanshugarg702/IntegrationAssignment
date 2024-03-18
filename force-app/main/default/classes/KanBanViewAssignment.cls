/**
Name:KanBanViewAssignment
Description:In this class implemented getting objects from custom label and implmeneted fields functionality depending on the object and getting records 
            on the basis of selected field to show kanban view
**/
public class KanBanViewAssignment {
     /** 
     Name: allObject,
     description: getting object from schema class,
     Param:null,
     Return Type:Map<String,String>
    **/
    @AuraEnabled 
    public static Map<String,String> allObject() {
        Map<String,String> listOfObject = new Map<String,String>();
        List<String> tempLabelName = new List<String>();
        List<String> tempApiName = new List<String>();
        for(SObjectType sType: Schema.getGlobalDescribe().values()) {
            DescribeSObjectResult res = sType.getDescribe();    
            if(res.isCustom()){
                tempLabelName.add(res.getLabel());
                tempApiName.add(res.getName());
            }
        }
        String standardObject = System.Label.StandardObject;
        for(String str:standardObject.split(',')) {
            tempLabelName.add(str.trim());
            tempApiName.add(str.trim());
        }
        tempApiName.sort();
        tempLabelName.sort();
        for(Integer i=0;i<tempApiName.size();i++) {
            listOfObject.put(tempApiName.get(i),tempLabelName.get(i));
        }
        if(listOfObject.size()>0) {
            return listOfObject;
        }
        return null;
    }
    /** 
     Name: allFields,
     description: getting field depend on the object,
     Param:Selected Object ,
     Return Type:Map<String,String>
    **/
    @AuraEnabled
    public static Map<String,String> allFields(String selectedObject) {
        Map<String,String> listOfField = new Map<String,String>();
        if (selectedObject != null) {
            for (SObjectField sField : Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                DescribeFieldResult res = sField.getDescribe();
                String fldType = string.valueOf(res.getType());
                // && fldType != 'PICKLIST'
                    if ((res.isUpdateable()||res.isCreateable()||res.isCustom())) {
                    listOfField.put(res.getName(),res.getLabel());
                }
            }
        }
        return listOfField;
    }
    /** 
     Name: pickListFields,
     description: getting only picklist field on the basis of selected object,
     Param:Selected Object ,
     Return Type:Map<String,String>
    **/
    @AuraEnabled
    public static Map<String,String> pickListFields(String selectedObject) {
        Map<String,String> listOfField = new Map<String,String>();
       
        if (selectedObject != null) {
            for (SObjectField sField : Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                DescribeFieldResult res = sField.getDescribe();
                String fldType = string.valueOf(res.getType());
                if (res.isGroupable() && res.isUpdateable() && fldType == 'PICKLIST') {
                    listOfField.put(res.getName(),res.getLabel());
                }
            }
        }
        return listOfField;
    }
    /** 
     Name: getPickVals,
     description: getting records on the basis of selected fields and selected picklist fields,
     Param:picklist field,selected Object, selected Fields
     Return Type:KanbanViewWrapperClass
    **/
    @AuraEnabled
    public static KanbanViewWrapperClass getPickVals(String fieldName, String selectedObject,List<String> selectedField){
        String apiName=fieldName;
        List<String> plist = new List<String>();

        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().get(apiName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            plist.add(f.getValue());
        }       	
        String query = 'SELECT Id,';
        for(String s:selectedField){
            query += s+',';
        }
        query = query.removeEnd(',');
        query += ' FROM ' + selectedObject;        
        return new KanbanViewWrapperClass(Database.query(query), plist);   
    }
    /** 
     Name: getUpdateStage,
     description: updating record after the drop of card,
     Param:picklist selected Object, record id,picklist field, picklist field new value
     Return Type:KanbanViewWrapperClass
    **/
    @AuraEnabled
    public static String getUpdateStage(String selectedObject,Id recId, String kanbanField, String kanbanNewValue) {
        SObject o1 = recId.getSObjectType().newSObject(recId);
        o1.put(kanbanField,kanbanNewValue);
        update o1;
        return 'Success';
    }
  
 /** 
     Name: KanbanViewWrapperClass,
     description: class for getting picklist values and records
    **/
    public class KanbanViewWrapperClass{
        @AuraEnabled
        public List<sObject> records {get;set;}
        @AuraEnabled
        public List<String> pickValues {get;set;}
        public KanbanViewWrapperClass(List<sObject> records, List<String> pickValues){
            this.records = records;
            this.pickValues = pickValues;
        }
    }
}