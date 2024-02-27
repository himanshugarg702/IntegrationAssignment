/**
Name:CommunityAssignmentClassGoogleDrive
Description:In this class implemented integration with google drive getting access token from custom object
**/
public class CommunityAssignmentClassGoogleDrive {

        private static string key = '116017441019-g59jsa3g2k5ehr4dln4mrvske5t062q4.apps.googleusercontent.com';//Drives__mdt.getInstance('box').AppKey__c
        private static string secert = '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';
        private static string redirect_uri = 'https://briskminds-b3-dev-ed.develop.my.site.com/s/?tabset-f0cd9=2';
        private static string authUrl='https://accounts.google.com/o/oauth2/v2/auth';
        private static string scope='https://www.googleapis.com/auth/drive';
        private static string tokenUrl='https://accounts.google.com/o/oauth2/token';
          /** 
         Name: checkUserCreatedOrNot,
        description: checking user is already created or not,
        Param:null,
        Return Type:Boolean
        **/
        @AuraEnabled
        public static Boolean checkUserCreatedOrNot() {
            list<Integration__c> integration=[Select id,Access_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Google Drive' limit 1]; 
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
         Name: getAccessToken,
        description: getting access token from google ,
        Param:Authorization code,
        Return Type:String
        **/
        @AuraEnabled
        public static String getAccessToken(String code) {
            // String method='POST';
            // String contentType='application/x-www-form-urlencoded';
            // String endPoint=tokenUrl;
            //Getting access token from google
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(tokenUrl);
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            
            String messageBody ='code='+code+'&client_id='+key+
                '&client_secret='+secert+
                '&redirect_uri='+redirect_uri+
                '&grant_type=authorization_code';
                String contentLength=String.valueOf(messageBody.length());
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60*1000);
            Http callout = new Http();
            String responseText;
            HttpResponse response = callout.send(req);
            responseText = response.getBody();
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
            String token =  String.valueOf(responseMap.get('access_token'));
            MetadataService.UpdateCustomMetadata(responseMap);
            return token;
        }
         /** 
         Name: getAllFilesFromGoogleDrive,
        description: getting access token from google ,
        Param:fileId for root and if breadcrumb folder it will change,
        Return Type:WrapperGoogleDrice class
        **/
        @AuraEnabled
        public static Object getAllFilesFromGoogleDrive(String fileId) {   
            Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Google Drive']; 
            if(integration.ExpiresIn__c<System.now()){
                integration=retrieveGoogleAccessToken(integration);
            }
            List<WrapperGoogleDrive> fileList=new List<WrapperGoogleDrive>();
            // String method='GET';
            // String contentType='application/Json';
            // String endPoint='https://www.googleapis.com/drive/v2/files';
            // String header=integration.Access_Token__c;
            HttpRequest req = new HttpRequest();
                req.setEndpoint('https://www.googleapis.com/drive/v2/files?q=\''+fileId+'\'%20in%20parents%20and%20trashed%3Dfalse');
            req.setMethod('GET');
            req.setHeader('content-type', 'application/Json');
            req.setHeader('Authorization','Bearer '+integration.Access_Token__c);
            req.setTimeout(60*1000);
            Http http=new Http();
            HttpResponse response = http.send(req);
            if(response.getStatusCode()==200){
                Map<String,Object> jsonResponse=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> files=(List<Object>) jsonResponse.get('items');
                for(Object file:files){
                    Map<String,Object> fileInfo=(Map<String,Object>) file;
                    if(fileInfo.get('shared')==false){
                        WrapperGoogleDrive googleDriveItem=new WrapperGoogleDrive();
                        googleDriveItem.name=(String) fileInfo.get('title');
                        googleDriveItem.Id=(String) fileInfo.get('id');
                        googleDriveItem.mimiType=(String) fileInfo.get('mimeType');
                        googleDriveItem.alternativeLink=(String) fileInfo.get('alternateLink');
                        googleDriveItem.downLoadLink=(String) fileInfo.get('webContentLink');
                        fileList.add(googleDriveItem);
                    }
                }
                String responseBody=response.getBody();
                update integration;
                return fileList;
            }
            else{ 
                
                // integration=retrieveGoogleAccessToken(integration);
                // update integration;
                // getAllFilesFromGoogleDrive();
                System.debug('Error: '+ response.getStatusCode()+' '+response.getStatus());

                return null;
            }
            
            
            // return true;
           
        }
         /** 
         Name: newFolder,
        description: creating new folder,
        Param:new folder name, parent id ,
        Return Type:Boolean
        **/
        @AuraEnabled
        public static Boolean newFolder(String folderName,String fileId) {
            Integration__c integration=[Select id,Access_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Google Drive']; 
            String accessToken=integration.Access_Token__c;
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');     
            // ?q=\''+fileId+'\'%20in%20parents%20and%20trashed%3Dfalse
            req.setEndpoint('https://www.googleapis.com/drive/v2/files');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            req.setHeader('content-type', 'application/json');
            String body = '{"title" : "'+ folderName +'","mimeType" : "application/vnd.google-apps.folder","parents": [{"kind":"drive#fileLink","id":"'+fileId+'"}]}';
            req.setTimeout(60*1000);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
            if(res.getStatusCode()==200){
                return true;
            }
            else{
                return false;
            }
        }
         /** 
         Name: deleteFileApex,
        description: delete file from apex ,
        Param:StringID,
        Return Type:Boolean
        **/
        @AuraEnabled
        public static Boolean deleteFileApex(String StringID) {   
            Integration__c integration=[Select id,Access_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Google Drive']; 
            String accessToken=integration.Access_Token__c;
            List<WrapperGoogleDrive> fileList=new List<WrapperGoogleDrive>();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://www.googleapis.com/drive/v2/files/'+StringID);
            req.setMethod('DELETE');
            req.setHeader('content-type', 'application/Json');
            req.setHeader('Authorization','Bearer '+accessToken);
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
            Integration__c integration=[Select id,Access_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Google Drive']; 
            String accessToken=integration.Access_Token__c;
            if(StringID == null){
                return null;
            }
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint('https://www.googleapis.com/drive/v2/files/'+ StringID+'?alt=media');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setTimeout(60 * 1000);
            HttpResponse resp = null;
            resp = http.send(req);
            if(resp.getStatusCode() == 200){
                PageReference pageref = new PageReference(resp.getBody());
                 return pageref.getUrl();
            }
            return null;
        }
         /** 
         Name: uploadFile,
        description:upload file from component in google drive ,
        Param:StringID,
        Return Type:String
        **/
        @AuraEnabled
        public static String uploadFile(String name,String attachmentId, String parentId,String type) {
            Integration__c integration=[Select id,Access_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Google Drive']; 
            String accessToken=integration.Access_Token__c;
            String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart';
            // try {
                String boundary = '----------72846284628223';
                String delimiter = '\r\n--' + boundary + '\r\n';
                String close_delim = '\r\n--' + boundary + '--';
                Blob valueFile = Blob.valueOf('file');
                String bodyEncoded = EncodingUtil.base64Encode(valueFile);
                Http http = new Http();
                HttpRequest req1 = new HttpRequest();
                List<ContentVersion> cvFile = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId ];
                Blob myBlob = cvFile[0].VersionData;
                String bodyEncoded2 = EncodingUtil.base64Encode(cvFile[0].VersionData);
                String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + name + '",' + ' "mimeType" : "' + type + '",' + '"parents":[{"id":"'+ ParentId +'"}]}'  + delimiter + 'Content-Type: ' + type + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded2 + close_delim; 
                Integer contentSize = myBlob.size();
                req1.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
                req1.setHeader('Authorization', 'Bearer ' + accessToken);
                req1.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
                req1.setHeader('Content-length', String.valueOf(body.length()));
                req1.setBody(body);
                req1.setMethod('POST');
                req1.setTimeout(60 * 1000);
                HttpResponse resp1 = http.send(req1);
                return String.valueOf(resp1.getStatuscode());
                
            // } catch (Exception e) {
            //     throw new AuraHandledException(e.getMessage());
            // }
        }
          /** 
         Name: retrieveGoogleAccessToken,
        description:retrieving again access token with the help of refrtesh token this method only for apex,
        Param:userData,
        Return Type:Integration__c object
        **/
        public static Integration__c  retrieveGoogleAccessToken(Integration__c userData){
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            string endPointValue = 'https://accounts.google.com/o/oauth2/token';   
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
            system.debug('responseText:'+responseText);
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
            userData.Access_Token__c=(String)responseMap.get('access_token');
            userData.ExpiresIn__c=DateTime.valueOf(System.now().addSeconds((Integer)responseMap.get('expires_in')));
            return userData;
        }
        /**
        Name:WrapperGoogleDrive
        Description:this is a wrapper class to storing name of file id of file mimitype of file download link
        **/
        public class WrapperGoogleDrive{
            @AuraEnabled
            public String name{get;set;}
            @AuraEnabled
            public String Id{get;set;}
            @AuraEnabled
            public String mimiType{get;set;}
            @AuraEnabled
            public String alternativeLink{get;set;}
            @AuraEnabled
            public String downLoadLink{get;set;}
        }
    }