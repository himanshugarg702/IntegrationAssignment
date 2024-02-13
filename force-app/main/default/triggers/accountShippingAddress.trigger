trigger accountShippingAddress on Account (before insert) {
    for(Account a:Trigger.new){
        if(a.BillingAddress!=null){
            
        }
    }
}