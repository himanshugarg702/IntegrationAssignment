public class Assignment2AccountButtons {
    // initialize account list
    public Account acc {get;set;}
    // this is for visibility of edit page
    public Boolean editable {get;set;}
    // this is for visibility of save button 
    public Boolean hideButton {get;set;}
    // this is for visibility of edit cancel button 
    public Boolean hideButtonEdit {get;set;}
    public Boolean hideButtonEdit2 {get;set;}
    // this is the reference for offset record
    public Integer numberCheck=0;
    
    public Assignment2AccountButtons(){
        acc=new Account();
        acc=Database.query('select Id,Name,Industry,Rating,isDeleted from Account order by lastmodifieddate   limit 1 ');
        editable=false;
        hideButton=true;
        
    }
    public void save(){
        try{
            hideButtonEdit2=false;
             Integer count=0;
        hideButtonEdit=false;
        hideButton=true;
        editable=false;
        numberCheck++;
         if(acc!=null&&acc.IsDeleted!=true){
              update acc;
        }
        acc=Database.query('select Id,Name,Industry,Rating,isDeleted from Account  order by lastmodifieddate  limit 1 ');
        }
        catch(System.DMLException e){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This account is already deleted'));
        }
    }
    public void quickSave(){
        if(acc!=null){
         update acc;
        }
    }
    public void editMode(){
        hideButtonEdit2=true;
        hideButton=false;
        hideButtonEdit=true;
       editable=true;
    }
    
    public PageReference  deleteMode(){
            try {
                hideButtonEdit2=true;
                   delete acc;
             
               } catch(System.DMLException e) {
                   hideButtonEdit2=false;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot be deleted this account because the account have associtated opportunities'));
                 }
           if(acc.isDeleted==true){
                    hideButtonEdit2=false;
                }
                   acc=Database.query('select Id,Name,Industry,Rating,isDeleted from Account  order by lastmodifieddate  limit 1 ');
                
        return null;
    }
     public void cancel(){
         acc=Database.query('select Id,Name,Industry,Rating,isDeleted from Account order by lastmodifieddate   limit 1 ');
         hideButtonEdit=false;
        hideButton=true;
          editable=false;
    }
}