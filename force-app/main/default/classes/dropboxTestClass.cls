@isTest 
public with sharing class dropboxTestClass {
    @isTest 
    static void checkUserIsCreatedOrNot(){
        Test.startTest();
        Communitydropboxintegration.checkUserCreatedOrNot();
        Test.stopTest();
    }
    @isTest 
    static void createAuthURL(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassDropbox());
        Test.startTest();
        String url=Communitydropboxintegration.createAuthURL();
        String testAccessToken=Communitydropboxintegration.getAccessToken(url);
        Test.stopTest();
    }
    @isTest 
    static void getFiles(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassDropbox());
        String url=Communitydropboxintegration.createAuthURL();
        String testAccessToken=Communitydropboxintegration.getAccessToken(url);
        Test.startTest();
        Object getFiles=Communitydropboxintegration.getAllFilesFromBox('');
        Test.stopTest();
    }
    @isTest 
    static void createNewFolder(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassDropbox());
        String url=Communitydropboxintegration.createAuthURL();
        String testAccessToken=Communitydropboxintegration.getAccessToken(url);
        Test.startTest();
        Boolean createFolder=Communitydropboxintegration.newFolder('/hello');
        Test.stopTest();
    }
    @isTest 
    static void deleteFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassDropbox());
        String url=Communitydropboxintegration.createAuthURL();
        String testAccessToken=Communitydropboxintegration.getAccessToken(url);
        Test.startTest();
        Boolean createFolder=Communitydropboxintegration.deleteFileDropbox('/hello');
        Test.stopTest();
    }
    @isTest 
    static void downloadFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassDropbox());
        String url=Communitydropboxintegration.createAuthURL();
        String testAccessToken=Communitydropboxintegration.getAccessToken(url);
        Test.startTest();
        String downloadFile=Communitydropboxintegration.downloadFile('/briskminds_software_solutions_pvt_ltd__logo (1) (2) (1) (1) (1).jpg');
        Test.stopTest();
    }
    @isTest 
    static void getRetrieveAcessToken(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassDropbox());
        String url=Communitydropboxintegration.createAuthURL();
        String testAccessToken=Communitydropboxintegration.getAccessToken(url);
        Integration__c googleDriveIntegration=new Integration__c();
        Test.startTest();
        Integration__c getAccessToken=Communitydropboxintegration.retrieveDropBoxAccessToken(googleDriveIntegration);
        Test.stopTest();
    }
    @isTest 
    static void uploadFile(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassDropbox());
        String url=Communitydropboxintegration.createAuthURL();
        String testAccessToken=Communitydropboxintegration.getAccessToken(url);
        Test.startTest();
        String getAccessToken=Communitydropboxintegration.uploadToDropBox('dsfgfdsdfgfds','briskminds_software_solutions_pvt_ltd__logo (1) (2) (1) (1) (1).jpg','/hello');
        Test.stopTest();
    }
}