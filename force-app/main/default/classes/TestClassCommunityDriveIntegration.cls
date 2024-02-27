@isTest 
public with sharing class TestClassCommunityDriveIntegration {
    @isTest 
    static void getAllObjects(){
        Test.startTest();
        CommunityAssignmentClassGoogleDrive.checkUserCreatedOrNot();
        // Map<String,String> result1 = KanBanViewAssignment.allObject();
        // System.assertEquals(true,result1!=null);
        // Map<String,String> result2 = KanBanViewAssignment.allObject();
        // System.assertEquals(false,result2.size()==null);
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
        Test.startTest();
        String getAccessToken=CommunityAssignmentClassGoogleDrive.uploadFile('hello','123','456','image/jpeg');
        Test.stopTest();
    }
    // @isTest 
    // static void getAccesssToken() {
       
    //     HttpResponse res = CommunityAssignmentClassGoogleDrive.getAccessToken();
        
    //     // Verify response received contains fake values
    //     String contentType = res.getHeader('Content-Type');
    //     System.assert(contentType == 'application/x-www-form-urlencoded');
    //     String actualValue = res.getBody();
    //     String expectedValue = '{"example":"test"}';
    //     System.assertEquals(actualValue, expectedValue);
    //     System.assertEquals(200, res.getStatusCode());
    // }
}