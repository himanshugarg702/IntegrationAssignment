public class EditDeleteStartVisualforce {
    // account list for getting the list of account records to r
    public list<Account> acc1 {get;set;}
    // wrap class variable for getting showing the record through visualforce page 
    public list<WrapClass> accWrap{get;set;}
    // variable for getting
    public Id accId{get;set;}
    
    public list<String> alphaList{
        get{                                                                                                                   
            alphaList = new list<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Others','All'};
                return alphaList;    
        }
        set;
    }
    public String alphaSearchConct{get;set;}
    public void getalphaSearch(){
        System.debug(alphaSearchConct);
        if (alphaSearchConct=='All'){
            acc1 = [SELECT Id,Name,Industry,Rating ,Owner.Name FROM Account];
            accWrap.clear();
            for(Account a:acc1){
                 
            accWrap.add(new WrapClass(a));
        }
        }
        else if(alphaSearchConct=='Others'){
				accWrap.clear();            
            for(Integer i=0;i<=9;i++){
                 acc1 = [SELECT Id,Name,Industry,Rating ,Owner.Name from Account WHERE Name Like:i+'%'];
                 for(Account a:acc1){
            accWrap.add(new WrapClass(a));
        }
            }
        }
        else{
            acc1 = [SELECT Id,Name,Industry,Rating ,Owner.Name from Account WHERE Name Like:alphaSearchConct+'%'];
            System.debug(acc1);
            
            accWrap.clear();
            for(Account a:acc1){
            accWrap.add(new WrapClass(a));
        }
        }
        if(accWrap.isEmpty()){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' Data Not Found'));
        }
    }
    
    // constructor
    public EditDeleteStartVisualforce(){
        acc1=new list<Account>();
        acc1=Database.query('select Id,Name,Industry,Rating ,Owner.Name from Account');
        accWrap = new list<WrapClass>();
        for(Account a:acc1){
            accWrap.add(new WrapClass(a));
        }
        System.debug(accWrap);
    }
    // Method for save the record
    public void save(){
        accId=ApexPages.currentPage().getParameters().get('save'); 
        System.debug(accId);
        for(WrapClass a:accWrap){
            if(accId==a.acc.id){
                a.checkStatus=false;
                update a.acc;
                break;
            }
        }
    }
    // Method for edit the record
    public void editMode(){
        accId=ApexPages.currentPage().getParameters().get('cid'); 
        for(WrapClass a:accWrap){
            if(accId==a.acc.id){
                a.checkStatus=true;
                break;
            }
        }
    }
    // Method for deleting record
    public PageReference  deleteMode(){
        Integer i=0;
        try {
            accId=ApexPages.currentPage().getParameters().get('del'); 
            System.debug(accId+'delete');
            for(WrapClass a:accWrap){
                if(accId==a.acc.id){
                    delete a.acc;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,' deleted account Successfully'));
                    break;
                }
                i++;
            }
            accWrap.remove(i);
        } catch(System.DMLException e) {
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot be deleted this account because the account have associtated opportunities'));
        }      
        return null;
    }
    // wrap class for making every record editable
    public class WrapClass{
        public Account acc{get;set;}
        public WrapClass(Account acc){
            this.acc=acc;
            checkStatus=false;
        }
        public Boolean checkStatus{get;set;}
        
        
    }
    
}