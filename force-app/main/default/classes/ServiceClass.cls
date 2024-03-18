public with sharing class ServiceClass {
    public static HttpResponse requestGoogleDrive(String method,String contentType,String contentLength,String messageBody,String endPoint,String header){
          HttpRequest req = new HttpRequest();
            req.setMethod(method);
            req.setEndpoint(endPoint);
            req.setHeader('content-type', contentType);
            System.debug(method);
            System.debug(contentType);
            System.debug(contentLength);
            System.debug(messageBody);
            System.debug(endPoint);
            System.debug(header);
            // String messageBody ='code='+code+'&client_id='+key+
            //     '&client_secret='+secert+
            //     '&redirect_uri='+redirect_uri+
            //     '&grant_type=authorization_code';
            if(contentLength!=null){
                req.setHeader('Content-length', contentLength);
            }
            if(messageBody!=null){
                req.setBody(messageBody);
            }
            req.setHeader('Authorization','Bearer '+header);

            req.setTimeout(60*1000);
            //    system.debug('messageBody:'+messageBody);
            Http callout = new Http();
            // String responseText;
            HttpResponse response = callout.send(req);
            System.debug(response);
            return response;
    }
    public static HttpResponse requestDropBox(String endPoint,String method,Map<String,String> headers,String body){
        HttpRequest req = new HttpRequest();
          req.setMethod(method);
          req.setEndpoint(endPoint);
          for(String header:headers.keySet()){
            req.setHeader(header,headers.get(header));
          }
          req.setBody(body);
          req.setTimeout(60*1000);
          // if(tempBlob!=null){
          //   req.setBodyAsBlob(tempBlob);
          // }
          Http callout = new Http();
          HttpResponse response = callout.send(req);
          System.debug(response);
          return response;
  }
  public static HttpResponse paymentIntegration(String endPoint,String method,Map<String,String> headers,String body){
    HttpRequest req = new HttpRequest();
      req.setMethod(method);
      req.setEndpoint(endPoint);
      for(String header:headers.keySet()){
        req.setHeader(header,headers.get(header));
      }
      req.setBody(body);
      req.setTimeout(60*1000);
      Http callout = new Http();
      HttpResponse response = callout.send(req);
      System.debug(response);
      return response;
}
}