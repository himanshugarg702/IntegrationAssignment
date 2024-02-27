    /**
    Name:CommunityBoxApiIntegration
    Description:In this class implemented integration with box getting access token from custom object
    **/
    public with sharing class CommunityBoxApiIntegration {
        //API Secret Key
        private static string key = Drives__mdt.getInstance('box').AppKey__c;//Drives__mdt.getInstance('box').AppKey__c
        //API Secret
        private static string secert = Drives__mdt.getInstance('box').AppSecret__c;
        private static string redirect_uri = 'https://briskminds-b3-dev-ed.develop.my.site.com/s/?tabset-f0cd9=3';
        private static string authUrl='https://account.box.com/api/oauth2/authorize';
        private static string scope='root_readwrite';
        private static string tokenUrl='https://account.box.com/oauth2/token';
        /** 
         Name: checkUserCreatedOrNot,
        description: checking user is already created or not,
        Param:null,
        Return Type:Boolean
        **/
        @AuraEnabled

        public static Boolean checkUserCreatedOrNot() {
            list<Integration__c> integration=[Select id,Access_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box' limit 1]; 
            if(integration.size()==1){
                return true;
            }
            else{
                return false;
            }
        }
         /** 
         Name: createAuthURL,
        description: creating auth url for user in which email id want to authenticate,
        Param:null,
        Return Type:String
        **/
        @AuraEnabled
        public static String createAuthURL() {
            String key = EncodingUtil.urlEncode(key,'UTF-8');
            String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
            String authuri = '';
            authuri = authUrl+'?'+
                'client_id='+key+
                '&response_type=code'+
                '&scope='+scope+
                '&redirect_uri='+uri+
                '&access_type=offline'+
                '&prompt=consent';
            return authuri;
        }
         /** 
         Name: newFolder,
        description: creating new folder,
        Param:new folder name, parent id ,
        Return Type:Boolean
        **/
        @AuraEnabled
        public static Boolean newFolder(String folderName,String fileId) {
            String parentFolderId=fileId;
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            String accessToken=integration.Access_Token__c;
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');     
            req.setEndpoint('https://api.box.com/2.0/folders');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            req.setHeader('content-type', 'application/json');
            String body = '{ "name": "' + folderName + '", "parent": { "id": "' + parentFolderId + '" } }';
            req.setTimeout(60*1000);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
            if(res.getStatusCode()==201){
                return true;
            }
            else{
                return false;
            }
        }
         /** 
         Name: retrieveBoxAccessToken,
        description:retrieving again access token with the help of refrtesh token this method only for apex,
        Param:userData,
        Return Type:Integration__c object
        **/
        public static Integration__c  retrieveBoxAccessToken(Integration__c userData){
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            string endPointValue = 'https://api.box.com/oauth2/token';   
            req.setEndpoint(endPointValue);
            string bodyRequest = '';
            bodyRequest = 'client_id=' + EncodingUtil.urlEncode(key, 'UTF-8');
            bodyRequest += '&client_secret=' + EncodingUtil.urlEncode(secert, 'UTF-8');
            bodyRequest += '&refresh_token=' + userData.Refresh_Token__c;
            bodyRequest += '&grant_type=refresh_token';
            req.setBody(bodyRequest);         
            req.setHeader('Content-length', string.ValueOf(bodyRequest.length())); 
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setMethod('POST');
            
            req.setTimeout(10000);
            HttpResponse res = h.send(req);   
            String responseText;
            responseText = res.getBody();
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
            userData.Access_Token__c=(String)responseMap.get('access_token');
            userData.ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)responseMap.get('expires_in')));
            return userData;
        }
         /** 
         Name: getAllFilesFromBox,
        description: getting access token from google ,
        Param:fileId for root and if breadcrumb folder it will change,
        Return Type:WrapperGoogleDrice class
        **/
        @AuraEnabled
        public static List<WrapperBox> getAllFilesFromBox(String fileId) {   
            Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            if(integration.ExpiresIn__c<System.now()){
                integration=retrieveBoxAccessToken(integration);
            }
            List<WrapperBox> fileList=new List<WrapperBox>();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.box.com/2.0/folders/'+fileId);
            req.setMethod('GET');
            req.setHeader('content-type', 'application/Json');
            req.setHeader('Authorization','Bearer '+integration.Access_Token__c);
            req.setTimeout(60*1000);
            Http http=new Http();
            HttpResponse response = http.send(req);
            if(response.getStatusCode()==200){
                Map<String,Object> jsonResponse=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                Map<String,Object> nestedJsonObject= (Map<String,Object>) jsonResponse.get('item_collection');
                List<Object> files=(List<Object>) nestedJsonObject.get('entries');
                for(Object file:files){
                    Map<String,Object> fileInfo=(Map<String,Object>) file;
                        WrapperBox googleDriveItem=new WrapperBox();
                        googleDriveItem.name=(String) fileInfo.get('name');
                        googleDriveItem.Id=(String) fileInfo.get('id');
                        googleDriveItem.mimiType=(String) fileInfo.get('type');
                        fileList.add(googleDriveItem);
                }
                String responseBody=response.getBody();
            }
            else{
                System.debug('Error: '+ response.getStatusCode()+' '+response.getStatus());
            }
            update integration;
            return fileList;
        }
          /** 
         Name: getAccessToken,
        description: getting access token from google ,
        Param:Authorization code,
        Return Type:String
        **/
        @AuraEnabled
        public static String getAccessToken(String code) {
            System.debug(code);
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(tokenUrl);
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            String messageBody ='code='+code+'&client_id='+key+
                '&client_secret='+secert+
                '&redirect_uri='+redirect_uri+
                '&grant_type=authorization_code';
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60*1000);
               system.debug('messageBody:'+messageBody);
            Http callout = new Http();
            String responseText;
            HttpResponse response = callout.send(req);
            responseText = response.getBody();
            system.debug('responseText:'+responseText);
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText);  
            String token =  String.valueOf(responseMap.get('access_token'));
            MetadataService.boxApiData(responseMap);
            return token;
        }
         /** 
         Name: newMessageException,
        description: for throwing exception if error occured,
        Param: message ,
        Return Type:AuraHandledException
        **/
        private static AuraHandledException newMessageException(String message) {
            AuraHandledException e = new AuraHandledException(message);
            e.setMessage(message);
            return e;
        }

          /** 
         Name: uploadFile,
        description:upload file from component in box ,
        Param:StringID,
        Return Type:String
        **/
        @AuraEnabled
        public static string uploadFile(String attachmentId, String fileName , String mimeType , String ParentId){
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            String accessToken=integration.Access_Token__c;
            String uploadEndPointURL='https://upload.box.com/api/2.0/files/content?parent_id='+ParentId;
    
                List<ContentVersion> cvFile = [SELECT VersionData,title,FileExtension,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId ];
    
                fileName = cvFile[0].title + '.' + cvFile[0].FileExtension ;
                Blob myBlob = cvFile[0].VersionData;
                String bodyEncoded = EncodingUtil.base64Encode(cvFile[0].VersionData);
                
    
                blob base64EncodeFile = base64EncodeFileContent(EncodingUtil.base64Decode(bodyEncoded), fileName);
                    if(base64EncodeFile == null) {
                        return 'Error';
                    }
                    String boundary = '----------------------------741e90d31eff';
                    String body = '{"name":"' + fileName + '", "parent":{"id":"' + parentId + '"}}';
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint('https://upload.box.com/api/2.0/files/content?parent_id='+parentId);
                    req.setBody(body);
                    req.setBodyAsBlob(base64EncodeFile);
                    req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
                    req.setHeader('Authorization', 'Bearer ' + accessToken);
                    req.setMethod('POST');
                    req.setTimeout(120000);
                    Http ht = new Http();
                    HTTPResponse res = ht.send(req);
    
                if (res.getStatusCode() == 201) {
                    return 'File uploaded successfully';
                } else {
                    return 'Error: ' + res.getStatus() + ', ' + res.getBody();
                }
        }
        public static blob base64EncodeFileContent(Blob file_body, String file_name){
                Blob bodyBlob = null;    
                String boundary = '----------------------------741e90d31eff';
                String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
                String footer = '--'+boundary+'--';             
                String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
                while(headerEncoded.endsWith('='))
                {
                    header+=' ';
                    headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
                }
                String bodyEncoded = EncodingUtil.base64Encode(file_body);
                String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        
                if(last4Bytes.endsWith('==')) {
                    last4Bytes = last4Bytes.substring(0,2) + '0K';
                    bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
                } else if(last4Bytes.endsWith('=')) {
                    last4Bytes = last4Bytes.substring(0,3) + 'N';
                    bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                    footer = '\n' + footer;
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
                } else {
                    footer = '\r\n' + footer;
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
                }
                return bodyBlob;
        }
         /** 
         Name: deleteFileApex,
        description: delete file from apex ,
        Param:StringID,
        Return Type:Boolean
        **/
        @AuraEnabled
        public static Boolean deleteFileBox(String StringID,String fileType) {   
            fileType=fileType+'s';
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            String accessToken=integration.Access_Token__c;
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.box.com/2.0/'+fileType+'/'+StringID);
            req.setMethod('DELETE');
            req.setHeader('content-type', 'application/Json');
            req.setHeader('Authorization','Bearer '+accessToken);
            req.setHeader('Accept', 'application/json');
            req.setTimeout(60*1000);
            Http http=new Http();
            HttpResponse response = http.send(req);
            if(response.getStatusCode()==204){
                return true;
            }
            else{
                System.debug('Error: '+ response.getStatusCode()+' '+response.getStatus());
                return false;
            }
        }

         /** 
         Name: downloadFile,
        description: download file  ,
        Param:StringID,
        Return Type:String
        **/
        @AuraEnabled
        public static String downloadFile(String StringID){
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            String accessToken=integration.Access_Token__c;
            if(StringID == null){
                return null;
            }
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint('https://api.box.com/2.0/files/'+StringID+'/content');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setHeader('Accept', 'application/json');
            req.setTimeout(60 * 1000);
            HttpResponse resp = null;
            resp = http.send(req);
            return resp.getHeader('location');
        }
        /**
        Name:WrapperGoogleDrive
        Description:this is a wrapper class to storing name of file id of file mimitype of file download link
        **/
        public class WrapperBox{
            @AuraEnabled
            public String name{get;set;}
            @AuraEnabled
            public String Id{get;set;}
            @AuraEnabled
            public String mimiType{get;set;}
        }
    }   
