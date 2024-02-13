({
     /** 
     Name: init,
     Param:component, event, helper
     Return Type:null
     description: when component render this method initialize and get sObjects
    **/
    init : function(component, event, helper) {
        component.set('v.loaded', !component.get('v.loaded'));
        helper.getData(component,event,helper);
    },
     /** 
     Name: handleChange,
     Param:component, event, helper
     Return Type:null
     description: when object selected their corresponding fields get from Apex
    **/
    handleChange:function(component,event,helper){
        var tempMap=new Map();
        component.set('v.allCheckBoxSelected',tempMap);
        component.set('v.loaded', !component.get('v.loaded'));
        component.set("v.selectedField", []);
        component.set("v.tableColumns", []);
        helper.getAllFields(component, event, helper);

    }, 
     /** 
     Name: handleToChangeSelectedField,
     Param:component, event, helper
     Return Type:null
     description: when field selected to show table in this method getting api name
    **/
    handleToChangeSelectedField: function (component, event, helper) {
        component.set('v.loaded', !component.get('v.loaded'));
       
        var selectedValues = event.getParam("value");
        component.set("v.selectedField", selectedValues);
        if(selectedValues==0){
            component.set("v.tableColumns", []);
        }
    },
    /** 
     Name: processTable,
     Param:component, event, helper
     Return Type:null
     description: after click of process getting data from apex
    **/
    processTable : function(component, event, helper){
                component.set('v.recordId',[]);
        var selectedValues=component.get("v.selectedField");
        var label=component.get('v.allField')
                    .filter(option=> selectedValues.indexOf(option.value)>-1)
                    .map(option=>option.label);
                    console.log(JSON.stringify(label),'label');
        var fields=[];
        for(var i=0;i<label.length;i++){
            fields.push({'label':label[i],'value':selectedValues[i]});
        }        
        component.set("v.tableColumns", fields);
       
        var pageNumber = component.get("v.PageNumber"); 
        var pageSize = component.find("pageSize").get("v.value");
        helper.getRecordsFromServer(component, pageNumber, pageSize);
        helper.totalRecords(component, pageNumber, pageSize);
    },
    /** 
     Name: pageRecordChange,
     Param:component, event, helper
     Return Type:null
     description: page size change 
    **/
    pageRecordChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        component.set('v.recordId',[]);
        helper.getRecordsFromServer(component, page, pageSize);
        helper.totalRecords(component, page, pageSize);
    },
    /** 
     Name: handlePrev,
     Param:component, event, helper
     Return Type:null
     description: when previous button is clicked
    **/
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        component.set('v.recordId',[]);
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
    /** 
     Name: handleNext,
     Param:component, event, helper
     Return Type:null
     description: when next button is clicked
    **/
    handleNext: function(component, event, helper) {
        component.set('v.recordId',[]);
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
    /** 
     Name: handleLastPage,
     Param:component, event, helper
     Return Type:null
     description: when last page is clicked
    **/
    handleLastPage: function(component, event, helper) {
        component.set('v.recordId',[]);
        var TotalPages = component.get("v.TotalPages");  
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber=TotalPages;
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
    /** 
     Name: handleChangeSorting,
     Param:component, event, helper
     Return Type:null
     description: when click on header for column sorting
    **/
    handleChangeSorting:function(component,event,helper){
        var selectedItem = event.currentTarget;
        var selectedField = selectedItem.dataset.tit;
        component.set("v.selectedSortingField", selectedField);
        var sortDirection=component.get("v.sortBy");
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        console.log(pageNumber);
        console.log(pageSize);
        if(sortDirection=='Asc'){
            sortDirection='Desc';
        }
        else{
            sortDirection='Asc';
        }
        component.set("v.sortBy",sortDirection);
        helper.getRecordsFromServer(component, pageNumber, pageSize);
    },
   
    selectDeselectAll: function(component, event, helper){
          var trueFalseCheck=event.getSource().get("v.value");
          console.log(trueFalseCheck);
          var sObjectRecords=component.get('v.sObjectList');
          sObjectRecords.forEach(element => {
            element.check=trueFalseCheck;
          });
          component.set('v.sObjectList',sObjectRecords);
        //   var conList=component.get("v.contactList");
        //   var pagnitaList=component.get("v.sObjectList");
        //   var conListUpd=[];
        //   var pagnitaListUpd=[];
        //   for(var i=0;i<conList.length;i++)
        //       {
        //           if(trueFalseCheck==true)
        //           {
        //               conList[i].check=true;
        //           }
        //           else
        //           {
        //               conList[i].check=false;
        //           }
        //           conListUpd.push(conList[i]);
        //       }
        //   component.set("v.contactList",conListUpd);
        //   for(var i=0;i<pagnitaList.length;i++)
        //       {
        //           if(trueFalseCheck==true)
        //           {
        //               pagnitaList[i].check=true;
        //           }
        //           else
        //           {
        //               pagnitaList[i].check=false;
        //           }
        //           pagnitaListUpd.push(pagnitaList[i]);
        //       }
        //        component.set("v.contactListPaginateWise",pagnitaListUpd);
     
      },
      handleChildCheckBox: function(component, event, helper){
        var trueFalseCheck=event.getSource().get("v.value");
        console.log(trueFalseCheck);
        var sObjectRecords=component.get('v.sObjectList');
        var temp=true;
        sObjectRecords.forEach(element => {
            if(element.check==false){
                temp=false;
            }
        });
        if(temp==false){
            component.set('v.recordsCheckBoxMaintain',false);
        }
        else{
            component.set('v.recordsCheckBoxMaintain',true);
        }
        component.set('v.sObjectList',sObjectRecords);
    }
})