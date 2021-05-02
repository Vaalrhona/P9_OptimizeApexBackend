trigger UpdateOrderItem on OrderItem (after insert, after update) {

    List<Order> orders = [SELECT ID, (SELECT ID FROM OrderItems WHERE ID IN :Trigger.new) FROM Order];
    update orders;
}