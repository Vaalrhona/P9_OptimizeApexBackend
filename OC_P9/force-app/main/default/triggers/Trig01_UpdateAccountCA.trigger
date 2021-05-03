trigger Trig01_UpdateAccountCA on Order (after update) {

    List<Account> accountsToUpdate = new List<Account>();
    Map<Id, Decimal> subAmount = new Map<Id, Decimal>();
    Map<Id, Decimal> addAmount = new Map<Id, Decimal>();

    for(Order o: Trigger.new){
        subAmount.put(o.AccountID,0.0);
        addAmount.put(o.AccountID,0.0);
        Order oldOrder = Trigger.oldMap.get(o.ID);
        Decimal previousSubAmount = subAmount.get(o.AccountID);
        subAmount.put(o.AccountID,previousSubAmount+o.TotalAmount);

        Decimal previousAddAmount = addAmount.get(o.AccountID);
        addAmount.put(o.AccountID,previousAddAmount+o.TotalAmount);
    }

    for(Account a: [SELECT ID, Chiffre_d_affaire__c, (SELECT ID FROM Orders WHERE ID IN: Trigger.new) FROM Account WHERE ID IN (SELECT AccountID FROM Order WHERE ID IN: Trigger.new)]){
        for(Order o: a.Orders){
            Decimal subAmount = (subAmount.get(a.ID)!=null)?subAmount.get(a.ID):0;
            Decimal addAmount = (addAmount.get(a.ID)!=null)?addAmount.get(a.ID):0;


            Decimal CA = (a.Chiffre_d_affaire__c!=null)?a.Chiffre_d_affaire__c:0;
            if(Trigger.isUpdate){
                a.Chiffre_d_affaire__c = (CA-subAmount>=0)?CA-subAmount:0;
            }
            a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + addAmount;
        }
        accountsToUpdate.add(a);
    }
    update accountsToUpdate;
}