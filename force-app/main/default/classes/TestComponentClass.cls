@isTest
public class TestComponentClass {
    @testSetup()
     static void insertRecord(){
        list<Account> acc=new list<Account>();
         for(Integer i=0;i<5;i++){
             acc.add(new Account(name='test1'+i));
         }
         insert acc;
    }
    @isTest
    static void testConstructor() {
        ComponentClass controller = new ComponentClass();
        controller.showData=new List<SelectOption>();
        //controller.accId='fgfdessdf';
         controller.ResultSize=1;
        controller.PageSize=1;
        controller.LimitSize=1;
        controller.selectedOption='abc';
        controller.ofPage=1;
        controller.csvButton='abc';
        
    }

    @isTest
    static void testChecking() {
        ComponentClass controller = new ComponentClass();
        // Set up test data or modify the controller state as needed
        controller.selectObj = 'Account';
        // controller.Fieldsa = 'Field1,Field2';
        Test.startTest();
        controller.checking();
        Test.stopTest();
    }
@isTest
    static void testMainPage() {
        // Set up test data or modify the controller state as needed
        ComponentClass controller = new ComponentClass();
        controller.selectObj = 'Case';
          controller.caseCon = 'Account';
       // controller.name='abc';  
      System.assertEquals(  controller.selectObj = 'Account', controller.caseCon = 'Account');
          controller.selectObj =    controller.caseCon;
        controller.nameFieldValues = new List<String>{'Name', 'Field1', 'Field2'};
              controller.objectNameField=true;
        // Add additional setup as needed
       controller.objectCaseField=false;
     
        
        // System.assertEquals( controller.name='abc',  controller.selectObj = 'Case');
        
        Test.startTest();
        controller.mainPage();
        Test.stopTest();

        // Add assertions based on the expected state after calling mainPage
        // For example:
        // System.assertEquals(5, controller.LimitSize);
        // System.assertEquals(1, controller.PageNumber);
        // System.assertEquals(true, controller.objectNameField);
        // ...

        // You may also want to assert the data in the dataList or tableData variables
        // For example:
        // System.assertEquals(5, controller.dataList.size());
        // System.assertEquals(10, controller.tableData.size());
    }
 @isTest
    static void testChangeList() {
        ComponentClass controller = new ComponentClass();
        controller.dataListToShow.clear();
        controller.ResultSize=1;
        controller.LimitSize=6;
        // Set up test data or modify the controller state as needed
        controller.selectObj = 'Account';
        // controller.Fieldsa = 'Field1,Field2';
        Test.startTest();
        controller.changeList();
        Test.stopTest();
    }
    @isTest
    static void testAlphaSearch() {
        // Set up test data or modify the controller state as needed
        ComponentClass controller = new ComponentClass();
        controller.selectObj = 'Case';
        controller.nameFieldValues = new List<String>{'Name', 'Field1', 'Field2'};
        controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
             controller.LimitSize=5;
        controller.ResultSize=2;
              Test.startTest();
               controller.alphaSearchConct = 'all';
          controller.alphaSearch();
        Test.stopTest();
          
        // Add assertions based on the expected state after calling alphaSearch
    }
     @isTest
    static void testAlphaSearch2() {
        // Set up test data or modify the controller state as needed
        ComponentClass controller = new ComponentClass();
        controller.selectObj = 'Case';
        controller.nameFieldValues = new List<String>{'Name', 'Field1', 'Field2'};
        controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
            controller.LimitSize=5;
        controller.ResultSize=2;
              Test.startTest();
               controller.alphaSearchConct = 'Others';
          controller.alphaSearch();
        Test.stopTest();
          
        // Add assertions based on the expected state after calling alphaSearch
    }
     @isTest
    static void testAlphaSearch3() {
        // Set up test data or modify the controller state as needed
        ComponentClass controller = new ComponentClass();
        controller.selectObj = 'Case';
        controller.nameFieldValues = new List<String>{'Name', 'Field1', 'Field2'};
        controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
             controller.LimitSize=5;
        controller.ResultSize=2;
              Test.startTest();
               controller.alphaSearchConct = '';
          controller.alphaSearch();
        Test.stopTest();
          
        // Add assertions based on the expected state after calling alphaSearch
    }
     static void testAllAlphaSearch() {
        // Set up test data or modify the controller state as needed
        ComponentClass controller = new ComponentClass();
        controller.selectObj = 'Case';
        controller.nameFieldValues = new List<String>{'Name', 'Field1', 'Field2'};
        controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              Test.startTest();
             controller.alphaSearchConct = 'Others';
        controller.alphaSearch();      
         Test.stopTest();
           
        // Add assertions based on the expected state after calling alphaSearch
    }
  @isTest
    static void downloadCSV() {
    // Add more test methods to cover other functionalities
         ComponentClass controller = new ComponentClass();
           controller.nameFieldValues = new List<String>{'Name'};
                 controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
             controller.dataListToShow[0].check=true;
          controller.dataListToShow[1].check=true;
               controller.csvButton='Name';
                 
               Test.startTest();
        controller.downloadCSV();
        Test.stopTest();
    }
    @isTest
    static void maintainCheckBox() {
         ComponentClass controller = new ComponentClass();
        controller.delCsvButttonDisable=true;
          controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha'))
        };
     
