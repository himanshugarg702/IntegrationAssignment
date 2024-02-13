({
    doInit : function(component, event, helper) {
       	var url = window.location.href;
        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
                // console.log('===reges==',reges);

            console.log('===results==',results);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }
        var code = getParameterByName('code');
        var action  = component.get("c.createAuthURL");
        var accessToken; 
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var authUrl = response.getReturnValue();
                console.log(authUrl);
                console.log(code);
            if(code !== undefined && code!==null) {
                    console.log('code');
                    helper.getAccessToken(component,code,helper);
                }
                if(code==null){
                    console.log('hellow hima2');
                    helper.getdoAuth(component,event,helper);
                    // accessToken=component.get('v.accessToken');
                    // window.location.href = response.getReturnValue();
                }
                // if(accessToken!=null){
                //     console.log(accessToken,'-------->');
                //     console.log('hello hima');
                //     helper.getFiles(component,event,helper);
                // }
            }
        });
        $A.enqueueAction(action);
        // var code = getParameterByName('code');
        // console.log(code,'code');
        // if(code !== undefined && code!==null) {
        //     var action = component.get('c.getAccessToken');
        //     action.setParams({
        //         'code' : code
        //     });
        //     action.setCallback(this, function(response){
        //         var status = response.getState();
        //         console.log(status,'status');
        //         // console.log(code,'code');
        //        	if(status === "SUCCESS"){
        //             console.log(code,'code23');
        //             var accessToken = response.getReturnValue();
        //             console.log(accessToken);
        //             component.set("v.accessToken", accessToken);
        //             component.set("v.access", accessToken==true?'Authenticated..':'Not Authenticated..');
        //         }
        //     });
            
        //     $A.enqueueAction(action);
        // }
    },
    // getLink:function(component,event,helper){

    // },
    doAuth : function(component, event, helper) {
        helper.getdoAuth(component,event,helper);
        // var temp=component.get('v.disabled');
        // console.log(temp,'---->');
        // if(temp==false){
            // helper.getFiles(component,event,helper);
        // }
        // var action  = component.get("c.createAuthURL");
        // action.setCallback(this, function(response){
        //     var status = response.getState();
        //     if(status === "SUCCESS"){
        //         var authUrl = response.getReturnValue();
        //         window.location.href = response.getReturnValue();
        //     }
        // });
        
        // $A.enqueueAction(action);
    },
    filesget : function(component, event, helper) {
        helper.getFiles(component,event,helper);
    },
    deleteFile : function(component, event, helper) {
        console.log('hello');
        // component.set('v.fileId','');
        var selectedItem = event.currentTarget;
        console.log('hello1',selectedItem);
        var selectedField = selectedItem.dataset.tit;
        console.log('hello2',selectedField);
        component.set('v.fileId',selectedField);
        console.log(component.get('v.fileId'));
        console.log(selectedField,'---selec');
        helper.getDeleteFile(component,event,helper);
        helper.getFiles(component,event,helper);
    },
    // handleFolderName: function(component, event, helper) {
    //     console.log('hello1');
    //     this.folderId = event.target.value;
    // },
 
     // getting file 
    // handleFilesChange: function(component, event, helper)  {
    //     console.log('hello2');

    //     if(event.target.files.length > 0) {
    //         const file = event.target.files[0]
    //         var reader = new FileReader()
    //         reader.onload = () => {
    //             var base64 = reader.result.split(',')[1]
    //             this.fileData = {
    //                 'filename': file.name,
    //                 'base64': base64,
    //                 'recordId': this.folderId
    //             }
    //             console.log(this.fileData)
    //         }
    //         reader.readAsDataURL(file)
    //     }
    // } ,
    handleFilesChange: function(component, event, helper) {
        var fileInput = event.getSource().get('v.files');
        console.log(fileInput);
         var file = fileInput[0];
         if (file) {
             var reader = new FileReader();
             reader.onload = function() {
                 var fileContent = reader.result.split(',')[1]; // Extract base64 content
                 var action = component.get("c.uploadFile");
                 action.setParams({
                     "fileName": file.name || 'Untitled', // Use file.name if available, otherwise fallback to 'Untitled'
                     "accessToken": component.get('v.accessToken'),
                     "fileContent": fileContent // This should be the Blob content, not a String
                 });
                 action.setCallback(this, function(response) {
                     var status = response.getState();
                     if (status === "SUCCESS") {
                         console.log('File uploaded successfully');
                                 helper.getFiles(component,event,helper);
 
                         // Handle success if needed
                     } else {
                         console.error('Error uploading file: ' + response.getError()[0].message);
                         // Handle error if needed
                     }
                 });
                 $A.enqueueAction(action);
             };
             reader.readAsDataURL(file);
         
         }
        // handleFilesChange: function(component, event, helper) {
        /* var fileInput = event.getSource().get('v.files');
         var file = fileInput[0];
         if (file) {
             var action = component.get("c.uploadFile");
             action.setParams({
                 "fileName": file.name,
                 "accessToken": component.get('v.accessToken'),
                 "fileContent": file
             });
             action.setCallback(this, function(response) {
                 var status = response.getState();
                 if (status === "SUCCESS") {
                     console.log('File uploaded successfully');
                     // Handle success if needed
                 } else {
                     console.error('Error uploading file: ' + response.getError()[0].message);
                     // Handle error if needed
                 }
             });
             $A.enqueueAction(action);
         }*/
         // var fileName = 'No File Selected..';
         // if (event.getSource().get("v.files").length > 0) {
         //     fileName = event.getSource().get("v.files")[0]['name'];
         // }
         // component.set("v.fileName", fileName);
     },
    // Calling apex class to upload the file to box storage
    // uploadFileToBox: function(component, event, helper)  {
    //     // this.handleSpinner();
    //     console.log('hello3');

    //     const {base64, filename, recordId} = this.fileData
    //     uploadFile({ base64 : base64, filename:filename, folderId:recordId }).then(result=>{
    //         this.fileData = null
    //         let title = `${filename} uploaded successfully!!`;
    //         this.ShowToast('Success!', title, 'success', 'dismissable');
    //     }).catch(err=>{
    //         this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
    //     }).finally(() => {
    //         this.handleSpinner();
    //     })
    // },
    ShowToast:function(title, message, variant, mode){
        const evt = new ShowToastEvent({
            title: title,
            message:message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    },
//     handleUploadFinished: function(component, event, helper) {
//             // var recordId=component.get('v.recordId');
//             // console.log(recordId);
//             // var filetype=component.get('v.filetype');
//             // console.log(filetype);
//             var uploadedFiles = event.getParam("files");
//             console.log(uploadedFiles);
//             var attachmentId = uploadedFiles[0].documentId;
//             var code = component.get("v.accessToken");
            
//             var action  = component.get("c.uploadFile");
//             action.setParams({
//                 "attachmentId": attachmentId,
//                 "accessToken" : code,
//                 "name":uploadedFiles[0].name
//             });
//             action.setCallback(this, function(response){
//                 var status = response.getState();
//                 if(status === "SUCCESS"){
//                     var responseCode = response.getReturnValue();
//                     if(responseCode == '200')
//                         alert('File Uploaded successfully');
//                     else
//                         alert('There was some error');
//                 }
//             });
            
//             $A.enqueueAction(action);

//     },
  
    // getAccessToken:function(component,event,helper) {
    //     console.log('code');
    //     var code = getParameterByName('code');
    //     console.log(code,'code');
    //     if(code !== undefined && code!=='' && code!==null) {
    //         var action = component.get('c.getAccessToken');
    //         action.setParams({
    //             'code' : code
    //         });
    //         action.setCallback(this, function(response){
    //             var status = response.getState();
    //            	if(status === "SUCCESS"){
    //                 var accessToken = response.getReturnValue();
    //                 component.set("v.accessToken", accessToken);
    //                 component.set("v.access", accessToken==true?'Authenticated..':'Not Authenticated..');
    //             }
    //         });
            
    //     }   $A.enqueueAction(action);
    // }
})