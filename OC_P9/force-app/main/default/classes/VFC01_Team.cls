public without sharing class VFC01_Team {
    public decimal sumOrders{
        get{
			List<AggregateResult> groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
			return (decimal)groupedResults[0].get('total');         
        }
        set;
    }
}