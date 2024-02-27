@isTest
public with sharing class CommunityBoxTestClass {
    @isTest 
    static void getAllObjects(){
        Test.startTest();
        CommunityBoxApiIntegration.checkUserCreatedOrNot();
        Test.stopTest();
    }
    @isTest 
    static void createAuthURL(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassBox());
        Test.startTest();
        String url=CommunityBoxApiIntegration.createAuthURL();
        String testAccessToken=CommunityBoxApiIntegration.getAccessToken(url);
        Test.stopTest();
    }
    @isTest 
    static void getFiles(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassBox());
        String url=CommunityBoxApiIntegration.createAuthURL();
        String testAccessToken=CommunityBoxApiIntegration.getAccessToken(url);
        Test.startTest();
        Object getFiles=CommunityBoxApiIntegration.getAllFilesFromBox('0');
        Test.stopTest();
    }
    @isTest 
    static void createNewFolder(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassBox());
        String url=CommunityBoxApiIntegration.createAuthURL();
        String testAccessToken=CommunityBoxApiIntegration.getAccessToken(url);
        Test.startTest();
        Boolean createFolder=CommunityBoxApiIntegration.newFolder('New Folder','root');
        Test.stopTest();
    }
    @isTest 
    static void deleteFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassBox());
        String url=CommunityBoxApiIntegration.createAuthURL();
        String testAccessToken=CommunityBoxApiIntegration.getAccessToken(url);
        Test.startTest();
        Boolean createFolder=CommunityBoxApiIntegration.deleteFileBox('123','files');
        Test.stopTest();
    }
    @isTest 
    static void downloadFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassBox());
        String url=CommunityBoxApiIntegration.createAuthURL();
        String testAccessToken=CommunityBoxApiIntegration.getAccessToken(url);
        Test.startTest();
        String downloadFile=CommunityBoxApiIntegration.downloadFile('123');
        Test.stopTest();
    }
    @isTest 
    static void getRetrieveAcessToken(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassBox());
        String url=CommunityBoxApiIntegration.createAuthURL();
        String testAccessToken=CommunityBoxApiIntegration.getAccessToken(url);
        Integration__c googleDriveIntegration=new Integration__c();
        Test.startTest();
        Integration__c getAccessToken=CommunityBoxApiIntegration.retrieveBoxAccessToken(googleDriveIntegration);
        Test.stopTest();
    }
    // @isTest 
    // static void uploadFile(){
    //     Test.setMock(HttpCalloutMock.class, new MockTestClass());
    //     String url=CommunityBoxApiIntegration.createAuthURL();
    //     String testAccessToken=CommunityBoxApiIntegration.getAccessToken(url);
    //     Test.startTest();
    //     String getAccessToken=CommunityBoxApiIntegration.uploadFile('hello','123','456','image/jpeg');
    //     Test.stopTest();
    // }
}