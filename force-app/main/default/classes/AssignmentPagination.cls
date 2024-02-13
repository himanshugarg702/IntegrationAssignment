public class AssignmentPagination {
    public list<Account> acc {get;set;}
    List<string> conditions = new List<string>();
    private Integer totalRecs = 0;
    private Integer OffsetSize = 0;
    public  Decimal LimitSize{get;set;}
    public Integer ResultSize {get;set;}
    public Integer PageSize {get;set;}
    public Integer PageNumber {get;set;}
    public String selectedOption {get;set;}
    public Boolean first{get;set;}
    public Boolean prev{get;set;}
    public Boolean nextPage{get;set;}
    public Boolean last{get;set;}
    private Integer a=0;
    private String query='SELECT Id,Name,Industry,Rating ,Owner.Name from Account';
    private String whereString='';
    private String order='';
    public String colName{get;set;}
    public list<String> alphaList{
        get{                                                                                                                   
            alphaList = new list<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Others','All'};
                return alphaList;    
        }
        set;
    }
    public String alphaSearchConct{get;set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public string sortFullExp='';
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
    
    
    public void alphaSearch(){
         
        String tempalpha=alphaSearchConct;
        alphaSearchConct=alphaSearchConct+'%';
         whereString=' WHERE Name Like :alphaSearchConct';
        acc.clear();
        if (tempalpha=='All'){
            whereString='';
           LimitSize= 5;
        a=(Integer)LimitSize;
        PageNumber=1;
              OffsetSize=0;
        acc=Database.query(query);
        ResultSize=acc.size();
        acc=Database.query(query+ order + ' limit :a offset:OffsetSize');
        }
        else if(tempalpha=='Others'){     
             whereString=' WHERE Name Like 0 '+ ' % ' +' or Name Like 1 ' +' % '  + ' or Name Like 2 '+' % '+ ' or Name Like 3 '+' % '+' or Name Like 4 '+' % '+' or Name Like 5 '+' % '+
                 ' or Name Like 6 '+' % '+' or Name Like 7 '+' % '+' or Name Like 8 '+' % '+' or Name Like 9 '+' % ';
             System.debug(whereString+'where');
             OffsetSize=0;
            PageNumber=1;
            acc =Database.query(query+ whereString);
            ResultSize=acc.size();
            System.debug(ResultSize);
            acc=Database.query(query+  whereString+ order + ' limit :a offset:OffsetSize');
        }
        else{
            acc = Database.query(query + whereString);
            ResultSize=acc.size();
            OffsetSize=0;
            PageNumber=1;
            acc = Database.query(query + whereString+' limit :a offset :OffsetSize');
        }
        
        if(acc.isEmpty()){
            PageNumber=0;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' Data Not Found'));
        }  
      
    }
    //ApexPages.standardController 
    public AssignmentPagination(){
        LimitSize= 5;
        a=(Integer)LimitSize;
        PageNumber=1;
        acc=Database.query(query);
        ResultSize=acc.size();
        acc=Database.query(query+ ' limit :a offset:OffsetSize');
        
    }
    public void FirstPage(){
        PageNumber=1;
        if(PageNumber>Math.ceil(ResultSize / LimitSize)){
            PageNumber=(Integer)Math.ceil(ResultSize / LimitSize);
        }
        a=(Integer)LimitSize;
        OffsetSize = 0;
        if(OffsetSize<0){
            OffsetSize=0;
        }
        acc=Database.query(query + whereString + order + ' limit :a offset:OffsetSize');
    }
    public void previous(){
        PageNumber--;
        OffsetSize =OffsetSize-a;
        if(OffsetSize<0){
            OffsetSize=0;
        }
        acc=Database.query(query + whereString + order + ' limit :a offset:OffsetSize');
    }
    public void next(){
        PageNumber++;
        OffsetSize =  OffsetSize + a; 
        acc=Database.query(query + whereString +order + ' limit :a offset:OffsetSize');
    }
    public void LastPage(){
        PageNumber=(Integer)Math.ceil(ResultSize / LimitSize);
        OffsetSize = ResultSize - math.mod(ResultSize,a);  
        if(Math.mod(ResultSize,a)==0){
            OffsetSize=OffsetSize-a;
        }
        if(OffsetSize<0){
            OffsetSize=0;
        }
        acc=Database.query(query + whereString+ order + ' limit :a offset:OffsetSize');
    }
    public void seeDataAccordingToRecordPerPage(){
        System.debug(selectedOption+'chekingbyme');
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
        else if(selectedOption=='25'){
            LimitSize=25;
        }
        PageNumber=(Integer)Math.ceil(ResultSize / LimitSize);
        a=(Integer)LimitSize;
        if(OffsetSize<a){
            OffsetSize=0;
            PageNumber=1;
        }
        if(OffsetSize>a){
            OffsetSize=a;
            if(PageNumber==(Integer)Math.ceil(ResultSize / LimitSize)){
                OffsetSize=ResultSize-a;
            }
            
            PageNumber=(Integer)Math.ceil(ResultSize / LimitSize);
        }
        
        acc=Database.query(query + whereString + order + ' limit :a offset:OffsetSize ');
    }
    public PageReference ViewData() {
        //build the full sort expression
         sortFullExp = sortExpression  + ' ' + sortDirection;
        order = ' order by ' +sortFullExp ;
        //query the database based on the sort expression
        acc = Database.query(query+ whereString + order + ' limit :a offset:OffsetSize');
        return null;
    }
    
    public class WrapClass{
        Account acc1{get;set;}
        public WrapClass(Account acc1){
            this.acc1=acc1;
        }
        public Boolean master{get;set;}
        public Boolean child{get;set;}
    }
    
    
}