public with sharing class cloneAccountContactsCases {
	public cloneAccountContactsCases() {
			
	}

	public static void cloneObjects(Account acc){
		Account newAccount = acc.clone();
		List<Contact> newContacts = new List<Contact> ();
		List<Case> newCases = new List<Case>();

		Map<Id, Contact> oldContacts = new Map<Id, Contact>([Select id, name from Contact where AccountId = :acc.Id]);
		for(Contact c: oldContacts.values()){
			Contact newcontact = c.clone();
			newContacts.add(newcontact);
		}


		List<Case> oldCases = [Select id from Case where contactId in :oldContacts.keyset()];
		
	}
}