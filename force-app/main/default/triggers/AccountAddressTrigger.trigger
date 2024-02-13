trigger AccountAddressTrigger on Account (before insert, before update) {
  //  for(Account a:Trigger.new){
    //    if(a.Match_Billing_Address__c!=null && a.BillingPostalCode!=null){
      //      a.ShippingPostalCode=a.BillingPostalCode;
       // }
    //}
    //  if(trigger.isInsert)
    for(Account a: Trigger.new){
        if( a.Match_Billing_Address__c == true && a.BillingPostalCode!=null ){
            a.ShippingPostalCode = a.BillingPostalCode;
        }
    }
}