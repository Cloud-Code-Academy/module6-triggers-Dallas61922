/* Opportunity trigger should do the following:
* 1. Validate that the amount is greater than 5000.
* 2. Prevent the deletion of a closed won opportunity for a banking account.
* 3. Set the primary contact on the opportunity to the contact with the title of CEO.*/


trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after update){
    If(Trigger.isBefore && Trigger.isUpdate){
        For(Opportunity opp : Trigger.new){
            System.debug('For before and update opp is ' + opp);
            If (opp.amount < 5000){
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
        Map<Id, Contact> contactsByAcct = new Map<Id, Contact>();
        Map<Id, Contact> ceoContactsById = new Map<Id, Contact>([SELECT Id, AccountId, Name FROM Contact WHERE Title LIKE '%CEO%']);
        For(Id contact : ceoContactsById.keyset()){ 
            Id accountId = ceoContactsById.get(contact).AccountId; 
            contactsByAcct.put(accountId, ceoContactsById.get(contact));
        }
        For(Opportunity opp : trigger.new){
            Id accountId = opp.AccountId;
            For(Id acc : contactsByAcct.keySet()){
                If (accountId == acc){
                opp.primary_contact__c = contactsByAcct.get(acc).Id;
                }
            }
        }   
    }

    If(Trigger.isDelete && Trigger.isBefore){
        Map<Id, Account> accountsByOppId = new Map<Id, Account>();
        Map<Id, Opportunity> oppsById = new Map<Id, Opportunity>([SELECT Id, Name, AccountId FROM Opportunity WHERE Id IN :trigger.old]);
        Set<Id> accountId = new Set<Id>();
        For (Opportunity opp : trigger.old){
            accountId.add(opp.AccountId);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, Industry FROM Account WHERE Id IN :accountID and Industry = 'Banking']);

        For (Id opId : oppsById.keyset()){
            Id acctId = oppsById.get(opId).AccountId;
            accountsByOppId.put(opId, accountMap.get(acctId));
        }
        For (Opportunity oppDelete : trigger.old){
            Id oppKey = oppDelete.Id;
            If (accountsByOppId.containsKey(oppkey) && oppDelete.StageName == 'Closed Won'){
                oppDelete.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
}
    


