@IsTest
private class OrderTests {

    @TestSetup
    static void setupTestData(){
        TestDataFactory.insertTestData(1);
    }

    @IsTest
    private static void orderUpdate_UnitTest() {
        Test.startTest();

        Order orderForUpdate = [SELECT Status FROM Order LIMIT 1];
        Product2 productToValidate = [SELECT Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];

        orderForUpdate.Status = Constants.ACTIVATED_ORDER_STATUS;
        update orderForUpdate;

        Product2 secondProduct =  [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];
        TestDataFactory.verifyQuantityOrdered(productToValidate, secondProduct, Constants.DEFAULT_ROWS);

        Test.stopTest();
    }

    @IsTest
    private static void orderExtension_unitTest() {
        PageReference reference = Page.OrderEdit;
        Test.setCurrentPage(reference);

        Order CurOrder = [SELECT Status FROM Order LIMIT 1];
        ApexPages.StandardController controller = new ApexPages.StandardController(CurOrder);
        OrderExtension extension = new OrderExtension(controller);

        System.assertEquals(1, extension.orderItemList.size());

        extension.selectedFamily = 'Dessert';
        extension.selectFamily();
        extension.onFieldChange();
        extension.First();
        extension.Next();
        extension.Previous();
        extension.Last();
        extension.GetHasNext();
        extension.GetPageNumber();
        extension.GetHasPrevious();
        extension.GetTotalPages();
        extension.GetFamilyOptions();
        extension.save();

        ChartHelper.GetInventory();
    }
}