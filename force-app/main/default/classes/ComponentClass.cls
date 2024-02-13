/**
Name:ComponentClass
Description:in this class we are retreiving records by query and column sorting and showing records in a visualforce page through component
and in this class i have worked on pagination on a page. and page jump as well.

**/

public class ComponentClass {
    public String selectObj{get;set;}    // variable for getting selected object
    public list<SelectOption> showData{get;set;}  // 
    public list<String> nameFieldValues{get;set;} // getting selected field  nameFieldValues
    public Boolean objectNameField{get;set;} // showing name field in first column if selected
    public Boolean objectCaseField{get;set;}  // showing auto number field 
    
    public String alphaSearchConct{get;set;} // which alphabet selected for search 	
    public Id accId{get;set;} // variable for deleted sObject id
    public list<Wrapper> dataListToShow{get;set;}    // child varibale for showing all records 
    private String selectId='Select ';   // temp variable 
    public list<Wrapper> dataForManipulatingDataList{get;set;}     // parent varibale for showing all records 
    public String caseCon{get;set;}
    public String query{get;set;}
    public Integer ResultSize {get;set;}   // how many records are come
    public Integer PageSize {get;set;}
    public Integer PageNumber {get;set;} //  variable for which pagenumber
    public Integer LimitSize {get;set;}  // showing records per page limit
    public String selectedOption {get;set;}
    public list<Wrapper> alphaTemp{get;set;}  // temp variable for manipulating records if aphabet selected
    public Boolean tempBool{get;set;}        // temp boolean
    public list<sObject> sobj{get;set;}  // getting all records 
    public Integer ofPage{get;set;}
    public list<String> alphaList{get;set;}    // showing list of alphabetical character
    public Boolean delCsvButttonDisable{get;set;}   //boolean variable making CSV button disable
    public list<String> fieldsToShowRecord{get;set;}   // list for showing record
    public String sortDirection = 'ASC';  // temp variable for default value
    private String sortExp = 'name';   // temp value for making default
    public String order='';// temp value for making default
    public string sortFullExp='';// temp value for making default
    public Boolean hideTableOnTheBasisOfData{get;set;}
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
   
