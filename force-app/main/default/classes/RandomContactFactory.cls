public class RandomContactFactory {
    public static list<Contact> generateRandomContacts (Integer numContact, String lastName){
        list<Contact> con=new list<Contact>();
        for(Integer i=0;i<numContact;i++){
             Contact a = new Contact(FirstName='Test ' + i,LastName=lastName);
            con.add(a);
        }
        return con;
    }
}