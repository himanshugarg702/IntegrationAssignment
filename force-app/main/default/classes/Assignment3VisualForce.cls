public class Assignment3VisualForce {
   public list<Account> acc {get;set;}
    public Boolean editable {get;set;}
    public Boolean hideButton {get;set;}
    public Boolean hideButtonEdit {get;set;}
    public String selectedOption {get;set;}
    String str='Select id';
    String whr='';
    
    //ApexPages.standardController 
    public Assignment3VisualForce(){
        acc=new list<Account>();
         acc=[select Id,Name,Industry,Rating ,Owner.Name from Account];
        editable=false;
        hideButton=true;
        selectedOption='AllAccounts';   
    }
    public void save(){
        hideButtonEdit=false;
        hideButton=true;
        editable=false;
        update acc;
    }
    public void quickSave(){
        update acc;
    }
    public void editMode(){
        hideButton=false;
        hideButtonEdit=true;
       editable=true;
    }
     public void cancel(){
         acc=[select Id,Name,Industry,Rating ,Owner.Name from Account];
         hideButtonEdit=false;
        hideButton=true;
          editable=false;
    }
    public void seeDataAccordingToFilter(){
        if(selectedOption=='AllAccounts'){
             acc=[select Id,Name,Industry,Rating ,Owner.Name from Account];
        }
        else if(selectedOption=='MyAccounts'){
             acc=[select Id,Name,Industry,Rating,Owner.Name from Account WHERE ownerId= :UserInfo.getUserId()];
        }
    }
    public list<SelectOption> getOptions(){
        list<SelectOption>  optionsToShowData =new list<SelectOption>();
        optionsToShowData.add(new SelectOption('AllAccounts','All Accounts'));
        optionsToShowData.add(new SelectOption('MyAccounts','My Accounts'));
        return optionsToShowData;
    }
}