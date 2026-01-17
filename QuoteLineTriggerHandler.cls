public class QuoteLineTriggerHandler {
    // The "catchers": newLines and oldMap
    public void handleAfterUpdate(List<SBQQ__QuoteLine__c> newLines, Map<Id, SBQQ__QuoteLine__c> oldMap) {
        
        // HANDOVER #2:
        // The handler doesn't do the work; it "tosses" the data one last time to the Service.
        QuoteLineService.preventEditsOnOrderedLines(newLines, oldMap);
    }
}