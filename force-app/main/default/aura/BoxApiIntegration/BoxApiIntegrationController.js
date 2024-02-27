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
                // console.log('===reges==',reges);

            console.log('===results==',results);
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
                    if(authUrl==true){
                        helper.getFiles(component,event,helper);
                    }
                    else{
                        helper.getdoAuth(component,event,helper);
                    }
                }
          });
          $A.enqueueAction(action);
          }
        var breadcrumbCollection = [
            {label: 'Home', id: '0' }
        ];

        component.set('v.breadcrumbCollection', breadcrumbCollection);
    },
    /** 
     Name: deleteFile,
     Param:component, event, helper
     Return Type:null
     description: method called when delete button is clicked
    **/
    deleteFile : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.del;
        var selectedType = selectedItem.dataset.type;
        var action  = component.get("c.deleteFileBox");
        action.setParams({
            "StringID":selectedField
        })
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var filesData = response.getReturnValue();
                if(filesData==true){
                    alert("your file is deleted successfully");
                    helper.getFiles(component,event,helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
     /** 
     Name: downLoadFile,
     Param:component, event, helper
     Return Type:null
     description: download file method using apex
    **/
    downLoadFile : function(component, event, helper) {
        console.log('hello1');
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.tit;
        console.log('hello2');

        var action  = component.get("c.downloadFile");
        console.log(action);
        action.setParams({
            "StringID":selectedField
        })
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var filesData = response.getReturnValue();
                window.location.href = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
   
    ShowToast:function(title, message, variant, mode){
        const evt = new ShowToastEvent({
            title: title,
            message:message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
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
     /** 
     Name: handleUploadFinished,
     Param:component, event, helper
     Return Type:null
     description:upload file using box
    **/
    handleUploadFinished: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var attachmentId = uploadedFiles[0].documentId;
        var dotLastIndex = uploadedFiles[0].name.lastIndexOf('.');
        var finalName = uploadedFiles[0].name.substring(0, dotLastIndex);
        var action  = component.get('c.uploadFile');
        action.setParams({
            "attachmentId": attachmentId,
            "fileName" : finalName,
            "mimeType" : uploadedFiles[0].mimeType,
            "ParentId" : component.get("v.breadCrumbFileId")
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            console.log(response.getReturnValue());
            if(status === "SUCCESS"){
                var response = response.getReturnValue();
                console.log('responseCode' , response);
                helper.getFiles(component, component.get("v.fileId"));
                alert('File uploaded Sucessfully');
            }            
            else
            alert('There was some error');
        });
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