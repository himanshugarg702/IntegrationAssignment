public class MainAssign2 {
    public static Boolean runOnce = true;
    public static void handleBeforeInsert(List<Contact> listOfContacts){
            runOnce=false;
        set<id> AccountIds=new set<id>();
        for(Contact con:listOfContacts){                                                                                                                                                                                                                                                        
                AccountIds.add(con.AccountId);                
        }
        list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
        Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
        for(Account acc:accListContacts){
            changeContactDataFromDataBase.put(acc.id,acc.contacts);
        }
        for(Contact con:listOfContacts){
            if(con.AccountId!=null){
                if(con.SequenceNumber__c==null||con.SequenceNumber__c<1||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()){
                    changeContactDataFromDataBase.get(con.AccountId).add(con);
                }
                else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()){
                    changeContactDataFromDataBase.get(con.AccountId).add((Integer)con.SequenceNumber__c-1,con);
                }
            }
        }
        list<Contact> ans=new list<Contact>();
            for(list<Contact> ct:changeContactDataFromDataBase.values()){
            // ans.addAll(ct);
           for(Integer i=0;i<ct.size();i++){
                ct.get(i).SequenceNumber__c=i+1;
                if(ct.get(i).id!=null){
                    ans.add(ct.get(i));
                }
            }
            }
        update ans;
        runOnce = true;
    }
    public static void handleBeforeUpdate(Map<id,Contact> listOfContacts,Map<id,Contact> conMap){
        // Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
        // Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
        // Map<Id,Contact> newContactList=new 
          runOnce=false;
        set<id> AccountIds=new set<id>();
        for(Contact con:listOfContacts.values()){                                                                                                                                                                                                                                                        
        // if(!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)){
            // mapToStoreAccountIDAssociatedContacts.put(con.AccountId,new List<Contact>());
            // tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
            AccountIds.add(con.AccountId);                
        // }
            // mapToStoreAccountIDAssociatedContacts.get(con.Accountid).add(con);
        }
        for(Id oldId:conMap.keySet()){
        
            AccountIds.add(conMap.get(oldId).AccountId);
        }
        Integer countNewParent=0;
        // Integer i=0;
        list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
            // System.debug(accListContacts);
        Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
        for(Account acc:accListContacts){
            changeContactDataFromDataBase.put(acc.id,acc.contacts);
        }
        Map<Id,Contact> temp=new Map<Id,Contact>();
        Map<Id,Contact> answerToReturn=new Map<Id,Contact>();
        //  for(Contact con:listOfContacts.values()){
        //     if(con.AccountId!=null){
        //     if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()||con.SequenceNumber__c<0){
        //         System.debug('hello');
        //         con.SequenceNumber__c=changeContactDataFromDataBase.get(con.Accountid).size();
        //         for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
        //             if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>conMap.get(con.id).SequenceNumber__c||listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
        //                 System.debug('hello3');
        //                 changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1;
        //                 if(listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
        //                     changeContactDataFromDataBase.get(con.AccountId).set(changeContactDataFromDataBase.get(con.Accountid).size()-1,con);
        //                 }
        //                 // temp.get(changeContactDataFromDataBase.get(con.AccountId).get(j).id).SequenceNumber__c=temp.get(changeContactDataFromDataBase.get(con.AccountId).get(j).id).SequenceNumber__c-1;
                        
        //                 if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
        //                     answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
        //                 }
        //             }
        //             // list.set(2, "E");
        //             // changeContactDataFromDataBase.get(con.AccountId).set((Integer)con.SequenceNumber__c-1,con);
        //         }
                
        //         tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
        //         // con.SequenceNumber__c=changeContactDataFromDataBase.get(con.Accountid).size();
        //         // temp.put(con.id,con);
        //     }
        for(Contact con:listOfContacts.values()){
            if(con.AccountId!=null){
                if(con.AccountId!=conMap.get(con.id).AccountId){
                    changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).remove((Integer)conMap.get(con.id).SequenceNumber__c-1);
                    changeContactDataFromDataBase.get(con.AccountId).add(con);
                }
                else if(con.SequenceNumber__c==null||con.SequenceNumber__c<1||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()){
                    changeContactDataFromDataBase.get(con.AccountId).remove((Integer)conMap.get(con.id).SequenceNumber__c-1);
                    changeContactDataFromDataBase.get(con.AccountId).add(con);
            }
        
            else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()){
                changeContactDataFromDataBase.get(con.AccountId).remove((Integer)conMap.get(con.id).SequenceNumber__c-1);

                changeContactDataFromDataBase.get(con.AccountId).add((Integer)con.SequenceNumber__c-1,con);
            }
        }
    }
    list<Contact> ans=new list<Contact>();
    for(list<Contact> ct:changeContactDataFromDataBase.values()){
        for(Integer i=0;i<ct.size()-1;i++){
            if(ct.get(i).SequenceNumber__c+1!=ct.get(i+1).SequenceNumber__c){
                if(ct.get(i).SequenceNumber__c>ct.get(i+1).SequenceNumber__c){
                    ct.get(i).SequenceNumber__c=i+1;
                }
                ct.get(i+1).SequenceNumber__c=i+2;
            }
            // ct.get(i).SequenceNumber__c=i+1;
            if(!listOfContacts.containsKey(ct.get(i).id)){
                ans.add(ct.get(i));
            }
        }
            ct.get(ct.size()-1).SequenceNumber__c=ct.size();
            if(!listOfContacts.containsKey(ct.get(ct.size()-1).id)){
                ans.add(ct.get(ct.size()-1));
            }
    }
    update ans;
    runOnce=true;
        //  list<Contact> ans=new list<Contact>();
        //         for(list<Contact> ct:changeContactDataFromDataBase.values()){
        //            ans.addAll(ct);
        //         }
                // update answerToReturn.values();
                // runOnce=true;
                //  update answerToReturn.Values();

                // runOnce=false;
        // for(Id ctr:conMap.keySet()){
        //     System.debug(conMap.get(ctr).SequenceNumber__c);
        // }
        //         set<id> AccountId=new set<id>();
        //         for(Contact con:contact){
        //             if(con.AccountId!=null){
        //                  AccountId.add(con);
        //             }
        //         }
        //         System.debug(AccountId);
        //         Integer i=0;
        //         for(Id accId:AccountId){
        //             List<Contact> contactsAssociatedWithParticularAccount=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid =:accId order by SequenceNumber__c Asc ]);
        //             i=contactsAssociatedWithParticularAccount.size();
        //             List<Contact> temp=new List<Contact>();
        //             for(Contact con:contact){
        //                 i++;
        //                 if(con.AccountId!=null&&con.AccountId==accId){
        //                     if(con.AccountId!=conMap.get(con.id).AccountId){
        //                             //  Integer temp=i;
        //                         for(Integer j=0;j<contactsAssociatedWithParticularAccount.size();j++){
        //                             if(contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c>con.SequenceNumber__c){
        //                                 contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c=contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c-1;
        //                             }
        //                         }   
        //                         if(i!=0){
        //                             con.SequenceNumber__c=i-1;
        //                         }
        //                     //con.SequenceNumber__c=i-1;
        //                     temp.add(con);
        //                     }
        //                 }
        //             }
        //         }
    }   

