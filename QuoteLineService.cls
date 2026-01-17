public class QuoteLineService {
   
   // method that takes in list of new quote lines and map of old quote lines
   public static void preventEditsOnOrderedLines(List<SBQQ__QuoteLine__c> newLines, Map<Id, SBQQ__QuoteLine__c> oldMap) {
        
        // --- STEP 1: 
        // Create a 'Set' as our data structure for storing Quote IDs.
        Set<Id> quoteIds = new Set<Id>();

        // Loop through the Quote Lines that are currently being saved.
        for (SBQQ__QuoteLine__c line : newLines) {
            // MAGIC ALERT: Even without a query, Salesforce gives us 'Lookup' fields.
            // These are like the shipping address on a box. We can see the Quote ID 
            // because it is stored directly on the Quote Line record in memory.
            if (line.SBQQ__Quote__c != null) {
                quoteIds.add(line.SBQQ__Quote__c);
            }
        }

        // Stop if quoteIds is empty
        if (quoteIds.isEmpty()) return;

        // SOQL query database for the Quote ID and Ordered status and store in a Map
        Map<Id, SBQQ__Quote__c> quoteMap = new Map<Id, SBQQ__Quote__c>(
            [SELECT Id, SBQQ__Ordered__c FROM SBQQ__Quote__c WHERE Id IN :quoteIds]
        );

        // We loop through the lines again to decide if they are allowed to be saved.
        for (SBQQ__QuoteLine__c newLine : newLines) {
            // We get the 'old' version of the record (from before the user typed anything).
            SBQQ__QuoteLine__c oldLine = oldMap.get(newLine.Id);
            
            // We pull the parent Quote out of our 'filing cabinet' (the Map) using its ID.
            SBQQ__Quote__c parentQuote = quoteMap.get(newLine.SBQQ__Quote__c);

            // If we found the Quote and it is already marked as 'Ordered'...
            for (SBQQ__QuoteLine__c newLine : newLines) {
    
    // Get the parent Quote from our map
    SBQQ__Quote__c parentQuote = quoteMap.get(newLine.SBQQ__Quote__c);
    SBQQ__QuoteLine__c oldLine = oldMap.get(newLine.Id);

    // GUARD CLAUSE: If we didn't find a parent quote, skip this iteration.
    // This prevents "Null Pointer Exceptions" if the map lookup fails.
    if (parentQuote == null) { 
        continue; 
    }

    // THE CLEAN CHECK:
    // 1. Is the Quote Ordered?
    // 2. AND did the price change?
    if (parentQuote.SBQQ__Ordered__c == true && 
        newLine.SBQQ__NetPrice__c != oldLine.SBQQ__NetPrice__c) {
        
        newLine.addError('You cannot change the price of a line that has already been Ordered.');
    }
            } 


            
