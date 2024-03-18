public with sharing class MockTestClassPaymentIntegration implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res=new HTTPResponse();
        if(req.getEndpoint()=='https://apitest.authorize.net/xml/v1/request.api'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"createTransactionRequest": {"merchantAuthentication": {"name": "9hV3nEA25","transactionKey":"3492Zrj8vF8hFQBQ"}, "refId": "123456",   "transactionRequest": {"transactionType": "authCaptureTransaction","amount": "5", "payment": { "creditCard": {"cardNumber": "2737282828282828","expirationDate": "2025-04","cardCode":"123"}}}}}');
            res.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://apitest.authorize.net/xml/v1/request.api'&& req.getMethod()=='POST'){
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "createTransactionRequest": { "merchantAuthentication": {"name": "9hV3nEA25","transactionKey": "3492Zrj8vF8hFQBQ"},"refId": "123456","transactionRequest": {"transactionType": "authCaptureTransaction","amount": "5","payment": {"bankAccount": {"accountType": "checking","routingNumber": "2345643213","accountNumber": "2345654323456","nameOnAccount": "hima"}}}}}');
            res.setStatusCode(200);
        }
        return res;
    }
}