public class ContactTriggerHandler {
    public static void updateNumberOfContacts(List<Contact> NewList, List<Contact> OldList){
        List<Account> accountsToUpdate = new List<Account>();
        Set<Id> accountIds = new Set<Id>(); 
        if(Trigger.isinsert || trigger.isUndelete){
            for(Contact c: NewList){
                accountIds.add(c.AccountId);
            }    
        }else if(Trigger.isDelete){
            for(Contact c: OldList){
                accountIds.add(c.AccountId);
            }    	        
        }
        
        for(Account a: [Select id,(select id from contacts) from Account where id in :accountIds]){
            a.Number_of_Contacts__c=a.contacts.size();
            accountsToUpdate.add(a);
            if((Trigger.isInsert || Trigger.isUndelete) && a.contacts.size()>10){
                NewList[0].addError('Account cannot have more than 10 contacts');
            }
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
        
    }
    
    
    public static void preventDuplicateContacts(List<Contact> newList){
        Map<Id, Contact> contactMap = new Map<Id,Contact>([Select id, email, mobilephone from Contact LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
        
        for(Contact c:newList){
            if(contactMap.containsKey(c.id) && c.email == contactMap.get(c.Id).email && c.MobilePhone == contactMap.get(c.Id).MobilePhone){
                c.addError('Duplicate Contact exists');
            }
        }
    }

    public static void rollupLastNames(List<Contact> newContacts){

        Set<Id> accountIds = new Set<Id>(); 
        for(Contact c: newContacts){
            accountIds.add(c.accountId);
        }

        List<Account> accounts =  [Select id, name, contactLastNames__c,(select lastName from Contacts) from Account where id in :accountIds];

/*      This can also be done using map of lists
        Map<Id, List<Contact>> accountContacts = new Map<Id, List<Contact>>();
        for(Account a: accounts){
            accountContacts.put(a.id, a.contacts);
        }
*/
        for(Account a: accounts){
            for(Contact c: a.contacts){
                a.contactLastNames__c=a.contactLastNames__c+c.lastName;
            }
        }

        if(!accounts.isEmpty()){
            update accounts;    
        }
        
    }
}