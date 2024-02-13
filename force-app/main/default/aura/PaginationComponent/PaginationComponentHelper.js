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
                // listOfObjects = listOfObjects.sort(function (a, b) {
                //     return a.val.localeCompare( b.val );
                // });
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
                // JSON.parse(listOfFields);
                 console.log(listOfFields);
                // var tempField=Json.stringify(listOfFields);
                
                // console.log(JSON.stringify(listOfFields),'hello');
                component.set("v.allField",JSON.parse(JSON.stringify(listOfFields)));
                // console.log('all fields ',JSON.stringify(component.get("v.allField")));
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
    getRecordsFromServer:function(component, pageNumber, pageSize){
        var action=component.get("c.dataForTable");
        action.setParams({
            selectedObject:component.get('v.selectedObject'),
            selectedField:component.get('v.selectedField'),
            "pageNumber": pageNumber,
            "pageSize": pageSize
        })
        action.setCallback(this,function(response)  {
            var state = response.getState();
            if(state==="SUCCESS"||state==="DRAFT") {
                var result=response.getReturnValue();
                // var listOfFields=[];
                // for (var i = 0; i < result.length; i++) {
                //     listOfFields.push({
                //         label: result[i],
                //         value: result[i]
                //     });
                // }
               
                component.set("v.sObjectList",result.sobj);
                component.set("v.PageNumber",result.pageNumber);
                component.set("v.TotalPages",Math.ceil(result.totalRecords / pageSize));
                component.set("v.TotalRecords",result.totalRecords);
                if(result.sobj.length==0){
                    component.set("v.selectedField", []);
                    component.set("v.tableColumns", []);
                    alert("data not found!");
                }
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
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.sObjectList");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
         
        data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            });
        component.set("v.sObjectList",data);
    }
})