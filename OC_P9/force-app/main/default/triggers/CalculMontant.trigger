trigger CalculMontant on Order (before update) {
	
	/*if(Trigger.isBefore && Trigger.isUpdate){
		for(Order o: Trigger.New){
			o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
		}
	}*/
}