trigger AccountTrigger on Account (before delete) {

    // Test comments
    // More test comments
    
    if(Trigger.isBefore && Trigger.isDelete){
        AccountTriggerHandler.hasOpportunities(Trigger.OldMap);
    }
    }