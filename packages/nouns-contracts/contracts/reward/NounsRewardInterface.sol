// SPDX-License-Identifier: BSD-3-Clause

/// @title Nouns DAO Logic V1 interfaces and events

pragma solidity ^0.8.6;

interface INounsDAOLogicV1 {
    /// @notice Ballot receipt record for a voter
    struct Receipt {
        /// @notice Whether or not a vote has been cast
        bool hasVoted;
        /// @notice Whether or not the voter supports the proposal or abstains
        uint8 support;
        /// @notice The number of votes the voter had, which were cast
        uint96 votes;
    }

    enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed,
        Vetoed
    }

    function getReceipt(uint256 proposalId, address voter) external view returns (Receipt memory);

    function proposalCount() external view returns (uint256);

    function state(uint256 proposalId) external view returns (ProposalState);
}

interface INounsSoulBoundToken {
    function mintMinter(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external;
}
