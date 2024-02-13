import { LightningElement, wire } from "lwc";
import getHouses from "@salesforce/apex/HouseService.getRecords";
export default class HousingMap extends LightningElement {
    mapMarkers;
    error;
    @wire(getHouses)
    wiredHouses({ error, data }) {
        if (data) {
        console.log(data);
    }
  }
}