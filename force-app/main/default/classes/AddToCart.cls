public class AddToCart {
    public  list<Wrapper1> myList=null;
    public list<Wrapper1> cartList{get;set;}
    public AddToCart(){
        
    }
    public list<Wrapper1> getRecord(){
        if(myList==null){
            myList=new list<Wrapper1>();
        }
        for(Merchandise__c merch:[select  Name,Job_Description__c,Price__c,Merchandise_Inventory__c from Merchandise__c]){
            myList.add(new Wrapper1(merch));
        }
        return myList;
            }
    public void addCart(){
        if(cartList==null){
            cartList=new list<Wrapper1>();
        }
        for(Wrapper1 obj:myList){
            if(obj.QtyToBuy>0){
                cartList.add(obj);
            }
        }
      //  return cartList;
    }
public class Wrapper1{
    Merchandise__c merch;
    public Wrapper1(Merchandise__c merch){
        this.merch=merch;
    }
    public String Name{get{return merch.Name;}}
    public String Description{get{return merch.Job_Description__c;}}
    public Decimal Price{get{return merch.price__c;}}
    public Boolean Stock{get{return 0<merch.Merchandise_Inventory__c;}}
    public Integer QtyToBuy{get;set;}
}
}