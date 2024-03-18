public with sharing class SalesforceToSalesforceIntegration {
    
    // @AuraEnabled(cacheable=true)
    // @future(callout=true)
    @AuraEnabled(cacheable=true)
    public static List<Object> getDetails() {
        try {
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:salesforcetosalesforce/services/apexrest/Contact/');
                req.setHeader('Content-Type', 'application/json; charset=URF-8');
                req.setHeader('Accept', 'application/json');
                req.setMethod('GET');
                Http http = new Http();
                HttpResponse response = http.send(req);
                // return response.getBody();
                if (response.getStatusCode() == 200) {
                    String responseBody = response.getBody();
                    List<Object> accountReceivedList = (List<Object>) JSON.deserializeUntyped(responseBody);
                    return accountReceivedList;
                } 
            } catch (Exception e) {
                System.debug('Exception caught: ' + e.getMessage());
                System.debug('Line no: ' + e.getLineNumber());
            }
        return null;

    }
    @AuraEnabled
    public static void uploadToNewOrg(String fileName,String base64){
        try {
            System.debug('hello');
            HttpRequest req=new HttpRequest();
            req.setEndpoint('callout:salesforcetosalesforce/services/apexrest/Contact/');
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            req.setHeader('Accept', 'application/json');
            req.setBody('{"fileName":"'+fileName+'","base64":"'+base64+'"}');
            req.setMethod('POST');
            Http http=new Http();
            HttpResponse response=http.send(req);
            System.debug(response);
        } catch (Exception e) {
            System.debug('error');
        }
    }
}