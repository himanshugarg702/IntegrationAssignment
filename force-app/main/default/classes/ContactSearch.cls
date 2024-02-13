public class ContactSearch {
    public static list<Contact> searchForContacts(String lastName, String mailing){
        list<Contact> con=new list<Contact>();
       con=[Select Id,Name from Contact where LastName=:lastName AND MailingPostalCode=:mailing];
        return con;
    }
}