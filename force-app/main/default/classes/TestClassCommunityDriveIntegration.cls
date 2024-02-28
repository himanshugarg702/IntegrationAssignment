@isTest 
public with sharing class TestClassCommunityDriveIntegration {
    @isTest 
    static void checkUserIsCreatedOrNot(){
        Test.startTest();
        CommunityAssignmentClassGoogleDrive.checkUserCreatedOrNot();
        Test.stopTest();
    }
    @isTest 
    static void createAuthURL(){
        Test.setMock(HttpCalloutMock.class, new MockTestClass());
        Test.startTest();
        String url=CommunityAssignmentClassGoogleDrive.createAuthURL();
        String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        Test.stopTest();
    }
    @isTest 
    static void getFiles(){
        Test.setMock(HttpCalloutMock.class, new MockTestClass());
        String url=CommunityAssignmentClassGoogleDrive.createAuthURL();
        String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        Test.startTest();
        Object getFiles=CommunityAssignmentClassGoogleDrive.getAllFilesFromGoogleDrive('root');
        Test.stopTest();
    }
    @isTest 
    static void createNewFolder(){
        Test.setMock(HttpCalloutMock.class, new MockTestClass());
        String url=CommunityAssignmentClassGoogleDrive.createAuthURL();
        String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        Test.startTest();
        Boolean createFolder=CommunityAssignmentClassGoogleDrive.newFolder('New Folder','root');
        Test.stopTest();
    }
    @isTest 
    static void deleteFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClass());
        String url=CommunityAssignmentClassGoogleDrive.createAuthURL();
        String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        Test.startTest();
        Boolean createFolder=CommunityAssignmentClassGoogleDrive.deleteFileApex('123');
        Test.stopTest();
    }
    @isTest 
    static void downloadFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClass());
        String url=CommunityAssignmentClassGoogleDrive.createAuthURL();
        String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        Test.startTest();
        String downloadFile=CommunityAssignmentClassGoogleDrive.downloadFile('123');
        Test.stopTest();
    }
    @isTest 
    static void getRetrieveAcessToken(){
        Test.setMock(HttpCalloutMock.class, new MockTestClass());
        String url=CommunityAssignmentClassGoogleDrive.createAuthURL();
        String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        Integration__c googleDriveIntegration=new Integration__c();
        Test.startTest();
        Integration__c getAccessToken=CommunityAssignmentClassGoogleDrive.retrieveGoogleAccessToken(googleDriveIntegration);
        Test.stopTest();
    }
    @isTest 
    static void uploadFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClass());
        String url=CommunityAssignmentClassGoogleDrive.createAuthURL();
        String testAccessToken=CommunityAssignmentClassGoogleDrive.getAccessToken(url);
        MockTestClass.insertFileAsContent();
        ContentVersion cv=[SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion LIMIT 1];
        Test.startTest();
        String getAccessToken=CommunityAssignmentClassGoogleDrive.uploadFile('hello',(String)cv.ContentDocumentId,'root','image/jpeg');
        Test.stopTest();
    }
}