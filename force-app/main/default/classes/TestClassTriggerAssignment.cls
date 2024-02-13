@isTest
public class TestClassTriggerAssignment{

    // @TestSetup
    // static void makeData(){
    //     Account acc=new Account(Name='hima');
    //     insert acc;
    //     for(Integer i=0;i<5;i++)
    //     Contact c=new Contact(LastName='hima', AccountId=acc.id,);
    //     insert c;
    // }

    @isTest
    static void testInsert() {

        list<Account> acc = TestDataFactory.createAccounts(1);
        list<Contact> con=TestDataFactory.createAccountsWithContactWithSequence(2,1,acc[0]);
            System.assertEquals(con[0].SequenceNumber__c, 1);
            con=TestDataFactory.createAccountsWithContactWithSequence(1,1,acc[0]);
            System.assertEquals(con[0].SequenceNumber__c, 1);
            con=TestDataFactory.createAccountsWithContactWithSequence(10,1,acc[0]);
            for(Integer i=0;i<con.size();i++){
                System.assertEquals(con[i].SequenceNumber__c, 1);
            }


                //    list<Contact> cont = TestDataFactory.createAccountsWithContactWithSequence(2,1,acc[0]);
                //   con=[select id,SequenceNumber__c from contact where AccountId=:acc[0].id];
                //   System.assertEquals(con[0].SequenceNumber__c, 1);


        // Account acc=new Account(Name='hima');
        // insert acc;
        // Contact c=new Contact(LastName='hima', AccountId=acc.id);
        // insert c;
        //  list<Contact> accListContacts=[select id,SequenceNumber__c from contact where AccountId = :acc.id ];
        // System.assertEquals(accListContacts[0].SequenceNumber__c, 1);
        // Contact ct=new Contact(LastName='hima2', AccountId=acc.id,SequenceNumber__c=1);
        // insert ct;
        //   accListContacts=[select id,SequenceNumber__c from contact where AccountId = :acc.id ];
        //   System.assertEquals(accListContacts[0].SequenceNumber__c, 1);

    }
    // @isTest
    // static void testInsert1() {
    //     list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account ];
    //     Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
    //     for(Account acc:accListContacts){
    //         changeContactDataFromDataBase.put(acc.id,acc.contacts);
    //     }
    //     Contact ct=new Contact(LastName='hima1',AccountId='0015g00001VZ47h');
    //     insert ct;
    // }
    @isTest
    static void testDelete() {
        list<Account> acc = TestDataFactory.createAccounts(1);
        list<Contact> con=TestDataFactory.createAccountsWithContactWithSequence(2,1,acc[0]);
               Contact  co=[select id,SequenceNumber__c from contact where Accountid = :acc[0].id limit 1];
                 delete co;
    }
      @isTest
    static void testUnDelete() {
        list<Account> acc = TestDataFactory.createAccounts(1);
        list<Contact> con=TestDataFactory.createAccountsWithContactWithSequence(2,1,acc[0]);
           Contact  co=[select id,SequenceNumber__c from contact where Accountid = :acc[0].id limit 1];
            delete co;
            Contact  cot=[select id,SequenceNumber__c,isDeleted from contact where isDeleted=true OR Accountid = :acc[0].id limit 1 All Rows];
        if(cot.isDeleted==true){
                     Undelete cot;
        }
    }
    @isTest
    static void testUpdate() {
        list<Account> acc = TestDataFactory.createAccounts(2);
        list<Contact> con=TestDataFactory.createAccountsWithContactWithSequence(2,1,acc[0]);
           Contact  co=[select id,SequenceNumber__c from contact where Accountid = :acc[0].id limit 1];
           co.AccountId=acc[1].id;
        update co;
        con=TestDataFactory.createAccountsWithContactWithSequence(2,1,acc[0]);
        con[0].SequenceNumber__c=0;
        update con[0];
    }
     @isTest
    static void testUpdate1() {
        list<Account> acc = TestDataFactory.createAccounts(1);
        list<Contact> con=TestDataFactory.createAccountsWithContactWithSequence(10,1,acc[0]);
           con[4].SequenceNumber__c=3;
        update con;
    }
     @isTest
    static void testUpdate2() {
        list<Account> acc = TestDataFactory.createAccounts(1);
        list<Contact> con=TestDataFactory.createAccountsWithContactWithSequence(10,1,acc[0]);
           con[6].SequenceNumber__c=9;
        update con;
    }
}