//     public static void handleBeforeInsert(List<Contact> listOfContacts){
//             runOnce=false;
//             Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
//         set<id> AccountIds=new set<id>();
//         for(Contact con:listOfContacts){                                                                                                                                                                                                                                                        
//             if(!tempMapToStoreAccountIdAssociatedContacts.containsKey(con.AccountId)){
//                 tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
//                 AccountIds.add(con.AccountId);                
//             }
//         }
//         list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
//             // System.debug(accListContacts);
//         Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
//         for(Account acc:accListContacts){
//             changeContactDataFromDataBase.put(acc.id,acc.contacts);
//         }
//         // System.debug();
//         for(Contact con:listOfContacts){
//             if(con.AccountId!=null){
//                 if(con.SequenceNumber__c==null||con.SequenceNumber__c<1||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()){
//                     tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
//                     // System.debug('hello');
//                     con.SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();
                    
//                     // System.debug(con.AccountId);
//                 }
//                 else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()+tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()){
//                     // System.debug('hello');
//                         for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
//                             // System.debug(j);
//                             if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=con.SequenceNumber__c){
//                                 changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c+1;
//                             }
//                         }   
//                         // System.debug(answerToReturn);
//                         for(Integer i=0;i<tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();i++){
//                             // System.debug('hello');
//                             if(tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c>=con.SequenceNumber__c){
//                                 tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c=tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c+1;
//                             }
//                         }
//                         tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
//                 }
//             }
//         }
//         list<Contact> ans=new list<Contact>();
//             for(list<Contact> ct:changeContactDataFromDataBase.values()){
//             ans.addAll(ct);
//             }
//         update ans;
//         runOnce = true;
//    }
    //         // set<id> AccountId=new set<id>();
    //     //     // for(Contact con:contact){
    //     //     // if(con.AccountId!=null){
    //     //     //     AccountId.add(con.AccountId);
    //     //     // }
    //     //     // }
    //     //     // Integer i=0;
    //     //     // //  list<Account>acc=[select id ,(select id from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountId];
    //     //     // //  System.debug(acc.contacts);
    //     //     // // // Integer k=1;
    //     //     // //  Integer k=1;
    //     //     // // for(Contact a:acc[i].contacts){
    //     //     // // }
        
    //     //     // for(Id accId:AccountId ){
    //     //     //     List<Contact> contactsAssociatedWithParticularAccount=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid =:accId order by SequenceNumber__c Asc ]);
            
    //     //     //       List<Contact> temp=new List<Contact>();
    //     //     //     i=contactsAssociatedWithParticularAccount.size();
    //     //     //     for(Contact con:contact){
    //     //     //         if(con.AccountId!=null&&con.AccountId==accId){
    //     //     //             i++;
    //     //     //             if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>i-1||con.SequenceNumber__c<0){
    //     //     //                 con.SequenceNumber__c=i;
    //     //     //                 temp.add(con);
    //     //     //             }
    //     //     //             else if(con.SequenceNumber__c<i){
    //     //     //                 for(Integer j=0;j<contactsAssociatedWithParticularAccount.size();j++){
    //     //     //                     System.debug(j);
    //     //     //                     if(contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c>=con.SequenceNumber__c){
    //     //     //                         contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c=contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c+1;
    //     //     //                     }
    //     //     //                 }   
    //     //     //                 for(Integer k=0;k<temp.size();k++){
    //     //     //                     if(temp.get(k).SequenceNumber__c>=con.SequenceNumber__c){
    //     //     //                     temp.get(k).SequenceNumber__c=temp.get(k).SequenceNumber__c+1;
    //     //     //                     }
    //     //     //                 }
    //     //     //                 temp.add(con);
    //     //     //                 update contactsAssociatedWithParticularAccount;
    //     //     //                 runOnce = true;
    //     //     //             }
    //     //     //         }
    //     //     //     }
    //     //     // }
    //     //     // System.debug(AccountId);
    //     //     // Integer i=0;
    //     //     // // List<Contact> AccountId=new List<Contact>([])
    //     //     //  List<Contact> AccountIds=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid = '0015g00001Va8FO']);
    //     //     //  System.debug(AccountIds);
    //     //     // // i=AccountIds.size();
    //     //     // for(Contact con : contact){
    //     //     // if(con.AccountId!=null){
        
    //     //     // }
    //     //     // }
    // }
    // public static void handleBeforeInsert(List<Contact> listOfContacts){
    //     // System.debug(listOfContacts.size());
    //     // System.debug('hello');
    //     runOnce=false;
    //     Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
    //     Map<Id,Map<Decimal,Contact>> changeContactDataFromDataBase =new Map<Id,Map<Decimal,Contact>>();
    //     set<id> AccountIds=new set<id>();
    //     for(Contact con:listOfContacts){                                                                                                                                                                                                                                                        
    //         if(!tempMapToStoreAccountIdAssociatedContacts.containsKey(con.AccountId)){
    //             changeContactDataFromDataBase.put(con.AccountId,new Map<Decimal,Contact>());
    //             tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
    //             AccountIds.add(con.AccountId);                
    //         }
    //     }
    //     // list<Contact> accListContacts=[SELECT id,SequenceNumber__c,AccountId from contact where Accountid in :AccountIds  order by SequenceNumber__c ];
    //     list<Account> accListContacts=[select id ,(select id,SequenceNumber__c,AccountId from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
    //         // System.debug(accListContacts);
    //     // Map<Id,Map<Decimal,Contact>> changeContactDataFromDataBase =new Map<Id,Map<Decimal,Contact>>();
    //     // System.debug(accListContacts.size());

       
    //     // System.debug('hello');
    //     //    Integer temp=0;
    //     for(Account acc:accListContacts){
    //         // System.debug(acc.contacts.size());
    //         Map<Decimal,Contact> temp=new Map<Decimal,Contact>();
    //       for(Contact c:acc.contacts){
    //         // System.debug(c.SequenceNumber__c);
    //         temp.put(c.SequenceNumber__c,c);
    //       }
    //        changeContactDataFromDataBase.put(acc.id,temp);
    //     }
    //     // System.debug('hello');



    //     for(Contact con:listOfContacts){
    //         if(con.AccountId!=null){
    //             if(con.SequenceNumber__c==null||con.SequenceNumber__c<1||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()){
    //                 tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
    //                 con.SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();
    //             }
    //             else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()+tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()){
    //                 if(changeContactDataFromDataBase.size()>0){
    //                     for(Contact d:changeContactDataFromDataBase.get(con.AccountId).Values()){
    //                         if(d.SequenceNumber__c>=con.SequenceNumber__c){
    //                             Decimal te=d.SequenceNumber__c;
    //                             d.SequenceNumber__c=d.SequenceNumber__c+1;
    //                             changeContactDataFromDataBase.get(con.AccountId).put(te,d);
    //                         }
    //                     }   
    //                     // for(Integer j=changeContactDataFromDataBase.get(con.AccountId).size();j>=con.SequenceNumber__c;j--){
    //                     //     // System.debug(j);
    //                     //     if(changeContactDataFromDataBase.get(con.AccountId).containsKey(j--)){
    //                     //         System.debug( changeContactDataFromDataBase.get(con.AccountId).get(j--).SequenceNumber__c);
    //                     //         changeContactDataFromDataBase.get(con.AccountId).get(j--).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j--).SequenceNumber__c+1;
    //                     //         changeContactDataFromDataBase.get(con.AccountId).put(j,changeContactDataFromDataBase.get(con.AccountId).get(j--));
    //                     //     }
    //                     // }   
    //                 }
    //                     for(Integer i=0;i<tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();i++){
    //                         if(tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c>=con.SequenceNumber__c){
    //                             tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c=tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c+1;
    //                         }
    //                     }
    //                     tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
    //             }
    //         }
    //     }
    //     list<Contact> ans=new list<Contact>();
    //     for(Id cto:changeContactDataFromDataBase.keySet()){
    //         ans.addAll(changeContactDataFromDataBase.get(cto).values());
    //     }
    //         if(ans.size()>0){
    //             update ans;
    //         }
        
    //     runOnce = true;
    //         // set<id> AccountId=new set<id>();
    //     //     // for(Contact con:contact){
    //     //     // if(con.AccountId!=null){
    //     //     //     AccountId.add(con.AccountId);
    //     //     // }
    //     //     // }
    //     //     // Integer i=0;
    //     //     // //  list<Account>acc=[select id ,(select id from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountId];
    //     //     // //  System.debug(acc.contacts);
    //     //     // // // Integer k=1;
    //     //     // //  Integer k=1;
    //     //     // // for(Contact a:acc[i].contacts){
    //     //     // // }
        
    //     //     // for(Id accId:AccountId ){
    //     //     //     List<Contact> contactsAssociatedWithParticularAccount=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid =:accId order by SequenceNumber__c Asc ]);
            
    //     //     //       List<Contact> temp=new List<Contact>();
    //     //     //     i=contactsAssociatedWithParticularAccount.size();
    //     //     //     for(Contact con:contact){
    //     //     //         if(con.AccountId!=null&&con.AccountId==accId){
    //     //     //             i++;
    //     //     //             if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>i-1||con.SequenceNumber__c<0){
    //     //     //                 con.SequenceNumber__c=i;
    //     //     //                 temp.add(con);
    //     //     //             }
    //     //     //             else if(con.SequenceNumber__c<i){
    //     //     //                 for(Integer j=0;j<contactsAssociatedWithParticularAccount.size();j++){
    //     //     //                     System.debug(j);
    //     //     //                     if(contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c>=con.SequenceNumber__c){
    //     //     //                         contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c=contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c+1;
    //     //     //                     }
    //     //     //                 }   
    //     //     //                 for(Integer k=0;k<temp.size();k++){
    //     //     //                     if(temp.get(k).SequenceNumber__c>=con.SequenceNumber__c){
    //     //     //                     temp.get(k).SequenceNumber__c=temp.get(k).SequenceNumber__c+1;
    //     //     //                     }
    //     //     //                 }
    //     //     //                 temp.add(con);
    //     //     //                 update contactsAssociatedWithParticularAccount;
    //     //     //                 runOnce = true;
    //     //     //             }
    //     //     //         }
    //     //     //     }
    //     //     // }
    //     //     // System.debug(AccountId);
    //     //     // Integer i=0;
    //     //     // // List<Contact> AccountId=new List<Contact>([])
    //     //     //  List<Contact> AccountIds=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid = '0015g00001Va8FO']);
    //     //     //  System.debug(AccountIds);
    //     //     // // i=AccountIds.size();
    //     //     // for(Contact con : contact){
    //     //     // if(con.AccountId!=null){
        
    //     //     // }
    //     //     // }
    // }
