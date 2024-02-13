public class AssignmentGrandChilds {
    
    public static void handleAfterInsert(List<Grand_Child__c> grand){
        // taking set for getting contact id from grandchild
        Set<Id> contactIds = new Set<Id>();
	for(Grand_Child__c grandchild : grand){
		contactIds.add(grandchild.contact__c);
	}
        // map for getting contact id from contact same associated with grandchild
	Map<Id,Contact> parentRecords = new Map<Id,Contact>([Select Account.Rating from contact where id = :contactIds]);
	Set<Id> grandParentIds = new Set<Id>();
	for(Contact contactRecord : parentRecords.values()){
		grandParentIds.add(contactRecord.accountId);
	}
        // map for getting account id from account same associated with contact
	Map<Id,Account> accountRecords = new Map<Id,Account>([Select id,Rating from Account where id =: grandParentIds]);
	for(Grand_Child__c child : grand){
		if(parentRecords.containsKey(child.contact__c) && accountRecords.containsKey(parentRecords.get(child.contact__c).accountid)){
			accountRecords.get(parentRecords.get(child.contact__c).accountId).Rating = child.Rating__c;
		}
	}
	update accountRecords.values();
        
        
      /*  for(Grand_Child__c gc:grandChild){
            if(gc.contact__c!=null){
                System.debug(gc.contact__c);
             Contact c=[select Account.Rating from contact where id = :gc.contact__c];
                System.debug(c.Account.Rating);
                System.debug(gc.Rating__c);
                Account a=c.Account;
                a.Rating=gc.Rating__c;
                update a;
            }
        }*/
    }
}