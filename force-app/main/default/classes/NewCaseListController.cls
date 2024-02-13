public class NewCaseListController {
    private  String status='New';
    public list<Case> getNewCases(){
        System.debug('Select Id, CaseNumber From Case Where Status =:status');
        list<Case> caseList=Database.query('Select Id, CaseNumber From Case Where Status =: status');
        System.debug(caseList);
        return caseList;
    }
}