             controller.dataListToShow[0].check=true;
          controller.delCsvButttonDisable=true;
        Test.startTest();
        controller.maintainCheckBox();
        Test.stopTest();
    }
     @isTest
    static void seeDataAccordingToRecordPerPage(){
        ComponentClass controller = new ComponentClass();
        controller.selectedOption='5';
        controller.LimitSize=5;
        controller.PageNumber=1;
        controller.tempBool=true;
        controller.resultSize=5;
        
          controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
        Test.startTest();
        controller.seeDataAccordingToRecordPerPage();
        controller.selectedOption='10';
        controller.seeDataAccordingToRecordPerPage();
        Test.stopTest();
    }
     @isTest
    static void seeDataAccordingToRecordPerPage2(){
        ComponentClass controller = new ComponentClass();
        controller.selectedOption='10';
        controller.LimitSize=10;
        controller.PageNumber=1;
        controller.tempBool=true;
        controller.resultSize=5;
        
          controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
        Test.startTest();
        controller.seeDataAccordingToRecordPerPage();
        controller.selectedOption='10';
        controller.seeDataAccordingToRecordPerPage();
        Test.stopTest();
    }
     @isTest
    static void seeDataAccordingToRecordPerPage3(){
        ComponentClass controller = new ComponentClass();
        controller.selectedOption='15';
        controller.LimitSize=15;
        controller.PageNumber=1;
        controller.tempBool=true;
        controller.resultSize=5;
        
          controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
        Test.startTest();
        controller.seeDataAccordingToRecordPerPage();
        controller.selectedOption='15';
        controller.seeDataAccordingToRecordPerPage();
        Test.stopTest();
    }
     @isTest
    static void seeDataAccordingToRecordPerPage4(){
        ComponentClass controller = new ComponentClass();
        controller.selectedOption='20';
        controller.LimitSize=20;
        controller.PageNumber=1;
        controller.tempBool=true;
        controller.resultSize=5;
        
          controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
        Test.startTest();
        controller.seeDataAccordingToRecordPerPage();
        controller.selectedOption='20';
        controller.seeDataAccordingToRecordPerPage();
        Test.stopTest();
    }
      @isTest
    static void seeDataAccordingToRecordPerPage5(){
        ComponentClass controller = new ComponentClass();
        controller.selectedOption='10';
        controller.LimitSize=10;
        controller.PageNumber=1;
        controller.tempBool=false;
        controller.resultSize=5;
        
          controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     
        controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
        Test.startTest();
        controller.seeDataAccordingToRecordPerPage();
        controller.selectedOption='10';
        controller.seeDataAccordingToRecordPerPage();
        Test.stopTest();
    }
     @isTest
    static void testFirstPage() {
        // Create test data
        // Add necessary test data creation here

        // Instantiate your Apex class
        ComponentClass controller = new ComponentClass();
         controller.PageNumber=1;
        Test.startTest();
        controller.firstPage();
        // Add assertions for the expected behavior of firstPage method
        Test.stopTest();
        // Test firstPage method
       /* Test.startTest();
        PageReference firstPageResult = controller.firstPage();
        // Add assertions for the expected behavior of firstPage method
        Test.stopTest();

        // Test previousPage method
        Test.startTest();
        PageReference previousPageResult = controller.previousPage();
        // Add assertions for the expected behavior of previousPage method
        Test.stopTest();

        // Test nextPage method
        Test.startTest();
        PageReference nextPageResult = controller.nextPage();
        // Add assertions for the expected behavior of nextPage method
        Test.stopTest();

        // Test lastPage method
        Test.startTest();
        PageReference lastPageResult = controller.lastPage();
        // Add assertions for the expected behavior of lastPage method
        Test.stopTest();

        // Test valueSet method
        Test.startTest();
        controller.valueSet();
        // Add assertions for the expected behavior of valueSet method
        Test.stopTest();

        // Test deleteMode method
        Test.startTest();
        PageReference deleteModeResult = controller.deleteMode();
        // Add assertions for the expected behavior of deleteMode method
        Test.stopTest();

        // Test deleteSelected method
        Test.startTest();
        PageReference deleteSelectedResult = controller.deleteSelected();
        // Add assertions for the expected behavior of deleteSelected method
        Test.stopTest();*/
    }
     @isTest
     static void testNextPage() {
        ComponentClass controller = new ComponentClass();
         controller.PageNumber=1;
        Test.startTest();
        controller.nextPage();
         Test.stopTest();
     }
      @isTest
     static void testpreviousPage() {
        ComponentClass controller = new ComponentClass();
         controller.PageNumber=1;
        Test.startTest();
        controller.previousPage();
         Test.stopTest();
     }
      @isTest
     static void testlastPage() {
        ComponentClass controller = new ComponentClass();
         controller.PageNumber=1;
         controller.ResultSize=1;
         controller.LimitSize=1;
        Test.startTest();
        controller.lastPage();
         Test.stopTest();
     }
      @isTest
     static void testvalueSet() {
        ComponentClass controller = new ComponentClass();
         controller.PageNumber=10;
         controller.ResultSize=3;
         controller.LimitSize=1;
          controller.tempBool=true;
          controller.alphaTemp=new list<ComponentClass.Wrapper>{
        	   new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
         controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{};
        Test.startTest();
        controller.valueSet();
         Test.stopTest();
     }
      @isTest
    static void testDeleteMode() {
      
        ComponentClass controller = new ComponentClass();

        ApexPages.currentPage().getParameters().put('del', '0015g00001Va8FO'); // Replace 'AccountId' with the actual Account Id
          controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
     

        Test.startTest();
        controller.deleteMode();
      
        Test.stopTest();
    }
    @isTest
    static void testViewData() {
        // Create test data
        // Add necessary test data creation here, including creating test sObjects

        // Instantiate your Apex class
        ComponentClass controller = new ComponentClass();
          controller.sobj=new list<sObject>();
        

  controller.ResultSize=3;
        // Set up any necessary variables or parameters for the method
        controller.sortExpression = 'Name'; // Set your sort expression
        controller.sortDirection = 'ASC'; // Set your sort direction
        // Set other variables used in the method
     controller.sortFullExp= controller.sortExpression +   controller.sortDirection ;
        controller.order = ' order by ' +controller.sortFullExp ;
        //controller.selectObj='Account';
         // controller.sobj=Database.query('select id from Account'+controller.order );
        // Test viewData method
          controller.dataForManipulatingDataList = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
              controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
        Test.startTest();
        controller.viewData();
        // Add assertions for the expected behavior of viewData method
        // Verify that the dataListToShow and dataForManipulatingDataList are populated correctly
        // Verify that the resultSize is set appropriately
        // Verify any other expected behavior

        Test.stopTest();
    }
       @isTest
    static void testDeleteSelected() {
        // Instantiate the class
        ComponentClass controller = new ComponentClass();

        // Set up test data
          controller.dataListToShow = new List<ComponentClass.Wrapper>{
            new ComponentClass.Wrapper(new Account(Name = 'Alpha')),
            new ComponentClass.Wrapper(new Account(Name = 'Beta')),
            new ComponentClass.Wrapper(new Account(Name = 'Gamma'))
        };
        // Call the method to be tested
        Test.startTest();
         controller.deleteSelected();
        Test.stopTest();

        // Add assertions to verify the results
        // For example, assert that the accounts with check=true were deleted
   //     System.assertEquals(expectedDeletedCount, [SELECT count() FROM Account WHERE Id IN :getSelectedAccountIds()], 'Accounts should be deleted');
        // Add more assertions based on the expected behavior
    }
    @isTest
    static void sortDirection() {
        ComponentClass controller = new ComponentClass();
        controller.sortExpression=null;
          Test.startTest();
         controller.getSortDirection();
         controller.sortExpression='Asc';
         controller.getSortDirection();
         controller.setSortDirection('Desc');
        Test.stopTest();
    } 

}