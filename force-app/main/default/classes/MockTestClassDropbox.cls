@isTest
public class MockTestClassDropbox  implements HttpCalloutMock{
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
        if(req.getEndpoint()=='https://www.dropbox.com/oauth2/token'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            // req.setHeader('Authorization', 'Bearer '+'sl.BwdC2u0ykw0XasPPEgk-rZ9W8VmRFKRTyRXg2QZ6k29rYV5xv1GkFDSk9hBn8SMad6LAbVK7FLM2uqcixJNpiPEC6MWnM_A4AEaGVPfgAfIgJbTIOBM1hF7juIWhONnuHYN2JocQGP0fN_8');
            Map<String,object> responseMap =new Map<String,object>{'access_token'=>'sl.BwdC2u0ykw0XasPPEgk-rZ9W8VmRFKRTyRXg2QZ6k29rYV5xv1GkFDSk9hBn8SMad6LAbVK7FLM2uqcixJNpiPEC6MWnM_A4AEaGVPfgAfIgJbTIOBM1hF7juIWhONnuHYN2JocQGP0fN_8',  'expires_in'=> 14400, 'refresh_token'=> '5hRXZkh0gYAAAAAAAAAAVnwSM-VcTMnB1ZIhCMfERGQWMztn5VUW7P-gtAjPe93'};
            res.setBody(JSON.serialize(responseMap));
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/list_folder'&& req.getMethod()=='POST'){
            // res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"entries":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","name":"hello",".tag":"image/png"}]}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/create_folder_v2'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"entries":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","name":"hello",".tag":"image/png"}]}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/delete_v2'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"entries":[{"kind":"drive#File","id":"ghhjvbjhkbhvvjbkhbv","name":"hello",".tag":"image/png"}]}');
            res.setStatusCode(204);
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/get_temporary_link'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"kind":"drive#fileList","incompleteSearch":false,"entries":[{ ".tag": "file", "name": "briskminds_software_solutions_pvt_ltd__logo (1) (2) (1) (1) (1).jpg", "path_lower": "/briskminds_software_solutions_pvt_ltd__logo (1) (2) (1) (1) (1).jpg",  "path_display": "/briskminds_software_solutions_pvt_ltd__logo (1) (2) (1) (1) (1).jpg", "id": "id:hKU8J3ZpwckAAAAAAAAACA", "client_modified": "2024-02-21T09:37:36Z"}],"link": "https://uc072b650588d9f7d9d742d6c3b6.dl.dropboxusercontent.com/cd/0/get/COBMly4QKlRmMayI21T_GBrqiwqiboQS7KY16u9xGNO28Qq8A7HolScL_PYAc9MQTPydC3DYvkurBxbYhxSoF9cODubalJOiRlSaTeYoHblEuvwy85SRfQUkHjXco4IZw5fzk7bSPWLjDjENgGNAg0LE1jFtboLNh1QW6KKBFW4L5g/file"}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://content.dropboxapi.com/2/files/upload'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"name":"hello",".tag": "image/jpeg"}');
            res.setStatusCode(200);
        }
        return res;
    }
}
