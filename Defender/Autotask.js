const ethers = require('ethers');
const { Relayer } = require('defender-relay-client');
const { DefenderRelaySigner, DefenderRelayProvider, } = require('defender-relay-client/lib/ethers');

const ADDRESS = '0xB1bfA3658c2b4a7541Ad3DDD3Ff77DDDDbD060d5';
const mal = '0x1A477E07f6e657dfbf9d79498b05BFD559dab372';
const good = '0x04A9eD0d134e894fEcD01E45e6696a55187Dd01A';

const ABI = [
  {
    "constant": true,
    "inputs": [],
    "name": "Getter",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_to",
        "type": "address"
      },
      {
        "name": "_name",
        "type": "string"
      }
    ],
    "name": "transferOwner",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_amount",
        "type": "uint256"
      }
    ],
    "name": "withdraw",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_to",
        "type": "address"
      }
    ],
    "name": "_setRoleAdmin",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getEP",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "minDeposit",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "_addr",
        "type": "address"
      }
    ],
    "name": "checkBalance",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_to",
        "type": "address"
      }
    ],
    "name": "reset",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "percent",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_p",
        "type": "uint256"
      }
    ],
    "name": "setPercent",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "owner_history",
    "outputs": [
      {
        "name": "new_owner",
        "type": "address"
      },
      {
        "name": "name",
        "type": "string"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "deposit",
    "outputs": [
      {
        "name": "",
        "type": "bool"
      }
    ],
    "payable": true,
    "stateMutability": "payable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "TrustLog",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "name": "_logger",
        "type": "address"
      },
      {
        "name": "_getter",
        "type": "address"
      }
    ],
    "payable": true,
    "stateMutability": "payable",
    "type": "constructor"
  }
];

exports.handler = async function(event) {
  const client = new Relayer(event);
  const relayer = await client.getRelayer();
  const provider = new DefenderRelayProvider(event);
  //ep = 1800
  const signer = new DefenderRelaySigner(event, provider, {
    	value: 1000000,
    	speed: 'fast',
  		from: relayer.address,
  	});

  const contract = new ethers.Contract(ADDRESS, ABI, signer);
  await contract.transferOwner(mal, "new");
  
}

