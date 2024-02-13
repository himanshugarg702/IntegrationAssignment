/*
Name:BatchApexClass
Description:In this implemented Batch class for with update status field on contact object and schedule mail with csv file.
*/
public with sharing class BatchApexClass implements Schedulable,
Database.Batchable<sObject>, Database.Stateful {
    public String csvString=''; // string variable for getting all fields
        public Database.QueryLocator start(Database.BatchableContext bc) {
            String query='SELECT Id, LastName, Status__c,Description,Birthdate,LastCURequestDate FROM Contact WHERE CreatedDate = Today';
            csvString='Id, LastName, Status__c,Birthdate,Description,LastCURequestDate\n';
            return Database.getQueryLocator(query);
        }
        public void execute(Database.BatchableContext bc, List<Contact> conList) {
            List<Contact> contacts=new List<Contact>();
            for(Contact con:conList){
                con.Status__c='Ready for Approval';
                csvString=csvString+con.id+','+con.LastName+','+con.Status__c+','+con.Birthdate+','+(con.Description).escapeCsv()+','+con.LastCURequestDate+'\n';
                contacts.add(con);
            }
            if(contacts.size()>0) {
                update contacts;
            }
        }
        public void finish(Database.BatchableContext bc) {
            User current_user=[SELECT Email FROM User WHERE Id= :UserInfo.getUserId()];
            Messaging.EmailFileAttachment csvFile=new Messaging.EmailFileAttachment();
            csvFile.setfileName('ContactData.csv');
            csvFile.setBody(blob.valueof(csvString));
            Messaging.SingleEmailMessage emailData=new Messaging.SingleEmailMessage();
            emailData.setToaddresses(new List<String>{current_user.Email});
            emailData.setSubject('Contact Data With Updated Status Field');
            emailData.setFileAttachments(new List<Messaging.EmailFileAttachment>{csvFile});
            emailData.setPlainTextBody('Please Find Attachment With Updated Status Filled In Contact');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailData});
        }
       public void execute(SchedulableContext ctx) {
            BatchApexClass batch=new BatchApexClass();
            // String sch = '0 0-26 14 * * ?';
            // String jobID = System.schedule('Remind Opp Owners', sch, Database.executeBatch(batch));
            Database.executeBatch(batch);
          /*  BatchApexClass be=new BatchApexClass();
            String sch = '0 19 17 * * ?';
            System.schedule('Remind Opp Owners', sch,be);*/
          
        }
}