@isTest
public class TestDataFactory {
    public static List<Account> createAccounts(Integer numAccts) {
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        return accts;
    }
    
    public static List<Contact> createAccountsWithContactWithSequence(Integer numContact, Decimal sequence, Account acct) {
      
        List<Contact> cons = new List<Contact>();
       
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numContact;k++) {
                cons.add(new Contact(LastName=acct.Name + ' Contact ' + k,
                                        SequenceNumber__c=sequence,
                                       AccountId=acct.Id));
            }
        // Insert all opportunities for all accounts.
        insert cons;
        return cons;
    }
    // public static List<Account> createAccountsWithContactWithoutSequence(Integer numAcct, Integer contact) {
    //     List<Contact> cons = new List<Contact>();
    //     for (Integer j=0;j<numAccts;j++) {
    //         Account acct = accts[j];
    //         // For each account just inserted, add opportunities
    //         for (Integer k=0;k<contact;k++) {
    //             cons.add(new Contact(LastName=acct.Name + ' Contact ' + k,
    //                                     SequenceNumber__c=sequence,
    //                                    AccountId=acct.Id));
    //         }
    //     }
    //     // Insert all opportunities for all accounts.
    //     insert cons;
    //     return cons;
    // }
}