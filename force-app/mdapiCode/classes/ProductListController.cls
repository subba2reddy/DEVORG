public with sharing class ProductListController {
    public List<Product2> getProducts(){
        List<Product2> products = [Select name, description from Product2];
        return products;
    }
}