public class AnnouncementQueueable implements Queueable {

    public List<ConnectApi.AnnouncementInput> inputs;

    public void execute(QueueableContext context) {
        PostAnnouncements(inputs);
    }

    public static void PostAnnouncements(List<ConnectApi.AnnouncementInput> announcements) {
        while (announcements.size() > 0) {
            if (Limits.getDmlStatements() < Limits.getLimitDmlStatements() && !Test.isRunningTest()) {
                ConnectApi.AnnouncementInput announcementInput = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', announcementInput);
            } else {
                break;
            }
        }

        if (announcements.size() > 0 && !Test.isRunningTest()) {
            AnnouncementQueueable announcementQueueable = new AnnouncementQueueable();
            announcementQueueable.inputs = announcements;

            System.enqueueJob(announcementQueueable);
        }
    }
}