trigger QuoteLineTrigger on SBQQ__QuoteLine__c (after update) {
    QuoteLineTriggerHandler handler = new QuoteLineTriggerHandler();

    // HANDOVER #1: 
    // We take the system variables and "throw" them into the handler's method.
    handler.handleAfterUpdate(Trigger.new, Trigger.oldMap); 
}