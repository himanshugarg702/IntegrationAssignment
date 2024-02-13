public class Checking {
    public String selectedObj{get;set;}
    public string selectedObject;
    public String[] selectedFields{get{
        if(selectedFields != null ){
            for(Integer i=0;i<this.selectedFields.size();i++){
                if(this.selectedFields[i] == firstField || this.selectedFields[i].contains('Address')){
                    this.selectedFields.remove(i);
                }
            }
        }
        return this.selectedFields;
    }
    set;}
    private String query;
    public List<sObject> recordList = new list<sObject>();
    public Boolean renderBlock{get;set;}
    private Integer offSetSize = 0;
    public Integer queryLimit {get{
        if(this.queryLimit == Null){
            this.queryLimit = 10;
        }
        return this.queryLimit;
    }set;
    }
    private Integer totalRecords;
    private Integer totalPage;
    public Integer pageNumber{get{
        this.pageNumber = (OffsetSize / queryLimit) + 1;
        return this.pageNumber;
    }set{
        this.pageNumber = value;
    }
    }
    public list<String> alphabet{get;set;}
    public String alphaSearch{get;set;}
    private String str;
    private String firstField;
    public String columnValue{get;set;}
    private Integer k = 1;
    public String sortDir{get;set;}
    public boolean renderFeilds{get;set;}
    private Integer quryLimit;
    private String recordCountQuery;
    public Integer h{get;set;}
    
    public Checking(){
        renderBlock = false ; 
        renderFeilds = false ;
        h = (OffsetSize / queryLimit) + 1;
        alphabet = new list<string>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Others','All'};
    }
    public void showFeilds(){
        selectedObject = selectedObj;
        renderBlock = false;
        renderFeilds = true ;
        System.debug('!!!^^Call');
    }
    public void renderTable(){
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
                        firstField = res.getName();
                    }
                }
            }
        return results;
    }
    public String firstColumn{
        get{
            this.firstColumn = firstField;
            return this.firstColumn;
        }set;
    }
    
    public void getfieldvalues(){
        if(selectedFields.size() == 0){
                query = firstField;
        }
        else{
            query = firstField + ',';
            for(Integer i=0;i<selectedFields.size();i++){
                if(!selectedFields[i].contains('Address')){
                    if(i == (selectedFields.size()-1)){    
                        query = query + selectedFields[i] ;
                    }
                    else{
                        query = query + selectedFields[i] + ',';
                    }
                }
            }
        }
        //System.debug('@@@@'+query+'^^^^^'+selectedObject);
        //System.debug('=======>'+totalRecords);
    } 
    
    public list<sObject> getobjectRecordList(){
        if (alphaSearch == Null && columnValue == Null) {
            str = 'SELECT '+query+' FROM '+selectedObject+' LIMIT '+queryLimit+' OFFSET '+offSetSize;
            recordCountQuery = selectedObject;
        }
      //  System.debug('---->'+str);
        recordList = Database.query(str);
        totalRecords = Database.countQuery('SELECT count() FROM '+ recordCountQuery);
        //totalRecords = recordList.size();
       // System.debug('sss---->'+totalRecords);
        return recordList;
    }

    public PageReference firstPage(){
        offSetSize = 0 ;
        return null;
    }
    public PageReference previousPage(){
        offSetSize = offSetSize - queryLimit;
        if(columnValue != Null){
            columnSorting();
        }
        if(alphaSearch != Null){
            alphsort();
        }
        return null;
    }
    public PageReference nextPage(){
        offSetSize = offSetSize + queryLimit;
       // System.debug('$$'+offSetSize);
        if(columnValue != Null){
            columnSorting();
        }
        if(alphaSearch != Null){
            alphsort();
        }
        return null; 
    }

    public PageReference lastPage(){
        offSetSize = totalRecords-Math.mod(totalRecords,queryLimit);
        return null;
    }
    public boolean getPrevious(){
        if (offSetSize == 0 ) {
            return true;
        }
        else{
            return false;
        }
    }
    public boolean getnxt()
    {
        if((OffsetSize + queryLimit) > totalRecords)
            return true;
        else
            return false;
    }
    public Integer gettotalPages(){
        totalPage = (totalRecords / queryLimit)+1;
        return totalPage ;
    }
    public PageReference updateQyeryLimit(){
        if(columnValue != Null){
            columnSorting();
        }
        if(alphaSearch != Null){
            alphsort();
        }
        return Null;
    }
    public void naviagteToPage(){
        offsetSize = (queryLimit * (h-1));
        //renderBlock = true;
        System.debug('**'+offSetSize); 
        //getobjectRecordList();
        //return Null;
    }
    public selectOption[] getrecordsPerPage(){
        list<SelectOption>  options = new list<SelectOption>();
        options.add(new selectOption('10','10'));
        options.add(new selectOption('25','25'));
        options.add(new selectOption('50','50')); 
        return options;
    }
    
    public Pagereference alphsort(){
        columnValue = Null;
        quryLimit = queryLimit;
        if (alphaSearch == Null || alphaSearch == 'All') {
            str = 'SELECT '+query+' FROM '+selectedObject+' LIMIT '+quryLimit+' OFFSET '+offSetSize;
            recordCountQuery = selectedObject;
        }
        else {
            str = 'SELECT '+query+' FROM '+selectedObject+' WHERE '+firstField+' LIKE \''+ alphaSearch +'%\'' + ' LIMIT '+quryLimit+' OFFSET '+offSetSize;
            recordCountQuery = selectedObject+' WHERE '+firstField+' LIKE \''+ alphaSearch +'%\'' ;
        }
        getobjectRecordList();
        return Null;
    }
    
    public Pagereference columnSorting(){
        alphaSearch = Null;
        quryLimit = queryLimit;
        recordCountQuery = selectedObject;
        if (k == 1) {
            System.debug('----->>'+columnValue);
            str = 'SELECT '+query+' FROM '+selectedObject+' ORDER BY '+columnValue+' LIMIT '+quryLimit+' OFFSET '+OffsetSize;
            ++k;
            sortDir = 'ASC';
        }
        else {
            str = 'SELECT '+query+' FROM '+selectedObject+' ORDER BY '+columnValue+' DESC '+' LIMIT '+quryLimit+' OFFSET '+offSetSize;
            --k;
            sortDir = 'DESC';
        }
        getobjectRecordList(); 
        return Null;
    }
    
}