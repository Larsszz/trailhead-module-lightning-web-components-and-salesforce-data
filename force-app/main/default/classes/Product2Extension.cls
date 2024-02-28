public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void addRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(PicklistEntry eachPicklistValue : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(eachPicklistValue.getValue(), eachPicklistValue.getLabel()));
        }

        return options;
    }

    public PageReference Save(){
        Savepoint sp = Database.setSavepoint();
        Integer insertedCount = 0;

        try {
            List<Product2> newProducts = new List<Product2>();
            List<PricebookEntry> pbeList = new List<PricebookEntry>();
            List<ProductWrapper> filteredProductWrappers = new List<ProductWrapper>();

            for(ProductWrapper eachPW : productsToInsert) {
                filteredProductWrappers.add(eachPW);
            }

            for(ProductWrapper eachPW : filteredProductWrappers) {
                newProducts.add(eachPW.productRecord);
            }

            Database.SaveResult[] productSaveResults = Database.insert(newProducts, false);

            for(Integer i = 0; i < productSaveResults.size(); i++) {
                if(productSaveResults[i].isSuccess()) {
                    PricebookEntry pbe = filteredProductWrappers[i].pricebookEntryRecord;
                    pbe.Product2Id = productSaveResults[i].getId();
                    pbe.IsActive = true;
                    pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    pbeList.add(pbe);
                    insertedCount++;
                }
            }

            Database.insert(pbeList, false);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();
            addRows();
        } catch (Exception e){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }

        return null;
    }

    public class ProductWrapper{
        public Product2 productRecord {get; set;}
        public PricebookEntry pricebookEntryRecord {get; set;}
        public ProductWrapper() {
            productRecord = new Product2(Initial_Inventory__c = 0);
            pricebookEntryRecord = new PricebookEntry(UnitPrice = 0.0);
        }
    }

}