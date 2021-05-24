@isTest
public with sharing class Test00_TestDataFactory {
    public static void createAccounts(Integer nbAccounts){
        List <Account> accns = new List<Account>();
        List <Order> orders = new List<Order>();
        List<OrderItem> items = new List<OrderItem>();

        for(integer i = 0; i<nbAccounts; i++){ //creating as much accs as possible
           Account a = new Account(Name='testAccount'+ i); 
           accns.add(a);
        }
        insert accns;
        //giving all of them one order
        for(Account a: accns){
            Order o = new Order(AccountId = a.Id, EffectiveDate=System.today(), Status='Ordered', Pricebook2Id=Test.getStandardPricebookId(),ShipmentCost__c=20);
            orders.add(o);
        }
        insert orders;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise', IsActive = true);
        Insert pd1;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        for(Order o: orders){
            OrderItem oi1 = new OrderItem (OrderId = o.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
            OrderItem oi2 = new OrderItem (OrderId = o.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
            items.add(oi1);
            items.add(oi2);
        }

        insert items;
    }
}
