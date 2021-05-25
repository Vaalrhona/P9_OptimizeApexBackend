trigger Trig01_UpdateAccountCA on Order (after update) {

    if(Trigger.isAfter && Trigger.isUpdate){
        Handler01_AccountHandler.updateAccountCA(Trigger.new, Trigger.oldMap);
    }
}