public class BatchableClassPrac implements Database.Batchable<sObject>,Database.Stateful{
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query='Select id,Name from Account';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Account> accList){
        for(Account acc:accList){
            acc.Name=acc.Name+'Hima';
        }
        try{
            update accList;
        }
        catch(Exception e){
            System.debug(e);
        }
    }
    public void finish(Database.BatchableContext bc){
        
    }
}