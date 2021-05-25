@isTest
public with sharing class Test02_BatchAccountCA {

    @TestSetup
    static void makeData(){
        Test00_TestDataFactory.createAccounts(900);
    }
    
    @isTest
    public static void test(){
        Test.startTest();
        List<Account> accns = new List<Account>([SELECT ID FROM Account WHERE Name LIKE 'testAccount%']);
        Batch01_AccountChiffreAffaire batch = new Batch01_AccountChiffreAffaire();
        Database.QueryLocator ql = batch.start(null);
        batch.execute(null, accns);
        batch.finish(null);
        List<Account> result = [SELECT ID, Chiffre_d_affaire__c FROM Account WHERE ID IN (SELECT AccountID FROM Order WHERE Status = 'Ordered')];
        Test.stopTest();

        for(Account a: result){ //making sure that all accounts have an updated CA
            System.assertEquals(21500, a.Chiffre_d_affaire__c);
        }
    }
}
