import { LightningElement,wire,track } from 'lwc';
import getDetails from '@salesforce/apex/SalesforceToSalesforceIntegration.getDetails';
// import uploadToNewOrg from '@salesforce/apex/SalesforceToSalesforceIntegration.uploadToNewOrg';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class SalesforceToSalesforceIntegration extends LightningElement {
    @track listOfFiles=[];
    fileData;
    @wire(getDetails) 
        wiredData({error,data}) {
            if(data){
                this.listOfFiles=data;
                this.ShowToast('Success!', 'files fetched successfully', 'success', 'dismissable');
            }
            else if(error){
                this.ShowToast('Success!','Error to fetched files successfully' , 'success', 'dismissable');
            }
        }
        ShowToast(title, message, variant, mode){
            const evt = new ShowToastEvent({
                title: title,
                message:message,
                variant: variant,
                mode: mode
            });
            this.dispatchEvent(evt);
        }
        handleUploadFinished(event) {
            // Get the list of uploaded files
            if(event.target.files.length > 0) {
                const file = event.target.files[0]
                console.log(file);
                let reader = new FileReader()
                reader.onload = () => {
                    var base64 = reader.result.split(',')[1]
                    console.log(base64);
                    this.fileData = {
                        'file': file.name,
                        'base64': base64,
                        // 'path': this.folderNameForNavigateFiles
                    }
                    // this.uploadFiles();
                }
                reader.readAsDataURL(file)
            }
        }
        /** 
         Name: uploadFiles,
         Param:event
         Return Type:null
         description: calling apex method with upload files data
        **/
        // uploadFiles() {
        //     this.handleSpinner();
        //     const {file, base64, path} = this.fileData
        //     uploadToNewOrg({ file : base64, filename:file, path:this.folderNameForNavigateFiles.substring(0,this.folderNameForNavigateFiles.length-1) }).then(result=>{
        //         this.fileData = null
        //         let title = `${file} uploaded successfully!!`;
        //         this.ShowToast('Success!', title, 'success', 'dismissable');
        //         this.getFiles();
        //     }).catch(err=>{
        //         this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
        //     }).finally(() => {
        //         this.handleSpinner();
        //     })
        // }
}
