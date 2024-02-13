@isTest
private class TestVerifyDate {
    @isTest static void testCase1(){
        Date date3=VerifyDate.CheckDates(System.Today(),System.Today()+10);
        Date date4=VerifyDate.CheckDates(System.today() ,System.Today()+30);
    }
}