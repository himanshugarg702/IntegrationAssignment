trigger Assignment3ContactEmail on Contact (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        Assignment3ContactEmail.handleBeforeInsert(Trigger.new);
    }
  /*  // getting user email from below query
    User current_user=[SELECT Email FROM User WHERE Id= :UserInfo.getUserId()] ;
 for(contact con :trigger.new){
     // if email is  equal to null make it user email
         if(con.email==null){
             con.email=current_user.Email;
         }
     // if email is equal to current user then show error
     else if(con.email==current_user.Email){
         con.email.addError('Please you cant add user email same');
     }
    }*/
}