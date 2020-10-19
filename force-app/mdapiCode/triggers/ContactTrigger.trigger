trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isDelete || Trigger.isUndelete)){
        ContactTriggerHandler.updateNumberOfContacts(Trigger.New, Trigger.Old);
    }

    if(Trigger.isInsert && Trigger.isAfter){
        ContactTriggerHandler.PreventDuplicateContacts(Trigger.New);
    }    

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
    	ContactTriggerHandler.rollupLastNames(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isDelete){
    	ContactTriggerHandler.rollupLastNames(Trigger.old);
    }
}