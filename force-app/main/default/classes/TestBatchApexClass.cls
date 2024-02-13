@isTest
private class TestBatchApexClass {
    public static testMethod void testschedule() {
		Test.StartTest();
		BatchApexClass batch = new BatchApexClass();
		String sch = '0 35 14 * * ?';
		system.schedule('Test status Check', sch, batch );
		Test.stopTest();
	}
    static testMethod void batchClass(){
        Contact con = new Contact();
        con.LastName='Codes';
        con.Status__c='Ready for Approval';
        con.Description='This is testing';
        con.Birthdate=System.Today();
        insert con;
        Test.setCreatedDate(con.Id, Date.today().addDays(-1));
        Test.startTest();
        BatchApexClass batch= new BatchApexClass();
        Id jobid= Database.executeBatch(batch,1);
        Test.stopTest();
        Contact contacts = [select Status__c from contact where id=:con.Id];
        system.assertEquals('Ready For Approval', contacts.Status__c);
    }
}