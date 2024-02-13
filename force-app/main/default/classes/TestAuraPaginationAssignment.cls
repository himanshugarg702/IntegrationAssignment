@isTest
public with sharing class TestAuraPaginationAssignment {

    @isTest 
    static void getAllObjects(){
        Test.startTest();
        Map<String,String> result1 = AuraPaginationAssignment.allObject();
        System.assertEquals(true,result1!=null);
        Map<String,String> result2 = AuraPaginationAssignment.allObject();
        System.assertEquals(false,result2.size()==0);
        Test.stopTest();
    }
    @isTest 
    static void getAllFields(){
        Test.startTest();
        Map<String,String> result1 = AuraPaginationAssignment.allFields('Account');
        System.assertEquals(true,result1!=null);
        Test.stopTest();
    }
     @isTest 
    static void getdataForTable(){
        List<String> fields=new List<String>();
        fields.add('Name');
        fields.add('BillingStreet');
        Test.startTest();
        AuraPaginationAssignment.WrapperClass result1 = AuraPaginationAssignment.dataForTable('Account',fields,4,5);
        //AuraPaginationAssignment.WrapperClass result2=5;
        System.assertEquals(true,result1!=null);
        Test.stopTest();
    }
}