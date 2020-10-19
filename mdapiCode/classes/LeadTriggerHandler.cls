public class LeadTriggerHandler {
    public static void checkforDuplicateContact(List<Lead> newList){
        Set<String> Leademails = new Set<String>();
        for(Lead l: newList){
            Leademails.add(l.email);
        }
        
        List<Contact> contactList = [Select id, email from Contact where email in :Leademails];
        
        Map<String, contact> contactMap = new Map<String, contact>(); 
        
        for(Contact c: contactList){
            contactMap.put(c.email, c);
        }
        
        for(Lead l: newList){
            if(contactMap.containsKey(l.email)){
                l.addError('There is a contact with the same email address');
            }
        }
    }

    public static void mergeLeads(Map<Id, Lead> leads){

        List<Lead> newLeads = [Select id, leadSource from Lead where id in :leads.keyset()];
        List<Lead> updatedLeads = new List<Lead>();

        for(Lead l: [Select id, leadSource from Lead where id in :leads.keyset()]){
            if(leads.containsKey(l.id)){
                l.leadSource=leads.get(l.id).leadSource;
                updatedLeads.add(l);                 
            }           
        }

        if(!updatedLeads.isEmpty()){
            update updatedLeads;
        }
    }
    
    public static void sendFarewellEmail(Map<Id, Lead> leadMap){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Lead l: leadMap.values()){
            if(l.rating=='Cold' && leadMap.get(l.id).rating != l.Rating){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> emails = new List<String>{'subba2reddy@gmail.com','vsubbareddy81@gmail.com'};
                mail.setToAddresses(emails);
                mail.setSubject('Farewell');
                mail.setReplyTo('subba2reddy@gmail.com');
                mail.setHtmlBody('Farewell buddy');
                mail.setSenderDisplayName('subba reddy');
                mails.add(mail);
            }
        }
        if(mails.size()>0){
        	Messaging.sendEmail(mails);    
        }
    }
}