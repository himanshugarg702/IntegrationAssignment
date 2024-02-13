@isTest
public class TestPaginationVisualforceClass {
    
    @isTest
    static void testConstructor() {
        PaginationVisualforceClass controller = new PaginationVisualforceClass();
       
        controller.selectedResults=new list<String>();
        controller.selectedResults.add('hello');
        controller.alphaSearchConct='a';
        
            }
    
    @isTest
    static void testFieldOptions() {
        PaginationVisualforceClass controller = new PaginationVisualforceClass();
        // Set up test data or modify the controller state as needed
        controller.selectedObject = 'Account';
        
        Test.startTest();
        controller.FieldOptions();
        Test.stopTest();
        
        
    }
   
    @isTest
    static void testSelectedFieldsToShow() {
        PaginationVisualforceClass controller = new PaginationVisualforceClass();
        // Set up test data or modify the controller state as needed
        controller.selectedField = new List<String>();
        controller.selectedField.add('hello');
        controller.result2 = new List<SelectOption>{};
            controller.resultsFields = new Map<String, String>();
        controller.resultsFields.put('hello','world');
        controller.resultsFields.put('hello','world');
        controller.results = new List<SelectOption>{};
            controller.selectedResultsFields=new Map<String, String>();
        controller.selectedResultsFields.put('hello','hello');
        controller.fieldsResultant=new Map<String, Integer>();
        controller.selectedResultsFields=new Map<String, String>();
        controller.selectedResultsFields.put('hello','hello');
        controller.result2 = new List<SelectOption>{};
            controller.results = new List<SelectOption>{};
                controller.results.add(new SelectOption('hello','hello'));
        controller.result2.add(new SelectOption('hello','hello'));
        controller.resultsFields = new Map<String, String>();
        controller.resultsFields.put('hello','world');
        controller.resultsFields.put('hello','world');
        controller.valuesSendComponent=new list<String>();
        controller.labelSendComponent=new list<String>();
        controller.selectedResultsFields.put('hello','hello');
        
        Test.startTest();
        controller.SelectedFieldsToShow();
        Test.stopTest();
    }
    
    @isTest
    static void testSelectedFieldRemove() {
        PaginationVisualforceClass controller = new PaginationVisualforceClass();
        // Set up test data or modify the controller state as needed
        controller.removeFields = new List<String>{'FieldToRemove1', 'FieldToRemove2'};
            controller.removeFields.add('hello');
        controller.removeFields.add('hello');
        controller.selectedResultsFields=new Map<String, String>();
        controller.selectedResultsFields.put('hello','hello');
        controller.result2 = new List<SelectOption>();
            controller.results = new List<SelectOption>();
                controller.results.add(new SelectOption('hello','hello'));
        controller.result2.add(new SelectOption('hello','hello'));
        controller.resultsFields = new Map<String, String>();
        controller.resultsFields.put('hello','world');
        controller.resultsFields.put('hello','world');
        controller.valuesSendComponent=new list<String>();
        controller.labelSendComponent=new list<String>();
        controller.selectedResultsFields.put('hello','hello');
        Test.startTest();
        controller.SelectedFieldRemove();
        Test.stopTest();       
    }
    
    @isTest
    static void testResetValueAction() {
        PaginationVisualforceClass controller = new PaginationVisualforceClass();
      //  controller.reset=true;
       // controller.processShow=false;
        controller.selectedObject = 'Account';
        Test.startTest();
        controller.resetValueAction();
        Test.stopTest();
    }
    
    @isTest
    static void testProcessToComp() {
        PaginationVisualforceClass controller = new PaginationVisualforceClass();
        // Set up test data or modify the controller state as needed
     controller.processShow=false;
            
            Test.startTest();
        controller.processToComp();
        Test.stopTest();
    }
     
   

}