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
        private static string authUrl='https://www.dropbox.com/oauth2/authorize';
        private static string scope='files.metadata.read file_requests.read files.content.read files.content.write file_requests.write';
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
            Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
           Boolean isError = false;
            String endPoint = 'https://api.dropboxapi.com/2/files/create_folder_v2';
            String body = '{"path": "'+folderName+'","autorename": false}';
            Map<String,String> headers=new Map<String,String>();
            headers.put('content-type','application/Json');
            headers.put('Authorization','Bearer '+integration.Access_Token__c);
            String method='POST';
            HttpResponse response = ServiceClass.requestDropBox(endPoint,method,headers,body);
            Map<string, string> jsonDataMap = new Map<string, string>();
            jsonDataMap = parseJSONToMap(response.getBody());
            if(jsonDataMap.containsKey('error')){
                isError = true;
                return isError;
            }
            else {
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
         /** 
         Name: retrieveGoogleAccessToken,
        description:retrieving again access token with the help of refrtesh token this method only for apex,
        Param:userData,
        Return Type:Integration__c object
        **/
        public static Integration__c  retrieveDropBoxAccessToken(Integration__c userData){
            string bodyRequest = '';
            bodyRequest = 'client_id=' + EncodingUtil.urlEncode(key, 'UTF-8');
            bodyRequest += '&client_secret=' + EncodingUtil.urlEncode(secert, 'UTF-8');
            bodyRequest += '&refresh_token=' + userData.Refresh_Token__c;
            bodyRequest += '&grant_type=refresh_token';
            Map<String,String> headers=new Map<String,String>();
            headers.put('content-length',string.ValueOf(bodyRequest.length()));
            String method='POST';
            HttpResponse response = ServiceClass.requestDropBox(tokenUrl,method,headers,bodyRequest);
            String responseText;
            responseText = response.getBody();
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
        public static Object getAllFilesFromBox(String rootFolderId) {   
            if(rootFolderId.length()>1){
                if(rootFolderId.substring(0,1)!='/'){
                    rootFolderId='/'+rootFolderId;
                }
            }
            Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
            if(rootFolderId=='/') {
                rootFolderId='';
            }
            if((integration.ExpiresIn__c<System.now()||integration.Access_Token__c==null)&&integration.Refresh_Token__c!=null){
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
            if(response.getStatusCode()==200){
                Map<String,Object> jsonResponse=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
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
                        googleDriveItem.pathDisplay=(String)fileInfo.get('path_display');
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
            String responseText;
            HttpResponse response = ServiceClass.requestDropBox(endPoint,method,headers,messageBody);
            responseText = response.getBody();
            System.debug(responseText);
            system.debug('responseText:'+responseText);
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText);  
            MetadataService.dropboxApiData(responseMap);
            return null;
        }

          /** 
         Name: uploadFile,
        description:upload file from component in box,
        Param:StringID,
        Return Type:String
        **/
        @AuraEnabled
        public static String uploadToDropBox(String file, String filename,String path) {
            Integration__c integration=[Select id,Access_Token__c,ExpiresIn__c,Refresh_Token__c,Contact__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
                String boundary = '----------9889464542212';
                // String bodyEncoded = EncodingUtil.base64Encode(file);
                Blob bodyEncoded2 = EncodingUtil.base64Decode(file);
                String body = '{ "path": "'+path+'/'+filename+'", "mode": "add", "autorename": true, "mute": false, "strict_conflict": false }';
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                String endpoint = 'https://content.dropboxapi.com/2/files/upload';
                String method='POST';
                Map<String,String> headers=new Map<String,String>();
                headers.put('Authorization', 'Bearer '+integration.Access_Token__c);
                headers.put('Dropbox-API-Arg', body);
                headers.put('Content-Type', 'application/octet-stream');
                headers.put('Content-length', String.valueOf(file.length()));
                req.setEndpoint(endpoint);
                req.setHeader('Authorization', 'Bearer '+integration.Access_Token__c);
                req.setHeader('Dropbox-API-Arg', body);
                req.setHeader('Content-Type', 'application/octet-stream');
                req.setHeader('Content-length', String.valueOf(file.length()));
                req.setBody(body);
                req.setBodyAsBlob(bodyEncoded2);
                req.setMethod('POST');
                req.setTimeout(60*1000);
                HttpResponse resp = http.send(req);
                map<string, string> jsonDataMap = new map<string, string>();
                jsonDataMap = parseJSONToMap1(resp.getBody());
                return null;
        }
        private static map<string, string> parseJSONToMap1(string JSONValue){
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
         /** 
         Name: deleteFileApex,
        description: delete file from apex ,
        Param:StringID,
        Return Type:Boolean
        **/
        @AuraEnabled
        public static Boolean deleteFileDropbox(String path){
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
            String accessToken=integration.Access_Token__c;
            String endPoint = 'https://api.dropboxapi.com/2/files/delete_v2';
            String body = '{"path": "'+path+'"}';
            Map<String,String> headers=new Map<String,String>();
            headers.put('content-type','application/Json');
            headers.put('Authorization','Bearer '+integration.Access_Token__c);
            String method='POST';
            HttpResponse response = ServiceClass.requestDropBox(endPoint,method,headers,body);
            Map<string, string> jsonDataMap = new Map<string, string>();
            jsonDataMap = parseJSONToMap(response.getBody());
            if(jsonDataMap.containsKey('error')){
                return false;
            }
            else {
                return true;
            }
        }
         /** 
         Name: downloadFile,
        description: download file,
        Param:StringID,
        Return Type:String
        **/
        @AuraEnabled
        public static String downloadFile(String path){
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Dropbox']; 
            String accessToken=integration.Access_Token__c;
            String endPoint = 'https://api.dropboxapi.com/2/files/get_temporary_link';
            String body = '{"path": "'+path+'"}';
            Map<String,String> headers=new Map<String,String>();
            headers.put('content-type','application/Json');
            headers.put('Authorization','Bearer '+integration.Access_Token__c);
            String method='POST';
            HttpResponse res = ServiceClass.requestDropBox(endPoint,method,headers,body);
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody());  

            return (String)responseMap.get('link');
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
            @AuraEnabled
            public String pathDisplay{get;set;}
        }
    }   
