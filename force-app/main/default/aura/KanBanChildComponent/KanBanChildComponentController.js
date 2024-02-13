({
    check : function(component, event, helper) {
        var selectFields=component.get('v.selectedFields');
            var pickValue = component.get('v.pickValue');
            var records = component.get('v.record');
            var apiFieldName=component.get('v.apiFieldName');
            var recordItem=records[apiFieldName];
            if(recordItem==pickValue){
                var map = component.get("v.totalRecordsPickValue");
                // console.log(map,'1');
                var count=component.get('v.totalCount');
                count++;
                component.set("v.totalCount", count);
                // console.log(component.get('v.totalCount'));

                // map['pickValue'] = pickValue;
                // map['totalCount'] = count++;
                // component.set("v.totalRecordsPickValue", map);
                // console.log(map,'2');
            }
            // console.log(recordItem,'3');
            // var count=component.get('v.totalRecordsPickValue');
            // count.push(recordItem,1);
            // console.log(count);
            component.set('v.fieldValue', recordItem);
        },
        doView: function(component, event, helper) {
            var editRecordEvent = $A.get("e.force:navigateToSObject");
            editRecordEvent.setParams({
                "recordId": event.target.id
            });
            editRecordEvent.fire();
        },
        
        drag: function (component, event, helper) {
            event.dataTransfer.setData("text", event.target.id);
        }
})