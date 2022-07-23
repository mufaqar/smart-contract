// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

contract Ecommerece {
    struct Product {
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool delivered;
    }

    uint counter = 1;
    Product[] public products;
    event register(string title , uint productId , address seller);
    event bought (uint productId , address buyer);
    event delivered (uint productId);
    
    function registerProduct(string memory _title , string memory _desc , uint _price) public {
        require( _price >0 , "Price should be greator then 0");
        Product memory temProduct;
        temProduct.title = _title;
        temProduct.desc = _desc;
        temProduct.price = _price * 10**18;
        temProduct.seller = payable(msg.sender);
        temProduct.productId = counter;
        products.push(temProduct);
        counter++;
        emit register(_title , temProduct.productId ,  msg.sender );
    }

    function buy ( uint _productId ) payable public {

        require(products[_productId-1].price == msg.value,"Please pay the exact price " );
        require(products[_productId-1].seller != msg.sender,"Seller can't be the buyer");

        products[_productId-1].buyer = msg.sender;
        emit bought(_productId , msg.sender);



    }

    function delivery(uint _productId) public {

        require(products[_productId-1].buyer == msg.sender,"Only buyer can confirm product" );
        products[_productId-1].delivered = true;
        products[_productId-1].seller.transfer(products[_productId-1].price);
        emit delivered(_productId);


    }
    





}