@isTest
private class testUpdateAccountCA {
    @isTest static void test() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise', IsActive = true);
        Insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Order o1 = new Order(AccountId = acc1.Id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id=Test.getStandardPricebookId(),ShipmentCost__c=20);
        insert o1;

        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2;

        Order oResult = [SELECT ID, TotalAmount FROM Order WHERE ID = :o1.ID];
        System.assertEquals(21500, oResult.TotalAmount);

        Account result = [SELECT ID,Chiffre_d_affaire__c FROM Account WHERE ID = :acc1.ID];
        System.assertEquals(21500, result.Chiffre_d_affaire__c);

        oi1.Quantity = oi1.Quantity*2;
        update oi1;
        oi2.Quantity = oi1.Quantity*2;
        update oi2;

        result = [SELECT ID,Chiffre_d_affaire__c FROM Account WHERE ID = :acc1.ID];
        System.assertEquals(43000, result.Chiffre_d_affaire__c);
    }
}
