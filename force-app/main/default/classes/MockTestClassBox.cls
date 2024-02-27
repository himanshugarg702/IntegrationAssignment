@isTest
public class MockTestClassBox  implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res=new HTTPResponse();
        if(req.getEndpoint()=='https://account.box.com/oauth2/token'&&req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('{"access_token":"abcdef","expires_in":3599,"scope":"root_readwrite","token_type":"Bearer"}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://api.box.com/2.0/folders/0'&& req.getMethod()=='GET'){
            // res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"item_collection":{"entries":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","title":"hello","mimiType":"image/png","shared":false}]}}');
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
        else if(req.getEndpoint()=='https://upload.box.com/api/2.0/files/content?parent_id='+'0'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"name":"hello","type": "image/jpeg"}');
            res.setStatusCode(200);
        }
        // System.assertEquals('https://accounts.google.com/o/oauth2/token', req.getEndpoint());
        // System.assertEquals('GET', req.getMethod());        
        // Create a fake response
        // HttpResponse res = new HttpResponse();
        // res.setStatusCode(200);
        // String messageBody ='code='+code+'&client_id='+key+
        // '&client_secret='+secert+
        // '&redirect_uri='+redirect_uri+
        // '&grant_type=authorization_code';
        return res;
    }
}