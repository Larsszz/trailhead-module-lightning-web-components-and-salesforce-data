trigger product2Trigger on Product2 (after update) {
    Product2Helper.afterUpdate(
            (List<Product2>)Trigger.new,
            (List<Product2>) Trigger.old
    );
}