    public String csvButton{get;set;}
    public list<String> selectedListCSV{get;set;}  // variable for getting selected recrod csv file
    public String getSortDirection()
    {
        //if not column is selected
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    public list<String> tempFieldList{get;set;}
    // constructor
    public ComponentClass(){
        hideTableOnTheBasisOfData=false;
        alphaList=new list<String>();
        String characterList= System.Label.AlphaList;
        for(String str:characterList.split(',')){
            alphaList.add(str.trim());
        }
        delCsvButttonDisable=true;
       
        selectedListCSV=new list<String>();
        tempFieldList=new list<String>();       
        fieldsToShowRecord=new list<String>();

        PageNumber=1;
        showData=new list<SelectOption>();
        selectObj=null;
        dataForManipulatingDataList = new list<Wrapper>();
        dataListToShow=new list<Wrapper>();
    }
    public void checking(){
        fieldsToShowRecord=new list<String>();
        nameFieldValues=new list<String>();
      
    }
     /** 
     Name: mainPage,
     description: method for showing records in visualforce page,
     Param:null,
     Return Type:Page Reference Null
**/
    
    public void mainPage(){
        caseCon='';
        if(selectObj=='Case'||selectObj=='Contact'){
            caseCon=selectObj;                          //
        }
        query='';
        selectedListCSV=new list<String>();
        dataListToShow.clear();
        dataForManipulatingDataList.clear();
    
        objectNameField=false;
        objectCaseField=false;
        tempFieldList=new list<String>();
        
        LimitSize=5;
        PageNumber=1;
        dataListToShow=new list<Wrapper>();
        query=null;
        query=selectId;
        
        String name='Name';
        if(selectObj=='Case'){
           name='CaseNumber';
        }
        query+=name+',';
        List<String>tempQuery=new list<String>();
        for(Integer k=0;k<nameFieldValues.size();k++){
            if(nameFieldValues.get(k)==name){
                objectNameField=true;
            }
            if(selectObj=='Case'&&nameFieldValues.get(k)==name){
                objectCaseField=true;
                objectNameField=false;
            }
            tempQuery.add(nameFieldValues.get(k));
        }
        for(String str:nameFieldValues){
            tempFieldList.add(str);
        }
        
        for(Integer j=0;j<tempQuery.size();j++){
            if(tempQuery.get(j)==name){
                tempQuery.remove(j);
                break;
            }
            selectedListCSV.add(tempQuery.get(j));
        }
        
        Integer i=0;
        
        for(String key : tempQuery) {
            if(i==tempQuery.size()-1){
                query+=key+' ';
            }
            else{
                query+=key+',';
            }
            i++;
        }
        query+=' from '+' '+selectObj+' ';  
        sobj=new list<sObject>();
        sobj=Database.query(query);
       
        dataListToShow.clear();
        for(sObject a:sobj) {
            dataForManipulatingDataList.add(new Wrapper(a));
            dataListToShow.add(new Wrapper(a));
        }
        hideTableOnTheBasisOfData=false;
        resultSize=dataListToShow.size();
        if(ResultSize==0){
            hideTableOnTheBasisOfData=true;
        }
        changeList();
     
    }
     /** 
     Name: changeList,
     description: when limit change data change this method clear that recrods adding new recrods according to page
     Param:null,
     Return Type: Null
**/
    public void changeList(){
        dataListToShow.clear();
        
        
        for(Integer j=0;j<LimitSize;j++){
            if(j>=resultSize){
                break;
            }
            dataListToShow.add(dataForManipulatingDataList.get(j));
        }
        
      
    }
      /** 
     Name: alphaSearch,
     description: showing records alphabetically in visualforce page
     Param:null,
     Return Type: Null
**/
    public void alphaSearch(){
        String name='Name';
        if(selectObj=='Case'){
            name='CaseNumber';
        }
        PageNumber=1;
        dataListToShow=new list<Wrapper>();
        alphaTemp=new list<Wrapper>();
        if(alphaSearchConct=='All'){
            for(Integer i=0;i<dataForManipulatingDataList.size();i++){
                alphaTemp.add(dataForManipulatingDataList.get(i));
            }
        }
        else if(alphaSearchConct=='Others'){
            for(Integer i=0;i<dataForManipulatingDataList.size();i++){
                String temp2=(String)dataForManipulatingDataList.get(i).acc.get(name);
                if(!((temp2.charAt(0)>=97&&temp2.charAt(0)<=122)||(temp2.charAt(0)>=65&&temp2.charAt(0)<=90))){
                    alphaTemp.add(dataForManipulatingDataList.get(i));
                }
            }
        }
        else{
            for(Integer i=0;i<dataForManipulatingDataList.size();i++){
                String temp2=(String)dataForManipulatingDataList.get(i).acc.get(name);
                if(temp2.left(1)==alphaSearchConct){
                    alphaTemp.add(dataForManipulatingDataList.get(i));
                }
            }
        }
        
        tempBool=true;
        
        PageNumber=1;
        resultSize=alphaTemp.size();
        for(Integer i=0;i<LimitSize;i++){
            if(i>=resultSize){
                break;
            }
            dataListToShow.add(alphaTemp.get(i));
        }
        hideTableOnTheBasisOfData=false;
        if(resultSize==0){
            hideTableOnTheBasisOfData=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' Data Not Found'));
            
            PageNumber=0;
        }
    }
       /** 
     Name: seeDataAccordingToRecordPerPage,
     description:  change records size page method
     Param:null,
     Return Type: Null
**/
    public void seeDataAccordingToRecordPerPage(){
       
        if(selectedOption=='5'){
            LimitSize=5;
        }
        else if(selectedOption=='10'){
            LimitSize=10;
        }
        else if(selectedOption=='15'){
            LimitSize=15;
        }
        else if(selectedOption=='20'){
            LimitSize=20;
        }
        PageNumber=1;
        dataListToShow.clear();
        if(tempBool==true){
            
            for(Integer i=0;i<LimitSize;i++){
                if(i>resultSize){
                    break;
                }
                dataListToShow.add(alphaTemp.get(i));
             
            }
          
        }
       
        else{
            
            for(Integer i=0;i<LimitSize;i++){
                if(i>=resultSize){
                    break;
                }
                dataListToShow.add(dataForManipulatingDataList.get(i));
            }
        }
        if(dataListToShow.size()==0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' Data Not Found'));
            
            PageNumber=0;
        }
    }
           /** 
     Name: firstPage,
     description:  method for go to direct first page 
     Param:null,
     Return Type: Null
**/
    public void firstPage(){
        PageNumber=1;
        valueSet();
    }
       /** 
     Name: previousPage,
     description:  method for previous page,
     Param:null,
     Return Type: Null
**/
 
    public void previousPage(){
        PageNumber--;
        valueSet();
    }
      /** 
     Name: nextPage,
     description: method for next page,
     Param:null,
     Return Type: Null
**/
    public void nextPage(){
        PageNumber++;        
        valueSet();
    }
      /** 
     Name: lastPage,
     description: method for lastPage,
     Param:null,
     Return Type: Null
**/
    public void lastPage(){
        if(Math.mod(ResultSize,LimitSize)==0){
            PageNumber=(Integer)Math.Floor(ResultSize/LimitSize);
        }
        else{
            PageNumber=(Integer)Math.CEIL(ResultSize/LimitSize)+1;
        }
        valueSet();
    }    
      /** 
     Name: valueSet,
     description: showing records to page method according to next page previous page etc,
     Param:null,
     Return Type: Null
**/
  
    public void valueSet(){
        if(PageNumber<1){
            PageNumber=1;
        }
        if(PageNumber>(Integer)Math.CEIL(ResultSize/LimitSize)+1){
            PageNumber=(Integer)Math.CEIL(ResultSize/LimitSize)+1;
        }
        dataListToShow.clear();
        if(tempBool==true){
            for(Integer i=(PageNumber-1)*LimitSize;i<((PageNumber-1)*LimitSize)+LimitSize;i++){
                if(i>resultSize-1){
                    break;
                }
                dataListToShow.add(alphaTemp.get(i));
            }
        }
        else{
            for(Integer i=(PageNumber-1)*LimitSize;i<((PageNumber-1)*LimitSize)+LimitSize;i++){
                if(i>=resultSize-1){
                    break;
                }
                dataListToShow.add(dataForManipulatingDataList.get(i));
            }
        }
        if(Math.mod(ResultSize,LimitSize)==0){
            ofPage=(Integer)Math.Floor(ResultSize/LimitSize);
        }
        else{
    //        ofPage=(Integer)Math.CEIL(ResultSize/LimitSize)+1;
        }
    }
      /** 
     Name: deleteMode,
     description: method for delete record,
     Param:null,
     Return Type: Null
**/
    public void  deleteMode(){
        Integer i=0;
        try {
            // List<sObjet
            List<sObject> tempListToDelete=new List<sObject>();
            accId=ApexPages.currentPage().getParameters().get('del'); 
            for(Wrapper a:dataListToShow){
                if(accId==a.acc.id){
                    tempListToDelete.add(a.acc);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' deleted account Successfully'));
                    break;
                }
                i++;
            }
            if(tempListToDelete.size()>0){
                delete tempListToDelete;
            }
        } catch(System.DMLException e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot be deleted this account because the account have associtated opportunities'));
        }      
    }
     /** 
     Name: deleteSelected,
     description: method for multiple deleting records using checkbox,
     Param:null,
     Return Type: Null
**/

    public void deleteSelected(){
        
        try{
            List<sObject> tempListToDelete=new List<sObject>();
            for(Wrapper a:dataListToShow){
                if(a.check==true){
                    tempListToDelete.add(a.acc);
                    // delete a.acc;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' deleted account Successfully'));
                }
            }
            if(tempListToDelete.size()>0){
                delete tempListToDelete;
            }
        }
        catch(System.DMLException e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot be deleted this account because the account have associtated opportunities'));
        }        
    }
     /** 
     Name: viewData,
     description: method for column sorting,
     Param:null,
     Return Type: Null
**/

    public void viewData(){
        sortFullExp = sortExpression  + ' ' + sortDirection;
        order = ' order by ' +sortFullExp ;
        sobj=new list<sObject>();
        sobj = Database.query(query+ order);
        dataListToShow.clear();
        dataForManipulatingDataList.clear();
        for(sObject a:sobj){
            dataForManipulatingDataList.add(new Wrapper(a));
            dataListToShow.add(new Wrapper(a));
        }
        resultSize=dataListToShow.size();
        changeList();
        
    }
      /** 
     Name: downloadCSV,
     description: for download csv data ,
     Param:null,
     Return Type: Null
**/

    // 
    public void downloadCSV(){
        csvButton=String.join(nameFieldValues,',')+'\n';
        for(Wrapper obj:dataListToShow){
            if(obj.check==true){
                for(Integer i=0;i<nameFieldValues.size();i++){
                    csvButton+=obj.acc.get(nameFieldValues[i])+',';
                }
                csvButton=csvButton+'\n';
            }
        }
    }
    /** 
     Name: maintainCheckBox,
     description: method for disable downlaodcsv button and delete selected button ,
     Param:null,
     Return Type: Null
**/
    public void maintainCheckBox(){
        delCsvButttonDisable=false;
        Integer checkCount=0;
        for(Wrapper obj:dataListToShow){
            //   sObject sob=obj.acc;
            if(obj.check==true){
                checkCount++;
            }
        }
        if(checkCount==0){
            delCsvButttonDisable=true;
        }
    }
    @testVisible
    public class Wrapper{
        public sObject acc{get;set;}
        public Boolean check{get;set;}
        public Wrapper(sObject acc){
            this.acc=acc;
            this.check=false;
        }
    }
}