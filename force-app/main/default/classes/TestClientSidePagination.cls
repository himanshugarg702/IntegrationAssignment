@isTest
public with sharing class TestClientSidePagination {
    @isTest 
    static void getAllObjects(){
        Test.startTest();
        Map<String,String> result1 = clientSidePagination.allObject();
        System.assertEquals(true,result1!=null);
        Map<String,String> result2 = KanBanViewAssignment.allObject();
        System.assertEquals(false,result2.size()==null);
        Test.stopTest();
    }
    @isTest 
    static void getAllFields(){
        Test.startTest();
        Map<String,String> result1 = clientSidePagination.allFields('Account');
        System.assertEquals(true,result1!=null);
        Test.stopTest();
    }
    @isTest 
    static void getAllRecords(){
        List<String> fields=new List<String>();
        fields.add('Name');
        fields.add('Id');
        Test.startTest();
        List<sObject> result1 = clientSidePagination.getRecords('Account',fields);
        System.assertEquals(true,result1!=null);
        Test.stopTest();
    }
}