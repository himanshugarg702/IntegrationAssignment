public class Checking2 {
    public String selectedObject {get;set;}
    public String[] selectedFields{get{
        if(selectedFields != null){
            for(Integer i=0;i<this.selectedFields.size();i++){
                if(this.selectedFields[i] == fieldType){
                    this.selectedFields.remove(i);
                }
            }
        }
        return this.selectedFields; 
    }
                                   set;}
    
    public String query;
    public boolean renderBlock{get;set;}
    public list<sObject> recordList = new list<sObject>();
    public String fieldType;
    public list<String> alphabet{
        get{                                                                                                                    //To display a list of alphabets on vf page 
            alphabet = new list<string>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Others','All'};
                return alphabet;         
        }
        set;
    }
    public String alphaSearch{get;set;} 
    public String columnValue{get;set;}
    public String sortDir{get;set;}
    
    public Checking2(){
        RecordsPerPageslist=10;
        renderBlock = false;    
    }
    
    public void rendering(){
        getfieldvalues();
        renderBlock = true;
    }
    
    
    
    public SelectOption[] getObjectOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
            for(SObjectType sType: Schema.getGlobalDescribe().values()) {
                DescribeSObjectResult res = sType.getDescribe();
                if(res.isQueryable()&& res.isUpdateable()){
                    results.add(new SelectOption(res.getName(), res.getLabel()));
                }
            }
        results.sort();
        return results;
    }
    public SelectOption[] getFieldOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
            if(selectedObject != null) {
                for(SObjectField sField: Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                    DescribeFieldResult res = sField.getDescribe();
                    results.add(new SelectOption(res.getName(), res.getLabel()));
                    if(res.isNameField()){
                        fieldType = res.getName();
                    }
                }
            }
        return results;
    }
    
    public string firstCol{get{
        this.firstCol = fieldType;
        return this.firstCol;
    }
                           set;}
    //--------//
    
    public void getfieldvalues(){
        query = fieldType + ',';
        for(Integer i=0;i<selectedFields.size();i++){
            if(i == (selectedFields.size()-1)){    
                query = query + selectedFields[i] ;
            }
            else{
                query = query + selectedFields[i] + ',';
            }
        }
        stdSetController = null ;
        // System.debug('@@@@'+query+'^^^^^'+selectedObject);
        
    } 
    //alphabatic search
    public Pagereference getalphaSearch(){                                                              //To update list as per the alphabet selected by the user
        
        if (alphaSearch=='All'){
            recordList = Database.query('Select '+query+' FROM '+selectedObject);
            //System.debug(query);
        }
        else{
            recordList = Database.query('Select '+ query +' FROM '+ selectedObject +' WHERE '+fieldType+' LIKE \''+ alphaSearch +'%\'');
        }
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(recordList);
        stdSetController= ssc;
        return null;
    }      
    
    
    
    public Integer PageNumber{
        get{                                                            //To get current page number
            this.PageNumber=stdSetController.getPageNumber();
            return this.PageNumber;
        }
        set{                                                              // To navigate to the page number entered by the user
            stdSetController.setPageNumber(value);
        }
    }
    public Integer TotalPages{                                            // Total number of pages as per user selection of Records per page
        get{
            if(stdSetController.getResultSize() <=10)
                this.TotalPages=1;
            if(Math.Mod(stdSetController.getResultSize() ,stdSetController.getPageSize()) == 0)
                this.TotalPages =(stdSetController.getResultSize()/stdSetController.getPageSize());
            else
                this.TotalPages = (stdSetController.getResultSize()/stdSetController.getPageSize())+1;
            //System.Debug(this.TotalPages);
            return totalpages;
        }
        set;
    }
    public Integer MaxNumberOfRecords{                                    //Maximum number of records in a query list
        get{
            return stdSetController.getRecords().size();
        }
        set;
    }
    public list<SelectOption> getRecordsPerPageOptionList(){              //To display a drop down list on vf page  
        list<SelectOption>  options = new list<SelectOption>();
        options.add(new selectOption('10','10'));
        options.add(new selectOption('25','25'));
        options.add(new selectOption('50','50'));
        return options;
    }
    public Integer RecordsPerPageslist{ 
        get;set{                                                          //To select number of records per page
            // System.debug(value);
            if(value!=null){
                this.RecordsPerPagesList=value;
            }
            // else
            // this.RecordsPerPageslist=10;
        }       
    }
    public void next(){
        this.stdSetController.next();
    }
    
    public ApexPages.StandardSetController stdSetController{            //Instantiating a standard set controller
        get{ 
            if(stdSetController==null){
                System.debug('#######'+query+'======>'+fieldType);
                recordList = Database.query('Select '+ query +' FROM '+ selectedObject);
                stdSetController = new ApexPages.StandardSetController(recordList);
            }
            
            stdSetController.setPageSize(RecordsPerPageslist);        //Limiting Number of records to be displayed per page 
            return stdSetController;   
        }
        set;
    }
    public list<sObject> getObjectRecordList(){                               //to display records on vf page
        return (list<sObject>)stdSetController.getRecords();
    } 
    
    
    private Integer k=1;
    public PageReference sortValues(){
        if(k == 1){
            recordList = Database.query('Select '+query+' FROM '+selectedObject+' ORDER BY '+columnValue);
            ++k;
            sortDir= 'ASC';
        }
        else{
            recordList = Database.query('Select '+query+' FROM '+selectedObject+' ORDER BY '+columnValue+' DESC');
            --k;
            sortDir = 'DESC';
        }
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(recordList);
        stdSetController= ssc; 
        return null;
    }
}