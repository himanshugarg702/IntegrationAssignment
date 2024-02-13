public class Practice3 {
    public List<Contact> contactList {get;set;}
    public Practice3(){
        contactList=[select id,FirstName,LastName from Contact];
    }
}