@isTest
public with sharing class WidgetIsProperlyNestedScheduleTests {
    
    @isTest
    static void tesSchedule(){
        Test.startTest();
        String ScheduledJobID = System.schedule('Test_Nested_Properly_Hourly_Schedule', '0 0 * * * ?', new WidgetIsProperlyNestedSchedule());
        Test.stopTest();

        List<CronTrigger> cronJob =  [SELECT Id FROM CronTrigger where Id = :ScheduledJobID];
        System.assertEquals(1, cronJob.size(), 'Job Not Scheduled');
       }
}