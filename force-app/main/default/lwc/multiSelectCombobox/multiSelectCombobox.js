import { LightningElement, track, api } from 'lwc';
 
export default class MultiSelectPickList extends LightningElement {
    
    @api options=[
        {'label':'India','value':'India'},
        {'label':'USA','value':'USA'},
        {'label':'China','value':'China'},
        {'label':'Rusia','value':'Rusia'},
        {'label':'UK','value':'Uk'},
        {'label':'Romania','value':'Romania'},
        {'label':'Rusia2','value':'Rusia2'},
        {'label':'Rusia3','value':'Rusia3'}
    ];
    @api selectedValue;
    @api selectedValues = [];
    @api label;
    @api disabled = false;
    @api multiSelect = false;
    @track value;
    @track values = [];
    @track optionData=[
        {'label':'India','value':'India'},
        {'label':'USA','value':'USA'},
        {'label':'China','value':'China'},
        {'label':'Rusia','value':'Rusia'},
        {'label':'UK','value':'Uk'},
        {'label':'Romania','value':'Romania'},
        {'label':'Rusia2','value':'Rusia2'},
        {'label':'Rusia3','value':'Rusia3'}
    ];
    @track multiSelectOptionData=[
        {'label':'India','value':'India'},
        {'label':'USA','value':'USA'},
        {'label':'China','value':'China'},
        {'label':'Rusia','value':'Rusia'},
        {'label':'UK','value':'Uk'},
        {'label':'Romania','value':'Romania'},
        {'label':'Rusia2','value':'Rusia2'},
        {'label':'Rusia3','value':'Rusia3'}
    ];
    @track singlePickList=true;
    @track multiPickList=false;
    @track searchString;
    @track multiSearchString;

    @track noResultMessage;
    @track showDropdown = false;
    @track showMultiSelect = false;
    @track tempStringSinglePicklist;
    @track count;
    /** 
     Name: connectedCallback,
     Param:null
     Return Type:null
     description: setting picklist values for single picklist and multi picklist
    **/
    connectedCallback() {
        this.showDropdown = false;
        var optionData = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
        var value = this.selectedValue ? (JSON.parse(JSON.stringify(this.selectedValue))) : null;
        var values = this.selectedValues ? (JSON.parse(JSON.stringify(this.selectedValues))) : null;
        if(value || values) {
            var searchString;
            var count = 0;
            for(var i = 0; i < optionData.length; i++) {
                if(this.multiSelect) {
                    if(values.includes(optionData[i].value)) {
                        optionData[i].selected = true;
                        count++;
                    }  
                } else {
                    if(optionData[i].value == value) {
                        searchString = optionData[i].label;
                    }
                }
            }
            if(this.multiSelect){
                this.multiSearchString=this.count + ' Option(s) Selected';
            }
            else
                this.searchString = searchString;
        }
        this.value = value;
        this.values = values;
        this.multiSelectOptionData=optionData;
        this.optionData = optionData;
    }
    /** 
     Name: filterOptions,
     Param:event
     Return Type:null
     description: method for showing values on the basis of what searching
    **/
    filterOptions(event) {
        this.multiSearchString=event.target.value;
        this.searchString = event.target.value;
        if( this.searchString && this.searchString.length > 0 ||  this.multiSearchString && this.multiSearchString.length>0) {
            this.noResultMessage = '';
            if(this.searchString.length >= 2||this.multiSearchString.length>=2) {
                var flag = true;
                for(var i = 0; i < this.optionData.length; i++) {
                    if(this.optionData[i].label.toLowerCase().trim().startsWith(this.searchString.toLowerCase().trim())||this.multiSelectOptionData[i].label.toLowerCase().trim().startsWith(this.multiSearchString.toLowerCase().trim())) {
                        this.optionData[i].isVisible = true;
                        this.multiSelectOptionData[i].isVisible=true;
                        flag = false;
                    } else {
                        this.multiSelectOptionData[i].isVisible=false;
                        this.optionData[i].isVisible = false;
                    }
                }
                if(flag) {
                    this.noResultMessage = "No results found for '" + this.searchString + "'";
                }
            }
            this.showDropdown = true;
        } else {
            this.showDropdown = false;
        }
    }
    /** 
     Name: selectItem,
     Param:event
     Return Type:null
     description: options for selecting values in a picklist
    **/
    selectItem(event) {
        var selectedVal = event.currentTarget.dataset.id;
        if(selectedVal) {
            var count = 0;
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === selectedVal) {
                    if(this.multiSelect) {
                        if(this.values.includes(options[i].value)) {
                            this.values.splice(this.values.indexOf(options[i].value), 1);
                        } else {
                            this.values.push(options[i].value);
                        }
                        options[i].selected = options[i].selected ? false : true;   
                    } else {
                        this.value = options[i].value;
                        this.multiSearchString=options[i].label;
                        this.searchString = options[i].label;
                    }
                }
                if(options[i].selected) {
                    count++;
                }
            }
            this.optionData = options;
            if(this.multiSelect){
                this.multiSearchString = count + ' Option(s) Selected';

                let ev = new CustomEvent('selectoption', {detail:this.values});
                this.dispatchEvent(ev);
            }
            if(!this.multiSelect){
                let ev = new CustomEvent('selectoption', {detail:this.value});
                this.dispatchEvent(ev);
            }

