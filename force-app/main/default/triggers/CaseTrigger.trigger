trigger CaseTrigger on Case (before update) {
    if(trigger.isUpdate && trigger.isBefore){
     	caseTriggerHandler.updateCasePreviousStatus(Trigger.New, Trigger.OldMap);   
     	caseTriggerHandler.updateContact(Trigger.New);
    }
}