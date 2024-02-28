import { LightningElement, track } from 'lwc';
import createFolder from "@salesforce/apex/Communitydropboxintegration.newFolder";
import uploadToDropBox from '@salesforce/apex/Communitydropboxintegration.uploadToDropBox';
import checkUserCreatedOrNot from  '@salesforce/apex/Communitydropboxintegration.checkUserCreatedOrNot';
import createAuthURL from  '@salesforce/apex/Communitydropboxintegration.createAuthURL';
import getAllFilesFromBox from  '@salesforce/apex/Communitydropboxintegration.getAllFilesFromBox';
import getAccessToken from  '@salesforce/apex/Communitydropboxintegration.getAccessToken';
import deleteFileDropbox from  '@salesforce/apex/Communitydropboxintegration.deleteFileDropbox';
import downloadFile from  '@salesforce/apex/Communitydropboxintegration.downloadFile';

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

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }
    /** 
     Name: constructor,
     Param:null
     Return Type:null
     description: when component render this method initialize and check if user is already present call files else called authurl
    **/
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
                        this.getFiles()
                    }
                })
                .catch((error) => {
                    console.log(error);
                });
            }
    }
     /** 
     Name: handleUploadFinished,
     Param:event
     Return Type:null
     description: getitng file name for uploading and blob and path where uploading data
    **/
    handleUploadFinished(event) {
        // Get the list of uploaded files
        if(event.target.files.length > 0) {
            const file = event.target.files[0]
            var reader = new FileReader()
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                this.fileData = {
                    'file': file.name,
                    'base64': base64,
                    'path': this.folderNameForNavigateFiles
                }
                this.uploadFiles();
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
    uploadFiles() {
        this.handleSpinner();
        const {file, base64, path} = this.fileData
        uploadToDropBox({ file : base64, filename:file, path:this.folderNameForNavigateFiles.substring(0,this.folderNameForNavigateFiles.length-1) }).then(result=>{
            this.fileData = null
            let title = `${file} uploaded successfully!!`;
            this.ShowToast('Success!', title, 'success', 'dismissable');
            this.getFiles();
        }).catch(err=>{
            this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
        }).finally(() => {
            this.handleSpinner();
        })
    }
    /** 
     Name: handleNavigateTo,
     Param:event
     Return Type:null
     description: when breadcrumb is clicking navigating files according to that
    **/
    handleNavigateTo(event) {
        //get the name of the breadcrumb that's clicked
        const name = event.target.label;
        this.folderNameForNavigateFiles='';
        for(var i=0;i<this.myBreadcrumbs.length;i++ ){
            if(this.myBreadcrumbs[i].label==name&&i<this.myBreadcrumbs.length){
                this.myBreadcrumbs.splice(i+1,this.myBreadcrumbs.length-(i+1));
                break;
            }      
            this.folderNameForNavigateFiles+=this.myBreadcrumbs[i].label+'/';
          }
          this.getFiles();
    }
    /** 
     Name: getFiles,
     Param:null
     Return Type:null
     description: returning files from apex by calling apex method
    **/
    getFiles(){
        getAllFilesFromBox({rootFolderId:this.folderNameForNavigateFiles})
        .then((data) => {
            this.listOfFolderFile=data;
        })
        .catch((error) => {
            console.log(error);
        });
    }
     /** 
     Name: navigateFolder,
     Param:event
     Return Type:null
     description: when clicking on folder showing folders files
    **/
    navigateFolder(event){
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.foldername;
        this.myBreadcrumbs.push({label:selectedField,id:selectedField})
        this.folderNameForNavigateFiles+=selectedField+'/';
        this.getFiles();
    }
      /** 
     Name: handleApexCallCreateFolder,
     Param:null
     Return Type:null
     description: create folder method
    **/
    handleApexCallCreateFolder(){
        var prompt=window.prompt('Please enter Folder name');
        if(prompt!=null){
            this.handleSpinner();
            createFolder({folderName :this.folderNameForNavigateFiles+ prompt})
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
     /** 
     Name: previewFile,
     Param:event
     Return Type:null
     description: when click on file it should open on next page 
    **/
    previewFile(event){
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.pathpreview;
        window.open('https://www.dropbox.com/home'+selectedField,'_blank');
        console.log(selectedField);
    }
     /** 
     Name: deleteFiles,
     Param:event
     Return Type:null
     description: deleteing files method
    **/
    deleteFiles(event){
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.pathdelete;
        deleteFileDropbox({path :selectedField})
        .then(res=>{
            this.ShowToast('Success!', 'Folder deleted successfully', 'success', 'dismissable');
            this.getFiles();
        }).catch(error=>{
            this.ShowToast('Error!!', error.body.message, 'error', 'dismissable');
        })
        console.log(selectedField);
    }
    /** 
     Name: downloadFiles,
     Param:event
     Return Type:null
     description: download files method
    **/
    downloadFiles(event){
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.pathdownload;
        downloadFile({path :selectedField})
        .then(res=>{
            window.location.href=res;
            this.ShowToast('Success!', 'download file successfully', 'success', 'dismissable');
        }).catch(error=>{
            this.ShowToast('Error!!', error.body.message, 'error', 'dismissable');
        })
        console.log(selectedField);
    }
   /** 
     Name: handleSpinner,
     Param:null
     Return Type:null
     description: show spinner
    **/
    handleSpinner(){
        this.showSpinner = !this.showSpinner;
    }
     /** 
     Name: ShowToast,
     Param:title,message,variant,mode
     Return Type:null
     description: for showing toast message
    **/
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