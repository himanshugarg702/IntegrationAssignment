/**
Name:PaginationVisualforceClass
Description:In this class i have implemented getting objects from custom label and implmeneted fields functionality depending on the object

**/

public class PaginationVisualforceClass {

    public String selectedObject {get; set;} // object selected variable
 
    public List<SelectOption> resultsObjects{get;set;}  // showing all objects
    public list<String> selectedField {get; set;}  // selected field to send 2nd picklist
    public list<String> removeFields { get; set;}  // variable for getting back to first picklist from second
    //public list<String> choose { get; set;} 
    public Map<String, String> resultsFields{get;set;}
    public Map<String, String> selectedResultsFields{get;set;}
    public Map<String, Integer> fieldsResultant{get;set;}
    public Boolean remove{get;set;}  // variable for disable remove and proceed button
    public Boolean add{get;set;} // variable for disable add button
    public Boolean reset{get;set;} // variable for remove reset button
    public String query{get;set;} // variable for dynamic query
    public Boolean processShow{get;set;} // variable for showing component after proceed button
   
    
 
    public list<SelectOption> results{get;set;}
    public list<SelectOption> result2{get;set;}
    public list<String> selectedResults{get;set;}
    public String alphaSearchConct{get;set;}
    
    public String selectedOption {get;set;}
    public list<String> valuesSendComponent{get;set;}
    public list<String> labelSendComponent{get;set;}
    //contructor
    public PaginationVisualforceClass(){
        processShow=true;
       
       
        resultsObjects = new List<SelectOption>{new SelectOption('', '-- none --') };
            for(SObjectType sType: Schema.getGlobalDescribe().values()) {
                DescribeSObjectResult res = sType.getDescribe();    
                if(res.isCustom()){
                    resultsObjects.add(new SelectOption(res.getName(), res.getLabel()));
                }
            }
        String standardObject= System.Label.StandardObject;
        for(String str:standardObject.split(',')){
            resultsObjects.add(new SelectOption(str.trim(),str.trim()));
        }
        remove=true;
        reset=true;
        resultsObjects.sort();
        selectedResultsFields = new Map<String, String>();
        resultsFields = new Map<String, String>();
        fieldsResultant= new Map<String, Integer>();
    }
    /** 
     Name: FieldOptions,
     description: getting field depend on the object,
     Param:null,
     Return Type:Page Reference Null
**/
    public PageReference FieldOptions() {
                    add=false;
        processShow=true;
        query=null;
        remove=true;
        results = new List<SelectOption>{};
            reset=true;
        resultsFields = new Map<String, String>();
        if (selectedObject != null) {
            for (SObjectField sField : Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                DescribeFieldResult res = sField.getDescribe();
                if (res.isUpdateable()||res.isCreateable()||res.isCustom()) {
                    resultsFields.put(res.getLabel(),res.getName());
                    results.add(new SelectOption(res.getLabel(),res.getLabel()));
                }
            }
            reset=false;
            selectedResultsFields.clear();
        }
        result2 = new List<SelectOption>{};
            results.sort();
        fieldsResultant= new Map<String, Integer>();
        selectedField=null;
        return null;
    }
     /** 
     Name: SelectedFieldsToShow,
     description: method for showing selected field in second picklist,
     Param:null,
     Return Type:Page Reference Null
**/
   
    public PageReference SelectedFieldsToShow(){
    
        remove=false;
        for(Integer i=0;i<selectedField.size();i++){
            result2.add(new SelectOption(selectedField.get(i),selectedField.get(i)));
            for(String key : resultsFields.keySet()) {
                if (key == selectedField.get(i)) {
                    selectedResultsFields.put(key,resultsFields.get(key));
                    fieldsResultant.put(selectedField.get(i),1);
                    resultsFields.remove(key);
                    break;
                }
            }
        }
        for(Integer i=0;i<result2.size();i++){
            for(Integer j=0;j<results.size();j++){
                if(result2.get(i)==results.get(j)){
                    //if(result2[i].getValue()==results[j].getValue()){
                    results.remove(j);
                }
            }
        }
        valuesSendComponent=new list<String>();
        labelSendComponent=new list<String>();
        for(String key : selectedResultsFields.values()) {
            valuesSendComponent.add(key);
        }
        for(String key : selectedResultsFields.keySet()){
            labelSendComponent.add(key);
        }
        if(results.size()==0){
            add=true;
        }
        selectedField=null;
        return null;
    }
    
     /** 
     Name: SelectedFieldsToShow,
     description:  method for sending back to first picklist fields,
     Param:null,
     Return Type:Page Reference Null
**/
    
    public PageReference SelectedFieldRemove(){
       
              valuesSendComponent=new list<String>();
        for(Integer i=0;i<removeFields.size();i++){
            results.add(new SelectOption(removeFields.get(i),removeFields.get(i)));
            for(String key : selectedResultsFields.keySet()) {
                if (key == removeFields.get(i)) {
                    resultsFields.put(key,removeFields.get(i));
                    selectedResultsFields.remove(key);
                    fieldsResultant.remove(removeFields.get(i));
                    break;
                }
            }
        }
        
        for(Integer i=0;i<results.size();i++){
            for(Integer j=0;j<result2.size();j++){
                if(results.get(i)==result2.get(j)){
                    result2.remove(j);
                }
            }
        }
        results.sort();
        removeFields=null;
        if(result2.size()==0){
            remove=true;
        }
        if(results.size()>0){
            add=false;
        }
        valuesSendComponent = new list<String>();
        labelSendComponent = new list<String>();
        for(String key : selectedResultsFields.values()) {
            valuesSendComponent.add(key);
        }
        for(String key : selectedResultsFields.keySet()){
            labelSendComponent.add(key);
        }
        
        return null;
    }
      /** 
     Name: resetValueAction,
     description:  method for reset page,
     Param:null,
     Return Type:Page Reference Null
**/
    
    public PageReference resetValueAction(){
        selectedObject=null;
        reset=true;
        processShow=true;
        return null;
    }
    /** 
     Name: resetValueAction,
     description:  method using for showing component after process button,
     Param:null,
     Return Type:Page Reference Null
**/
    public PageReference processToComp(){
        processShow=false;
        return null;
    }

}