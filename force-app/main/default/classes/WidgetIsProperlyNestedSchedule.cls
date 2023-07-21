public with sharing class WidgetIsProperlyNestedSchedule implements Schedulable {
    public void execute(SchedulableContext ctx) {
        WidgetIsProperlyNestedSendEmailBatch batch = new WidgetIsProperlyNestedSendEmailBatch();
        Database.executeBatch(batch);
    }
    // to start Schedule this class, run the following Script after deployment of Schedule and Bacth Class 
    // System.schedule('Nested_Properly_Hourly_Schedule', '0 0 * * * ?', new WidgetIsProperlyNestedSchedule());
}