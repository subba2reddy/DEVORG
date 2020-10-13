/* Author: Subba Reddy */
public class AccountTriggerHandler 
{
    // Constructor
    public static void hasOpportunities(Map<Id, Account> AccountMap){
        System.debug('In constructor');
        for(Account a: [Select id,(select id from opportunities) from Account where id in :AccountMap.Keyset()] ){
            if(a.opportunities.size()>0){
                a.addError('Account cannot be delete as it has Opportunies associated');
            }   
        }
    }
    
    /**
     *   Enum representing each of before/after CRUD events on Sobjects
     */
    public enum Evt 
    {
        afterdelete, afterinsert, afterundelete,
        afterupdate, beforedelete, beforeinsert, beforeupdate   
    }

    /*
     *   Simplistic handler to implement on any of the event. It doesn't require or enforces any pattern except the
     *   method name to be "handle()".
     */
    public interface HandlerInterface
    {
        void handle();          
    } 

    // Internal mapping of handlers
    Map<String, List<HandlerInterface>> eventHandlerMapping = new Map<String, List<HandlerInterface>>();

    /**
     *   Core API to bind handlers with events
     */
    public AccountTriggerHandler bind(Evt event, HandlerInterface eh)
    {
        List<HandlerInterface> handlers = eventHandlerMapping.get(event.name());
        if (handlers == null) 
        {
            handlers = new List<HandlerInterface>();
            eventHandlerMapping.put(event.name(), handlers);
        }
        handlers.add(eh);
        return this;
    }

    /**
     *   Invokes correct handlers as per the context of Trigger and available registered handlers
     */
    public void manage()
    {
        Evt ev = null;
        if(Trigger.isInsert && Trigger.isBefore)
        {
            ev = Evt.beforeinsert;
        }
        else if(Trigger.isInsert && Trigger.isAfter)
        {
            ev = Evt.afterinsert;
        }
        else if(Trigger.isUpdate && Trigger.isBefore)
        {
            ev = Evt.beforeupdate;
        }
        else if(Trigger.isUpdate && Trigger.isAfter)
        {
            ev = Evt.afterupdate;
        }
        else if(Trigger.isDelete && Trigger.isBefore)
        {
            ev = Evt.beforedelete;
        }
        else if(Trigger.isDelete && Trigger.isAfter)
        {
            ev = Evt.afterdelete;
        }
        else if(Trigger.isundelete)
        {
            ev = Evt.afterundelete;             
        }
        
        List<HandlerInterface> handlers = eventHandlerMapping.get(ev.name());
        
        if (handlers != null && ! handlers.isEmpty()) 
        {
            for (HandlerInterface h : handlers) 
            {
                h.handle();
            }
        }
    }
    
    public static void CloneAccountsContactsCases(Map<id, Account> accMap){
        List<Account> newAccounts = new List<Account>();
        List<Contact> newContacts = new List<Contact>();
        List<Case> newCases = new List<Case>();
        
        for(Account a: accMap.values()){
        	Account newAccount = a.clone();
            newAccounts.add(newAccount);
        }
        
        if(newAccounts.size()>0){
        	insert newAccounts;    
        }
    }
}
