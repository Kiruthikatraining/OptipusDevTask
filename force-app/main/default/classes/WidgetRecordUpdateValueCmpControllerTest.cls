@isTest
public with sharing class WidgetRecordUpdateValueCmpControllerTest {
    @isTest
    static void userSystemAdmin(){
        User adminUser = createUser('System Administrator');

        System.runAs(adminUser){
            Boolean userProfileName = WidgetRecordUpdateValueCmpController.isUserSystemAdminOrWidgetMaster();
            System.assertEquals(true, userProfileName, 'Profile Name not correct');
        }
    }

    @isTest
    static void userNotSystemAdmin(){
        User standardUser = createUser('Standard User');

        System.runAs(standardUser){
            Boolean userProfileName = WidgetRecordUpdateValueCmpController.isUserSystemAdminOrWidgetMaster();

            System.assertEquals(false, userProfileName, 'Profile Name not correct');
        }
    }

    @isTest
    static void updateWidgetRecord(){
        Widget__c widget = new Widget__c();
        widget.Value__c = 'Testss ';
        insert widget;
        
        WidgetRecordUpdateValueCmpController.updateWidgetRecord(widget.Id, 'properly nested');

        List<Widget__c> widgets = [SELECT Id, Value__c FROM Widget__c];
        System.assertEquals('properly nested', widgets[0].value__c, 'Incorrect Value in Widget Record');
    }

    private static user createUser(String profileName){
        System.debug('In test calss '+profileName);
        Profile standardProfile = [SELECT Id, Name FROM Profile WHERE Name=: profileName];
        System.debug('In Test Class standardProfile '+standardProfile);
        User standardUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = standardProfile.Id, 
                                    TimeZoneSidKey='Europe/London', UserName='standardusertestqwe@testorg.com');
        insert standardUser;
        return standardUser;
    }
}