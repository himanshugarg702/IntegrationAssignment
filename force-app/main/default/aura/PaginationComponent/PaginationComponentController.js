({
    init : function(component, event, helper) {
        component.set('v.loaded', !component.get('v.loaded'));
        helper.getData(component,event,helper);
    },
    handleChange:function(component,event,helper){
        component.set('v.loaded', !component.get('v.loaded'));
        component.set("v.selectedField", []);
        component.set("v.tableColumns", []);
        helper.getAllFields(component, event, helper);

    }, 
    handleToChangeSelectedField: function (component, event, helper) {
        component.set('v.loaded', !component.get('v.loaded'));
        //Get the Selected values   
        // var tempList=[];
        //  console.log(' component.get("v.allField") ', JSON.stringify(component.get("v.allField")).length);
        //  for(let i=0;i<JSON.stringify(component.get("v.allField")).length;i++){
        //     console.log(JSON.stringify(component.get("v.allField"))[i]);
        //  }
        var selectedValues = event.getParam("value");
        // var labels = component.get("v.allField")
        // .filter(option => selectedValues.indexOf(option.value) > -1)
        // .map(option => option.label);
        console.log(selectedValues);
        component.set("v.selectedField", selectedValues);
        if(selectedValues==0){
            component.set("v.tableColumns", []);
        }
    },
    processTable : function(component, event, helper){
        component.set('v.loaded', !component.get('v.loaded'));
        // var selectedValues=component.get("v.selectedField");
        // component.set("v.tableColumns", selectedValues);
        var fieldNames=component.get("v.selectedField");//list of selected fields from picklist       
        var columnsDataTable = [];
        for (var i in fieldNames) {
            columnsDataTable.push({label: fieldNames[i],
                fieldName: fieldNames[i],
                type: 'String',
                sortable:true
            });
        }
        component.set("v.tableColumns", columnsDataTable);
        var pageNumber = component.get("v.PageNumber"); 
        console.log(component.get("v.PageNumber")); 
        var pageSize = component.find("pageSize").get("v.value");
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
    pageRecordChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.getRecordsFromServer(component, page, pageSize);
    },
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
    // handleFirstPage: function(component, event, helper) {
    //     var pageNumber = component.get("v.PageNumber");  
    //     var pageSize = component.find("pageSize").get("v.value");
    //     helper.getRecordsFromServer(component, pageNumber, pageSize);
    // },
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
    handleLastPage: function(component, event, helper) {
        var TotalPages = component.get("v.TotalPages");  
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber=TotalPages;
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
    handleSort: function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
    },
    handleRowAction: function(component,event,helper){
        var selected = [],  checkboxes = component.find("id").get("v.value");
        console.log(checkboxes);
    }
})