//     public static void handleBeforeInsert(List<Contact> listOfContacts) {
        //          if (!runOnce) {
        //     runOnce = false;

        //     Map<Id, Map<Integer, Contact>> mapToStoreAccountIDAssociatedContacts = new Map<Id, Map<Integer, Contact>>();
        //     set<Id> accountIds = new set<Id>();

        //     for (Contact con : listOfContacts) {
        //         if (!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)) {
        //             mapToStoreAccountIDAssociatedContacts.put(con.AccountId, new Map<Integer, Contact>());
        //             accountIds.add(con.AccountId);
        //         }

        //         mapToStoreAccountIDAssociatedContacts.get(con.AccountId).put((Integer)con.SequenceNumber__c, con);
        //     }

        //     list<Account> accListContacts = [
        //         SELECT Id, (SELECT Id, SequenceNumber__c FROM Contacts ORDER BY SequenceNumber__c)
        //         FROM Account
        //         WHERE Id IN :accountIds
        //     ];

        //     Map<Id, List<Contact>> changeContactDataFromDataBase = new Map<Id, List<Contact>>();
        //     for (Account acc : accListContacts) {
        //         changeContactDataFromDataBase.put(acc.Id, acc.Contacts);
        //     }

        //     for (Contact con : listOfContacts) {
        //         if (con.AccountId != null && changeContactDataFromDataBase.containsKey(con.AccountId)) {
        //             if (con.SequenceNumber__c == null || con.SequenceNumber__c <= 0) {
        //                 // If SequenceNumber__c is null or less than or equal to 0, set it to the last position
        //                 con.SequenceNumber__c = changeContactDataFromDataBase.get(con.AccountId).size() + 1;
        //             } else if (con.SequenceNumber__c > changeContactDataFromDataBase.get(con.AccountId).size()) {
        //                 // If SequenceNumber__c is greater than the size, set it to the last position
        //                 con.SequenceNumber__c = changeContactDataFromDataBase.get(con.AccountId).size() + 1;
        //             } else {
        //                 // Adjust the sequence numbers based on existing contacts
        //                 for (Integer j = (Integer)con.SequenceNumber__c; j <= changeContactDataFromDataBase.get(con.AccountId).size(); j++) {
        //                     if (mapToStoreAccountIDAssociatedContacts.get(con.AccountId).containsKey(j)) {
        //                         mapToStoreAccountIDAssociatedContacts.get(con.AccountId).get(j).SequenceNumber__c++;
        //                     }
        //                 }
        //             }

        //             mapToStoreAccountIDAssociatedContacts.get(con.AccountId).put((Integer)con.SequenceNumber__c, con);
        //         }
        //     }

        //     list<Contact> ans = new list<Contact>();
        //     for (Map<Integer, Contact> contactMap : mapToStoreAccountIDAssociatedContacts.values()) {
        //         ans.addAll(contactMap.values());
        //     }

        //     update ans;
        //     runOnce = true;
        // }
