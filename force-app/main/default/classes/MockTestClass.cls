@isTest
public class MockTestClass  implements HttpCalloutMock{
    public static void insertFileAsContent(){
        ContentVersion cv=new ContentVersion(
            Title='testing',
            PathOnClient='TextFile.txt',
            VersionData=Blob.valueOf('T')
        );
        insert cv;
    }
    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res=new HTTPResponse();
        if(req.getEndpoint()=='https://accounts.google.com/o/oauth2/token'&&req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('{"access_token":"abcdef","expires_in":3599,"scope":"https://www.googleapis.com/auth/drive","token_type":"Bearer"}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/drive/v2/files?q=\''+'root'+'\'%20in%20parents%20and%20trashed%3Dfalse'&& req.getMethod()=='GET'){
            // res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"items":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","title":"hello","mimiType":"image/png","shared":false}]}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/drive/v2/files'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"items":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","title":"New Folder","mimiType":"application/vnd.google-apps.folder"}]}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/drive/v2/files/123'&& req.getMethod()=='DELETE'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"items":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","title":"New Folder","mimiType":"application/vnd.google-apps.folder"}]}');
            res.setStatusCode(204);
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/drive/v2/files/'+ '123'+'?alt=media'&& req.getMethod()=='GET'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"items":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","title":"New Folder","mimiType":"image/png"}]}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"title":"hello","mimeType": "image/jpeg"}');
            res.setStatusCode(200);
        }
        return res;
    }
}