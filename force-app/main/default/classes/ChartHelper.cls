public without sharing class ChartHelper {

    @AuraEnabled
    public static List<ChartData> GetInventory() {
        List<ChartData> chartData = new List<ChartData>();
        for (AggregateResult ar : [
                SELECT Family, SUM(Quantity_Remaining__c)
                FROM Product2
                WHERE Quantity_Remaining__c > 0 AND IsActive = TRUE
                GROUP BY Family
        ]) {
            chartData.add(
                    new ChartData(
                            String.valueOf(ar.get('Family')),
                            Integer.valueOf(ar.get('expr0'))
                    ));
        }

        return chartData;
    }

    public class ChartData {
        public String name { get; set; }
        public Decimal val { get; set; }

        public ChartData(String name, Decimal val) {
            this.name = name;
            this.val = val;
        }
    }
}