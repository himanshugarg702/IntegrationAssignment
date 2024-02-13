/**
Name:TriggerAssignmentSequenceNumber
Description:In this class i have created one field in contact object sequence number 
then i implemented insertion of records and updation of records according records inserted and updation

**/
public class TriggerAssignmentSequenceNumber {
    public static Boolean runOnce = true;// for handle recursiveness
    /** 
        Name: handleBeforeInsert,
        description: This method will run when records will inserted,
        Param:null,
        Return Type:void
    **/
    public static void handleBeforeInsert(List<Contact> listOfContacts) {
        runOnce = false;
        set<id> AccountIds = new set<id>();
        for(Contact con:listOfContacts){                                                                                                                                                                                                                                                        
                AccountIds.add(con.AccountId);                
        }
        list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
        Map<Id,list<Contact>> changeContactDataFromDataBase = new Map<Id,list<Contact>>();
        for(Account acc:accListContacts) {
            changeContactDataFromDataBase.put(acc.id,acc.contacts);
        }
        for(Contact con:listOfContacts) {
            if(con.AccountId!=null) {
                if(con.SequenceNumber__c==null||con.SequenceNumber__c<1||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()) {
                    changeContactDataFromDataBase.get(con.AccountId).add(con);
                }
                else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()) {
                    changeContactDataFromDataBase.get(con.AccountId).add((Integer)con.SequenceNumber__c-1,con);
                }
            }
        }
        list<Contact> ans=new list<Contact>();
        for(list<Contact> ct:changeContactDataFromDataBase.values()) {
            for(Integer i=0;i<ct.size();i++) {
                    ct.get(i).SequenceNumber__c=i+1;
                    if(ct.get(i).id!=null) {
                        ans.add(ct.get(i));
                    }
                }
        }
        if(ans.size()>0) {
            update ans;
        }
        runOnce = true;
    }
    /**
         Name: handleBeforeUpdate,
        description: This method will run when records will updated,
        Param:null,
        Return Type:void
    **/
    public static void handleBeforeUpdate(Map<id,Contact> listOfContacts,Map<id,Contact> conMap) {
        runOnce=false;
        Map<Id,Contact> tempOldMap=conMap.clone();
        Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
        Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
        set<id> AccountIds=new set<id>();
        for(Contact con:listOfContacts.values()) {                                                                                                                                                                                                                                                        
            if(!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)) {
                mapToStoreAccountIDAssociatedContacts.put(con.AccountId,new List<Contact>());
                tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
                AccountIds.add(con.AccountId);                
            }
            mapToStoreAccountIDAssociatedContacts.get(con.Accountid).add(con);
        }
        for(Id oldId:conMap.keySet()) {
            AccountIds.add(conMap.get(oldId).AccountId);
        }
        Integer countNewParent=0;
        Integer i=0;
        list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
        Map<Id,list<Contact>> changeContactDataFromDataBase = new Map<Id,list<Contact>>();
        for(Account acc:accListContacts) {
            changeContactDataFromDataBase.put(acc.id,acc.contacts);
        }
        Map<Id,Contact> temp = new Map<Id,Contact>();
        Map<Id,Contact> answerToReturn = new Map<Id,Contact>();
        
        for(Contact con:listOfContacts.values()) {
            if(con.AccountId!=null) {
                if(con.AccountId!=conMap.get(con.id).AccountId) {
                    for(Integer j=0;j<changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).size();j++) {
                        if(changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).SequenceNumber__c>con.SequenceNumber__c) {
                            changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).SequenceNumber__c-1;
                            if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).id)) {
                                answerToReturn.put(changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).id,changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j));
                            }
                        }
                    }
                    Integer tempInteger=changeContactDataFromDataBase.get(con.AccountId).size()+1;
                    changeContactDataFromDataBase.get(con.AccountId).add(con);//check
                    con.SequenceNumber__c=tempInteger;
                }
                else if(con.SequenceNumber__c==null||con.SequenceNumber__c<1||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()) {
                    for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++) {
                        if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=tempOldMap.get(con.id).SequenceNumber__c) {
                            changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1;
                            if(tempOldMap.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)) {
                                tempOldMap.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
                            }
                            if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)) {
                                answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
                            }
                        }
                    }
                
                    tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
                    con.SequenceNumber__c = changeContactDataFromDataBase.get(con.Accountid).size();
                }
                else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()) {
                    boolean tempBool = true;
                    for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++) {    
                        if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>tempOldMap.get(con.id).SequenceNumber__c&&changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c<=con.SequenceNumber__c) {
                            changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c = changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1;
                            
                            changeContactDataFromDataBase.get(con.AccountId).set((Integer) changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1,changeContactDataFromDataBase.get(con.AccountId).get(j));                        
                            if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)) {
                                answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
                            }
                        }
                        else if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c<tempOldMap.get(con.id).SequenceNumber__c&&changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=con.SequenceNumber__c) {
                            changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c = changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c+1;    
                            tempBool = false;
                            if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)) {
                                answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
                            }
                        }
                            if(tempOldMap.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)) {
                                tempOldMap.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
                            }
                    }
                    if(tempBool==true) {
                    changeContactDataFromDataBase.get(con.AccountId).set((Integer)con.SequenceNumber__c-1,con);
                    }
                    if(tempBool==false) {
                        changeContactDataFromDataBase.get(con.AccountId).remove((Integer)conMap.get(con.id).SequenceNumber__c-1);
                        changeContactDataFromDataBase.get(con.AccountId).add((Integer)con.SequenceNumber__c-1,con);
                    }
                }
            }
        }
        
        if(answerToReturn.size()>0){
            update answerToReturn.values();
        }
        runOnce = true;
    }   
    /** 
         Name: handleAfterDelete,
        description: This method will run when records will Deleted,
        Param:null,
        Return Type:void
    **/
    public static void handleAfterDelete(list<Contact> listOfContacts) {
        runOnce = false;
        set<id> AccountIds = new set<id>();
        for(Contact con : listOfContacts) {
                AccountIds.add(con.AccountId);                
        }
        list<Account> accListContacts = [select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountIds ];
            Map<Id,list<Contact>> changeContactDataFromDataBase = new Map<Id,list<Contact>>();
            for(Account acc:accListContacts){
                changeContactDataFromDataBase.put(acc.id,acc.contacts);
            }
            Map<Id,Contact> answerToReturn=new Map<Id,Contact>();
            for(Id con:AccountIds) {
                    for(Integer j=0;j<changeContactDataFromDataBase.get(con).size();j++) {
                        changeContactDataFromDataBase.get(con).get(j).SequenceNumber__c=j+1;
                        answerToReturn.put(changeContactDataFromDataBase.get(con).get(j).id,changeContactDataFromDataBase.get(con).get(j));
                    }
                }
            if(answerToReturn.size()>0) {
                update answerToReturn.values();
            }
            runOnce=true;
    }
    /** 
     Name: handleAfterUndelete,
    description: This method will run when records will UnDeleted,
    Param:null,
    Return Type:void
    **/
    public static void handleAfterUndelete(list<Contact> listOfContacts) {
        Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
        Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
        set<id> AccountIds=new set<id>();
        for(Contact con:listOfContacts) {
            if(!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)) {
                mapToStoreAccountIDAssociatedContacts.put(con.AccountId,new List<Contact>());
                tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
                AccountIds.add(con.AccountId);                
            }
            mapToStoreAccountIDAssociatedContacts.get(con.Accountid).add(con);
        }
        
        Integer tempIterate=0;
        list<Account> accListContacts=[select id ,(select id from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountIds ];
        Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
            for(Account acc:accListContacts) {
                changeContactDataFromDataBase.put(acc.id,acc.contacts);
            }
            Map<Id,Contact> answerToReturn=new Map<Id,Contact>();
            for(Contact con:listOfContacts) {
                tempIterate=changeContactDataFromDataBase.get(con.AccountId).size()-mapToStoreAccountIDAssociatedContacts.get(con.AccountId).size();
                if(tempIterate<0) {
                    tempIterate=0;
                }
                for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++) {
                        if(con.AccountId!=null&&changeContactDataFromDataBase.containsKey(con.AccountId)&&con.id==changeContactDataFromDataBase.get(con.AccountId).get(j).id) {    
                            changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=tempIterate+tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()+1;   
                            tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
                            answerToReturn.put(con.id,changeContactDataFromDataBase.get(con.AccountId).get(j));
                            break;
                        } 
                }
            }
        if(answerToReturn.size()>0) {
            update answerToReturn.values();
        }
    }  
}