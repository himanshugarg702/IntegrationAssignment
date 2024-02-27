public with sharing class MetadataService {
    public static String accessToken;
    public static void UpdateCustomMetadata(Map<String,object> token) {
        System.debug(token);
        accessToken=(String)token.get('access_token');
        Integration__c integration=new Integration__c();
        integration.Access_Token__c=(String)token.get('access_token');
        integration.Refresh_Token__c=(String)token.get('refresh_token');
        integration.Type_Integration__c='Google Drive';
        integration.ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)token.get('expires_in')));
        integration.Contact__c=UserInfo.getName();

        list<Integration__c> recordSize=new list<Integration__c>([Select id,ExpiresIn__c,Type_Integration__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c =  :UserInfo.getName() AND Type_Integration__c='Google Drive']);
        System.debug(recordSize.size());
        if(recordSize.isEmpty()){
            insert integration;
        }
        if(recordSize.size()==1){
            recordSize[0].Access_Token__c=(String)token.get('access_token');
            recordSize[0].ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)token.get('expires_in')));
            update recordSize;
        }
    }
    public static void boxApiData(Map<String,object> token) {
        System.debug(token);
        accessToken=(String)token.get('access_token');
        Integration__c integration=new Integration__c();
        integration.Access_Token__c=(String)token.get('access_token');
        integration.Refresh_Token__c=(String)token.get('refresh_token');
        integration.Type_Integration__c='Box';
        integration.ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)token.get('expires_in')));
        integration.Contact__c=UserInfo.getName();

        list<Integration__c> recordSize=new list<Integration__c>([Select id,ExpiresIn__c,Type_Integration__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c =  :UserInfo.getName() AND Type_Integration__c = 'Box']);
        System.debug(recordSize.size());
        if(recordSize.isEmpty()){
            insert integration;
        }
        if(recordSize.size()==1){
            recordSize[0].Access_Token__c=(String)token.get('access_token');
            recordSize[0].ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)token.get('expires_in')));
            update recordSize;
        }
    }
    public static void dropboxApiData(Map<String,object> token) {
        System.debug(token);
        accessToken=(String)token.get('access_token');
        Integration__c integration=new Integration__c();
        integration.Access_Token__c=(String)token.get('access_token');
        integration.Refresh_Token__c=(String)token.get('refresh_token');
        integration.Type_Integration__c='Dropbox';
        integration.ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)token.get('expires_in')));
        integration.Contact__c=UserInfo.getName();

        list<Integration__c> recordSize=new list<Integration__c>([Select id,ExpiresIn__c,Type_Integration__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c =  :UserInfo.getName() AND Type_Integration__c = 'Dropbox']);
        System.debug(recordSize.size());
        if(recordSize.isEmpty()){
            insert integration;
        }
        if(recordSize.size()==1){
            recordSize[0].Access_Token__c=(String)token.get('access_token');
            recordSize[0].ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)token.get('expires_in')));
            update recordSize;
        }
    }

}