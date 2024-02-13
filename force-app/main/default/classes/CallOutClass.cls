public class CallOutClass {
    @future(callout=true)
    public static void makeCallout() {
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        String endpoint = 'http://yourHost/yourService';
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        HttpResponse response = new HTTP().send(request);
    }
}


// trigger updateSerialNoOnOppoLineItem on OpportunityLineItem(before insert){
//     Set<Id> oppId = new Set<Id>();
//     for(OpportunityLineItem oppProd:Trigger.new){
//     oppId.add(oppProd.OpportunityId);
//     }
//     List<OpportunityLineItem> oppProdListTOUpdate = new List<OpportunityLineItem>();
//     //Map of Opportunity Id and SeralNo of OpportunityLineItem
//     Map<Id,String> oppIdSerialNoMap =new Map<Id,String>();
//     List<OpportunityLineItem> oppProdList=[Select Id,Serial_No__c,OpportunityId from OpportunityLineItem where OpportunityId=:oppId];
//     if(oppProdList.size()>0){
//     for(OpportunityLineItem oppoPrd:oppProdList){
//     if(oppoPrd.Serial_No__c!=null){
//     //Getting the last number of the SerialNo field
//     String lastword = oppoPrd.Serial_No__c.right(1);
//     //converting String into Integer so that I can increment the lastnumber which is already there in SerialNo field
//     Integer num = Integer.valueOf(lastword);
//     num++;
//     //appending the incremented number
//     oppoPrd.Serial_No__c=oppoPrd.Serial_No__c+','+(num);
//     oppProdListTOUpdate.add(oppoPrd);
//     //adding it to Map so that i can make changes for the OpportunityLineItem which is newly getting inserted
//     oppIdSerialNoMap.put(oppoPrd.OpportunityId,oppoPrd.Serial_No__c);
//     }
//     else{
//     //if the SerialField is null then it means there is no OpportunityLineItem present so by default we are passing 1
//     oppoPrd.Serial_No__c='1';
//     oppProdListTOUpdate.add(oppoPrd);
//     }
//     }
//     }
//     if(oppProdListTOUpdate.size()>0){
//     update oppProdListTOUpdate;
//     }
//     for(OpportunityLineItem oppProd:Trigger.new){
//     /*Checking if the OpportunityId of newly inserting OpportunityLineItem is present in the Map
//     If present we are passing that SerialNo to the newly inserting OpportunityLineItem else we are just adding 1 because
//     this is the first OpportunityLineItem getting added*/
//     if(oppIdSerialNoMap.containsKey(oppProd.OpportunityId)){
//     oppProd.Serial_No__c = oppIdSerialNoMap.get(oppProd.OpportunityId);
//     }
//     else{
//     oppProd.Serial_No__c='1';
//     }
//     }
//     }