// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WalletTransfer {
    // 事件，用於記錄轉帳
    event Transfer(address indexed from, address indexed to, uint256 amount);
    // 事件，用於記錄資金接收
    event PaymentReceived(address indexed from, uint256 amount);

    // 收到以太幣的回退函數
    receive() external payable {}
    mapping(address=>uint256[])public requestHistory;
    // 初始化合約，設置特定的地址
    address public requiredAddress; // 特定的地址
    constructor(address _requiredAddress) {
        require(_requiredAddress != address(0), "Invalid address");
        requiredAddress = _requiredAddress;
    }
    uint256 public totalReceived; // 合約收到的總金額

    // 僅允許特定地址發送資金
    function sendFunds() external payable {
        require(msg.sender == requiredAddress, "You are not authorized to send funds");
        require(msg.value > 0, "No funds sent");

        // 記錄收到的金額
        totalReceived += msg.value;

        // 發布事件
        emit PaymentReceived(msg.sender, msg.value);
    }
    // 從合約轉帳到指定的錢包地址
    function transferTo(address payable _to, uint256 _amount) external {
        require(_to != address(0), "Invalid recipient address");
        require(_amount > 0, "Transfer amount must be greater than zero");
        require(address(this).balance >= _amount, "Insufficient contract balance");
        requestHistory[_to].push(_amount);
        // 進行轉帳
        _to.transfer(_amount);

        // 發布事件
        emit Transfer(msg.sender, _to, _amount);
    }
    function getRequestHistory(address user) external view returns (uint256[] memory){
        return requestHistory[user];
    }
    // 查詢合約餘額
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
