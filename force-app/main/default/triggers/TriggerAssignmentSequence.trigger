/*
Name:TriggerAssignmentSequence
Description:In this trigger implementing CRUD operation on contact object with sequence number field.

*/
trigger TriggerAssignmentSequence on Contact (before insert,before update,after delete,after undelete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        TriggerAssignmentSequenceNumber.handleBeforeInsert(Trigger.new);
    }
    if(TriggerAssignmentSequenceNumber.runOnce) {
        if(Trigger.isBefore && Trigger.isUpdate) {
            TriggerAssignmentSequenceNumber.handleBeforeUpdate(Trigger.newMap,Trigger.oldMap);
        }
    }
    if(Trigger.isAfter && Trigger.isDelete) {
        TriggerAssignmentSequenceNumber.handleAfterDelete(Trigger.old);
    }
    if(Trigger.isAfter && Trigger.isUndelete) {
        TriggerAssignmentSequenceNumber.handleAfterUndelete(Trigger.new);
    }
}