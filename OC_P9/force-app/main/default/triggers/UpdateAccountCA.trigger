trigger UpdateAccountCA on Order (after update) {

    List<Account> accountsToUpdate = new List<Account>();
    Map<Id, Decimal> subAmount = new Map<Id, Decimal>();
    Map<Id, Decimal> addAmount = new Map<Id, Decimal>();
    List<Order> orders = new List<Order>();

    for(Order o: Trigger.new){
        Order oldOrder = Trigger.oldMap.get(o.ID);
        if(o.TotalAmount<>oldOrder.TotalAmount){
            orders.add(o);
            if(subAmount.containsKey(o.AccountID)){
                Decimal previousAmount = subAmount.get(o.AccountID);
                subAmount.put(o.AccountID,previousAmount+o.TotalAmount);
            }
            else{
                subAmount.put(o.AccountID, oldOrder.TotalAmount);
            }
            if(addAmount.containsKey(o.AccountID)){
                Decimal previousAmount = addAmount.get(o.AccountID);
                addAmount.put(o.AccountID,previousAmount+o.TotalAmount);
            }
            else{
                addAmount.put(o.AccountID, o.TotalAmount);
            }
        }
    }

    for(Account a: [SELECT ID, Chiffre_d_affaire__c, (SELECT ID FROM Orders WHERE ID IN: orders) FROM Account]){
        for(Order o: a.Orders){
            Decimal subAmount = subAmount.get(a.ID);
            Decimal addAmount = addAmount.get(a.ID);
            a.Chiffre_d_affaire__c = (a.Chiffre_d_affaire__c-subAmount>0)?a.Chiffre_d_affaire__c-subAmount:0;
            a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + addAmount;
            //a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + o.TotalAmount;
        }
        accountsToUpdate.add(a);
    }
    update accountsToUpdate;
}

