public with sharing class WidgetRecordUpdateValueCmpController {
    @AuraEnabled(cacheable=true)
    public static Boolean isUserSystemAdminOrWidgetMaster() {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName == 'Widget Masters' || profileName== 'System Administrator'){
            return true;
        }
        return false;
    }

    @AuraEnabled
    public static void updateWidgetRecord(Id recordId, String value) {
        widget__c widget = new widget__c (Id = recordId, value__c = value );
        update widget;
    }
}