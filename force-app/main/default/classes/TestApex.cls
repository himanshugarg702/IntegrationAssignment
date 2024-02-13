public class TestApex {
    public Integer x {get;set;}
    public Contact con {get;set;}
    
    public TestApex(){
        con=[select LastName from contact limit 1];
        x=5;
       
    }
    {
      
    }
    static{
        
    }
    public void save(){
       
    }
}