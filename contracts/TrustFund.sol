// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.7.0;
import "hardhat/console.sol";


contract TrustFund {
  Logger public TrustLog;
  string name;
  address owner;
  uint256 public minDeposit;
  mapping (address => uint256) balances;
  
  struct Change {
    address new_owner;
    string name;
  }

  Change[] public owner_history;

  constructor (address _logger) public payable {
    owner = msg.sender;
    name = "contract creator";

    minDeposit = 1e17;
    TrustLog = Logger(_logger);
  }

  function transferOwner(address _to, string memory _name) public {
    if (msg.sender != owner){
      console.log("Not owner");
    }
    require(msg.sender == owner);

    Change change;
    change.new_owner = _to;
    change.name = _name;

    console.log(address(TrustLog));

    if (owner == _to){ //intentionaly typo
      owner_history.push(change);
      owner = _to;
    }
  }

  function deposit() public payable returns (bool) {
    if (msg.value >= minDeposit) {
      balances[msg.sender]+=msg.value;
      console.log("enough msg.value");
      TrustLog.LogTransfer(msg.sender,msg.value,"deposit");
    } else {
        //console.log("value:", msg.value);
      console.log("Not enough");
      TrustLog.LogTransfer(msg.sender,msg.value,"depositFailed");
    }
  }

  function withdraw(uint256 _amount) public {
    if(_amount <= balances[msg.sender]) {
      (bool s, ) = msg.sender.call{value: _amount}("");
      console.log("Finish transfer?");
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