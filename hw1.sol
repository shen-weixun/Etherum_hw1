// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationContract {
    // 儲存每個地址的捐贈金額
    mapping(address => uint256) public donations;
    

    // 收到捐贈事件
    event DonationReceived(address indexed donor, uint256 amount);

    // 合約接收 ETH 的函數 (fallback 和 receive)
    receive() external payable {
        // 紀錄捐贈金額
        donations[msg.sender] += msg.value;

        // 發出捐贈事件
        emit DonationReceived(msg.sender, msg.value);
    }

    // 查詢合約餘額
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 合約擁有者提取合約中的 ETH
    address public owner;

    constructor() {
        owner = msg.sender; // 部署者為合約擁有者
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can withdraw funds");
        _;
    }
    //把ETH從合約轉出去
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }
}
