@isTest
private class Test01_UpdateAccountCA {

    @TestSetup
    static void makeData(){
        Test00_TestDataFactory.createAccounts(5);
    }
    @isTest static void test() {
        Test.startTest();
        List<OrderItem> items = [SELECT ID,Quantity,OrderID,Order.AccountID FROM OrderItem WHERE Order.Account.Name LIKE 'testAccount%'];
        Order oResult = [SELECT ID, TotalAmount, NetAmount__c FROM Order WHERE ID = :items[0].OrderID];
        System.assertEquals(21500, oResult.TotalAmount); //The total amount = o1 quantity * o1 price + o2 quantity * o2 price
        System.assertEquals(21480, oResult.NetAmount__c);//totalamount - shippingcost

        Account result = [SELECT ID,Chiffre_d_affaire__c FROM Account WHERE ID = :items[0].Order.AccountID];
        System.assertEquals(21500, result.Chiffre_d_affaire__c); //CA = order total amount (we only have one order here)

        items[0].Quantity = items[0].Quantity*2;
        items[1].Quantity = items[1].Quantity*2;
        update items;

        result = [SELECT ID,Chiffre_d_affaire__c FROM Account WHERE ID = :items[0].Order.AccountID]; //changing the order items total value to change the order total amount
        Test.stopTest();
        System.assertEquals(43000, result.Chiffre_d_affaire__c); //checking if CA is still equal to the order total amount
    }
}