//  }
    /*public static void handleBeforeInsert(List<Contact> listOfContacts){
        runOnce=false;
        Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
        Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
        // Map<Id,Contact> newContactList=new 
     set<id> AccountIds=new set<id>();
     for(Contact con:listOfContacts){                                                                                                                                                                                                                                                        
         if(!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)){
             mapToStoreAccountIDAssociatedContacts.put(con.AccountId,new List<Contact>());
             tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
             AccountIds.add(con.AccountId);                
         }
         mapToStoreAccountIDAssociatedContacts.get(con.Accountid).add(con);
     }
     
        // Integer countNewParent=0;
        // Integer i=0;
        list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
            System.debug(accListContacts);
        Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
        for(Account acc:accListContacts){
            changeContactDataFromDataBase.put(acc.id,acc.contacts);
        }
        // Map<Id,list<Contact>> answerToReturn=new Map<Id,list<Contact>>();
        for(Contact con:listOfContacts){
            if(con.AccountId!=null&&changeContactDataFromDataBase.containsKey(con.AccountId)){
                if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()||con.SequenceNumber__c<0){
                    tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
                    System.debug('hello');
                    con.SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();
                    // answerToReturn.put(con.AccountId,con);
                    
                    System.debug(con.AccountId);
                }
                else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()+tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()){
                    System.debug('hello');
                        for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
                            System.debug(j);
                            if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=con.SequenceNumber__c){
                                changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c+1;
                            }
                        }   
                        // System.debug(answerToReturn);
                        for(Integer i=0;i<tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();i++){
                            System.debug('hello');
                            if(tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c>=con.SequenceNumber__c){
                                // System.debug(ct);
                                tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c=tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c+1;
                            }
                        }
                        tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
                }
            }
        }
         list<Contact> ans=new list<Contact>();
            for(list<Contact> ct:changeContactDataFromDataBase.values()){
               ans.addAll(ct);
            }
        update ans;
        runOnce = true;*/
        // set<id> AccountId=new set<id>();
        // for(Contact con:contact){
        // if(con.AccountId!=null){
        //     AccountId.add(con.AccountId);
        // }
        // }
        // Integer i=0;
        // //  list<Account>acc=[select id ,(select id from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountId];
        // //  System.debug(acc.contacts);
        // // // Integer k=1;
        // //  Integer k=1;
        // // for(Contact a:acc[i].contacts){
        // // }
    
        // for(Id accId:AccountId ){
        //     List<Contact> contactsAssociatedWithParticularAccount=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid =:accId order by SequenceNumber__c Asc ]);
        
        //       List<Contact> temp=new List<Contact>();
        //     i=contactsAssociatedWithParticularAccount.size();
        //     for(Contact con:contact){
        //         if(con.AccountId!=null&&con.AccountId==accId){
        //             i++;
        //             if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>i-1||con.SequenceNumber__c<0){
        //                 con.SequenceNumber__c=i;
        //                 temp.add(con);
        //             }
        //             else if(con.SequenceNumber__c<i){
        //                 for(Integer j=0;j<contactsAssociatedWithParticularAccount.size();j++){
        //                     System.debug(j);
        //                     if(contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c>=con.SequenceNumber__c){
        //                         contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c=contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c+1;
        //                     }
        //                 }   
        //                 for(Integer k=0;k<temp.size();k++){
        //                     if(temp.get(k).SequenceNumber__c>=con.SequenceNumber__c){
        //                     temp.get(k).SequenceNumber__c=temp.get(k).SequenceNumber__c+1;
        //                     }
        //                 }
        //                 temp.add(con);
        //                 update contactsAssociatedWithParticularAccount;
        //                 runOnce = true;
        //             }
        //         }
        //     }
        // }
        // System.debug(AccountId);
        // Integer i=0;
        // // List<Contact> AccountId=new List<Contact>([])
        //  List<Contact> AccountIds=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid = '0015g00001Va8FO']);
        //  System.debug(AccountIds);
        // // i=AccountIds.size();
        // for(Contact con : contact){
        // if(con.AccountId!=null){
    
        // }
        // }
  //  }
// public static void handleAfterInsert(List<Contact> listOfContacts,Map<id,contact> conMap){
//             runOnce=false;
//             Map<Id,Map<Decimal,Contact>> mainAns=new Map<Id,Map<Decimal,Contact>>();
//              set<id> AccountIds=new set<id>();
            
//              for(Contact con:listOfContacts) {                                                                                                                                                                                                                                                        
//                  if(!mainAns.containsKey(con.AccountId)) {                         
//                     mainAns.put(con.AccountId,new Map<Decimal,Contact>());
//                      AccountIds.add(con.AccountId);                
//                  }
//              }
            

//              Map<id,contact> totalContacts=new Map<id,Contact>([SELECT id,SequenceNumber__c from contact where id in :conMap.keySet() ORDER BY SequenceNumber__c ]);

//             //  Map<id,contact> totalContacts=new Map<Id,Contact>([SELECT id,SequenceNumber__c from contact where id in :conMap.keySet()]);
//             //  System.debug(totalContacts.size());
//             //  System.debug()
//              list<Account> accListContacts=[ SELECT id ,
//                                                 (SELECT id,SequenceNumber__c 
//                                                 FROM contacts where id not in :totalContacts.keySet() ORDER BY SequenceNumber__c) 
//                                              FROM Account where id in :AccountIds ];
//             // System.debug('accListContacts=> '+accListContacts.size());

