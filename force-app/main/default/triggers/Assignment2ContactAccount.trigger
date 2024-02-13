trigger Assignment2ContactAccount on Contact (before update ) {
    
      for(Contact con:Trigger.old){
            if(con.AccountId!=null){
                Contact con1=[select accountid,Account.Rating from contact where id =:con.id];
                Account a=new Account();
                 a.id=con1.Accountid;
                a.Rating='Cold';
                update a;
            }
        }
    for(Contact con:Trigger.new){
            if(con.AccountId!=null){
                Contact con1=[select accountid,Account.Rating from contact where id =:con.id];
               Account a=new Account();
                 a.id=con1.Accountid;
                a.Rating='Hot';
                update a;
            }
        }
    system.debug('Compe');
   
    
}