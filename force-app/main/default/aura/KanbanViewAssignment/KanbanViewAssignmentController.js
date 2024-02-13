({
    /** 
     Name: init,
     Param:component, event, helper
     Return Type:null
     description: when component render this method initialize and get sObjects
    **/
    init : function(component, event, helper) {
        helper.getData(component,event,helper);
    },
    /** 
     Name: handleChange,
     Param:component, event, helper
     Return Type:null
     description: when object selected their corresponding fields get from Apex
    **/
    handleChange:function(component,event,helper){
        component.set('v.kanbanDataShow',false);

        component.set("v.selectedField", []);
        component.set("v.allField", []);
        component.set("v.requiredOptions",[]);
        var requiredOptions1 = ["Name","Id"];
        component.set("v.requiredOptions",requiredOptions1);
        helper.getAllPickListField(component, event, helper);
    }, 
    /** 
     Name: handleToGetPickListField,
     Param:component, event, helper
     Return Type:null
     description: getting only picklist field depending on the objects
    **/
    handleToGetPickListField: function (component, event, helper) {
        component.set("v.selectedFieldsValue",[]);
        component.set("v.requiredOptions",[]);
        component.set("v.requiredOptions",["Name"]);
        var selectedPickListField=component.get('v.selectedPickListField');
        var requiredOptions1= component.get("v.requiredOptions");
        requiredOptions1.push(selectedPickListField);
        component.set("v.requiredOptions",requiredOptions1);
        requiredOptions1= component.get("v.requiredOptions");
        helper.getAllFields(component, event, helper);
    },
    /** 
     Name: handleToChangeSelectedField,
     Param:component, event, helper
     Return Type:null
     description: when field selected to show table in this method getting api name
    **/
    handleToChangeSelectedField: function (component, event, helper) {
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
    processTable: function (component, event, helper) {
        component.set('v.totalCountValue',0);
        component.set('v.kanbanDataShow',true);
        helper.getAllPickListValues(component, event, helper);
       
    },
    /** 
     Name: allowDrop,
     Param:component, event, helper
     Return Type:null
     description: it prevent to drop to the valid drop target
    **/
    allowDrop: function(component, event, helper) {
        event.preventDefault();
    },
     /** 
     Name: drop,
     Param:component, event, helper
     Return Type:null
     description: drop the card at the target with the updated functionality
    **/
    drop: function (component, event, helper) {
        component.set('v.totalCountValue',0);
        event.preventDefault();
        var data = event.dataTransfer.getData("text");
        var tar = event.target;
        while(tar.tagName != 'ul' && tar.tagName != 'UL')
            tar = tar.parentElement;
        tar.appendChild(document.getElementById(data));
        component.set('v.pickVal',tar.getAttribute('data-Pick-Val'));
        document.getElementById(data).style.backgroundColor = "#ffb75d";
        helper.updatePickVal(component,data,component.get("v.selectedPickListField"),tar.getAttribute('data-Pick-Val'));
        // component.set('v.totalCountValue',0);
        helper.getAllPickListValues(component, event, helper);

    }
})