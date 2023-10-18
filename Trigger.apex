trigger RaceResultTrigger on Race_Result__c (Before insert,After insert, after update, before delete) {
    //1. Before insert trigger to save record with points in race_result object
    If((trigger.isBefore) && (trigger.isInsert)){
        RaceResultTriggerHandler.handlerBeforeInsert(trigger.new);
        
    }
        If((trigger.isAfter) && (trigger.isInsert)){
        RaceResultTriggerHandler.handlerAfterInsert(trigger.new);
    }
    if(trigger.isBefore && trigger.isDelete){
        RaceResultTriggerHandler.handlerBeforeDelete(trigger.old);
    }
}