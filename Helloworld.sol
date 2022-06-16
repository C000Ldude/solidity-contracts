//SPDX-License-Identifier:Unlicensed

pragma solidity ^0.8.0;

contract Helloworld{

    //variable to store number
    uint256 no;

    //function to store number - parameter=number 
    function storeNumber(uint256 _no)public{
        no=_no;

    }

    //function to retrieve number - returns=number
    function retrieveNumber()public view returns(uint256 _no){
         _no=no;
    }
}

