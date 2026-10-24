// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title MartinLutherAIToken
 * @notice Global Civil Rights, Conscience Reformation & Beloved Community Launchpad ($MLUTHER)
 * @dev Direct micro-escrows for civil rights legal defense, racial reconciliation, and non-violent peace
 */
contract MartinLutherAIToken {
    string public name = "Martin Luther AI";
    string public symbol = "MLUTHER";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    uint256 public constant INITIAL_PRICE = 0.0001 ether;
    uint256 public constant CURVE_SLOPE = 1e10;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event CurveMint(address indexed reformer, uint256 tokenAmount, uint256 ethDonation);
    event CivilRightsDisbursement(string indexed causeType, address indexed activist, uint256 amountWei, bytes32 indexed moralProof);

    function calculateCost(uint256 amount) public view returns (uint256) {
        uint256 currentSupply = totalSupply;
        uint256 baseCost = amount * INITIAL_PRICE;
        uint256 curveFactor = (CURVE_SLOPE * ((currentSupply + amount)**2 - currentSupply**2)) / 2e18;
        return baseCost + curveFactor;
    }

    function mint(uint256 amount) external payable returns (bool) {
        require(amount > 0, "Zero donation amount");
        uint256 cost = calculateCost(amount);
        require(msg.value >= cost, "Insufficient donation for bonding curve");

        totalSupply += amount;
        balanceOf[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
        emit CurveMint(msg.sender, amount, cost);

        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }
        return true;
    }

    function disburseCivilRightsGrant(
        string memory causeType,
        address activist,
        uint256 amount,
        bytes32 moralProof
    ) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient freedom treasury reserve");
        balanceOf[msg.sender] -= amount;
        balanceOf[activist] += amount;
        emit Transfer(msg.sender, activist, amount);
        emit CivilRightsDisbursement(causeType, activist, amount, moralProof);
        return true;
    }
}
