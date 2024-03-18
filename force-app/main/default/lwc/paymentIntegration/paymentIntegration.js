import { LightningElement,track  } from 'lwc';
import integrationImage from '@salesforce/resourceUrl/PaymentIntegrationImage';
import payByAuthrizePayment from "@salesforce/apex/PaymentIntegration.payByAuthrizePayment";
import payByEcheck from "@salesforce/apex/PaymentIntegration.payByEcheck";

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class PaymentIntegration extends LightningElement {
    showPaymentByCard=false;
    showPaymentByEcheck=true;
    imageForUI=integrationImage;
    monthOptions = [
                    {
                        value: "01",
                        label: "January"
                    },
                    {
                        value: "02",
                        label: "February"
                    },
                    {
                        value: "03",
                        label: "March"
                    },
                    {
                        value: "04",
                        label: "April"
                    },
                    {
                        value: "05",
                        label: "May"
                    },
                    {
                        value: "06",
                        label: "June"
                    },
                    {
                        value: "07",
                        label: "July"
                    },
                    {
                        value: "08",
                        label: "August"
                    },
                     {
                        value: "09",
                        label: "September"
                    },
                    {
                        value: "10",
                        label: "October"
                    },
                    {
                        value: "11",
                        label: "November"
                    },
                    {
                        value: "12",
                        label: "December"
                    }
    ];
    yearOptions = [
                    {
                        value: "2023",
                        label: "2023"
                    },
                    {
                        value: "2024",
                        label: "2024"
                    },
                    {
                        value: "2025",
                        label: "2025"
                    },
                    {
                        value: "2026",
                        label: "2026"
                    },
                    {
                        value: "2027",
                        label: "2027"
                    },
                    {
                        value: "2028",
                        label: "2028"
                    },
                     {
                        value: "2029",
                        label: "2029"
                    },
                    {
                        value: "2030",
                        label: "2030"
                    }
                    
    ];
 
    countries = [
            {
                value: "India",
                label: "India"
            },
            {
                value: "USA",
                label: "USA"
            },
            {
                value: "United Kingdom",
                label: "United Kingdom"
            },
    ];
 

    @track cardNumber;
    @track cvv;
    @track cardMonth;
    @track cardYear;
    @track routingNumber;
    @track accountNumber;
    @track nameOnTheCard;
    showSpinner = false;
    /** 
     Name: handleChange,
     Param:event
     Return Type:null
     description: value getting depending on the input value
    **/
    handleChange(event) {
        if(event.target.name === 'cardNumber'){
            this.cardNumber = event.detail.value;
        } else if(event.target.name === 'month'){
            this.cardMonth = event.detail.value;
        } else if(event.target.name === 'year'){
            this.cardYear = event.detail.value;
        } else if(event.target.name === 'cvv'){
            this.cvv = event.detail.value;
        } else if(event.target.name === 'routingnumber'){
            this.routingNumber = event.detail.value;
        } else if(event.target.name === 'accountNumber'){
            this.accountNumber = event.detail.value;
        } else if(event.target.name === 'nameOnTheCard'){
            this.nameOnTheCard = event.detail.value;
        }
    }
     /** 
     Name: handlePaymentByCard,
     Param:null
     Return Type:null
     description: handle payment by card
    **/
    handlePaymentByCard(){
        this.handleSpinner();
        // if(this.cardNumber.length===16 && this.cardMonth!=null&&this.cardYear!=null&&this.cvv.length===3){
            payByAuthrizePayment({cardNumber : this.cardNumber,cardMonth : this.cardMonth, cardYear : this.cardYear, cvv : this.cvv})
            .then(res=>{
                let title = res;
                this.ShowToast('Success!', title, 'success', 'dismissable');
            }).catch(err=>{
                this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
            }).finally(() => {
                this.handleSpinner();
            })
        // }
        // else{
        //     this.ShowToast('Error!!', 'pls fill proper information', 'error', 'dismissable');
        //     this.handleSpinner();
        // }
    }
     /** 
     Name: handlePaymentByEcheck,
     Param:null
     Return Type:null
     description: handle payment by echeck
    **/
    handlePaymentByEcheck(){
        this.handleSpinner();
        // if(this.routingNumber.length===9 && this.accountNumber.length===9&&this.nameOnAccount!=null){
            payByEcheck({routingNumber : this.routingNumber,accountNumber : this.accountNumber, nameOnAccount : this.nameOnTheCard})
            .then(res=>{
                let title = res;
                this.ShowToast('Success!', title, 'success', 'dismissable');
            }).catch(err=>{
                this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
            }).finally(() => {
                this.handleSpinner();
            })
        // }
        // else{
        //     this.ShowToast('Error!!', 'pls fill proper information', 'error', 'dismissable');
        //     this.handleSpinner();
        // }
    }
     /** 
     Name: handleSpinner,
     Param:null
     Return Type:null
     description: for handling spinner
    **/
    handleSpinner(){
        this.showSpinner = !this.showSpinner;
    }
     /** 
     Name: changeEcheckToCard,
     Param:null
     Return Type:null
     description: changing ui depening on the payment method
    **/
    changeEcheckToCard(){
        console.log('checked');
        if(this.showPaymentByCard===false){
            this.showPaymentByCard=true;
            this.showPaymentByEcheck=false;
        }
        else if(this.showPaymentByCard===true){
            this.showPaymentByCard=false;
            this.showPaymentByEcheck=true;
        }
    }
     /** 
     Name: ShowToast,
     Param:null
     Return Type:null
     description: showing toast method
    **/
    ShowToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
            title: title,
            message:message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}