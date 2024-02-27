({
     /** 
     Name: getdoAuth,
     Param:component, event, helper
     Return Type:null
     description: this method is creating url if user is not present from apex
    **/
    getdoAuth : function(component, event, helper) {
        var action  = component.get("c.createAuthURL");
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var authUrl = response.getReturnValue();
                window.location.href = response.getReturnValue();
                component.set('v.accessToken',authUrl);
                component.set('v.disabled',false);
            }
        });
        $A.enqueueAction(action);
    },

     /** 
     Name: getFiles,
     Param:component, event, helper
     Return Type:null
     description: all the files which stored in drive will be fetched by this method after the call of apex method
    **/
    getFiles:function(component,event,helper){
        var action  = component.get("c.getAllFilesFromBox");
        action.setParams({
            // console.log('check');
            "fileId":component.get('v.breadCrumbFileId')
        })
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var filesData = response.getReturnValue();
                component.set('v.files',filesData);
                
                console.log('----------->',filesData);
                // window.location.href = response.getReturnValue();
            }
        });
        
        $A.enqueueAction(action);
    },
     /** 
     Name: getDeleteFile,
     Param:component, event, helper
     Return Type:null
     description: this method is deleting file on the click of delete 
    **/
    getDeleteFile:function(component,event,helper) {
        var action  = component.get("c.deleteFileApex");
        console.log(action);
        action.setParams({
            "StringID":component.get('v.fileId'),
            "accessToken":component.get('v.accessToken')
        })
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                console.log('hello world 6');
                var filesData = response.getReturnValue();
                console.log('hello world 5');
                if(filesData==true){
                    alert("your file is deleted successfully");
                }
            }
        });
        $A.enqueueAction(action);
    },
      /** 
     Name: getAccessToken,
     Param:component, event, helper
     Return Type:null
     description: this method is getting access token 
    **/
    getAccessToken:function(component,code,helper) {
        if(code !== undefined && code!==null) {
            var action = component.get('c.getAccessToken');
            action.setParams({
                'code' : code
            });
            action.setCallback(this, function(response){
                var status = response.getState();
               	if(status === "SUCCESS"){
                    var accessToken = response.getReturnValue();
                    if(accessToken!=null){
                        var action  = component.get("c.getAllFilesFromGoogleDrive");
                        action.setCallback(this, function(response){
                            var status = response.getState();
                            if(status === "SUCCESS"){
                                var filesData = response.getReturnValue();
                                component.set('v.files',filesData);
                            }
                        });
                        $A.enqueueAction(action);
                    }
                    component.set("v.accessToken", accessToken);
                    component.set("v.access", accessToken==true?'Authenticated..':'Not Authenticated..');
                }
            });
            
        }   $A.enqueueAction(action);
    }
})