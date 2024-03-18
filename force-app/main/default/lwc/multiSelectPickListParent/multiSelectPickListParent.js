import { LightningElement, track, wire } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
// const options = [
//                     {'label':'India','value':'India'},
//                     {'label':'USA','value':'USA'},
//                     {'label':'China','value':'China'},
//                     {'label':'Rusia','value':'Rusia'}
//                 ];
 
export default class MultiSelectPickListParent extends LightningElement {
    @track selectedValue = '';//selected values
    @track selectedValueList = [];//selected values
    @track options; //= options;
    @track toggled=true;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;
 
    //fetch picklist options
    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: TYPE_FIELD
    })
    wirePickList({ error, data }) {
        if (data) {
            this.options = data.values;
        } else if (error) {
            console.log(error);
        }
    }
     
    //for single select picklist
    handleSelectOption(event){
        this.selectedValue = event.detail;
    }
 
    //for multiselect picklist
    handleSelectOptionList(event){
        this.selectedValueList = event.detail;
    }
    toggleChangeSignleToMulti(){
        this.toggled=!this.toggled;
    }
   
}