            if(this.multiSelect)
                event.preventDefault();
            else
                this.showDropdown = false;
        }
    }
    /** 
     Name: selectItemMultiSelect,
     Param:event
     Return Type:null
     description: options for selecting values in a multiselect picklist
    **/
    selectItemMultiSelect(event) {
        var selectedVal = event.currentTarget.dataset.id;
        if(selectedVal) {
            var count = 0;
            var options = JSON.parse(JSON.stringify(this.multiSelectOptionData));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === selectedVal) {
                    if(this.multiSelect) {
                        if(this.values.includes(options[i].value)) {
                            this.values.splice(this.values.indexOf(options[i].value), 1);
                        } else {
                            this.values.push(options[i].value);
                        }
                        options[i].selected = options[i].selected ? false : true;   
                    } else {
                        this.value = options[i].value;
                        this.multiSearchString=options[i].label;
                    }
                }
                if(options[i].selected) {
                    count++;
                }
            }
            this.count=count;
            this.multiSelectOptionData=options;
            if(this.multiSelect){
                this.multiSearchString = this.count + ' Option(s) Selected';

                let ev = new CustomEvent('selectoption', {detail:this.values});
                this.dispatchEvent(ev);
            }
            if(!this.multiSelect){
                let ev = new CustomEvent('selectoption', {detail:this.value});
                this.dispatchEvent(ev);
            }

            if(this.multiSelect)
                event.preventDefault();
            else
                this.showDropdown = false;
        }
    }
    /** 
     Name: showOptions,
     Param:event
     Return Type:null
     description: showing option for select single picklist
    **/
    showOptions() {
        if(this.disabled == false && this.options) {
            this.showMultiSelect = true;
            this.noResultMessage = '';
            this.searchString = '';
            this.multiSearchString='';
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                options[i].isVisible = true;
            }
            if(options.length > 0) {
                this.showDropdown = true;
            }

            this.optionData = options;
        }
    }
    /** 
     Name: showOptionsMultiPicklist,
     Param:event
     Return Type:null
     description: showing option for select multi picklist
    **/
    showOptionsMultiPicklist() {
        if(this.disabled == false && this.options) {
            this.showMultiSelect = true;
            this.noResultMessage = '';
            this.searchString = '';
            this.multiSearchString='';
            var options = JSON.parse(JSON.stringify(this.multiSelectOptionData));
            for(var i = 0; i < options.length; i++) {
                options[i].isVisible = true;
            }
            if(options.length > 0) {
                this.showDropdown = true;
            }
            
            this.multiSelectOptionData = options;
        }
    }
     /** 
     Name: removePill,
     Param:event
     Return Type:null
     description: deselect picklist values in case multipicklist
    **/
    removePill(event) {
        console.log('checkD');
        var value = event.currentTarget.name;
        console.log(value);
        var count = 0;
        var options = JSON.parse(JSON.stringify(this.multiSelectOptionData));
        for(var i = 0; i < options.length; i++) {
            if(options[i].value === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].value), 1);
            }
            if(options[i].selected) {
                count++;
            }
        }
        this.count=count;
        this.multiSelectOptionData = options;
        if(this.multiSelect)
            this.multiSearchString = this.count + ' Option(s) Selected';
    }
    /** 
     Name: toggleChangeSignleToMulti,
     Param:event
     Return Type:null
     description: toggle button for change single picklist to multipicklist
    **/
    toggleChangeSignleToMulti(){
        if(this.singlePickList===false){
            this.singlePickList=true;
            this.multiPickList=false;
            this.multiSelect=false;
        }
        else if( this.singlePickList===true){
            this.singlePickList=false;
            this.multiPickList=true;
            this.multiSelect=true;
        }
    }
   
    /** 
     Name: handleBlur,
     Param:null
     Return Type:null
     description: when we change change value for single to multiselect the value select previously should remain same
    **/
    handleBlur() {
        var previousLabel;
        var count = 0;
        for(var i = 0; i < this.optionData.length; i++) {
            if(this.optionData[i].value === this.value) {
                previousLabel = this.optionData[i].label;
            }
            if(this.optionData[i].selected) {
                count++;
            }
        }
        if(this.multiSelect){
            this.multiSearchString = this.count + ' Option(s) Selected';
        }else{
            this.searchString = previousLabel;
        }

        this.showDropdown = false;
    }
}