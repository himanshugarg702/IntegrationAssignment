public class Practice14 {
 public Practice14(ApexPages.StandardController controller)
 {}
 @remoteAction
 public static boolean getData(String merchandiseName,String merchandiseDescription,Decimal merchandisePrice,
Integer merchandiseinventory )
 {
 Merchandise__c myItem=new Merchandise__c(Name=merchandiseName,
Job_Description__c=merchandiseDescription,Price__c=merchandisePrice, Merchandise_Inventory__c=merchandiseinventory );
 insert myItem;
 return true;
 }
}