public class Assignment2Contact {
    public static void handleBeforeUpdate(list<Contact> contacts){
        
        for(Contact con:contacts){
            if(con.AccountId!=null){
                Contact con1=[select accountid,Account.Rating from contact where id =:con.id];
                con1.Account.Rating='Cold';
                update con1;
            }
        }
    }
     public static void handleAfterUpdate(list<Contact> contacts){
        for(Contact con:contacts){
        Contact con1=[select accountid,Account.Rating from contact where id =:con.id];
        con1.Account.Rating='Hot';
             update con1;
        }
    }
}