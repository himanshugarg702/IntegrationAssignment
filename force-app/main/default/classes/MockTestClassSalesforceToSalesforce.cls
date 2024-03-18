public with sharing class MockTestClassSalesforceToSalesforce implements HttpCalloutMock{
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
        if(req.getEndpoint()=='callout:salesforcetosalesforce/services/apexrest/Contact/'&&req.getMethod()=='GET'){
            res.setHeader('Content-Type', 'application/json; charset=URF-8');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='callout:salesforcetosalesforce/services/apexrest/Contact/'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/json; charset=UTF-8');
            // res.setHeader('Content-Type', 'application/Json');
            res.setBody('{"fileName":"helloCHeck","base64":"hjiiohbuijubyjiubjiubyu"}');
            res.setStatusCode(200);
        }
        return res;
    }
}