// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Counter
 * @notice Increment, decrement, reset. With access control for giggles.
 *
 * Learning: modifiers, events, require with custom errors.
 */
contract Counter {
    uint256 private count;

    address public owner;

    error NotOwner(address caller);
    error ZeroNotAllowed();

    event CountChanged(uint256 oldValue, uint256 newValue, address indexed by);

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner(msg.sender);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function increment() external {
        uint256 old = count;
        count++;
        emit CountChanged(old, count, msg.sender);
    }

    function decrement() external {
        uint256 old = count;
        if (count == 0) revert ZeroNotAllowed();
        count--;
        emit CountChanged(old, count, msg.sender);
    }

    function reset() external onlyOwner {
        uint256 old = count;
        count = 0;
        emit CountChanged(old, count, msg.sender);
    }

    function value() external view returns (uint256) {
        return count;
    }
}