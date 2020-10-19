@isTest
public class CaseTriggerHandlerTest {
    
    @testSetup
    static void createTestData(){
    	Case c = new Case();
        c.status='New';
        c.Origin='Phone';
        insert c;
    }
    
    @isTest
    static void testStatusChange(){
        
        Case c = [Select id, status from Case LIMIT 1];
        string oldstatus = c.Status;
        c.Status='Working';
        update c;
        case updatedCase = [Select id, status, previous_status__c from case LIMIT 1];
        System.assertEquals(oldstatus, updatedCase.Previous_Status__c);
    }
	
    @isTest
    static void testNoStatusChange(){
        Case c = [Select id, status from Case LIMIT 1];
        string oldstatus = c.status;
        c.origin='Email';
        update c;
        case updatedCase = [Select id, status, previous_status__c from case LIMIT 1];
        System.assertNotEquals(oldstatus, updatedCase.Previous_Status__c);
        
    }
}