//             Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
//             for(Account acc:accListContacts){
//                 // System.debug(acc.contacts.size());
//                 changeContactDataFromDataBase.put(acc.id,acc.contacts);
//             }
//             for(Contact con:listOfContacts){
//             if(con.AccountId!=null&&changeContactDataFromDataBase.containsKey(con.AccountId)){
//             if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()+ mainAns.get(con.AccountId).size()||con.SequenceNumber__c<0){
//                         // System.debug('vikas');
//                 Integer j=changeContactDataFromDataBase.get(con.AccountId).size()+mainAns.get(con.AccountId).size()+1;
//                mainAns.get(con.AccountId).put((Decimal)j, totalContacts.get(con.id));

//                totalContacts.get(con.id).SequenceNumber__c=j;
//             //    System.debug('hello1'+j);
//             }

            
//             else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()+ mainAns.get(con.AccountId).size()){
//                 // System.debug('hello2');
//                 for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
//                     // System.debug(j);
//                     if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=con.SequenceNumber__c){
//                         changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c+1;
//                     }
//                 }   
//                     for(Contact c:mainAns.get(con.AccountId).Values()){
//                         if(c.SequenceNumber__c>=con.SequenceNumber__c){
//                              Decimal j=c.SequenceNumber__c+1;
//                             totalContacts.get(c.id).SequenceNumber__c=totalContacts.get(c.id).SequenceNumber__c+1;
//                             // System.debug(totalContacts.get(c.id).SequenceNumber__c);
//                             mainAns.get(con.AccountId).put( j,c);
//                         }
//                     }
//                          mainAns.get(con.AccountId).put(con.SequenceNumber__c, totalContacts.get(con.id));
//                         }
//                 }
//                 }
//                 list<Contact> ans=new list<Contact>();
//                 for(list<Contact> ct:changeContactDataFromDataBase.values()){
//                    ans.addAll(ct);
//                 }
//             update totalContacts.values();
//             if(ans.size()>0){
//             update ans;
//             }
//                 runOnce=true;
// }
    // public static void handleBeforeInsert(List<Contact> listOfContacts,Map<id,contact> conMap){
    //     runOnce=false;
    //     Map<Id,Map<Decimal,Contact>> mainAns=new Map<Id,Map<Decimal,Contact>>();
    //     // Set<Id> AccountId=conMap.keySet(); 
    //         // Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
    //         // Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
    //         // Map<Id,Contact> newContactList=new 
    //      set<id> AccountIds=new set<id>();
        
    //     //  for(Contact con:conMap.values()){
    //     //     mainAns.put(con.Account)
    //     //  }

    //      for(Contact con:listOfContacts) {                                                                                                                                                                                                                                                        
    //          if(!mainAns.containsKey(con.AccountId)) {                         
    //             mainAns.put(con.AccountId,new Map<Decimal,Contact>());
    //             //  tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
    //              AccountIds.add(con.AccountId);                
    //          }
    //         //  mainAns.get(con.Accountid).put(con.SequenceNumber__c,con);
    //      }
    //      Map<id,contact> totalContacts=new Map<Id,Contact>([SELECT id,SequenceNumber__c from contact where id in :conMap.keySet()]);
    //      System.debug(totalContacts.size());
    //      list<Account> accListContacts=[ SELECT id ,
    //                                         (SELECT id,SequenceNumber__c 
    //                                         FROM contacts where id not in :conMap.keySet() ORDER BY SequenceNumber__c) 
    //                                      FROM Account where id in :AccountIds ];

    //     // Map<Id,Contact> ans=new Map<Id,Contact>();
    //     Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
    //     for(Account acc:accListContacts){
    //         System.debug(acc.contacts.size());
    //         // mainAns.put(acc.id,new Map<Id,Contact>());
    //         changeContactDataFromDataBase.put(acc.id,acc.contacts);
    //     }
    //     for(Contact con:listOfContacts){
    //     // System.debug('hello1');

    //     if(con.AccountId!=null&&changeContactDataFromDataBase.containsKey(con.AccountId)){
    //         // System.debug('hima');
    //         // System.debug(mainAns.size());
    //         // System.debug(con.SequenceNumber__c);
    //     if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()+ mainAns.get(con.AccountId).size()||con.SequenceNumber__c<0){
    //                 System.debug('vikas');
    //         // con.SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).size()- mainAns.get(con.AccountId).size()+ans.size()+1;
    //         Integer j=changeContactDataFromDataBase.get(con.AccountId).size()+mainAns.get(con.AccountId).size()+1;
    //         // con.SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).size()+1;
    //        mainAns.get(con.AccountId).put((Decimal)j, totalContacts.get(con.id));

    //        totalContacts.get(con.id).SequenceNumber__c=j;
    //        System.debug('hello1'+j);
    //     }
    //     //    System.debug(mainAns.get(con.AccountId).size());
    
        
    //     else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()+ mainAns.get(con.AccountId).size()){
    //         System.debug('hello2');
    //             for(Contact c:mainAns.get(con.AccountId).Values()){
    //                 if(c.SequenceNumber__c>=con.SequenceNumber__c){
                        
    //                     // c.SequenceNumber__c=c.SequenceNumber__c+1;
    //                     Decimal j=c.SequenceNumber__c+1;
    //                     // System.debug(c.SequenceNumber__c);
    //                     totalContacts.get(c.id).SequenceNumber__c=totalContacts.get(c.id).SequenceNumber__c+1;
    //                     System.debug(totalContacts.get(c.id).SequenceNumber__c);
    //                     // c.SequenceNumber__c=c.SequenceNumber__c+1;
    //                     mainAns.get(con.AccountId).put( j,c);

    //                 }
    //             }
    //             mainAns.get(con.AccountId).put(con.SequenceNumber__c, totalContacts.get(con.id));
    //                 }
    //         }
    //         }
    //     // list<Contact> ans1=new list<Contact>();
    //     // for(Map<Decimal,Contact> contactMap:mainAns.values()){
    //     //     ans1.addAll(contactMap.values());
    //     // }
    //     update totalContacts.values();
    //     // insert ans1;
    //         // update ans.Values();
    //         runOnce=true;
    // }
 /*public static void handleBeforeInsert(List<Contact> listOfContacts) {
    runOnce = false;

    Map<Id, Map<Decimal, Contact>> accountContactMap = new Map<Id, Map<Decimal, Contact>>();
    
    for (Contact con : listOfContacts) {
        if (!accountContactMap.containsKey(con.AccountId)) {
            accountContactMap.put(con.AccountId, new Map<Decimal, Contact>());
        }

        Decimal sequenceNumber = con.SequenceNumber__c != null && con.SequenceNumber__c > 0 ?
                                con.SequenceNumber__c :
                                accountContactMap.get(con.AccountId).size() + 1;

        accountContactMap.get(con.AccountId).put((Decimal)sequenceNumber, con);
    }

    for (Contact con : listOfContacts) {
        if (con.AccountId != null && accountContactMap.containsKey(con.AccountId)) {
            Map<Decimal, Contact> contactsMap = accountContactMap.get(con.AccountId);
            Decimal sequenceNumber = con.SequenceNumber__c != null && con.SequenceNumber__c > 0 ?
                                    con.SequenceNumber__c :
                                    contactsMap.size();

            contactsMap.put((Decimal)sequenceNumber, con);
        }
    }

    List<Contact> contactsToUpdate = new List<Contact>();
    
    // Flatten the map for update
    for (Map<Decimal, Contact> contactsMap : accountContactMap.values()) {
        contactsToUpdate.addAll(contactsMap.values());
    }

    update contactsToUpdate;
    runOnce = true;
}*/


