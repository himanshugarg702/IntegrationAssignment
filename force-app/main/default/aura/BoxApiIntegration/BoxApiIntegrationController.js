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
        var selectedField = selectedItem.dataset.del;
        var selectedType = selectedItem.dataset.type;
        console.log(selectedType);

        var action  = component.get("c.deleteFileBox");
        console.log(action);
        action.setParams({
            // console.log('check');
            "StringID":selectedField,
            "fileType":selectedType
        })
        console.log('hello world 2');
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                console.log('hello world 6');
                var filesData = response.getReturnValue();
                console.log('hello world 5');
                if(filesData==true){
                    alert("your file is deleted successfully");
                            helper.getFiles(component,event,helper);

                }
                // component.set('v.files',filesData);
                console.log('----------->',filesData);
                // window.location.href = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
        // helper.getDeleteFile(component,event,helper);
        // helper.getFiles(component,event,helper);
    },
    downLoadFile : function(component, event, helper) {
        // component.set('v.fileId','');
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.tit;
        var action  = component.get("c.downloadFile");
        console.log(action);
        action.setParams({
            // console.log('check');
            "StringID":selectedField
            // "accessToken":component.get('v.accessToken')
        })
        console.log('hello world 2');
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                console.log('hello world 6');
                var filesData = response.getReturnValue();
                window.location.href = response.getReturnValue();
                console.log('hello world 5');
                // if(filesData==true){
                //     alert("your file is deleted successfully");
                // }
                // component.set('v.files',filesData);
                console.log('----------->',filesData);
                // window.location.href = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
        // helper.getDeleteFile(component,event,helper);
        // helper.getFiles(component,event,helper);
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
         console.log(file.lastModified);
         if (file) {
             var reader = new FileReader();
             reader.onload = function() {
                 var fileContent = reader.result.split(',')[1]; // Extract base64 content
                 var action = component.get("c.uploadFile");
                 action.setParams({
                    "base64":fileContent,
                     "fileName": file.name, // Use file.name if available, otherwise fallback to 'Untitled'
                     "folderId":  file.lastModified// This should be the Blob content, not a String
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
    createNewFolder:function(component, event, helper) {
        var prompt=window.prompt('Please enter Folder name');
        console.log(prompt);
        if(prompt!=null){
        var action  = component.get("c.newFolder");
        action.setParams({
            "folderName": prompt
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var responseCode = response.getReturnValue();
                console.log(responseCode);
                if(responseCode == true){
                    alert('Folder Created Successfully');
                    helper.getFiles(component,event,helper);

                }
                else
                    alert('There was some error');
            }
        });
    }
        $A.enqueueAction(action);
    },
    handleUploadFinished: function(component, event, helper) {
            var recordId=component.get('v.recordId');
            console.log(recordId);
            var filetype=component.get('v.filetype');
            console.log(filetype);
            var uploadedFiles = event.getParam("files");
            console.log(uploadedFiles);
            var name=uploadedFiles[0].name;
            console.log(name);
            var attachmentId = uploadedFiles[0].contentVersionId;
            console.log(attachmentId);
            // var code = component.get("v.accessToken");
            if (uploadedFiles.length>0) {
                console.log('hello world');
                // var reader = new FileReader();
                console.log('helloworld3');
                // reader.onload = readSuccess;                                            
                //    function readSuccess(evt) { 
                // reader.onload = function() {

               var fileContent = reader.result.split(',')[1]; // Extract base64 content
                console.log('helloworld2');
                var action  = component.get("c.uploadFile");
                console.log('helloworld2');
            action.setParams({
                "base64" : fileContent,
                "filename":uploadedFiles[0].name,
                "folderId": attachmentId
            });
            console.log('hellow orld 3');
            action.setCallback(this, function(response){
                var status = response.getState();
                if(status === "SUCCESS"){
                    var responseCode = response.getReturnValue();
                    if(responseCode == '200')
                        alert('File Uploaded successfully');
                    else
                        alert('There was some error');
                }
            });
            
            $A.enqueueAction(action);
        // }
        // reader.readAsDataURL(uploadedFiles);
    }

    },
  
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