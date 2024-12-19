// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract HackathonEscrow is ReentrancyGuard {
    using SafeERC20 for IERC20;

    error HackathonEscrow__OnlyOrganizerCanAccess();
    error HackathonEscrow__OnlySponsorCanAccess();
    error HackathonEscrow__ConfigurationLocked();
    error HackathonEscrow__ChallengeDoesNotExist();
    error HackathonEscrow__OrganizerAddressCannotBeZero();
    error HackathonEscrow__InvalidTokenOrAmount();
    error HackathonEscrow__ChallengeAlreadyConfigured();
    error HackathonEscrow__InvalidTokenOrPrize();
    error HackathonEscrow__TotalPercentageIsNotOneHundred();
    error HackathonEscrow__ChallengeIsNotConfigured();
    error HackathonEscrow__WinnersAreNotEqualToPrizeAllocations();
    error HackathonEscrow__WinnerAlreadyAdded();
    error HackathonEscrow__ChallengeIsAlreadyPaidOut();
    error HackathonEscrow__OrganizerAlreadyApproved();
    error HackathonEscrow__SponsorAlreadyApproved();
    error HackathonEscrow__UnauthorizedAccess();
    error HackathonEscrow__NotEnoughApprovals();
    error HackathonEscrow__SponsorNameCannotBeEmpty();

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
    Approval public approval;
    Challenge public challenge;
    PrizeAllocation public allocation;

    // Mappings
    mapping(uint256 => Challenge) public challenges;
    mapping(uint256 => Approval) public challengeApprovals;

    // Events
    event SponsorAdded(address indexed sponsor);
    event FundsDeposited(address indexed sponsor, uint256 challengeId, uint256 amount);
    event ChallengeAdded(uint256 indexed challengeId, string sponsorName);
    event ChallengeConfigured(
        uint256 indexed challengeId, uint256 prize, address token, PrizeAllocation[] prizeAllocations
    );
    event WinnersAdded(uint256 indexed challengeId, PrizeAllocation[] winners);
    event FundsApproved(uint256 indexed challengeId, address approver);
    event FundsDistributed(uint256 indexed challengeId, PrizeAllocation[] winners);
    event ConfigurationLockedEvent();

    // Modifiers
    modifier onlyOrganizer() {
        if (msg.sender != organizer) revert HackathonEscrow__OnlyOrganizerCanAccess();
        _;
    }

    modifier onlySponsor(uint256 _challengeId) {
        if (challenges[_challengeId].sponsor != msg.sender) {
            revert HackathonEscrow__OnlySponsorCanAccess();
        }
        _;
    }

    modifier beforeLock() {
        if (isConfigurationLocked) revert HackathonEscrow__ConfigurationLocked();
        _;
    }

    modifier challengeExists(uint256 _challengeId) {
        if (bytes(challenges[_challengeId].sponsorName).length == 0) {
            revert HackathonEscrow__ChallengeDoesNotExist();
        }
        _;
    }

    constructor(address _organizer) {
        if (_organizer == address(0)) revert HackathonEscrow__OrganizerAddressCannotBeZero();
        organizer = _organizer;
        challengeCount = 0;
    }

    // Add Challenge
    function addChallenge(string calldata _sponsorName) external beforeLock {
        // what exactly is the purpose of this check?????
        if (bytes(_sponsorName).length == 0) revert HackathonEscrow__SponsorNameCannotBeEmpty();

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
    function depositFunds(uint256 _challengeId, uint256 _amount, address _token)
        external
        onlySponsor(_challengeId)
        beforeLock
        challengeExists(_challengeId)
    {
        if (_amount == 0 || _token == address(0)) revert HackathonEscrow__InvalidTokenOrAmount();

        // Transfer tokens to contract with strict validation
        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);

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
        challenge = challenges[_challengeId];

        if (challenge.isConfigured) revert HackathonEscrow__ChallengeAlreadyConfigured();
        if (_totalPrize == 0 || _token == address(0)) revert HackathonEscrow__InvalidTokenOrPrize();

        uint256 totalPercentage;
        for (uint256 i = 0; i < _prizeAllocations.length; i++) {
            totalPercentage += _prizeAllocations[i].percentage;
        }
        if (totalPercentage != 100) revert HackathonEscrow__TotalPercentageIsNotOneHundred();

        challenge.totalPrize = _totalPrize;
        challenge.token = _token;
        challenge.isConfigured = true;

        delete challenge.prizeAllocations;
        for (uint256 i = 0; i < _prizeAllocations.length; i++) {
            challenge.prizeAllocations.push(_prizeAllocations[i]);
        }

        emit ChallengeConfigured(_challengeId, _totalPrize, _token, _prizeAllocations);
    }

    // Add Winners
    function addWinners(uint256 _challengeId, address[] calldata _winners)
        external
        onlyOrganizer
        challengeExists(_challengeId)
    {
        challenge = challenges[_challengeId];
        if (!challenge.isConfigured) revert HackathonEscrow__ChallengeIsNotConfigured();
        if (_winners.length != challenge.prizeAllocations.length) {
            revert HackathonEscrow__WinnersAreNotEqualToPrizeAllocations();
        }

        // Validate winners are unique
        for (uint256 i = 0; i < _winners.length; i++) {
            for (uint256 j = i + 1; j < _winners.length; j++) {
                if (_winners[i] == _winners[j]) revert HackathonEscrow__WinnerAlreadyAdded();
            }
            challenge.prizeAllocations[i].winner = _winners[i];
        }

        // are the parameters indexed well?????
        emit WinnersAdded(_challengeId, challenge.prizeAllocations);
    }

    // Distribute Funds
    function distributeFunds(uint256 _challengeId)
        external
        nonReentrant
        onlySponsor(_challengeId)
        challengeExists(_challengeId)
    {
        challenge = challenges[_challengeId];
        approval = challengeApprovals[_challengeId];

        if (!approval.organizerApproved || !approval.sponsorApproved) {
            revert HackathonEscrow__NotEnoughApprovals();
        }
        if (challenge.isPaidOut) revert HackathonEscrow__ChallengeIsAlreadyPaidOut();
        // @ybtuti This should be <= not <
        for (uint256 i = 0; i <= challenge.prizeAllocations.length; i++) {
            allocation = challenge.prizeAllocations[i];
            // total prize = 400
            // allocation = 54
            // 400 * 54 / 100 =
            // Looks good!!!!
            uint256 prizeAmount = (challenge.totalPrize * allocation.percentage) / 100;

            IERC20(challenge.token).safeTransfer(allocation.winner, prizeAmount);
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
    function approveFundsDistribution(uint256 _challengeId) external challengeExists(_challengeId) {
        approval = challengeApprovals[_challengeId];

        if (msg.sender == organizer) {
            if (approval.organizerApproved) revert HackathonEscrow__OrganizerAlreadyApproved();
            approval.organizerApproved = true;
        } else if (challenges[_challengeId].sponsor == msg.sender) {
            if (approval.sponsorApproved) revert HackathonEscrow__SponsorAlreadyApproved();
            approval.sponsorApproved = true;
        } else {
            revert HackathonEscrow__UnauthorizedAccess();
        }

        // will the approver always be msg.sender????
        emit FundsApproved(_challengeId, msg.sender);
    }
}

// Do we need to declare all the parameters in the constructor during deployment?? since
// Add function modify the sponsor address and the organizer address
