public class ObjectFieldSelectionController {
    public String selectedObject { get; set; }
    public List<String> selectedFields { get; set; }
    public List<SelectOption> objectOptions { get; set; }
    public List<SelectOption> fieldOptions { get; set; }

    public ObjectFieldSelectionController() {
        loadObjects();
    }

    public void loadObjects() {
        objectOptions = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (String sObjectApiName : gd.keySet()) {
            objectOptions.add(new SelectOption(sObjectApiName, sObjectApiName));
        }
    }

    public void loadFields() {
        fieldOptions = new List<SelectOption>();
        if (selectedObject != null) {
            Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap();
            for (String fieldName : fields.keySet()) {
                fieldOptions.add(new SelectOption(fieldName, fieldName));
            }
        }
    }
}