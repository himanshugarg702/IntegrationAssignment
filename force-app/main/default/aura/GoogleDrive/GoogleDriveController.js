({
     /** 
     Name: doInit,
     Param:component, event, helper
     Return Type:null
     description: when component render this method initialize and check if user is already present call files else called authurl
    **/
    doInit : function(component, event, helper) {
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
        var code = getParameterByName('code');
            if(code !== undefined && code!==null) {
                  console.log('code');
                    helper.getAccessToken(component,code,helper);
                }
            else{
                    var action  = component.get("c.checkUserCreatedOrNot");
                    action.setCallback(this, function(response){
                        var status = response.getState();
                        if(status === "SUCCESS"){
                            var authUrl = response.getReturnValue();
                            console.log(authUrl);
                            console.log(code);
                            if(authUrl==true){
                                helper.getFiles(component,event,helper);
                            }
                            else{
                                console.log('hello world');
                                helper.getdoAuth(component,event,helper);
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }
                var breadcrumbCollection = [
                    {label: 'Home', id: 'root' }
                ];
        
                component.set('v.breadcrumbCollection', breadcrumbCollection);
                component.set('v.loaded', true);
    },
     /** 
     Name: deleteFile,
     Param:component, event, helper
     Return Type:null
     description: method called when delete button is clicked
    **/
    deleteFile : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.tit;
        component.set('v.fileId',selectedField);
        helper.getDeleteFile(component,event,helper);
        helper.getFiles(component,event,helper);
    },
    /** 
     Name: handleUploadFinished,
     Param:component, event, helper
     Return Type:null
     description:if file is upload this method called
    **/
    handleUploadFinished: function(component, event, helper) {
        console.log(component.get('v.breadCrumbFileId'));
        var uploadedFiles = event.getParam("files");
        var attachmentId = uploadedFiles[0].documentId;
        var lastIndex= uploadedFiles[0].name.lastIndexOf('.');
        var name=uploadedFiles[0].name.substring(0,lastIndex);
        var action  = component.get("c.uploadFile");
        console.log('hello1');
        action.setParams({
            "name":name,
            "attachmentId": attachmentId,
            "parentId" :  component.get('v.breadCrumbFileId'),
            "type":uploadedFiles[0].mimeType
        });
        console.log('hello2');

        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var responseCode = response.getReturnValue();
                if(responseCode == '200'){
                    alert('File Uploaded successfully');
                    helper.getFiles(component,event,helper);
                }     
                else
                    alert('There was some error');
            }
        });
        $A.enqueueAction(action);
    },
    /** 
     Name: handleFilesChange,
     Param:component, event, helper
     Return Type:null
     description:if file is upload this method called
    **/
    handleFilesChange: function(component, event, helper) {
       var fileInput = event.getSource().get('v.files');
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
    },
    /** 
     Name: createNewFolder,
     Param:component, event, helper
     Return Type:null
     description:this method call when new folder is created
    **/
    createNewFolder:function(component, event, helper) {
        var prompt=window.prompt('Please enter Folder name');
        if(prompt!=null){
            var action  = component.get("c.newFolder");
            action.setParams({
                "folderName": prompt,
                "fileId":component.get('v.breadCrumbFileId')
            });
            action.setCallback(this, function(response) {
                var status = response.getState();
                if(status === "SUCCESS"){
                    var responseCode = response.getReturnValue();
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
    /** 
     Name: openFolderFiles,
     Param:component, event, helper
     Return Type:null
     description:this method for breadcrumb when folder will clicked according to that file will come
    **/
    openFolderFiles:function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.tit;
        var selectedFieldName=selectedItem.dataset.name;
        component.set('v.breadCrumbFileId',selectedField);
        helper.getFiles(component,event,helper);
        var breadCrumbLists=component.get('v.breadcrumbCollection');
        breadCrumbLists.push({label:selectedFieldName, id:selectedField});
        component.set('v.breadcrumbCollection', breadCrumbLists);
    },

    /** 
     Name: navigateTo,
     Param:component, event, helper
     Return Type:null
     description:this method for breadcrumb when breadcrumb file will clicked
    **/
    navigateTo: function (component, event, helper) {
        component.set('v.loaded', false);
        var folderIdToNavigate = event.getSource().get('v.id');
        var labelName = event.getSource().get('v.label');
        component.set('v.breadCrumbFileId',folderIdToNavigate);
        var breadCrumbLists=component.get('v.breadcrumbCollection');
        for(var i=0;i<breadCrumbLists.length;i++ ){
            if(breadCrumbLists[i].label==labelName&&i<breadCrumbLists.length){
                breadCrumbLists.splice(i+1,breadCrumbLists.length-(i+1));
                break;
            }
        }
        helper.getFiles(component,event,helper);
        component.set('v.breadcrumbCollection', breadCrumbLists);
        component.set('v.loaded', true);
    }
})