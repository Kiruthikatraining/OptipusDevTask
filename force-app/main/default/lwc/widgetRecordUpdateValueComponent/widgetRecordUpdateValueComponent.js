import { LightningElement, track, wire, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import checkUserProfileName from '@salesforce/apex/WidgetRecordUpdateValueCmpController.isUserSystemAdminOrWidgetMaster';
import updateWidgetRecord from '@salesforce/apex/WidgetRecordUpdateValueCmpController.updateWidgetRecord';

export default class TextInputComponent extends LightningElement {
    @track inputText = '';
    @api recordId;
    isValueProperlyNested = false;
    userAdminOrWidgetMaster = false;


    @wire(checkUserProfileName)
    getprofileUser({ error, data }) {
        if (data) {
            this.userAdminOrWidgetMaster = data;
            console.log('this.userAdminOrWidgetMaster ',this.userAdminOrWidgetMaster);
        } else if (error) {
            console.error('Error fetching profile name:', error);
        }
    }

    handleInputChange(event) {
        this.inputText = event.target.value;
    }

    handleSave() {
        if(this.inputText === 'properly nested' || this.userAdminOrWidgetMaster === true){
            updateWidgetRecord({recordId : this.recordId, value : this.inputText })
                .then(result => {
                    this.result = result;
                    const event = new ShowToastEvent({
                        title: 'Success',
                        message: 'Widget Record Updated successfully.',
                        variant: 'success'
                    });
                    this.dispatchEvent(event);

                    this.dispatchEvent(new CloseActionScreenEvent());
                })
                .catch(error => {
                    console.error('Error calling Apex method:', error);
                });
            
        }else{
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Please Enter Widget Value as properly nested',
                variant: 'error'});
            this.dispatchEvent(toastEvent);
        }
        
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    // closeModal() {
    //     // Fire a custom event to notify the parent component to close the modal
    //     this.dispatchEvent(new CustomEvent('close'));
    // }
}
