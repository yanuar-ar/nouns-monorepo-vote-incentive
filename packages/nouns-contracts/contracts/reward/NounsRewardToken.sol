// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './NounsRewardInterface.sol';

contract NounsRewardToken is ERC20, ERC20Burnable, Ownable {
    mapping(uint256 => mapping(address => uint256)) public claimedProposal;

    // reward rate in WEI
    uint256 public rewardRate;

    // NounsSoulBoundToken
    INounsSoulBoundToken public NounsSoulBoundToken;

    // NousDAOLogicV1
    INounsDAOLogicV1 public NounsDAOLogicV1;

    constructor(
        INounsDAOLogicV1 _NounsDAOLogicv1,
        INounsSoulBoundToken _NounsSoulBoundToken,
        uint256 _rewardRate
    ) ERC20('Nouns Reward Token', 'NOUNSR') {
        NounsSoulBoundToken = INounsSoulBoundToken(_NounsSoulBoundToken);
        NounsDAOLogicV1 = INounsDAOLogicV1(_NounsDAOLogicv1);
        rewardRate = _rewardRate;
    }

    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // claimreward
    function claimReward(uint256 proposalId) public {
        require(claimedProposal[proposalId][msg.sender] == 0, 'Proposal already claimed');

        uint96 votes = NounsDAOLogicV1.getReceipt(proposalId, msg.sender).votes;
        require(votes > 0, 'No Votes');

        uint256 rewardAmounts = rewardRate * votes;

        claimedProposal[proposalId][msg.sender] = votes;

        // mint Soul Bount Token
        NounsSoulBoundToken.mintMinter(msg.sender, 1, votes, '');

        // Mint reward token
        _mint(msg.sender, rewardAmounts);
    }

    // claimreward
    function unclaimedProposal() external view returns (uint256[] memory) {
        uint256[] memory proposals;
        uint256 proposalCount = NounsDAOLogicV1.proposalCount();
        uint256 index = 0;

        for (uint256 i = 0; i < proposalCount; i++) {
            uint96 votes = NounsDAOLogicV1.getReceipt(i, msg.sender).votes;

            if (votes > 0 && claimedProposal[i][msg.sender] == 0) {
                proposals[index] = i;
                index++;
            }
        }

        return proposals;
    }
}
