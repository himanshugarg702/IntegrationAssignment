import { LightningElement,track } from 'lwc';
import allObject from "@salesforce/apex/clientSidePagination.allObject";
import allFields from "@salesforce/apex/clientSidePagination.allFields";
import getRecords from "@salesforce/apex/clientSidePagination.getRecords";
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class ClientSidePagination extends LightningElement {
    @track listOfObject=[];
    @track listOfFields=[];
    @track selectedFields=[];
    @track listOfRecords=[]; 
    @track records=[];  
    @track columnTable=[];
    TotalListOfButtons=[];
    listOfButtonsToShow=[];
    @track selectedObject='--None--';
    @track pageSize='5';
    searchKey='';
    resetButton=true;
    showTable=false;
    showFields=false;
    showSpinner=false;
    totalRecords=0;
    pageNumber=1;
    totalPages=0;
    nextPageAndLast=false;
    firstPageAndPrev=true;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

     /** 
     Name: options,
     Param:null
     Return Type:null
     description: showing dropdowwn to change page size for record
    **/
    get options() {
        return [
            { 'label': '5',  'value': '5'  },
            { 'label': '10', 'value': '10' },
            { 'label': '15', 'value': '15' },
            { 'label': '20', 'value': '20' },
            { 'label': '50', 'value': '50' },
        ];
    }
    /** 
     Name: constructor,
     Param:null
     Return Type:null
     description: getting objects list from apex 
    **/
    constructor(){
        super();
        this.handleSpinner();
        allObject()
        .then((res) => {
            if(res!=null){
                this.listOfObject.push({label:'--None--',value:'--None--'});
                for(let key in res)  {
                    if(key!=null)
                    this.listOfObject.push({label:res[key],value:key});
                }
                this.ShowToast('Success!', 'objects list fetched', 'success', 'dismissable');
            }
        })
        .catch((error) => {
            this.ShowToast('Error!!', error.body.message, 'error', 'dismissable');
        });
    }
    /** 
     Name: reset,
     Param:null
     Return Type:null
     description: when click on reset all functionality should change
    **/
    reset(){
        this.resetButton=true;
        this.showTable=false;
        this.showFields=false;
        this.selectedObject='--None--';
       
    }
    /** 
     Name: handleChange,
     Param:event
     Return Type:null
     description: when object is selected the methods gets the field
    **/
    handleChange(event) {
        this.searchKey='';
        this.pageSize='5';
        this.firstPageAndPrev=true;
        this.showTable=false;
        this.listOfFields=[];
        this.resetButton=false;
        this.selectedObject = event.detail.value;
        if(this.selectedObject==='--None--'){
            this.resetButton=true;
            this.showTable=false;
            this.showFields=false;
        }
        else{
            if(this.selectedObject!=null){
                allFields({selectedObject:this.selectedObject})
                .then((res) => {
                    if(res!=null){
                        for(let key in res)  {
                            if(key!=null)
                            this.listOfFields.push({label:res[key],value:key});
                        }
                        this.showFields=true;
                        this.ShowToast('Success!', 'fields fetched', 'success', 'dismissable');
                    }
                })
                .catch((error) => {
                    this.ShowToast('Error!!', error.body.message, 'error', 'dismissable');
                });
            }
        }
    }
     /** 
     Name: handleChangeSelectedFields,
     Param:event
     Return Type:null
     description: selected field to show records
    **/
    handleChangeSelectedFields(event){
        const selectedOptionsList = event.detail.value;
        this.columnTable=selectedOptionsList;
    }
    /** 
     Name: processGetRecords,
     Param:null
     Return Type:null
     description: when click on process show data 
    **/
    processGetRecords(){
        this.listOfButtons=[];
        this.showTable=true;
        this.records=[];
        let selectedValues=this.columnTable;
        let label=this.listOfFields
                    .filter(option=> selectedValues.indexOf(option.value)>-1)
                    .map(option=>option.label);
        let fields=[];
        for(let i=0;i<label.length;i++){
            fields.push({ 
                            'label':label[i],
                            'fieldName':selectedValues[i],
                            type: 'String',
                            sortable:true
                        });
        }        
    this.selectedFields=fields;
        if(this.selectedFields!=null) {
            getRecords({selectedObject:this.selectedObject,selectedField:this.columnTable})
            .then((res) => {
                this.totalRecords=res.length;
                if(res!=null) {
                    this.listOfRecords=res;
                    this.totalPages=Math.ceil( this.listOfRecords.length/this.pageSize);
                    for(let i=0;i<this.totalPages;i++){
                        this.TotalListOfButtons.push(i+1);
                    }
                    this.handleDisplyButtons();
                    console.log(this.listOfButtons);
                    this.records=this.listOfRecords.slice(0,parseInt(this.pageSize,Number));
                    if(this.totalPages===1){
                        this.nextPageAndLast=true;
                    }
                }
            })
            .catch((error) => {
                this.ShowToast('Error!!', error.body.message, 'error', 'dismissable');
            });
        }
    }
    /** 
     Name: changePageSize,
     Param:null
     Return Type:null
     description: handle the page size 
    **/
    changePageSize(event) {
        this.pageSize= event.detail.value;
        this.records=this.listOfRecords.slice(0,parseInt(this.pageSize,Number));
        this.pageNumber=1;
        this.nextPageAndLast=false;
        this.firstPageAndPrev=true;
        this.totalPages=Math.ceil( this.listOfRecords.length/this.pageSize);
        this.handleDisplyButtons();
    }
    /** 
     Name: handleSpinner,
     Param:null
     Return Type:null
     description: handle the spinner
    **/
    handleSpinner(){
        this.showSpinner = !this.showSpinner;
    }
    handleRecordButton(event){
        let temp=event.currentTarget.dataset.tit;
        this.pageNumber=parseInt(temp,Number);
        this.records=this.listOfRecords.slice(parseInt(this.pageSize,Number)*(this.pageNumber-1),parseInt(this.pageSize,Number)*this.pageNumber);
        console.log(temp);
        if(this.pageNumber>1){
            this.firstPageAndPrev=false;
            this.nextPageAndLast=false;
        }
        console.log(this.pageNumber,this.totalPages);
        if(this.pageNumber===this.totalPages){
            this.nextPageAndLast=false;
        }
        else{
            this.firstPageAndPrev=true;
        }
        this.handleDisplyButtons();
    }
    handleDisplyButtons(){
        
        var startIndex=0;
        var endIndex=0;
        if(this.totalPages <= 5 || this.pageNumber <= 3){
            startIndex = 0;
            endIndex = 4;
        }
        else if(this.pageNumber > this.totalPages-2){
            startIndex = this.totalPages - 5;
            endIndex = this.totalPages - 1;
        }
        else{
            startIndex = this.pageNumber-3;
            endIndex = this.pageNumber +1;
        }
        console.log(endIndex);
        let tempDisplayButtons = [];
        for(let i = startIndex ; i <= endIndex ; i++){
            tempDisplayButtons.push(this.TotalListOfButtons[i]);
        }
        console.log('abc',JSON.stringify(tempDisplayButtons));
        this.listOfButtonsToShow = tempDisplayButtons;
    }
    /** 
     Name: nextPage,
     Param:null
     Return Type:null
     description: when click on next page changes the records should be navigate
    **/
    nextPage(){
        this.records=[];
        if(this.pageNumber<this.totalPages){
            this.pageNumber=this.pageNumber+1;
            this.records=this.listOfRecords.slice(parseInt(this.pageSize,Number)*(this.pageNumber-1),parseInt(this.pageSize,Number)*this.pageNumber);
        }
        if(this.pageNumber===this.totalPages)  {
            this.nextPageAndLast=true;
        }
        this.firstPageAndPrev=false;
    }
    /** 
     Name: firstPage,
     Param:null
     Return Type:null
     description: when click on first page changes the records should be navigate
    **/
    firstPage(){
        this.nextPageAndLast=false;
        this.firstPageAndPrev=true;
        this.pageNumber=1;
        this.records=this.listOfRecords.slice(0,parseInt(this.pageSize,Number));
        this.handleDisplyButtons();
    }
    /** 
     Name: prevPage,
     Param:null
     Return Type:null
     description: when click on prev page records should change
    **/
    prevPage(){
        this.nextPageAndLast=false;
        this.pageNumber=this.pageNumber-1;
        if(this.pageNumber===1){
            this.firstPageAndPrev=true;
        }
        this.records=this.listOfRecords.slice(parseInt(this.pageSize,Number)*(this.pageNumber-1),parseInt(this.pageSize,Number)*this.pageNumber);
    }
    /** 
     Name: lastPage,
     Param:null
     Return Type:null
     description: when click on lastpage the records should navigate to last page
    **/
    lastPage(){
        this.pageNumber=Math.ceil( this.listOfRecords.length/this.pageSize)
        this.records=this.listOfRecords.slice(parseInt(this.pageSize,Number)*(this.pageNumber-1),parseInt(this.pageSize,Number)*this.pageNumber);
        if(this.pageNumber===this.totalPages)  {
            this.nextPageAndLast=true;
        }
        this.firstPageAndPrev=false;
        this.handleDisplyButtons();

    }
    /** 
     Name: handleKeyChange,
     Param:event
     Return Type:null
     description: when searching by default it will search on the basis of Name field
    **/
    handleKeyChange(event) {
        this.searchKey = event.target.value;
        let tempName=this.columnTable[0];
        let data = [];
        for (let i = 0; i < this.listOfRecords.length; i++) {
            if(this.listOfRecords[i][tempName]!==null&&this.listOfRecords[i][tempName]!==undefined){
                if (this.listOfRecords[i] !== undefined && this.listOfRecords[i][tempName].includes(this.searchKey)) {
                    data.push(this.listOfRecords[i]);
                }
            }
            else{
                this.ShowToast('Error!!','there is no text you are searching for', 'error', 'dismissable');
            }
        }
        this.records=data.slice(0,parseInt(this.pageSize,Number));
    }
    /** 
     Name: sortBy,
     Param:field, reverse, primer
     Return Type:null
     description: when click column sorting should happen 
    **/
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };
        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }
    /** 
     Name: onHandleSort,
     Param:null
     Return Type:null
     description: when click column sorting should happen 
    **/
    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.records];
        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.records = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        console.log(JSON.stringify(selectedRows));

            for(let i of this.records){
                let isSelected=selectedRows.findIndex(item => item.Id === i.Id);
                let currentIndex = this.listOfRecords.findIndex(item => item.Id === i.Id);
                if(isSelected!==-1){
                    this.listOfRecords[currentIndex].isChecked = false;
                    // console.log();
                }else{
                    this.listOfRecords[currentIndex].isChecked = true;
                }
            }
            // for(let i of selectedRows){
            //     // this.dataList.splice(this.dataList.findIndex(item => item.Id == recordId), 1);
            // }

        // Display that fieldName of the selected rows
        // for (let i = 0; i < selectedRows.length; i++) {
        //     alert('You selected: ' + selectedRows[i]);
        // }
    }
    
    /** 
     Name: ShowToast,
     Param:title,message,variant,mode
     Return Type:null
     description: for showing toast message
    **/
    ShowToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message:message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}