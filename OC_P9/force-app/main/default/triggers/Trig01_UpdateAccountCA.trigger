trigger Trig01_UpdateAccountCA on Order (after update) {

    List<Account> accountsToUpdate = new List<Account>();
    Set<ID> ids = new Set<ID>();
    Map<Id, Decimal> subAmount = new Map<Id, Decimal>();
    Map<Id, Decimal> addAmount = new Map<Id, Decimal>();

    for(Order o: Trigger.new){
        subAmount.put(o.AccountID,0.0); //initializing at 0 to avoid nullreference exception below
        addAmount.put(o.AccountID,0.0);
        Order oldOrder = Trigger.oldMap.get(o.ID); //getting the previous values of the order in question
        Decimal previousSubAmount = subAmount.get(o.AccountID);
        subAmount.put(o.AccountID,previousSubAmount+o.TotalAmount); //amount to sub from the acc CA

        Decimal previousAddAmount = addAmount.get(o.AccountID);
        addAmount.put(o.AccountID,previousAddAmount+o.TotalAmount); //amount to add to the acc CA
        ids.add(o.AccountID);
    }

    Map<ID,Account> orders = new Map<ID,Account>([SELECT ID, Chiffre_d_affaire__c FROM Account WHERE ID IN: ids]);
    for(Account a: orders.values()){
        Decimal subAmount = (subAmount.get(a.ID)!=null)?subAmount.get(a.ID):0; //still handling the nullreference exception
        Decimal addAmount = (addAmount.get(a.ID)!=null)?addAmount.get(a.ID):0;
        Decimal CA = (a.Chiffre_d_affaire__c!=null)?a.Chiffre_d_affaire__c:0;
        a.Chiffre_d_affaire__c = (CA-subAmount>=0)?CA-subAmount:0; //handling negative values
        a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + addAmount;
        accountsToUpdate.add(a);
    }
    update accountsToUpdate;
}