({
    getCurrentUserInformation:function(component,event,helper)  {
        var action=component.get("c.getUserInformation");
        action.setCallback(this,function(response) {
            var state=response.getState();
            if(state=="SUCCESS"||state=="DRAFT") {
                var result=response.getReturnValue();
                console.log(JSON.stringify(result.Name));
                component.set('v.contactName',result.Name);
                component.set('v.userName',result.userName);
                component.set('v.contactId',result.userId);

            }
            else if(state=="INCOMPLETE")    {
                console.log("No response from server or client is offline.");
            }
            else if(state=="ERROR") {
                if(errors)  {
                    if(errors[0]&&errors[0].message)  {
                        console.log("Error Message: "+ errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        })
        $A.enqueueAction(action);
    },
})