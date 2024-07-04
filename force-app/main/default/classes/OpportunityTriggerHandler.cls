public with sharing class OpportunityTriggerHandler {
    public static void doNotDeleteBankingWonOpps(List<Opportunity> listOfOpps) {
        List<Opportunity> oppsToSave = [SELECT Name, Id, Account.Id, Account.Industry, StageName FROM Opportunity WHERE Id IN :listOfOpps];
        for (Opportunity opp : oppsToSave) {
            if (opp.Account.Industry == 'Banking' && opp.StageName == 'Closed Won') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
    }
}
}
}