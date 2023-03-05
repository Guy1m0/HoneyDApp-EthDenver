// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "Log.sol";
import "Migrations.sol";
import "TrustFund.sol";
//import "../contracts/3_Ballot.sol";

// deploy three contracts first
contract test_simple {
    function beforeAll() public{
        owner = TestsAccounts.getAccount(0);
        user1 = TestsAccounts.getAccount(1);
        user2 = TestsAccounts.getAccount(2);
        user3 = TestsAccounts.getAccount(3);
        attacker = TestsAccounts.getAccount(4);
    }


}


contract TrustFundTest{
    TrustFund tfToTest;
    Log logToTest;

    function beforeAll () public {
        tfToTest = new TrustFund(bytes32("SC1"));
    }
}

contract BallotTest {

    bytes32[] proposalNames;

    Ballot ballotToTest;
    function beforeAll () public {
        proposalNames.push(bytes32("candidate1"));
        ballotToTest = new Ballot(proposalNames);
    }

    function checkWinningProposal () public {
        console.log("Running checkWinningProposal");
        ballotToTest.vote(0);
        Assert.equal(ballotToTest.winningProposal(), uint(0), "proposal at index 0 should be the winning proposal");
        Assert.equal(ballotToTest.winnerName(), bytes32("candidate1"), "candidate1 should be the winner name");
    }

    function checkWinninProposalWithReturnValue () public view returns (bool) {
        return ballotToTest.winningProposal() == 0;
    }
}