// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol';
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol';

error FunctionNotSupported();

contract NounsSoulBoundToken is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
    // An address who has permissions to mint Nouns SBT
    address public minter;

    /**
     * @notice Require that the sender is the minter.
     */
    modifier onlyMinter() {
        require(msg.sender == minter, 'Sender is not the minter');
        _;
    }

    constructor(address _minter) ERC1155('') {
        minter = _minter;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mintMinter(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyMinter {
        _mint(account, id, amount, data);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function mintAirdrop(uint256 tier, address[] calldata holders) external onlyOwner {
        for (uint256 i = 0; i < holders.length; i++) {
            _mint(holders[i], tier, 1, '');
        }
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    /*
     * All functions having to do with the transfer of the NFT's have been overridden.
     * Although the approval functions don't need to be overridden, there is no use
     * for them, so I am overriding to save users gas in case they try and execute them.
     */
    function setApprovalForAll(address, bool) public pure override {
        revert FunctionNotSupported();
    }

    function safeTransferFrom(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public pure override {
        revert FunctionNotSupported();
    }

    function safeBatchTransferFrom(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public pure override {
        revert FunctionNotSupported();
    }
}
