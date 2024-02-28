@IsTest
private class Product2Tests {

    @IsTest
    static void Product2Extension_UnitTest() {
        PageReference pageRef = Page.Product2New;
        Product2 prod = new Product2(Name = 'test', IsActive = true);
        ApexPages.StandardController controller = new ApexPages.StandardController(prod);

        Test.startTest();

        Product2Extension ext = new Product2Extension(controller);
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());

        ext.addRows();
        System.assertEquals(2 * Constants.DEFAULT_ROWS, ext.productsToInsert.size());

        for (Integer i = 0; i < Constants.DEFAULT_ROWS; i++) {
            Product2 newProduct = new Product2(Name = 'Product' + i, Initial_Inventory__c = 10, IsActive = true, Family = Constants.PRODUCT_FAMILY.get(Math.mod(i, 4)).getValue());
            ext.productsToInsert.get(i).productRecord = newProduct;

            PricebookEntry entry = new PricebookEntry(UnitPrice = 100, IsActive = true);
            ext.productsToInsert.get(i).pricebookEntryRecord = entry;
        }

        ext.Save();
        ext.GetFamilyOptions();
        ext.GetInventory();

        List<Product2> selectedProd = [SELECT Id FROM Product2];
        System.assertEquals(Constants.DEFAULT_ROWS, selectedProd.size());

        Test.stopTest();
    }

    @IsTest
    static void Product2Trigger_UnitTest() {
        Test.startTest();
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        newProduct.Family = 'Dessert';
        newProduct.IsActive = true;
        newProduct.Quantity_Ordered__c = 5;
        newProduct.Initial_Inventory__c = 10;
        insert newProduct;

        CollaborationGroup collaborationGroup = new CollaborationGroup();
        collaborationGroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        collaborationGroup.Description = 'Description';
        collaborationGroup.CollaborationType = 'Public';
        insert collaborationGroup;

        newProduct.Quantity_Ordered__c = 96;
        update newProduct;
        Test.stopTest();
    }

}