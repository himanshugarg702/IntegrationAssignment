@isTest
public class TestClassKanBanViewAssignment {
     @isTest 
    static void getAllObjects(){
        Test.startTest();
        Map<String,String> result1 = KanBanViewAssignment.allObject();
        System.assertEquals(true,result1!=null);
        Map<String,String> result2 = KanBanViewAssignment.allObject();
        System.assertEquals(false,result2.size()==null);
        Test.stopTest();
    }
    @isTest 
    static void getAllFields(){
        Test.startTest();
        Map<String,String> result1 = KanBanViewAssignment.allFields('Account');
        System.assertEquals(true,result1!=null);
        Test.stopTest();
    }
    @isTest 
    static void pickListFields(){
        Test.startTest();
        Map<String,String> result1 = KanBanViewAssignment.pickListFields('Account');
        System.assertEquals(true,result1!=null);
        Test.stopTest();
    }
      @isTest 
    static void getPickVals(){
        List<String> fields=new List<String>();
        fields.add('Name');
        fields.add('BillingStreet');
        Test.startTest();
        KanBanViewAssignment.KanbanViewWrapperClass result1 = KanBanViewAssignment.getPickVals('Rating','Account',fields);
        //AuraPaginationAssignment.WrapperClass result2=5;
        System.assertEquals(true,result1!=null);
        Test.stopTest();
    }
     @isTest 
    static void getUpdateStage(){
        List<String> fields=new List<String>();
        fields.add('Name');
        fields.add('BillingStreet');
        Test.startTest();
        String result1 = KanBanViewAssignment.getUpdateStage('Account','0015g00001SWDF3','Rating','Hot');
        //AuraPaginationAssignment.WrapperClass result2=5;
        System.assertEquals('Success',result1);
        Test.stopTest();
    }
}