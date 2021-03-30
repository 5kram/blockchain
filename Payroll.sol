// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract Payroll {
    uint constant WITHDRAW_INTERVAL = 10 seconds;
    address owner;
    
    constructor() {
            owner = msg.sender;
    }
    
    struct Employee {
        uint salary;
        uint lastWithdraw;
    }
    
    mapping(address => Employee) employees;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner of the contract!");
        _;
    }
    
    modifier onlyEmployee() {
        require(isEmployee(msg.sender), "You are not an employee of this company!");
        _;
    }
    
    function deposit() public payable { }
    
    function withdraw() public onlyEmployee {
        Employee storage e = employees[msg.sender];
        require(employees[msg.sender].lastWithdraw + WITHDRAW_INTERVAL < block.timestamp, "It is too early to withdraw.");
        e.lastWithdraw = block.timestamp;
        require(msg.sender.send(e.salary), "Could not send salary to employee.");
    }
    
    function isEmployee(address addr) public view returns(bool) {
            return (employees[addr].salary != 0);
    }
    
    function canWithdraw(address _addr) public view returns(bool) {
            Employee memory e = employees[_addr];
        if (e.lastWithdraw + WITHDRAW_INTERVAL < block.timestamp && e.salary != 0) {
                return true;
        }
            return false;
    }
    
    function getEmployeeBalance(address _employee) public view returns(uint) {
            return address(_employee).balance;
    }
    
    function getContractBalance() public view returns(uint) {
            return address(this).balance;
    }
    
    function addEmployees(address addr, uint _salary) public onlyOwner {
            employees[addr].salary = _salary;
    }
    
    function removeEmployee(address addr) public onlyOwner {
            employees[addr].salary = 0;
    }
    
    receive() external payable { }
}
