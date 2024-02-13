public class Practice13{
     public List<String> SelectedFile;
     public List<Blob> SelectedBody;
    
     public transient String fileName{get;set;}
     public transient Blob fileBody{get;set;}
    
     public Practice13(){
         SelectedFile=new List<String>();
         SelectedBody=new List<Blob>();
     }
     public void AddToList(){
         SelectedFile.add(fileName);
         SelectedBody.add(fileBody);
     }
    
    
     public void uploadFile(){
         if(SelectedFile.size()>0) {
         	for(Integer i=0;i<SelectedFile.size();i++){
         		Attachment atch=new Attachment();
         		atch.Body=SelectedBody.get(i);
        		atch.Name=SelectedFile.get(i);
         		//atch.Description=fileDescription;
        		atch.ParentId='a082800000AaA3A';
         		try{
                        insert atch;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Uploaded successfully.'));
         			}
         		catch(DMLException ex){
         			ApexPages.addMessage(new ApexPages.message(Apexpages.severity.ERROR,fileName+':Error uploading attachment'));
         		}
        	 }
         }
     }
}