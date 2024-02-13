public class LeadProcessor implements 
Database.Batchable<sObject>, Database.Stateful{
    public Database.QueryLocator start(Database.BatchableContext bc){
     return  Database.getQueryLocator('Select Id,LeadSource from Lead');
    }
    public void execute(Database.BatchableContext bc,List<Lead> scope){
      	List <Lead> leads=new List<Lead>();
        for(Lead le:scope){
            le.LeadSource='Dreamforce';
        }
        update leads;
    }
    public void finish(Database.BatchableContext bc){
        
    }
}