public class ContactAndLeadSearch {
    public static list<list<sObject>> searchContactsAndLeads(String para1){
        Contact con=new Contact(LastName='Smith');
        insert con;
        Lead lead=new Lead(LastName='Smith',COMPANY='abc');
        insert lead;
        list<list<sObject>> searchList=[Find :para1 IN ALL FIELDS 
                      Returning Contact(LastName),Lead(LastName)];
      
        return searchList;
    }
}