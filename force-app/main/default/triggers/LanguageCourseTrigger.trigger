trigger LanguageCourseTrigger on Language_Course__c (after insert, after update, after delete) {
    CustomNotificationType notificationType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName='Course_Added_or_Updated'];

    Messaging.CustomNotification n = new Messaging.CustomNotification();
    n.setTitle('Language Course added or updated');
    n.setNotificationTypeId(notificationType.Id);

    List<User> results = [SELECT Id FROM User WHERE ProfileId = '00e2w000003cyxh'];
    Set<String> targets = new Set<String>();
    for (User u : results) {
        targets.add(u.Id); 
    }

    for (Language_Course__c lc : Trigger.new) {
        n.setTargetId(lc.Id);
        n.setBody('Course name is ' + lc.name);
        try {
            n.send(targets);
        } catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
    
    
    

    
}