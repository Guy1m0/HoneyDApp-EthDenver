// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TrustFund {
  address owner;
  uint256 public minDeposit;
  mapping (address => uint256) balances;
  Logger public TrustLog;

  constructor (uint256 _minDeposit, address _logger) public payable {
    owner = msg.sender;
    minDeposit = _minDeposit;
    TrustLog = Logger(_logger);
  }

  function deposit() public payable returns (bool) {
    if (msg.value > minDeposit) {
      balances[msg.sender]+=msg.value;
      TrustLog.LogTransfer(msg.sender,msg.value,"deposit");
    } else {
      TrustLog.LogTransfer(msg.sender,msg.value,"depositFailed");
    }
  }

  function withdraw(uint256 _amount) public {
    if(_amount <= balances[msg.sender]) {
      (bool s, ) = msg.sender.call{value: _amount}("");
      if(s) {
        balances[msg.sender] -= _amount;
        TrustLog.LogTransfer(msg.sender, _amount, "withdraw");
      } else {
        TrustLog.LogTransfer(msg.sender, _amount, "withdrawFailed");
      }
    }
  }

  function checkBalance(address _addr) public view returns (uint256) {
    return balances[_addr];
  }
}

contract Logger {
  struct Message {
    address sender;
    uint256 amount;
    string note;
  }

  Message[] History;
  Message public LastLine;

  function LogTransfer(address _sender, uint256 _amount, string memory _note) public {
    LastLine.sender = _sender;
    LastLine.amount = _amount;
    LastLine.note = _note;
    History.push(LastLine);
  }
}