// public static void handleBeforeInsert(List<Contact> listOfContacts){
        //     runOnce=false;
        //     Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
        //     Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
        //     // Map<Id,Contact> newContactList=new 
        //  set<id> AccountIds=new set<id>();

        //  for(Contact con:listOfContacts){                                                                                                                                                                                                                                                        
        //      if(!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)){                         
        //          mapToStoreAccountIDAssociatedContacts.put(con.AccountId,new List<Contact>());
        //          tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
        //          AccountIds.add(con.AccountId);                
        //      }
        //      mapToStoreAccountIDAssociatedContacts.get(con.Accountid).add(con);
        //  }
        
        //     // Integer countNewParent=0;
        //     // Integer i=0;
        //     list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
        //         System.debug(accListContacts);
        //     Map<Id,Map<Id,Contact>> mainAns=new  Map<Id,Map<Id,Contact>>();
        //     // Map<Id,Map<Id,Contact>> mainAns=new  Map<Id,Map<Id,Contact>>();

            
        //     Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
        //     for(Account acc:accListContacts){
        //         mainAns.put(acc.id,new Map<Id,Contact>());
        //         changeContactDataFromDataBase.put(acc.id,acc.contacts);
        //     }
        //     // Map<Id,list<Contact>> answerToReturn=new Map<Id,list<Contact>>();
        //     for(Contact con:listOfContacts){
        //         if(con.AccountId!=null&&changeContactDataFromDataBase.containsKey(con.AccountId)){
        //             if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()||con.SequenceNumber__c<0){
        //                 // tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
        //                 mainAns.get(con.AccountId).put(con.id,con);
        //                 System.debug('hello');                                         
        //                 // con.SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).size()+ tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();
        //                 // answerToReturn.put(con.AccountId,con);
        //                 con.SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).size()+ mainAns.get(con.AccountId).size();

        //                 System.debug(con.AccountId);
        //             }
        //             else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()+tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()){
        //                 System.debug('hello');
        //                     for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
        //                         System.debug(j);
        //                         if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=con.SequenceNumber__c){
        //                             changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c+1;
        //                         }
        //                     }   
        //                     // System.debug(answerToReturn);
        //                     // Map<Id,Map<Id,Contact>> mainAns=new  Map<Id,Map<Id,Contact>>();
        //                     for(Id conId:mainAns.get(con.AccountId).keySet()){
        //                         if(mainAns.get(con.AccountId).get(conId).SequenceNumber__c>=con.SequenceNumber__c){
        //                             mainAns.get(con.AccountId).get(conId).SequenceNumber__c++;
        //                         }
        //                     }
        //                     // for(Integer i=0;i<tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();i++){
        //                     //     System.debug('hello');
        //                     //     if(tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c>=con.SequenceNumber__c){
        //                     //         // System.debug(ct);
        //                     //         tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c=tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).get(i).SequenceNumber__c+1;
        //                     //     }
        //                     // }
        //                     tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
        //             }
        //         }
        //     }
        //      list<Contact> ans=new list<Contact>();
        //         for(list<Contact> ct:changeContactDataFromDataBase.values()){
        //            ans.addAll(ct);
        //         }
        //     update ans;
        //     runOnce = true;
        // // set<id> AccountId=new set<id>();
        // // for(Contact con:contact){
        // // if(con.AccountId!=null){
        // //     AccountId.add(con.AccountId);
        // // }
        // }
        // Integer i=0;
        // //  list<Account>acc=[select id ,(select id from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountId];
        // //  System.debug(acc.contacts);
        // // // Integer k=1;
        // //  Integer k=1;
        // // for(Contact a:acc[i].contacts){
        // // }

        // for(Id accId:AccountId ){
        //     List<Contact> contactsAssociatedWithParticularAccount=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid =:accId order by SequenceNumber__c Asc ]);
        
        //       List<Contact> temp=new List<Contact>();
        //     i=contactsAssociatedWithParticularAccount.size();
        //     for(Contact con:contact){
        //         if(con.AccountId!=null&&con.AccountId==accId){
        //             i++;
        //             if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>i-1||con.SequenceNumber__c<0){
        //                 con.SequenceNumber__c=i;
        //                 temp.add(con);
        //             }
        //             else if(con.SequenceNumber__c<i){
        //                 for(Integer j=0;j<contactsAssociatedWithParticularAccount.size();j++){
        //                     System.debug(j);
        // //                     if(contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c>=con.SequenceNumber__c){
        // //                         contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c=contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c+1;
        // //                     }
        // //                 }   
        // //                 for(Integer k=0;k<temp.size();k++){
        // //                     if(temp.get(k).SequenceNumber__c>=con.SequenceNumber__c){
        // //                     temp.get(k).SequenceNumber__c=temp.get(k).SequenceNumber__c+1;
        // //                     }
        // //                 }
        // //                 temp.add(con);
        // //                 update contactsAssociatedWithParticularAccount;
        // //                 runOnce = true;
        // //             }
        // //         }
        // //     }
        // // }
        // // System.debug(AccountId);
        // // Integer i=0;
        // // // List<Contact> AccountId=new List<Contact>([])
        // //  List<Contact> AccountIds=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid = '0015g00001Va8FO']);
        // //  System.debug(AccountIds);
        // // // i=AccountIds.size();
        // // for(Contact con : contact){
        // // if(con.AccountId!=null){

        // // }
        // // }
