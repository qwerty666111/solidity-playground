// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Escrow
 * @notice Simple 2-party escrow for Arc.
 *
 * Flow:
 * 1. Buyer deposits ARC (msg.value)
 * 2. Seller delivers goods offchain
 * 3. Buyer approves release → funds go to seller
 * 4. OR timeout passes → buyer can refund
 *
 * Learning: payable, msg.value, timestamps, state machine.
 */
contract Escrow {
    enum State { AWAITING_DEPOSIT, FUNDED, RELEASED, REFUNDED }

    State public state = State.AWAITING_DEPOSIT;

    address public immutable buyer;
    address public immutable seller;
    uint256 public immutable timeout;

    uint256 public depositedAt;
    uint256 public amount;

    event Deposited(uint256 amount);
    event Released(address to, uint256 amount);
    event Refunded(address to, uint256 amount);

    modifier onlyBuyer() {
        require(msg.sender == buyer, "only buyer");
        _;
    }

    modifier inState(State s) {
        require(state == s, "wrong state");
        _;
    }

    constructor(address _seller, uint256 _timeoutHours) payable {
        require(msg.value > 0, "must deposit funds");
        require(_seller != address(0), "zero seller");

        buyer = msg.sender;
        seller = _seller;
        timeout = block.timestamp + (_timeoutHours * 1 hours);

        amount = msg.value;
        state = State.FUNDED;
        depositedAt = block.timestamp;

        emit Deposited(msg.value);
    }

    /**
     * Buyer approves — release funds to seller.
     */
    function release() external onlyBuyer inState(State.FUNDED) {
        state = State.RELEASED;
        (bool ok, ) = seller.call{value: amount}("");
        require(ok, "transfer failed");
        emit Released(seller, amount);
    }

    /**
     * Refund — only after timeout has passed.
     */
    function refund() external onlyBuyer inState(State.FUNDED) {
        require(block.timestamp >= timeout, "timeout not reached");
        state = State.REFUNDED;
        (bool ok, ) = buyer.call{value: amount}("");
        require(ok, "transfer failed");
        emit Refunded(buyer, amount);
    }
}