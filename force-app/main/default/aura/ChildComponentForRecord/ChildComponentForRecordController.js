({
    check : function(component, event, helper) {
            var fieldName = component.get('v.fieldName');
            var records = component.get('v.record');
            var recordItem=records[fieldName];
            component.set('v.fieldValue', recordItem);

        }
})