//  }
//    public static void handleBeforeUpdate(Map<id,Contact> listOfContacts,Map<id,Contact> conMap){
//             runOnce=false;
//             // runOnce=false;
//         //      for(Contact c:listOfContacts){
//         //      System.debug(c.SequenceNumber__c);
//         //      System.debug(c.AccountId);
//         //      System.debug(conMap.get(c.id).SequenceNumber__c);
//         //      System.debug(conMap.get(c.id).AccountId);
//         //      System.debug(conMap.get(c.id));
//         //  }
//         Map<Id,Contact> tempOldMap=conMap.clone();
//         // System.debug(conMap);
//         // System.debug(tempOldMap);
//             Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
//             Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
//             // Map<Id,Contact> newContactList=new 
//         set<id> AccountIds=new set<id>();
//         for(Contact con:listOfContacts.values()){                                                                                                                                                                                                                                                        
//             if(!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)){
//                 mapToStoreAccountIDAssociatedContacts.put(con.AccountId,new List<Contact>());
//                 tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
//                 AccountIds.add(con.AccountId);                
//             }
//             mapToStoreAccountIDAssociatedContacts.get(con.Accountid).add(con);
//         }
//         for(Id oldId:conMap.keySet()){
        
//             AccountIds.add(conMap.get(oldId).AccountId);
//         }
//         Integer countNewParent=0;
//         Integer i=0;
//         list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c) from Account where id in :AccountIds ];
//             // System.debug(accListContacts);
//         Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
//         for(Account acc:accListContacts){
//             changeContactDataFromDataBase.put(acc.id,acc.contacts);
//         }
//         Map<Id,Contact> temp=new Map<Id,Contact>();
//         Map<Id,Contact> answerToReturn=new Map<Id,Contact>();
//         //  for(Contact con:listOfContacts.values()){
//         //     if(con.AccountId!=null){
//         //     if(con.SequenceNumber__c==null||con.SequenceNumber__c==0||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()||con.SequenceNumber__c<0){
//         //         System.debug('hello');
//         //         con.SequenceNumber__c=changeContactDataFromDataBase.get(con.Accountid).size();
//         //         for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
//         //             if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>conMap.get(con.id).SequenceNumber__c||listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//         //                 System.debug('hello3');
//         //                 changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1;
//         //                 if(listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//         //                     changeContactDataFromDataBase.get(con.AccountId).set(changeContactDataFromDataBase.get(con.Accountid).size()-1,con);
//         //                 }
//         //                 // temp.get(changeContactDataFromDataBase.get(con.AccountId).get(j).id).SequenceNumber__c=temp.get(changeContactDataFromDataBase.get(con.AccountId).get(j).id).SequenceNumber__c-1;
                        
//         //                 if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//         //                     answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
//         //                 }
//         //             }
//         //             // list.set(2, "E");
//         //             // changeContactDataFromDataBase.get(con.AccountId).set((Integer)con.SequenceNumber__c-1,con);
//         //         }
                
//         //         tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
//         //         // con.SequenceNumber__c=changeContactDataFromDataBase.get(con.Accountid).size();
//         //         // temp.put(con.id,con);
//         //     }
//         for(Contact con:listOfContacts.values()){
//             if(con.AccountId!=null){
//                 if(con.AccountId!=conMap.get(con.id).AccountId){
//                     for(Integer j=0;j<changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).size();j++){
//                         // System.debug(changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).size());
//                         // System.debug(con.SequenceNumber__c);
//                         if(changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).SequenceNumber__c>con.SequenceNumber__c){
//                             // System.debug(conMap.get(con.id).AccountId.get(j).SequenceNumber__c);
//                             changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).SequenceNumber__c-1;
//                             if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).id)){
//                                 answerToReturn.put(changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j).id,changeContactDataFromDataBase.get(conMap.get(con.id).AccountId).get(j));
//                             }
//                         }
//                     }
//                     // for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
                        
//                     //     if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>con.SequenceNumber__c){
//                     //         changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1;
//                     //         if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//                     //             answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
//                     //         }
//                     //     }
//                     // }
//                     // changeContactDataFromDataBase.get(con.AccountId).set(changeContactDataFromDataBase.get(con.AccountId).size(),con);
//                     Integer tempInteger=changeContactDataFromDataBase.get(con.AccountId).size()+1;
//                     changeContactDataFromDataBase.get(con.AccountId).add(con);//check
//                     //answerToReturn.put(con.id,con);
//                     con.SequenceNumber__c=tempInteger;
//                 }
//                 else if(con.SequenceNumber__c==null||con.SequenceNumber__c<1||con.SequenceNumber__c>changeContactDataFromDataBase.get(con.AccountId).size()){
//                 // System.debug('hello');
//                 for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
//                     // System.debug(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c);
//                     // System.debug(conMap.get(con.id).SequenceNumber__c);
//                     if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=tempOldMap.get(con.id).SequenceNumber__c){
//                         // System.debug('hello3');
//                         changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1;
//                         if(tempOldMap.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//                             tempOldMap.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
//                         }
//                         if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//                             answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
//                         }
//                     }
//                 }
                
//                 tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
//                 // con.SequenceNumber__c=changeContactDataFromDataBase.get(con.Accountid).size()-mapToStoreAccountIDAssociatedContacts.get(con.AccountId).size()+tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size();
//                 con.SequenceNumber__c=changeContactDataFromDataBase.get(con.Accountid).size();

//             }
        
//             else if(con.SequenceNumber__c<=changeContactDataFromDataBase.get(con.AccountId).size()){
//                 // System.debug('hell'+con.SequenceNumber__c);
//                     boolean tempBool=true;
//                     // boolean tempBool=true;

//                 for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
                
