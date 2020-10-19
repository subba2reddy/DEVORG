trigger LeadTrigger on Lead (before insert, after delete, before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        LeadTriggerHandler.checkforDuplicateContact(Trigger.New);
    }
	
    if(Trigger.isBefore && Trigger.isUpdate){
    	LeadTriggerHandler.sendFarewellEmail(Trigger.oldMap);    
    }
    
    Map<Id, Lead> mergedLeads = new Map<Id, Lead>();
    if(Trigger.isAfter && Trigger.isDelete){
    	for(Lead l: Trigger.old){
    		if(l.masterRecordId != null){
    			mergedLeads.put(l.masterRecordid, l);
    		}
    	}

    	if(mergedLeads.size()>0){
    		LeadTriggerHandler.mergeLeads(mergedLeads);
    	}
    }
}