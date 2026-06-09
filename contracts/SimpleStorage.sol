// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title SimpleStorage
 * @notice My first Solidity contract — store and retrieve a number.
 *
 * Deployed on Arc testnet: 0x...
 */
contract SimpleStorage {
    uint256 private stored;

    event NumberChanged(uint256 oldValue, uint256 newValue);

    function set(uint256 x) external {
        uint256 old = stored;
        stored = x;
        emit NumberChanged(old, x);
    }

    function get() external view returns (uint256) {
        return stored;
    }

    // Gas optimization: combine set + get in one call
    function setAndGet(uint256 x) external returns (uint256) {
        stored = x;
        return x;
    }
}