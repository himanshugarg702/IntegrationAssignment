@isTest
public with sharing class TestPaymentIntegration {
    @isTest 
    static void getPaymentByCard(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassPaymentIntegration());
        Test.startTest();
        String url=PaymentIntegration.payByAuthrizePayment('2737282828282828','04','2025','123');
        Test.stopTest();
    }
    @isTest 
    static void getPaymentByEcheck(){
        Test.setMock(HttpCalloutMock.class, new MockTestClassPaymentIntegration());
        Test.startTest();
        String url=PaymentIntegration.payByEcheck('2345643213','2345654323456','Hima');
        Test.stopTest();
    }
}