public with sharing class OpportunityTriggerHandler {
	private static final String BULK_PRICEBOOK = 'Bulk Price Book';
	private static final String BULK_RECORDTYPE = 'Bulk Record Type';

	public OpportunityTriggerHandler() {
		
	}

	public static void assignPriceBook(List<Opportunity> opps){

		Id bulkRecordTypeId = [Select id from RecordType where name=:BULK_RECORDTYPE and sObjectType='Opportunity' LIMIT 1].id;
		Pricebook2 priceBook = [Select id from Pricebook2 where name = :BULK_PRICEBOOK LIMIT 1];

		for(Opportunity o: opps){
			if(o.RecordTypeId == bulkRecordTypeId){
				o.Pricebook2Id = priceBook.Id;
			}
		}

	}

	// can be improved, may be even wrong, not tested
	public static void copyContactLeadSource(Map<id, Opportunity> opps){


		for(Opportunity o: [Select id, leadSource, (Select id, contact.leadSource from OpportunityContactRoles where isPrimary=TRUE) from Opportunity where id in :opps.keySet()]){
			if(!o.OpportunityContactRoles.isEmpty()){
				o.leadSource=o.OpportunityContactRoles[0].contact.leadSource;
			}
		}

	}
	
    public static void updateTotalAmount(List<Opportunity> opps){
        
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity o: opps){
            accountIds.add(o.AccountId);
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        Map<id, account> accountmap = new Map<id, account>([Select id, Total_Amount__c from Account where id in :accountIds]);
        for(AggregateResult ar: [Select SUM(Amount),accountId from Opportunity where accountId in :accountIds group by accountid]){
            if(accountMap.containsKey((id) ar.get('accountId'))){
	            Account a = accountMap.get((id) ar.get('accountId'));
	            a.Total_Amount__c=(Double) ar.get('expr0');
    	        accountsToUpdate.add(a);
            }
        }
        
        if(accountsToUpdate.size()>0){
            update accountsToUpdate;
        }
    } 
}