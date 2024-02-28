public with sharing class TestDataFactory {

    public static CollaborationGroup constructCollaborationGroup() {
        CollaborationGroup collaborationGroup = new CollaborationGroup();
        collaborationGroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        collaborationGroup.CanHaveGuests = false;
        collaborationGroup.CollaborationType = 'Public';
        collaborationGroup.IsArchived = false;
        collaborationGroup.IsAutoArchiveDisabled = false;
        return collaborationGroup;
    }

    public static List<Product2> constructProducts(Integer cnt) {
        List<Schema.PicklistEntry> familyValueList = Product2.Family.getDescribe().getPicklistValues();
        Integer listSize = familyValueList.size();

        List<Product2> productList = new List<Product2>();
        for (Integer i = 0; i < cnt; i++) {
            Product2 constructedProduct = new Product2();
            constructedProduct.Name = 'Product ' + i;
            constructedProduct.Family = familyValueList[Math.mod(i, listSize)].getValue();
            constructedProduct.Initial_Inventory__c = 10;
            constructedProduct.IsActive = true;
            productList.add(constructedProduct);
        }

        return productList;
    }

    public static List<PricebookEntry> constructPricebookEntries(List<Product2> productList) {
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        for (Product2 product : productList) {
            PricebookEntry pricebookEntry = new PricebookEntry();
            pricebookEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pricebookEntry.Product2Id = product.Id;
            pricebookEntry.IsActive = true;
            pricebookEntry.UnitPrice = 1;
            priceBookEntries.add(pricebookEntry);
        }

        return priceBookEntries;
    }


    public static List<Account> constructAccounts(Integer cnt) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            Account acct = new Account();
            acct.Name = 'Account ' + i;
            accounts.add(acct);
        }

        return accounts;
    }

    public static List<Contact> constructContacts(Integer cnt, List<Account> accts) {
        Integer listSize = accts.size();

        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            Contact newContact = new Contact();
            newContact.LastName = 'Contact ' + i;
            newContact.AccountId = accts[Math.mod(i, listSize)].Id;
            contactList.add(newContact);
        }

        return contactList;
    }

    public static List<Order> constructOrders(Integer cnt, List<Account> accts) {
        Integer listSize = accts.size();
        List<Order> orders = new List<Order>();

        for (Integer i = 0; i < cnt; i++) {
            Order newOrder = new Order();
            newOrder.Name = 'Order ' + i;
            newOrder.AccountId = accts[Math.mod(i, listSize)].Id;
            newOrder.EffectiveDate = Date.today();
            newOrder.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            newOrder.Status = 'Draft';
            orders.add(newOrder);
        }

        return orders;
    }

    public static List<OrderItem> constructOrderItems(Integer cnt, List<PricebookEntry> pbes, List<Order> ords) {
        Integer pbeListSize = pbes.size();
        Integer orderListSize = ords.size();

        List<OrderItem> orderItemList = new List<OrderItem>();

        for (Integer i = 0; i < cnt; i++) {
            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = ords[Math.mod(i, orderListSize)].Id;
            orderItem.PricebookEntryId = pbes[Math.mod(i, pbeListSize)].Id;
            orderItem.Quantity = Constants.DEFAULT_ROWS;
            orderItem.UnitPrice = 1;
            orderItemList.add(orderItem);
        }

        return orderItemList;
    }

    public static void insertTestData(Integer cnt) {
        insert constructCollaborationGroup();

        List<Product2> productList = constructProducts(cnt);
        insert productList;

        List<PricebookEntry> priceBookEntries = constructPricebookEntries(productList);
        insert priceBookEntries;

        List<Account> accounts = constructAccounts(cnt);
        insert accounts;
        insert constructContacts(cnt, accounts);

        List<Order> orders = constructOrders(cnt, accounts);
        insert orders;

        insert constructOrderItems(cnt, priceBookEntries, orders);
    }

    public static void verifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        Integer quantitySum = Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;

        System.assertEquals(updatedProduct.Quantity_Ordered__c, quantitySum);
    }

}