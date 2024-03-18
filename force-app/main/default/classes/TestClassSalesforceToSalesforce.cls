@isTest 
public with sharing class TestClassSalesforceToSalesforce {
    @isTest 
    static void getFilesFromTargetOrg(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassSalesforceToSalesforce());
        Test.startTest();
        List<Object> objectOfList=SalesforceToSalesforceIntegration.getDetails();
        // String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        Test.stopTest();
    }
    @isTest 
    static void uploadFiles(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassSalesforceToSalesforce());
        Test.startTest();
        SalesforceToSalesforceIntegration.uploadToNewOrg('helloCHeck','hjiiohbuijubyjiubjiubyu');
        Test.stopTest();
    }
}