global class Batch01AccountChiffreAffaire implements Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT AccountID FROM Order WHERE Status = \'Ordered\' GROUP BY AccountID');

   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){
       List<Account> accountsToUpdate = new List<Account>();      
       
       for(Account a: [SELECT ID, Chiffre_d_affaire__c, (SELECT ID, TotalAmount FROM Orders) FROM Account WHERE ID IN :scope]){
           a.Chiffre_d_affaire__c = 0;
           for(Order o: a.Orders){
               a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + o.TotalAmount;
           }
           accountsToUpdate.add(a);
       }
       
       update scope;
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}