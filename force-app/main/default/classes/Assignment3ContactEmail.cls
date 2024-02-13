public class Assignment3ContactEmail {
 
    public static void handleBeforeInsert(List<Contact> listCon){
         User current_user=[SELECT Email FROM User WHERE Id= :UserInfo.getUserId()] ;
         for(contact con :listCon){
             if(con.email==null){
                 con.email=current_user.Email;
             }
             else if(con.email==current_user.Email){
            	 con.email.addError('Please you cant add user email same');
             }
         }
    }
}