import { LightningElement, track } from 'lwc';
import createFolder from "@salesforce/apex/Communitydropboxintegration.newFolder";
import uploadFile from '@salesforce/apex/Communitydropboxintegration.uploadFile';
import checkUserCreatedOrNot from  '@salesforce/apex/Communitydropboxintegration.checkUserCreatedOrNot';
import createAuthURL from  '@salesforce/apex/Communitydropboxintegration.createAuthURL';
import getAllFilesFromBox from  '@salesforce/apex/Communitydropboxintegration.getAllFilesFromBox';
import getAccessToken from  '@salesforce/apex/Communitydropboxintegration.getAccessToken';
import deleteFileDropbox from  '@salesforce/apex/Communitydropboxintegration.deleteFileDropbox';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class BoxAPILWC extends LightningElement {
     fileName = '';
    @track showSpinner = false;
    content;
    fileData;
    newFolderName;
    folderId;
    checkUserOrNot;
    code;
    folderNameForNavigateFiles='/';
    @track listOfFolderFile=[];
    @track
    myBreadcrumbs = [
        { label: 'Home',  id: '/' }
    ];


    constructor(){
        
        super();
        this.handleSpinner();
            var url = window.location.href;
         function getParameterByName(name, url) {
             if (!url) url = window.location.href;
             name = name.replace(/[\[\]]/g, '\\$&');
             var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                 results = regex.exec(url);
             if (!results) return null;
             if (!results[2]) return '';
             return decodeURIComponent(results[2].replace(/\+/g, ' '));
         }

         var code = getParameterByName('code',url);
         if(code !== undefined && code!==null) {
              getAccessToken({code:code})
              .then((data) => {
                this.getFiles();
            })
            .catch((error) => {
                console.log(error);
            }).finally(() => {
                this.handleSpinner();
            })
          }
     else{
        this.handleSpinner();
        checkUserCreatedOrNot()
            .then((data) => {
                if(data==false){
                    createAuthURL()
                    .then((data) => {
                        window.location.href = data;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
                }
                else{
                    console.log(this.folderNameForNavigateFiles);
                    this.getFiles()
                }
                console.log(data);
            })
            .catch((error) => {
                console.log(error);
            });
            // .finally(() => {
            //     this.handleSpinner();
            // })
        }
    }
    handleNavigateTo(event) {
        //get the name of the breadcrumb that's clicked
        const name = event.target.label;
        this.folderNameForNavigateFiles='';
        console.log(name);
        // event.preventDefault();
        for(var i=0;i<this.myBreadcrumbs.length;i++ ){
            if(this.myBreadcrumbs[i].label==name&&i<this.myBreadcrumbs.length){
                this.myBreadcrumbs.splice(i+1,this.myBreadcrumbs.length-(i+1));
                break;
            }      
            this.folderNameForNavigateFiles+=this.myBreadcrumbs[i].label+'/';
          }
          this.getFiles();
          console.log(this.myBreadcrumbs);
          console.log('hello',JSON.Stringify(this.myBreadcrumbs));
        // var temp.push{label:name,id:name};
        // this.myBreadcrumbs.push({label:name,id:name})
        //your custom navigation here
    }
    getFiles(){
        getAllFilesFromBox({rootFolderId:this.folderNameForNavigateFiles})
        .then((data) => {
            this.listOfFolderFile=data;
            console.log(data);
        })
        .catch((error) => {
            console.log(error);
        });
    }
    navigateFolder(event){
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.foldername;
        console.log(selectedField);
        this.myBreadcrumbs.push({label:selectedField,id:selectedField})
        this.folderNameForNavigateFiles+=selectedField+'/';
        console.log('hello',this.folderNameForNavigateFiles);
        this.getFiles();
        console.log('hello',selectedField);
    }
    handleCreateFolder(event){
        var prompt=window.prompt('Please enter Folder name');
        if(prompt!=null){
        const inputValidation = [...this.template.querySelectorAll('.fieldvalidate')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (inputValidation) {
          let inputFields = this.template.querySelectorAll('.fieldvalidate');
          inputFields.forEach(inputField => {
            if(inputField.name == "newFolderName"){
                this.newFolderName = inputField.value;
            }
           });
           this.handleApexCallCreateFolder();
        }
    }
    }
    handleApexCallCreateFolder(){
        var prompt=window.prompt('Please enter Folder name');
        if(prompt!=null){
        this.handleSpinner();
        console.log(prompt);
        createFolder({folderName : prompt})
        .then(res=>{
            this.ShowToast('Success!', 'Folder Create Successfully', 'success', 'dismissable');
            this.getFiles();
        }).catch(error=>{
            this.ShowToast('Error!!', error.body.message, 'error', 'dismissable');
        }).finally(() => {
            this.handleSpinner();
        })
    }
    }
    handleFolderName(event){
        this.folderId = event.target.value;
    }
     // getting file 
    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            const file = event.target.files[0]
            var reader = new FileReader()
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                this.fileData = {
                    'filename': file.name,
                    'base64': base64,
                    'recordId': this.folderId
                }
                console.log(this.fileData)
            }
            reader.readAsDataURL(file)
        }
    } 
    // Calling apex class to upload the file to box storage
    uploadFileToBox() {
        this.handleSpinner();
        const {base64, filename, recordId} = this.fileData
        uploadFile({ base64 : base64, filename:filename, folderId:recordId }).then(result=>{
            this.fileData = null
            let title = `${filename} uploaded successfully!!`;
            this.ShowToast('Success!', title, 'success', 'dismissable');
        }).catch(err=>{
            this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
        }).finally(() => {
            this.handleSpinner();
        })
    }
    handleSpinner(){
        this.showSpinner = !this.showSpinner;
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
}