public class WidgetIsProperlyNestedSendEmailBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Value__c, Is_Properly_Nested__c, OwnerId, Owner.Email FROM Widget__c';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Widget__c> scope){
        List<Widget__c> widgetsToUpdate = new List<Widget__c>();
        List<Messaging.SingleEmailMessage> emails = new  List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [SELECT Id, Name FROM EmailTemplate where DeveloperName = 'Widget_is_not_properly_nested'];

        for(Widget__c widget : scope){
            System.debug('widget.Owner.Email '+widget.Owner.Email);
            System.debug('widget.OwnerId '+widget.OwnerId);
            if(widget.Value__c == 'properly nested'){
                widget.Is_Properly_Nested__c = true;
                widgetsToUpdate.add(widget);
            }else{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(widget.OwnerId);
                mail.setTemplateId(template.Id);
                mail.setToAddresses(new List<String>{widget.Owner.Email});
                mail.setSaveAsActivity(false);
                emails.add(mail);
            }
        }
        
        if(widgetsToUpdate != null && widgetsToUpdate.size() > 0){
            update widgetsToUpdate;
        }

        if(emails != null && emails.size() > 0){
           Messaging.sendEmail(emails);
        }
    }
    
    public void finish(Database.BatchableContext bc){
        
    }  
}