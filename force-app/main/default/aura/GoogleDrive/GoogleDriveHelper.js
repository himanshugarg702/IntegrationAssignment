({
    getdoAuth : function(component, event, helper) {
        var action  = component.get("c.createAuthURL");
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var authUrl = response.getReturnValue();
                window.location.href = response.getReturnValue();
                console.log(authUrl);
                component.set('v.accessToken',authUrl);
                component.set('v.disabled',false);
            }
        });
        $A.enqueueAction(action);
    },
    getFiles:function(component,event,helper){
        var action  = component.get("c.getAllFilesFromGoogleDrive");
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
    getDeleteFile:function(component,event,helper) {
        console.log('hello world 3');
        var action  = component.get("c.deleteFileApex");
        console.log(action);

        action.setParams({
            // console.log('check');
            "StringID":component.get('v.fileId'),
            "accessToken":component.get('v.accessToken')
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
                }
                // component.set('v.files',filesData);
                console.log('----------->',filesData);
                // window.location.href = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
    getAccessToken:function(component,code,helper) {
        // var code = getParameterByName('code');
        console.log(code,'code198');
        if(code !== undefined && code!==null) {
            var action = component.get('c.getAccessToken');
            action.setParams({
                'code' : code
            });
            action.setCallback(this, function(response){
                var status = response.getState();
               	if(status === "SUCCESS"){
                    console.log(code,'code2');
                    var accessToken = response.getReturnValue();
                    if(accessToken!=null){
                        var action  = component.get("c.getAllFilesFromGoogleDrive");
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
                    }
                    console.log(accessToken);
                    component.set("v.accessToken", accessToken);
                    component.set("v.access", accessToken==true?'Authenticated..':'Not Authenticated..');
                }
            });
            
        }   $A.enqueueAction(action);
    }
})