global class Batch01_UpdateAccountCA implements Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT ID FROM Account WHERE ID IN (SELECT AccountID FROM Order WHERE Status = \'Ordered\')');

   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){
       List<Account> accountsToUpdate = new List<Account>();
       Map<ID,AggregateResult> sumOfTotalAmount = new Map<ID,AggregateResult>([SELECT AccountID, SUM(TotalAmount) total FROM Order WHERE AccountID IN :scope GROUP BY AccountID]);
       //for each account in the scope, we get the orders associated if there's some
       for(Account a: scope){
           Decimal amount = (Decimal)sumOfTotalAmount.get(a.ID).get('total');
           a.Chiffre_d_affaire__c = (a.Chiffre_d_affaire__c!=null)?a.Chiffre_d_affaire__c:0;
           a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + amount;
           accountsToUpdate.add(a);
       }
       
       update scope;
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}