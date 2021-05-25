public with sharing class Handler01_AccountHandler {

    public static void batchUpdateAccount(List<Account> scope){
        List<Account> accountsToUpdate = new List<Account>();
       Map<ID,AggregateResult> sumOfTotalAmount = new Map<ID,AggregateResult>([SELECT AccountID, SUM(TotalAmount) total FROM Order WHERE AccountID IN :scope GROUP BY AccountID]);
       //for each account in the scope, we get the orders associated if there's some
       for(Account a: scope){
           Decimal amount = (Decimal)sumOfTotalAmount.get(a.ID).get('total');
           a.Chiffre_d_affaire__c = (a.Chiffre_d_affaire__c!=null)?a.Chiffre_d_affaire__c:0;
           a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + amount;
           accountsToUpdate.add(a);
       }
       
       update scope;
    }

    public static void updateAccountCA(List<Order> orders, Map<Id, sObject> oldMap){
        List<Account> accountsToUpdate = new List<Account>();
        Set<ID> ids = new Set<ID>();
        Map<Id, Decimal> subAmount = new Map<Id, Decimal>();
        Map<Id, Decimal> addAmount = new Map<Id, Decimal>();
        Map<ID, Decimal> amount = new Map<ID, Decimal>();
    
        for(Order o: orders){
            Decimal a = o.TotalAmount - (Decimal)oldMap.get(o.ID).get('TotalAmount');
            amount.put(o.AccountID,a);
        }
        List<Account> accns = new List<Account>([SELECT ID, Chiffre_d_affaire__c FROM Account WHERE ID IN: ids]);
    
        for(Account a: accns){
            Decimal ca = a.Chiffre_d_affaire__c-amount.get(a.ID);
            a.Chiffre_d_affaire__c = (ca<0)?0:ca;
            accountsToUpdate.add(a);
        }
        update accountsToUpdate;
    }
}