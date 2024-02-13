trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
	List<Task> taskList=new list<Task>();
    for(Opportunity opp:Trigger.new){
        if(Trigger.isInsert){
            if(Opp.stagename=='Closed Won'){
                taskList.add(new Task(Subject='Follow Up Test Task',WhatId=opp.id));
            }
        }
        if(Trigger.isUpdate){
            if(opp.stagename=='Closed Won'&&Opp.StageName != Trigger.oldMap.get(opp.Id).StageName){
                 taskList.add(new Task(Subject='Follow Up Test Task',WhatId=opp.id));
            }
        }
    }
    if(taskList.size()>0){
        insert taskList;
    }
}