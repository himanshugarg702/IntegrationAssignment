/**
Name:clientSidePagination
Description:In this class implemented getting objects from custom label and implmeneted fields functionality depending on the object and getting records 
            on the basis of selected field
**/
public with sharing class clientSidePagination {
      /** 
     Name: allObject,
     description: getting object from schema class,
     Param:null,
     Return Type:Map<String,String>
    **/
    @AuraEnabled
    public static Map<string,string> allObject(){
        Map<String,String> listOfObject=new Map<String,String>();
        List<String> tempLabelName = new List<String>();
        List<String> tempApiName = new List<String>();
        for(SobjectType sType:Schema.getGlobalDescribe().values())  {
            DescribeSObjectResult res=sType.getDescribe();
            if(res.isCustom())  {
                tempLabelName.add(res.getLabel());
                tempApiName.add(res.getName());
            }
        }
        String standardObject=System.Label.standardObject;
        for(String str:standardObject.split(','))   {
            tempLabelName.add(str.trim());
            tempApiName.add(str.trim());
        }
        tempApiName.sort();
        tempLabelName.sort();
        for(Integer i=0;i<tempApiName.size();i++){
            listOfObject.put(tempApiName.get(i),tempLabelName.get(i));
        }
        if(listOfObject.size()>0){
            return listOfObject;
        }
      return null;
    }
    /** 
     Name: allFields,
     description: getting field depend on the object,
     Param:Selected Object ,
     Return Type:map<String,String>
    **/
    @AuraEnabled
    public static Map<String,String> allFields(String selectedObject){
        Map<String,String> listOfField = new Map<String,String>();
        if (selectedObject != null) {
            for (SObjectField sField : Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                DescribeFieldResult res = sField.getDescribe();
                if (res.isUpdateable()||res.isCreateable()||res.isCustom()) {
                    listOfField.put(res.getName(),res.getLabel());
                }
            }
        }
        return listOfField;
    }
    /** 
     Name: getRecords,
     description: getting records depending on the selected fields,
     Param:Selected selectedObject,selectedFields ,
     Return Type:map<String,String>
    **/
    @AuraEnabled
    public static List<sObject> getRecords(String selectedObject,List<String> selectedField){
        
        String allFieldsForQuery = '';
        for(Integer i = 0;i<selectedField.size();i++){
           if(i==selectedField.size()-1){
                allFieldsForQuery+=selectedField.get(i)+' ';
            }
           else{
                allFieldsForQuery+=selectedField.get(i)+',';
            }
        }
        list<sObject> sobjectRecords = Database.query('SELECT '+allFieldsForQuery+' FROM '+selectedObject);
        return sobjectRecords;
    }
}