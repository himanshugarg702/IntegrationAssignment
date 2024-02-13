trigger AssignmentGrandChild on Grand_Child__c (After insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        AssignmentGrandChilds.handleAfterInsert(Trigger.New);
    }
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