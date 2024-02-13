public class PaginationController {
    public ApexPages.StandardSetController standardController { get; set; }

    public PaginationController() {
        standardController = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name FROM Account]));
        standardController.setPageSize(10);
    }

    public List<Account> getRecords() {
        return (List<Account>) standardController.getRecords();
    }

    public Boolean hasNext {
        get { return standardController.getHasNext(); }
    }

    public Boolean hasPrevious {
        get { return standardController.getHasPrevious(); }
    }

    public void next() {
        standardController.next();
    }

    public void previous() {
        standardController.previous();
    }
}