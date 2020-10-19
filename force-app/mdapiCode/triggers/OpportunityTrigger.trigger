trigger OpportunityTrigger on Opportunity (before insert, after update) {
	if(Trigger.isBefore && Trigger.isInsert ){
		OpportunityTriggerHandler.assignPriceBook(Trigger.new);
		OpportunityTriggerHandler.copyContactLeadSource(Trigger.newMap);
	}
}