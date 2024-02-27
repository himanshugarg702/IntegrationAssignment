    /**
    Name:Communitydropboxintegration
    Description:In this class implemented integration with dropbox getting access token from custom object
    **/
    public with sharing class Communitydropboxintegration {
        // private static Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
        //API Secret Key
        private static string key =Drives__mdt.getInstance('dropbox').AppKey__c;
        //API Secret
        private static string secert =Drives__mdt.getInstance('dropbox').AppSecret__c;
        private static string redirect_uri = 'https://briskminds-b3-dev-ed.develop.my.site.com/s/?tabset-f0cd9=43259';
        private static string authUrl='https://www.dropbox.com/oauth2/authorize';//https://api.dropboxapi.com/2/users/get_current_account
        private static string scope='files.metadata.read file_requests.read files.content.read files.content.write file_requests.write';//'file_requests.read';//'files.metadata.read';
        private static string tokenUrl='https://www.dropbox.com/oauth2/token';
        /** 
        Name: checkUserCreatedOrNot,
        description: checking user is already created or not,
        Param:null,
        Return Type:Boolean
        **/
        @AuraEnabled
        public static Boolean checkUserCreatedOrNot() {
            list<Integration__c> integration=[Select id,Access_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox' limit 1]; 
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
            System.debug(key);
            String key = EncodingUtil.urlEncode(key,'UTF-8');
            String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
            String authuri = '';
            authuri = authUrl+'?'+
                'client_id='+key+
                '&response_type=code'+      
                '&scope='+scope+          
                '&redirect_uri='+uri+
                '&token_access_type=offline'+
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
        public static Boolean newFolder(String folderName){
            System.debug(folderName);
            Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
           Boolean isError = false;
            String endPoint = 'https://api.dropboxapi.com/2/files/create_folder_v2';
            String body = '{"path": "/'+folderName+'","autorename": false}';
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setEndpoint(endpoint);
            req.setHeader('Authorization', 'Bearer '+integration.Access_Token__c);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setBody(body);
            res = http.send(req);
            System.debug(res);
            Map<string, string> jsonDataMap = new Map<string, string>();
            jsonDataMap = parseJSONToMap(res.getBody());
            if(jsonDataMap.containsKey('error')){
                isError = true;
                return isError;
                // errorMessage = 'Create Folder Process failed!!';
            }
            else {
                // successMessage = 'Folder Created Successfully!!';
                return isError;
            }
        }
        private static map<string, string> parseJSONToMap(string JSONValue){
            JSONParser parser = JSON.createParser(JSONValue);
            map<string, string> jsonMap = new map<string, string>();
            string keyValue = '';
            string tempValue = '';
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                    keyValue = parser.getText();
                    parser.nextToken();
                    tempValue = parser.getText();
                    jsonMap.put(keyValue, tempValue);            
                }
            }
            return jsonMap;
        }
        // public static Boolean newFolder(String folderName,String fileId) {
        //     String parentFolderId=fileId;
        //     Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
        //     String accessToken=integration.Access_Token__c;
        //     HttpRequest req = new HttpRequest();
        //     req.setMethod('POST');     
        //     req.setEndpoint('https://api.box.com/2.0/folders');
        //     req.setHeader('Authorization', 'Bearer '+accessToken);
        //     req.setHeader('content-type', 'application/json');
        //     String body = '{ "name": "' + folderName + '", "parent": { "id": "' + parentFolderId + '" } }';
        //     req.setTimeout(60*1000);
        //     req.setBody(body);
        //     Http http = new Http();
        //     HttpResponse res = http.send(req);
        //     if(res.getStatusCode()==201){
        //         return true;
        //     }
        //     else{
        //         return false;
        //     }
        // }
         /** 
         Name: retrieveGoogleAccessToken,
        description:retrieving again access token with the help of refrtesh token this method only for apex,
        Param:userData,
        Return Type:Integration__c object
        **/
        public static Integration__c  retrieveDropBoxAccessToken(Integration__c userData){
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(tokenUrl);
            string bodyRequest = '';
            bodyRequest = 'client_id=' + EncodingUtil.urlEncode(key, 'UTF-8');
            bodyRequest += '&client_secret=' + EncodingUtil.urlEncode(secert, 'UTF-8');
            bodyRequest += '&refresh_token=' + userData.Refresh_Token__c;
            bodyRequest += '&grant_type=refresh_token';
            req.setBody(bodyRequest);         
            req.setHeader('Content-length', string.ValueOf(bodyRequest.length())); 
            // req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setMethod('POST');
            System.debug('hello world hima garg');
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
        public static List<WrapperBox> getAllFilesFromBox(String rootFolderId) {   
            Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
            if(rootFolderId=='/'){
                rootFolderId='';
            }
            if(integration.ExpiresIn__c<System.now()){
                integration=retrieveDropBoxAccessToken(integration);
            }
            List<WrapperBox> fileList=new List<WrapperBox>();
            String endPoint='https://api.dropboxapi.com/2/files/list_folder';
            String method='POST';
            Map<String,String> headers=new Map<String,String>();
            headers.put('content-type','application/Json');
            headers.put('Authorization','Bearer '+integration.Access_Token__c);
            String body='{"include_deleted":false,"include_has_explicit_shared_members":false,"include_media_info":false,"include_mounted_folders":true,"include_non_downloadable_files":true,"path":"'+rootFolderId+'","recursive":false}';
            HttpResponse response = ServiceClass.requestDropBox(endPoint,method,headers,body);
            System.debug(response);
            if(response.getStatusCode()==200){
                Map<String,Object> jsonResponse=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                System.debug(jsonResponse);
                List<Object> files=(List<Object>) jsonResponse.get('entries');
                for(Object file:files){
                    Map<String,Object> fileInfo=(Map<String,Object>) file;
                        WrapperBox googleDriveItem=new WrapperBox();
                        googleDriveItem.name=(String) fileInfo.get('name');
                        googleDriveItem.Id=(String) fileInfo.get('id');
                        googleDriveItem.mimiType=(String) fileInfo.get('.tag');
                        if((String) fileInfo.get('.tag')=='file'){
                            googleDriveItem.folderOrFile=true;
                        }
                        else{
                            googleDriveItem.folderOrFile=false;
                        }
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
            HttpRequest req = new HttpRequest();
            String method='POST';
            String endPoint=tokenUrl;
            Map<String,String> headers=new Map<String,String>();
            headers.put('content-type','application/x-www-form-urlencoded');
            String messageBody ='code='+code+'&client_id='+key+
                '&client_secret='+secert+
                '&redirect_uri='+redirect_uri+
                '&grant_type=authorization_code';
                headers.put('Content-length', String.valueOf(messageBody.length()));
            System.debug('messageBody:'+messageBody);
            String responseText;
            HttpResponse response = ServiceClass.requestDropBox(endPoint,method,headers,messageBody);
            responseText = response.getBody();
            system.debug('responseText:'+responseText);
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText);  
            String token =  String.valueOf(responseMap.get('access_token'));
            MetadataService.dropboxApiData(responseMap);
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
        public static String uploadFile(String base64, String filename, String folderId){
            folderId='0';
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            String accessToken=integration.Access_Token__c;
            if(base64!=null){
                blob base64EncodeFile = base64EncodeFileContent(EncodingUtil.base64Decode(base64),filename);
                String uploadEndPointURL='https://upload.box.com/api/2.0/files/content?parent_id='+folderId;
                String boundary = '----------------------------741e90d31eff';
                String body = '{"name":"' + filename + '", "parent":{"id":"' + folderId + '"}}';
                HttpRequest req = new HttpRequest();
                req.setBody(body);
                req.setBodyAsBlob(base64EncodeFile);
                req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
                req.setHeader('Authorization', 'Bearer ' + accessToken);
                req.setMethod('POST');
                req.setEndpoint(uploadEndPointURL);
                req.setTimeout(120000);
                Http ht = new Http();
                HTTPResponse res = ht.send(req);
                System.debug('**Files upload Response: ' + res.getBody());
                Integer uploadStatusCode=res.getStatusCode();
                if(uploadStatusCode==201){
                    return 'File uploaded successfully.';
                }else{
                throw newMessageException('Error encountered. Status Code: ' + uploadStatusCode);                
                }
            }else{
                throw newMessageException('Please select file.');
            }
        }

        public static blob base64EncodeFileContent(Blob file_body, String file_name){
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
            Blob bodyBlob = null;
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
        public static Boolean deleteFileDropbox(){
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            String accessToken=integration.Access_Token__c;
            String endPoint = 'https://api.dropboxapi.com/2/files/delete_v2';
            String body = '{"path": "/Test"}';
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setHeader('Authorization', 'Bearer '+accessToken);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setBody(body);
            HttpResponse res = http.send(req);
            system.debug(res);
            Map<string, string> jsonDataMap = new Map<string, string>();
            jsonDataMap = parseJSONToMap(res.getBody());
            if(jsonDataMap.containsKey('error')){
                return false;
                // isError = true;
                // errorMessage = 'Delete Folder Process failed!!';
            }
            else {
                return true;
                // successMessage = 'Folder Deleted Successfully!!';
                // isSuccess = true;
            }
        }
        // public static Boolean deleteFileDropbox(String StringID,String fileType) {   
        //     fileType=fileType+'s';
        //     Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
        //     String accessToken=integration.Access_Token__c;
        //     HttpRequest req = new HttpRequest();
        //     req.setEndpoint('https://api.box.com/2.0/'+fileType+'/'+StringID);
        //     req.setMethod('DELETE');
        //     req.setHeader('content-type', 'application/Json');
        //     req.setHeader('Authorization','Bearer '+accessToken);
        //     req.setHeader('Accept', 'application/json');
        //     req.setTimeout(60*1000);
        //     Http http=new Http();
        //     HttpResponse response = http.send(req);
        //     if(response.getStatusCode()==204){
        //         return true;
        //     }
        //     else{
        //         System.debug('Error: '+ response.getStatusCode()+' '+response.getStatus());
        //         return false;
        //     }
        // }

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
            @AuraEnabled
            public Boolean folderOrFile{get;set;}
        }
    }   
