// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract HackathonEscrow is ReentrancyGuard {
    error InvalidInput();
    error UnauthorizedAccess();
    error InsufficientFunds();
    error AlreadyApproved();
    error NotEnoughApprovals();
    error ConfigurationLocked();
    error ChallengeDoesNotExist();
    error InvalidERC20Transfer();
    error WinnerAlreadyAdded();
    error ChallengeAlreadyConfigured();

    struct PrizeAllocation {
        uint8 position;
        uint8 percentage;
        address winner;
    }

    struct Challenge {
        uint256 totalPrize;
        string sponsorName;
        address sponsor;
        bool isPaidOut;
        address token;
        PrizeAllocation[] prizeAllocations;
        bool isConfigured;
    }

    struct Approval {
        bool sponsorApproved;
        bool organizerApproved;
    }

    // State Variables
    address public immutable organizer;
    uint256 public challengeCount;
    bool public isConfigurationLocked;

    // Mappings
    mapping(uint256 => Challenge) public challenges;
    mapping(uint256 => Approval) public challengeApprovals;

    // Events
    event SponsorAdded(address indexed sponsor);
    event FundsDeposited(
        address indexed sponsor,
        uint256 challengeId,
        uint256 amount
    );
    event ChallengeAdded(uint256 indexed challengeId, string sponsorName);
    event ChallengeConfigured(
        uint256 indexed challengeId,
        uint256 prize,
        address token,
        PrizeAllocation[] prizeAllocations
    );
    event WinnersAdded(uint256 indexed challengeId, PrizeAllocation[] winners);
    event FundsApproved(uint256 indexed challengeId, address approver);
    event FundsDistributed(
        uint256 indexed challengeId,
        PrizeAllocation[] winners
    );
    event ConfigurationLockedEvent();

    // Modifiers
    modifier onlyOrganizer() {
        if (msg.sender != organizer) revert UnauthorizedAccess();
        _;
    }

    modifier onlySponsor(uint256 _challengeId) {
        if (challenges[_challengeId].sponsor != msg.sender)
            revert UnauthorizedAccess();
        _;
    }

    modifier beforeLock() {
        if (isConfigurationLocked) revert ConfigurationLocked();
        _;
    }

    modifier challengeExists(uint256 _challengeId) {
        if (bytes(challenges[_challengeId].sponsorName).length == 0) {
            revert ChallengeDoesNotExist();
        }
        _;
    }

    constructor(address _organizer) {
        if (_organizer == address(0)) revert InvalidInput();
        organizer = _organizer;
    }

    // Add Challenge
    function addChallenge(string calldata _sponsorName) external beforeLock {
        if (bytes(_sponsorName).length == 0) revert InvalidInput();

        uint256 challengeId = challengeCount++;
        challenges[challengeId] = Challenge({
            totalPrize: 0,
            sponsorName: _sponsorName,
            sponsor: msg.sender,
            isPaidOut: false,
            token: address(0),
            prizeAllocations: new PrizeAllocation[](0),
            isConfigured: false
        });

        emit ChallengeAdded(challengeId, _sponsorName);
    }

    // Deposit Funds
    function depositFunds(
        uint256 _challengeId,
        uint256 _amount,
        address _token
    )
        external
        onlySponsor(_challengeId)
        beforeLock
        challengeExists(_challengeId)
    {
        if (_amount == 0 || _token == address(0)) revert InvalidInput();

        // Transfer tokens to contract with strict validation
        bool success = IERC20(_token).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        if (!success) revert InvalidERC20Transfer();

        challenges[_challengeId].totalPrize += _amount;
        challenges[_challengeId].token = _token;

        emit FundsDeposited(msg.sender, _challengeId, _amount);
    }

    // Configure Challenge
    function configureChallenge(
        uint256 _challengeId,
        uint256 _totalPrize,
        address _token,
        PrizeAllocation[] memory _prizeAllocations
    ) external onlyOrganizer beforeLock challengeExists(_challengeId) {
        Challenge storage challenge = challenges[_challengeId];

        if (challenge.isConfigured) revert ChallengeAlreadyConfigured();
        if (_totalPrize == 0 || _token == address(0)) revert InvalidInput();

        uint256 totalPercentage;
        for (uint i = 0; i < _prizeAllocations.length; i++) {
            totalPercentage += _prizeAllocations[i].percentage;
        }
        if (totalPercentage != 100) revert InvalidInput();

        challenge.totalPrize = _totalPrize;
        challenge.token = _token;
        challenge.isConfigured = true;

        delete challenge.prizeAllocations;
        for (uint i = 0; i < _prizeAllocations.length; i++) {
            challenge.prizeAllocations.push(_prizeAllocations[i]);
        }

        emit ChallengeConfigured(
            _challengeId,
            _totalPrize,
            _token,
            _prizeAllocations
        );
    }

    // Add Winners
    function addWinners(
        uint256 _challengeId,
        address[] calldata _winners
    ) external onlyOrganizer challengeExists(_challengeId) {
        Challenge storage challenge = challenges[_challengeId];

        if (!challenge.isConfigured) revert InvalidInput();
        if (_winners.length != challenge.prizeAllocations.length)
            revert InvalidInput();

        // Validate winners are unique
        for (uint i = 0; i < _winners.length; i++) {
            for (uint j = i + 1; j < _winners.length; j++) {
                if (_winners[i] == _winners[j]) revert WinnerAlreadyAdded();
            }
            challenge.prizeAllocations[i].winner = _winners[i];
        }

        emit WinnersAdded(_challengeId, challenge.prizeAllocations);
    }

    // Distribute Funds
    function distributeFunds(
        uint256 _challengeId
    )
        external
        nonReentrant
        onlySponsor(_challengeId)
        challengeExists(_challengeId)
    {
        Challenge storage challenge = challenges[_challengeId];
        Approval storage approval = challengeApprovals[_challengeId];

        if (!approval.organizerApproved || !approval.sponsorApproved)
            revert NotEnoughApprovals();
        if (challenge.isPaidOut) revert InvalidInput();

        for (uint i = 0; i < challenge.prizeAllocations.length; i++) {
            PrizeAllocation memory allocation = challenge.prizeAllocations[i];
            uint256 prizeAmount = (challenge.totalPrize *
                allocation.percentage) / 100;

            bool success = IERC20(challenge.token).transfer(
                allocation.winner,
                prizeAmount
            );
            if (!success) revert InvalidERC20Transfer();
        }

        challenge.isPaidOut = true;

        emit FundsDistributed(_challengeId, challenge.prizeAllocations);
    }

    // Lock Configuration
    function lockConfiguration() external beforeLock onlyOrganizer {
        isConfigurationLocked = true;
        emit ConfigurationLockedEvent();
    }

    // Approve Funds
    function approveFundsDistribution(
        uint256 _challengeId
    ) external challengeExists(_challengeId) {
        Approval storage approval = challengeApprovals[_challengeId];

        if (msg.sender == organizer) {
            if (approval.organizerApproved) revert AlreadyApproved();
            approval.organizerApproved = true;
        } else if (challenges[_challengeId].sponsor == msg.sender) {
            if (approval.sponsorApproved) revert AlreadyApproved();
            approval.sponsorApproved = true;
        } else {
            revert UnauthorizedAccess();
        }

        emit FundsApproved(_challengeId, msg.sender);
    }
}