//                         // System.debug(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c);
//                         // System.debug(conMap.get(con.id).SequenceNumber__c);
//                         // for increase
//                     if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>tempOldMap.get(con.id).SequenceNumber__c&&changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c<=con.SequenceNumber__c){
//                         changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1;
//                         // System.debug(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1);
//                         // tempBool=true;
//                         changeContactDataFromDataBase.get(con.AccountId).set((Integer) changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1,changeContactDataFromDataBase.get(con.AccountId).get(j));                        
//                         if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//                             answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
//                         }
//                     }
//                     else if(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c<tempOldMap.get(con.id).SequenceNumber__c&&changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c>=con.SequenceNumber__c){
//                         changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c+1;
//                         // changeContactDataFromDataBase.get(con.AccountId).set((Integer) changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c-1,changeContactDataFromDataBase.get(con.AccountId).get(j));  
//                         // j++;                      
//                         tempBool=false;
//                         if(!listOfContacts.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//                             answerToReturn.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
//                         }
//                     }
//                     if(tempOldMap.containsKey(changeContactDataFromDataBase.get(con.AccountId).get(j).id)){
//                         tempOldMap.put(changeContactDataFromDataBase.get(con.AccountId).get(j).id,changeContactDataFromDataBase.get(con.AccountId).get(j));
//                     }
//                 }
//                 if(tempBool==true){
//                  changeContactDataFromDataBase.get(con.AccountId).set((Integer)con.SequenceNumber__c-1,con);
//                 }
//                 if(tempBool==false){
//                     changeContactDataFromDataBase.get(con.AccountId).remove((Integer)conMap.get(con.id).SequenceNumber__c-1);
//                     changeContactDataFromDataBase.get(con.AccountId).add((Integer)con.SequenceNumber__c-1,con);
//                 }
//             }
//         }
//         }
//         //  list<Contact> ans=new list<Contact>();
//         //         for(list<Contact> ct:changeContactDataFromDataBase.values()){
//         //            ans.addAll(ct);
//         //         }
//                 update answerToReturn.values();
//                 runOnce=true;
//                 //  update answerToReturn.Values();

//                 // runOnce=false;
//         // for(Id ctr:conMap.keySet()){
//         //     System.debug(conMap.get(ctr).SequenceNumber__c);
//         // }
//         //         set<id> AccountId=new set<id>();
//         //         for(Contact con:contact){
//         //             if(con.AccountId!=null){
//         //                  AccountId.add(con);
//         //             }
//         //         }
//         //         System.debug(AccountId);
//         //         Integer i=0;
//         //         for(Id accId:AccountId){
//         //             List<Contact> contactsAssociatedWithParticularAccount=new  List<Contact>([select id,SequenceNumber__c from Contact where Accountid =:accId order by SequenceNumber__c Asc ]);
//         //             i=contactsAssociatedWithParticularAccount.size();
//         //             List<Contact> temp=new List<Contact>();
//         //             for(Contact con:contact){
//         //                 i++;
//         //                 if(con.AccountId!=null&&con.AccountId==accId){
//         //                     if(con.AccountId!=conMap.get(con.id).AccountId){
//         //                             //  Integer temp=i;
//         //                         for(Integer j=0;j<contactsAssociatedWithParticularAccount.size();j++){
//         //                             if(contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c>con.SequenceNumber__c){
//         //                                 contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c=contactsAssociatedWithParticularAccount.get(j).SequenceNumber__c-1;
//         //                             }
//         //                         }   
//         //                         if(i!=0){
//         //                             con.SequenceNumber__c=i-1;
//         //                         }
//         //                     //con.SequenceNumber__c=i-1;
//         //                     temp.add(con);
//         //                     }
//         //                 }
//         //             }
//         //         }
//    }   

     public static void handleAfterDelete(list<Contact> listOfContacts){
        runOnce=false;
        set<id> AccountIds=new set<id>();
        for(Contact con : listOfContacts){
                AccountIds.add(con.AccountId);                
        }
        Integer i=0;
          list<Account> accListContacts=[select id ,(select id,SequenceNumber__c from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountIds ];
          System.debug(accListContacts.size());
            Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
            for(Account acc:accListContacts){
                changeContactDataFromDataBase.put(acc.id,acc.contacts);
            }
            Map<Id,Contact> answerToReturn=new Map<Id,Contact>();
            for(Id con:AccountIds){
                    for(Integer j=0;j<changeContactDataFromDataBase.get(con).size();j++){
                        changeContactDataFromDataBase.get(con).get(j).SequenceNumber__c=j+1;
                        answerToReturn.put(changeContactDataFromDataBase.get(con).get(j).id,changeContactDataFromDataBase.get(con).get(j));
                    }
                }
            if(answerToReturn.size()>0){
                update answerToReturn.values();
            }
            runOnce=true;
    }
     public static void handleAfterUndelete(list<Contact> listOfContacts){
        Map<Id,list<Contact>> tempMapToStoreAccountIdAssociatedContacts=new Map<Id,list<Contact>>();
        Map<Id,list<Contact>> mapToStoreAccountIDAssociatedContacts=new Map<Id,list<Contact>>();
        set<id> AccountIds=new set<id>();
        for(Contact con:listOfContacts){
            if(!mapToStoreAccountIDAssociatedContacts.containsKey(con.AccountId)){
                mapToStoreAccountIDAssociatedContacts.put(con.AccountId,new List<Contact>());
                tempMapToStoreAccountIdAssociatedContacts.put(con.AccountId,new List<Contact>());
                AccountIds.add(con.AccountId);                
            }
            mapToStoreAccountIDAssociatedContacts.get(con.Accountid).add(con);
        }
        Integer i=0;
          list<Account> accListContacts=[select id ,(select id from contacts order by SequenceNumber__c Asc ) from Account where id in :AccountIds ];
            System.debug(accListContacts); 
          Map<Id,list<Contact>> changeContactDataFromDataBase =new Map<Id,list<Contact>>();
            for(Account acc:accListContacts){
                changeContactDataFromDataBase.put(acc.id,acc.contacts);
            }
           
            Map<Id,Contact> answerToReturn=new Map<Id,Contact>();
            for(Contact con:listOfContacts){
                i=changeContactDataFromDataBase.get(con.AccountId).size()-mapToStoreAccountIDAssociatedContacts.get(con.AccountId).size();
              if(i<0){
                i=0;
              }
               for(Integer j=0;j<changeContactDataFromDataBase.get(con.AccountId).size();j++){
                    if(con.AccountId!=null&&changeContactDataFromDataBase.containsKey(con.AccountId)&&con.id==changeContactDataFromDataBase.get(con.AccountId).get(j).id){    
                        changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c=i+tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).size()+1;   
                           // System.debug(changeContactDataFromDataBase.get(con.AccountId).get(j).SequenceNumber__c);
                        tempMapToStoreAccountIdAssociatedContacts.get(con.AccountId).add(con);
                        answerToReturn.put(con.id,changeContactDataFromDataBase.get(con.AccountId).get(j));
                        break;
                    } 
               }
            }
          update answerToReturn.Values();
    }  
}