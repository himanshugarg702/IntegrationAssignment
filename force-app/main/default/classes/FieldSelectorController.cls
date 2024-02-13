public class FieldSelectorController {

    // Lists for available and selected objects and fields
    public List<SelectOption> availableObjects { get; set; }
    public List<String> selectedObjects { get; set; }
    public List<SelectOption> availableFields { get; set; }
    public List<String> selectedFields { get; set; }

    public FieldSelectorController() {
        // Initialize available objects list
        availableObjects = new List<SelectOption>();
         for(SObjectType sType: Schema.getGlobalDescribe().values()) {
                DescribeSObjectResult res = sType.getDescribe();
                 if (res.isQueryable() && res.isUpdateable()) 
                    availableObjects.add(new SelectOption(res.getName(), res.getLabel()));
            }
       
          
        selectedObjects = new List<String>();
        availableFields = new List<SelectOption>();
        selectedFields = new List<String>();
    }

   /* public void onObjectSelect(String selectedObject) {
        selectedObjects.add(selectedObject);
       
        availableObjects.removeIf(obj -> obj.getValue() == selectedObject);
        availableFields = refreshFieldList(selectedObject);
    }*/

    public void onFieldSelect(String selectedField, boolean add) {
     /*   if (add) {
            selectedFields.add(selectedField);
            availableFields.removeIf(field -> field.getValue() == selectedField);
        } else {
            selectedFields.remove(selectedField);
            availableFields.add(new SelectOption(selectedField, selectedField));
        }*/
    }

    public void onRemoveAllFields() {
        selectedObjects.clear();
      /*  availableObjects.addAll(selectedObjects);*/
        selectedFields.clear();
        availableFields = new List<SelectOption>();
    }

    private List<SelectOption> refreshFieldList(String selectedObject) {
        List<SelectOption> options = new List<SelectOption>();
    /*    for (Schema.DescribeFieldResult field : Schema.describeSObject(selectedObject).fields().values()) {
            if (field.isUpdateable()) {
                options.add(new SelectOption(field.getName(), field.getLabel()));
            }
        }*/
        return options;
    }
}