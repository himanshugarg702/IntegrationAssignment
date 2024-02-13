public with sharing class CommunityBoxApiIntegration {
        //API Secret Key
        private static string key = 'clqx56kbwh0zw15rlqc4jinw30n36a68';
        //API Secret
        private Static string secert = 'oNOxQS9bbbnvq7VUcKR8oM8eKylcSECd';
        //API Redirect. Use your Lightning Tab or Lightning community URL
        private Static string redirect_uri = 'https://briskminds-b3-dev-ed.develop.my.site.com/s/?tabset-f0cd9=3';
       //String authorizationUrl = "https://account.box.com/api/oauth2/authorize?client_id=[CLIENT_ID]&response_type=code";
        // response.redirect(authorizationUrl);
        private static string authUrl='https://account.box.com/api/oauth2/authorize';
        private static string scope='root_readwrite';
        //https://www.googleapis.com/auth/drive
        private static string tokenUrl='https://account.box.com/oauth2/token';
        // https://briskminds-b3-dev-ed.develop.my.site.com/s
        // https://www.googleapis.com/auth/fitness.activity.read
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
        
        @AuraEnabled
        public static String getAccessToken(String code)
        {
            System.debug('helloworld');
            //Getting access token from google
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
            System.debug('response'+response);
            responseText = response.getBody();
            system.debug('responseText:'+responseText);
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText);  
            String token =  String.valueOf(responseMap.get('access_token'));
            system.debug('token:'+token);
            //Update token in custom metadata 
            MetadataService.boxApiData(responseMap);
            return token;
        }
        @AuraEnabled
        public static List<WrapperGoogleDrive> getAllFilesFromGoogleDrive() {   
            Integration__c integration=[Select id,Access_Token__c,Contact__c,Type_Integration__c from Integration__c where Contact__c=:UserInfo.getName() AND Type_Integration__c = 'Box']; 
            // integration.Access_Token__c;

            String accessToken=integration.Access_Token__c;
            // Integration__c inte= MetadataService.accessToken;
            //Getting access token from google
            List<WrapperGoogleDrive> fileList=new List<WrapperGoogleDrive>();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.box.com/2.0/folders/0');
            req.setMethod('GET');
            req.setHeader('content-type', 'application/Json');
            req.setHeader('Authorization','Bearer '+accessToken);
            req.setTimeout(60*1000);
            Http http=new Http();
            HttpResponse response = http.send(req);
            if(response.getStatusCode()==200){
                Map<String,Object> jsonResponse=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('jsonResponse'+jsonResponse);
                for(String v:jsonResponse.keySet()){
                    System.debug(v+' '+ jsonResponse.get(v));
                }
                //System.debug()
                // String obj = (String)jsonResponse.get('item_collection');
                // Map<String,Map<String,Object>> files=(Map<String,Map<String,Object>>)JSON.deserializeUntyped(jsonResponse.get('item_collection').get('entries'));
                Map<String,Object> nestedJsonObject= (Map<String,Object>) jsonResponse.get('item_collection');
                // for(Object file:files){
                //     System.debug(file);
                // }
                // System.debug('files'+files);

                List<Object> files=(List<Object>) nestedJsonObject.get('entries');
                // System.debug('files1'+files1);

                for(Object file:files){
                    Map<String,Object> fileInfo=(Map<String,Object>) file;
                    // if(fileInfo.get('shared')==false){
                        WrapperGoogleDrive googleDriveItem=new WrapperGoogleDrive();
                        googleDriveItem.name=(String) fileInfo.get('name');
                        googleDriveItem.Id=(String) fileInfo.get('id');
                        googleDriveItem.mimiType=(String) fileInfo.get('type');
                        // googleDriveItem.alternativeLink=(String) fileInfo.get('alternateLink');
                        // googleDriveItem.downLoadLink=(String) fileInfo.get('webContentLink');
                        fileList.add(googleDriveItem);
                    // }
                }
                String responseBody=response.getBody();
                System.debug('Response body: '+responseBody);
            }
            else{
                System.debug('Error: '+ response.getStatusCode()+' '+response.getStatus());
            }
            // return true;
            return fileList;

        }
        @AuraEnabled
        public static Boolean deleteFileApex(String StringID,String accessToken)
        {   
            // Integration__c inte= MetadataService.accessToken;
            //Getting access token from google
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
                // Map<String,Object> jsonResponse=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                // List<Object> files=(List<Object>) jsonResponse.get('items');
            // HttpResponse resp = null;
            // resp = http.send(req);
            // // Object test = resp.getBody();
            // System.debug('hello world');
            // if(resp.getStatusCode() == 200){
            //     // PageReference pageref = new PageReference(resp.getBody());
            //     //  return pageref.getUrl();
            // }
        
            // return true;
            // return true;
            // return fileList;

        }

        // @AuraEnabled
        // public void UploadFile() {
        //     String boundary = '----------9889464542212';
        //     String delimiter = '\r\n--' + boundary + '\r\n';
        //     String close_delim = '\r\n--' + boundary + '--';
        //     String bodyEncoded = EncodingUtil.base64Encode(file);
        //     String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '" }' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
        //     Http http = new Http();
        //     HttpRequest req = new HttpRequest();
        //     req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
        //     req.setHeader('Authorization', 'Bearer ' + accessToken);
        //     req.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        //     req.setHeader('Content-length', String.valueOf(body.length()));
        //     req.setBody(body);
        //     req.setMethod('POST');
        //     req.setTimeout(60 * 1000);
        //     HttpResponse resp = http.send(req);
        //     file = null;
        //     filetype = '';
        //     filename = '';
        // }
        // --BOUNDARY
        // Content-Type: application/json
        
        // {"name": "fileName"}
        
        // --BOUNDARY
        // Content-Transfer-Encoding: base64
        // Content-Type: image/png
        
        // fileData
        // --BOUNDARY--
        @AuraEnabled
        public static String downloadFile(String StringID,String accessToken){
            //webContentLink
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
            // Object test = resp.getBody();
            System.debug('hello world');
            if(resp.getStatusCode() == 200){
                PageReference pageref = new PageReference(resp.getBody());
                 return pageref.getUrl();
            }
        
            return null;
        }
        // @AuraEnabled
        // public static String uploadFile(String attachmentId, String accessToken,String name) {
        //     System.debug('helloworld');
        //     List<ContentVersion> cvFile = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        //     System.debug('hello');
        //     System.debug(cvFile);
        //     Blob myBlob = cvFile[0].VersionData;
        //    String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
        //    string authorizationHeader = 'Bearer ' + accessToken; 
        //    Integer contentSize = myBlob.size();
        //    HttpRequest req = new HttpRequest();
        //    req.setheader('Authorization',authorizationHeader);
        //    req.setheader('Content-Length',String.valueOf(contentSize));
        //     req.setheader('Content-Type','image/'+cvFile[0].FileType);//,'title/'+ name
        //    req.setMethod('POST'); 
        //    req.setEndpoint(url); 
        //    req.setBodyAsBlob(myBlob); 
        //    Http h = new Http(); 
          
        //    Httpresponse resp = h.send(req);
        //    //After file was successfully upload we delete the file
        //    delete new ContentDocument(Id = cvFile[0].ContentDocumentId);
        //    return String.valueOf(resp.getStatuscode());
        // }
        // @AuraEnabled
        // public static String  uploadFile(String fileName, String accessToken,String fileContent) {
        //         String boundary = '-------314159265358979323846';
        //     String body = '--' + boundary + '\nContent-Disposition: form-data; name="file"; filename="' + fileName + '"\nContent-Type: application/octet-stream\n\n';
        //     String endPoint = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart';
            
        //     HttpRequest req = new HttpRequest();
        //     req.setMethod('POST');
        //     req.setEndpoint(endPoint);
        //     req.setHeader('Authorization', 'Bearer ' + accessToken);
        //     req.setHeader('Content-Type', 'multipart/related; boundary=' + boundary);
        //         String base64Content = (Blob.valueOf(body) + fileContent + Blob.valueOf('\n--' + boundary + '--'));
        //         //Blob body = EncodingUtil.base64Decode(base64Content);
        //     req.setBodyAsBlob(EncodingUtil.base64Decode(base64Content));
        //     //  req.setBodyAsBlob(EncodingUtil.base64Decode(( String ) JSON.deserialize(Blob.valueOf(body) + fileContent + Blob.valueOf('\n--' + boundary + '--'))));
            
        //         System.debug(fileName);
        //         System.debug(filecontent);
        //     /*      String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
        //     String authorizationHeader = 'Bearer ' + accessToken; 
        //     HttpRequest req = new HttpRequest();
        //     req.setHeader('Authorization', authorizationHeader);
        //     req.setHeader('Content-Type', 'application/octet-stream');
        //     req.setMethod('POST'); 
        //     req.setEndpoint(url); 
        //     req.setBodyAsBlob(EncodingUtil.base64Decode(fileContent)); // Set the Blob content as the body directly*/
        //     Http h = new Http(); 
        //     HttpResponse resp = h.send(req);
            
        //     if (resp.getStatusCode() == 200) {
        //         return 'File uploaded successfully';
        //     } else {
        //         throw new AuraHandledException('Error uploading file: ' + resp.getStatusCode() + ' ' + resp.getStatus());
        //     }
        //     /*   System.debug('helloworld');
        //     String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
        //     string authorizationHeader = 'Bearer ' + accessToken; 
        //     //    Integer contentSize = myBlob.size();
        //     HttpRequest req = new HttpRequest();
        //     req.setheader('Authorization',authorizationHeader);
        //     req.setheader('Content-Length',String.valueOf(fileContent.length()));
        //         req.setheader('Content-Type','application/octet-stream');//,'title/'+ name
        //     req.setMethod('POST'); 
        //     req.setEndpoint(url); 
        //     req.setBodyAsBlob(EncodingUtil.base64Decode(fileContent)); 
        //     Http h = new Http(); 
            
        //     Httpresponse resp = h.send(req);
        //     if(resp.getStatusCode()==200){
        //         System.debug('helloworld2');

        //         return true;
        //     }
        //     else{
        //         System.debug('helloworld3');

        //         System.debug('Error: '+ resp.getStatusCode()+' '+resp.getStatus());
        //         return false;
        //     }*/
        //     //After file was successfully upload we delete the file
        //     //    delete new ContentDocument(Id = cvFile[0].ContentDocumentId);
        //     //    return String.valueOf(resp.getStatuscode());
        // }
        // public PageReference downloadFile(FileWrapper file){
        //     if(file == null || file.webViewLink == null){
        //         return null;
        //     }
        
        //     String url = file.webViewLink + '?access_token=' + accessToken;
        
        //     PageReference pageref = new PageReference(url);
        //     return pageref;
        // }
        
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