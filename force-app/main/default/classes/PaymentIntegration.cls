    /**
    Name:PaymentIntegration
    Description:In this class implemented payment integration with authorize .net by card and echeck
    **/
public with sharing class PaymentIntegration {
        /** 
         Name: payByAuthrizePayment,
        description: payment authorizing by card,
        Param:cardNumber, cardMonth, cardYear, cvv
        Return Type:String
        **/
    @AuraEnabled
    public static String payByAuthrizePayment(String cardNumber, String cardMonth, String cardYear, String cvv){
        String email = 'himanshu.garg@briskminds.com';//you can also feed this in LWC Form
        // String fullName = firstName + ' ' + lastName;
        String phone = '9910490806'; //you can also feed this in LWC Form
        String loginId = '9hV3nEA25'; // these get from authurize.net sandbox account tab
        String transactionKey = '3492Zrj8vF8hFQBQ';// these get from authurize.net sandbox account tab
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String endPoint='https://apitest.authorize.net/xml/v1/request.api';
        String method='POST';
        Map<String,String> headers=new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String body='{"createTransactionRequest": {"merchantAuthentication": {"name": "'+loginId+' ","transactionKey":"'+transactionKey+'"}, "refId": "123456",   "transactionRequest": {"transactionType": "authCaptureTransaction","amount": "5", "payment": { "creditCard": {"cardNumber": "'+cardNumber+'","expirationDate": "'+cardYear+'-'+cardMonth+'","cardCode":'+cvv+'}}}}}';
        HttpResponse res = ServiceClass.paymentIntegration(endPoint,method,headers,body);
        String responseBody = res.getBody();
        if(String.IsNotBlank(res.getBody())){
            System.debug(res.getBody());
            if(responseBody.contains('"description":"This transaction has been approved."') || responseBody.contains('"description":"Your order has been received. Thank you for your business!"')){
                return 'This transaction has been approved.';
            } else{
                string error = responseBody.substringBetween('"errorText":"','"');
                throw newMessageException('Error encountered: ' + error);   
            }
        } else{
            throw newMessageException('Error encountered. Status Code: ' + res.getStatus());   
        }
    }

    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }
      /** 
         Name: payByEcheck,
        description: payment authorizing by echeck,
        Param:routingNumber, accountNumber, nameOnAccount
        Return Type:String
        **/
    @AuraEnabled
    public static String payByEcheck(String routingNumber,String accountNumber,String nameOnAccount){
        String loginId = '9hV3nEA25';
        String transactionKey = '3492Zrj8vF8hFQBQ';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String endPoint='https://apitest.authorize.net/xml/v1/request.api';
        String method='POST';
        Map<String,String> headers=new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String body='{ "createTransactionRequest": { "merchantAuthentication": {"name": "'+loginId+'","transactionKey": "'+transactionKey+'"},"refId": "123456","transactionRequest": {"transactionType": "authCaptureTransaction","amount": "5","payment": {"bankAccount": {"accountType": "checking","routingNumber": "'+routingNumber+'","accountNumber": "'+accountNumber+'","nameOnAccount": "'+nameOnAccount+'"}}}}}';
        HttpResponse res = ServiceClass.paymentIntegration(endPoint,method,headers,body);
        String responseBody = res.getBody();
        if(String.IsNotBlank(res.getBody())){
            System.debug(res.getBody());
            if(responseBody.contains('"description":"This transaction has been approved."') || responseBody.contains('"description":"Your order has been received. Thank you for your business!"')){
                return 'This transaction has been approved.';
            } else{
                string error = responseBody.substringBetween('"errorText":"','"');
                throw newMessageException('Error encountered: ' + error);   
            }
        } else{
            throw newMessageException('Error encountered. Status Code: ' + res.getStatus());   
        }
    }
}
 