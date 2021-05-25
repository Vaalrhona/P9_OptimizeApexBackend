trigger Trig01_UpdateAccountCA on Order (after update) {

    List<Account> accountsToUpdate = new List<Account>();
    Set<ID> ids = new Set<ID>();
    Map<Id, Decimal> subAmount = new Map<Id, Decimal>();
    Map<Id, Decimal> addAmount = new Map<Id, Decimal>();
    Map<ID, Decimal> amount = new Map<ID, Decimal>();

    for(Order o: Trigger.new){
        Decimal a = o.TotalAmount - Trigger.oldMap.get(o.ID).TotalAmount;
        amount.put(o.AccountID,a);
    }
    List<Account> accns = new List<Account>([SELECT ID, Chiffre_d_affaire__c FROM Account WHERE ID IN: ids]);

    for(Account a: accns){
        Decimal ca = a.Chiffre_d_affaire__c-amount.get(a.ID);
        a.Chiffre_d_affaire__c = (ca<0)?0:ca;
        accountsToUpdate.add(a);
    }
    update accountsToUpdate;
    update accountsToUpdate;
}