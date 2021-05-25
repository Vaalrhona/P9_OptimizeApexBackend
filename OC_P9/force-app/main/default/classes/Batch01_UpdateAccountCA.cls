global class Batch01_UpdateAccountCA implements Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
       return Database.getQueryLocator('SELECT ID FROM Account WHERE ID IN (SELECT AccountID FROM Order WHERE Status = \'Ordered\')');

   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){
       Handler01_AccountHandler.batchUpdateAccount(scope);
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}