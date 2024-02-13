public class Practice12{
     public List<WrapperClass> myList;
     public List<WrapperClass> SelectedList{get;set;}
     public List<String> ListIteration{get;set;}
     public Practice12() {
     ListIteration=new String[]{'Name','Status__c','Location__c'};
     }
     public List<WrapperClass> getRecord(){
         myList=new List<WrapperClass>();
         List<SObject> RecordList=[SELECT Id, Name, Location__c, Status__c FROM
         Position__c];
     	for(SObject obj:RecordList){
     		myList.add(new WrapperClass(obj));
     }
     	return myList;
     }
     public void SelectedRecord(){
         SelectedList=new List<WrapperClass>();
         for(WrapperClass obj:myList){
          if(obj.MyCheck==true){
          	SelectedList.add(obj);
          }
     }
 }
 public class WrapperClass{
 public SObject NestObj{get;set;}
 public Boolean MyCheck{get;set;}
 public WrapperClass(SObject NestObj){
 this.NestObj=NestObj;
 }
 }
}