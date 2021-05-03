trigger Trig02_UpdateOrderItem on OrderItem (after insert, after update) {

    List<Order> orders = [SELECT ID FROM Order WHERE ID IN (SELECT OrderID FROM OrderItem WHERE ID IN :Trigger.new)];
    update orders;
}