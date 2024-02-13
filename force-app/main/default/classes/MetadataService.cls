public with sharing class MetadataService {
    public static String accessToken;
    public static void UpdateCustomMetadata(Map<String,object> token) {
        System.debug(token);
        accessToken=(String)token.get('access_token');
        Integration__c integration=new Integration__c();
        integration.Access_Token__c=(String)token.get('access_token');
        integration.Refresh_Token__c=(String)token.get('refresh_token');
        integration.Type_Integration__c='Google Drive';
        integration.Contact__c=UserInfo.getName();

        list<Integration__c> recordSize=new list<Integration__c>([Select id,Type_Integration__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c =  :UserInfo.getName() AND Type_Integration__c='Google Drive']);
        System.debug(recordSize.size());
        if(recordSize.isEmpty()){
            insert integration;
        }
        if(recordSize.size()==1){
            recordSize[0].Access_Token__c=(String)token.get('access_token');
            // recordSize[0].Refresh_Token__c=(String)token.get('refresh_token');
            // recordSize[0].Type_Integration__c='Google Drive';
            // recordSize[0].Contact__c=UserInfo.getName();
            update recordSize;
        }

        // Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        // customMetadata.fullName = 'GoogleAuthSetting.AccessToken';
        // customMetadata.label = 'AccessToken';
        // customMetadata.protected_x = true;
        
        // Metadata.CustomMetadataValue accessToken = new Metadata.CustomMetadataValue();
        // accessToken.field = 'AccessToken__c';
        // accessToken.value = token;
        // customMetadata.values.add(accessToken);
        
        // Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        // mdContainer.addMetadata(customMetadata);
        // CustomMetadataCallback callback = new CustomMetadataCallback();
        // Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
    public static void boxApiData(Map<String,object> token) {
        System.debug(token);
        accessToken=(String)token.get('access_token');
        Integration__c integration=new Integration__c();
        integration.Access_Token__c=(String)token.get('access_token');
        integration.Refresh_Token__c=(String)token.get('refresh_token');
        integration.Type_Integration__c='Box';
        integration.Contact__c=UserInfo.getName();

        list<Integration__c> recordSize=new list<Integration__c>([Select id,Type_Integration__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c =  :UserInfo.getName() AND Type_Integration__c = 'Box']);
        System.debug(recordSize.size());
        if(recordSize.isEmpty()){
            insert integration;
        }
        if(recordSize.size()==1){
            recordSize[0].Access_Token__c=(String)token.get('access_token');
            // recordSize[0].Refresh_Token__c=(String)token.get('refresh_token');
            // recordSize[0].Type_Integration__c='Google Drive';
            // recordSize[0].Contact__c=UserInfo.getName();
            update recordSize;
        }
    }
    // public class CustomMetadataCallback implements Metadata.DeployCallback {
        
    //     public void handleResult(Metadata.DeployResult result,
    //                                 Metadata.DeployCallbackContext context) {
    //                                     if (result.status == Metadata.DeployStatus.Succeeded) {
    //                                         System.debug(' success : '+ result);
    //                                     } else {
    //                                         System.debug(' fail : '+ result);
    //                                     }
    //                                 }
    // }
}