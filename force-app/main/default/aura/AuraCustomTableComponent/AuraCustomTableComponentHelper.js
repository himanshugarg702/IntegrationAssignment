({
     /** 
     Name: getData,
     Param:component, event, helper
     Return Type:null
     description: getting sobjects when component render helper function
    **/
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
    /** 
     Name: getAllFields,
     Param:component, event, helper
     Return Type:null
     description: helper function of getting all fields when object is selected
    **/
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
    /** 
     Name: getRecordsFromServer,
     Param:component, event, helper
     Return Type:null
     description: helper function of getting all data from controller apex
    **/
    getRecordsFromServer:function(component, pageNumber, pageSize){
        console.log(pageNumber,'hello');
        // if(component.get('v.selectedObject')!=null){
        //     console.log('helloworld');
        //     var tempMap=new Map();
        //     // component.set('v.allCheckBoxSelected',tempMap);
        //     var sObjectRecords=component.get('v.sObjectList');
        //     console.log(JSON.stringify(sObjectRecords));
        //     for(var key of sObjectRecords){
        //         console.log(key.id,key.check);
        //         tempMap.set(key.id,key.check);
        //     }
        //     // for(var i=0;i<sObjectRecords.length;i++){

        //     //     console.log(sObjectRecords[i].id,sObjectRecords[i].check);
        //     //     tempMap.set(sObjectRecords[i].sobj.id,sObjectRecords[i].check);
        //     // }
        //     component.set('v.allCheckBoxSelected',tempMap);
        // }
        var action=component.get("c.dataForTable");
        action.setParams({
            selectedObject:component.get('v.selectedObject'),
            selectedField:component.get('v.selectedField'),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            sortingField:component.get('v.selectedSortingField'),
            sortBy:component.get('v.sortBy'),
            recordsID:component.get('v.recordId')
        })
        
        action.setCallback(this,function(response)  {
            var state = response.getState();
            if(state==="SUCCESS"||state==="DRAFT") {
                var result=response.getReturnValue();
                var recordsData=[];
                var recordsIds=[];
                // var mapRecords=component.get('v.allCheckBoxSelected');
                // for(var i=0;i<mapRecords.length;i++){
                //  if(mapRecords.has(result[i].sObj.id)){
                //      result[i].check=(mapRecords.get(result[i].sObj.id));
                //  }
                // }
               for(var key of result){
                recordsIds.push(key.sobj.Id);
                recordsData.push(key.sobj)
               }
              
               component.set('v.recordId',recordsIds);
                component.set("v.sObjectList",recordsData);
                component.set("v.PageNumber",pageNumber);
                if(recordsData.length==0){
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
    /** 
     Name: totalRecords,
     Param:component, event, helper
     Return Type:null
     description: helper function of getting all total records value
    **/
    totalRecords:function(component, pageNumber, pageSize){
        var action=component.get("c.getTotalRecords");
        action.setParams({
            selectedObject:component.get('v.selectedObject')
        })
        action.setCallback(this,function(response)  {
            var state = response.getState();
            if(state==="SUCCESS"||state==="DRAFT") {
                var result=response.getReturnValue();
                component.set("v.TotalPages",Math.ceil(result/ pageSize));
                component.set("v.TotalRecords",result);
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
    /** 
     Name: totalRecords,
     Param:component, event, helper
     Return Type:null
     description: helper function of getting all total records value
    **/
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.sObjectList");
        var sortingField=component.set("v.selectedSortingField");
        var isSortAsc = component.get("v.isSortAsc");
        data.sort(function(a, b){
            var s1 = a[sortingField] == b[sortingField];
            var s2 = (!a[sortingField] && b[sortingField]) || (a[sortingField] < b[sortingField]);
            return s1? 0: (isSortAsc?-1:1)*(s2?1:-1);
        });
        component.set("v.sObjectList", data);
        component.set("v.isSortAsc", !isSortAsc);
        //function to return the value stored in the field
        // var key = function(a) { return a[fieldName]; }
        // var reverse = sortDirection == 'asc' ? 1: -1;
         
        // data.sort(function(a,b){
        //         var a = key(a) ? key(a) : '';
        //         var b = key(b) ? key(b) : '';
        //         return reverse * ((a>b) - (b>a));
        //     });
        // component.set("v.sObjectList",data);
    }
})