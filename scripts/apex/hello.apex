// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

public with sharing class OpportunityTriggerHandler {
    public void doNotDeleteBankingWonOpps(List<Opportunity> listOfOpps) {
        List<Opportunity> oppsToSave = [SELECT Name, Id, Account.Id, Account.Industry, StageName FROM Opportunity WHERE Id IN :listOfOpps];
        For (Opportunity opp : oppsToSave){
            System.debug(' 1 opp is '+ opp);
            If (opp.Account.Industry == 'Banking'){
                System.debug(' 2 opp is '+ opp);
                If(opp.StageName == 'Closed Won'){
                    System.debug(' 3 opp is ' + opp);
                System.debug('Do not delete this opp since industry is ' + opp.Account.Industry);
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
    }
}
}
}