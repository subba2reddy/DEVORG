public class CaseTriggerHandler {
    public static void updateCasePreviousStatus(List<Case> newCaseList, Map<Id,Case> oldCaseMap){
        for(Case c: newCaseList){
            if(oldCaseMap.containsKey(c.Id) && c.Status!=oldCaseMap.get(c.id).status){
            	c.Previous_Status__c=oldCaseMap.get(c.Id).status;    
            }
        }
    }

// Merge conflict		
    // Example for nested for loops
    // One way this could have been done is to get a list of cases and list of contacts and loop through them to 
    // see if the emails match and update the contactid but that would be inefficient and could cause APEX CPU LIMIT 
    // EXCEEDED exception as it could consume a lot of CPU if the volumes are a little high. So we avoided nested for loops
    // by going for maps.
    public static void updateContact(List<Case> cases){
		System.debug('merge conflict local');
    	Set<String> contactEmails = new Set<String>();
    	for(Case c: cases){
    		contactEmails.add(c.contactEmail);
    	}

    	Map<String, Contact> contactMap = new Map<String, Contact>();
    	List<Contact> contactList = [Select id, email from contact where email in :contactEmails];

    	for(Contact con: contactList){
    		contactMap.put(con.email, con);
    	}

    	// Used SOQL in the for loop to identify only those cases for which the contact with matching email has been found ,
    	// so if there were any cases in the trigger.new that did not have a contact with matching email they will not be part of this loop
    	for(Case c: [Select id from Case where contactEmail in :contactMap.keySet()]){
    		if(c.contactEmail != null && contactMap.containsKey(c.contactEmail)){
    			c.Contactid = contactMap.get(c.contactEmail).id;	
    		}
    	}
    }
}
