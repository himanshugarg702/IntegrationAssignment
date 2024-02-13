@isTest
private class TestRestrictContactByName {
    @isTest static void checkInvalidLastName(){
        Contact con=new Contact(LastName='InvalidName');
         insert con;
    }
}