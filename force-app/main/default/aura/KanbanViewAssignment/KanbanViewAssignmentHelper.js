({
    getData:function(component,event,helper)  {
        var action=component.get("c.allObject");
        action.setCallback(this,function(response) {
            var state=response.getState();
            if(state=="SUCCESS"||state=="DRAFT") {
                var result=response.getReturnValue();
                var listOfObjects=[];
                for(var key in result)  {
                   
                    listOfObjects.push({key:key,value:result[key]});
                }
                component.set("v.allObject",listOfObjects);
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
    getAllPickListField:function(component,event,helper){
        var action=component.get("c.pickListFields");
        action.setParams({
            selectedObject:component.get('v.selectedObject'),
        })
        action.setCallback(this,function(response)  {
            var state = response.getState();
            if(state==="SUCCESS"||state==="DRAFT") {
                var result=response.getReturnValue();
                var listOfFields=[];
                for(var key in result)  {
                    listOfFields.push({
                        key:key,
                        value:result[key]});
                }
                 console.log(listOfFields);                
                component.set("v.allPickListField",JSON.parse(JSON.stringify(listOfFields)));
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
    getAllFields:function(component,event,helper){
        var action=component.get("c.allFields");
        action.setParams({
            selectedObject:component.get('v.selectedObject'),
        })
        action.setCallback(this,function(response)  {
            var state = response.getState();
            if(state==="SUCCESS"||state==="DRAFT") {
                var result=response.getReturnValue();
                var listOfFields=[];
                for(var key in result)  {
                    listOfFields.push({
                        label:result[key],
                        value:key});
                }
                 console.log(listOfFields);                
                component.set("v.allField",JSON.parse(JSON.stringify(listOfFields)));
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
    getAllPickListValues:function(component,event,helper){
        var selectedPickListField=component.get('v.selectedPickListField');
        var action=component.get("c.getPickVals");
        action.setParams({
            selectedObject:component.get('v.selectedObject'),
            fieldName:component.get('v.selectedPickListField'),
            selectedField:component.get('v.selectedFieldsValue')
        })
        action.setCallback(this,function(response)  {
            var state = response.getState();
            if(state==="SUCCESS"||state==="DRAFT") {
                var result=response.getReturnValue();
                var countTotalRecordsAsPerValue=[];
                result.pickValues.forEach(val => {
                    var count=0;
                    result.records.forEach(rec => {
                        if(rec[selectedPickListField]==val){
                            count++;
                        }
                    });
                    countTotalRecordsAsPerValue.push({'label':val,'count':count});
                });
                // var records
                component.set('v.totalCountValueRecords',countTotalRecordsAsPerValue)
                component.set("v.kanbanData", result);
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
    
    updatePickVal : function(component, recId, pField, pVal) {
		var action = component.get("c.getUpdateStage");
        action.setParams({
            selectedObject:component.get('v.selectedObject'),
            "recId":recId,
            "kanbanField":pField,
            "kanbanNewValue":pVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                document.getElementById(recId).style.backgroundColor = "#04844b";
                setTimeout(function(){ document.getElementById(recId).style.backgroundColor = ""; }, 300);
            }
        });
        $A.enqueueAction(action);
	}
})