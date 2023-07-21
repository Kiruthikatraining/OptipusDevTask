@isTest
public with sharing class WidgetIsProperlyNestedSendEmailBatchTest {
    @isTest
    static void valueIsProperlyNested(){
        User standardUser = createUser();
        System.runAs(standardUser){
            List<Widget__c> widgets = insertBulkWidgets(200, true, standardUser);

            Test.startTest();
                WidgetIsProperlyNestedSendEmailBatch batch = new WidgetIsProperlyNestedSendEmailBatch();
                Database.executeBatch(batch, 200);
            Test.stopTest();

            List<Widget__c> widgetsList = [SELECT Id, Is_Properly_Nested__c FROM Widget__c WHERE Is_Properly_Nested__c = true];
            System.assertEquals(200,widgetsList.size(), 'Is Properly Nested CheckBox is wrong');
        }
    }

    @isTest
    static void valueIsProperlyNestedMixed(){
        User standardUser = createUser();
        System.runAs(standardUser){
            List<Widget__c> widgetsProperLyNested = insertBulkWidgets(100, true, standardUser);
            List<Widget__c> widgetsNotProperLyNested = insertBulkWidgets(100, false, standardUser);

            Test.startTest();
                WidgetIsProperlyNestedSendEmailBatch batch = new WidgetIsProperlyNestedSendEmailBatch();
                Database.executeBatch(batch, 200);
            Test.stopTest();

            List<Widget__c> widgetsListProperlyNested = [SELECT Id, Is_Properly_Nested__c FROM Widget__c WHERE Is_Properly_Nested__c = true];
            System.assertEquals(100,widgetsListProperlyNested.size(), 'Is Properly Nested CheckBox is wrong');
            List<Widget__c> widgetsListNotProperlyNested = [SELECT Id, Is_Properly_Nested__c FROM Widget__c WHERE Is_Properly_Nested__c = false];
            System.assertEquals(100,widgetsListNotProperlyNested.size(), 'Is Properly Nested CheckBox is wrong');
        }
        
    }

    @isTest
    static void valueIsProperlyNestedfalse(){
        User standardUser = createUser();
        System.runAs(standardUser){
            List<Widget__c> widgetsNotNested = insertBulkWidgets(200, false, standardUser);
    
            Test.startTest();
                WidgetIsProperlyNestedSendEmailBatch batch = new WidgetIsProperlyNestedSendEmailBatch();
                Database.executeBatch(batch, 200);
            Test.stopTest();
            List<Widget__c> widgetsListNotNested = [SELECT Id, Is_Properly_Nested__c FROM Widget__c WHERE Is_Properly_Nested__c = false];
            System.assertEquals(200,widgetsListNotNested.size(), 'Is Properly Nested CheckBox is wrong');
        }
    }  

    private static List<Widget__c> insertBulkWidgets(Integer noOfRecords, Boolean IsProperlyNested, User standardUser){
        List<Widget__c> widgetsToInsert = new List<Widget__c>();
        for(Integer i = 0 ; i < noOfRecords ;  i++ ){
            Widget__c widget = new Widget__c();
            widget.OwnerId = standardUser.Id;
            if(IsProperlyNested == true){
                widget.Value__c = 'properly nested';
            }else{
                widget.Value__c = 'Other Value';
            }
            
            widget.OwnerId = UserInfo.getUserId();
            widgetsToInsert.add(widget);
        }
        insert widgetsToInsert;
        return widgetsToInsert;    
    }

    private static user createUser(){
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User standardUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = standardProfile.Id, 
                                    TimeZoneSidKey='Europe/London', UserName='standardusertestqwe@testorg.com');
        insert standardUser;
        return standardUser;
    }
}