// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./HackathonEscrow.sol";

contract HackathonFactory {
    struct Hackathon {
        string name;
        address escrowContract;
        address organizer;
    }

    Hackathon[] public hackathons;
    mapping(string => address) public hackathonRegistry;
    address public factoryOwner;

    // Custom Errors
    error HackathonFactory__Unauthorized();
    error HackathonFactory__OnlyOrganizerCanAccess();
    error HackathonFactory__OnlyFactoryOwnerCanAccess();
    error HackathonFactory__HackathonNameCannotBeEmpty();
    error HackathonFactory__OrganizerAddressCannotBeZero();
    error HackathonFactory__NewOrganizerAddressCannotBeZero();
    error HackathonFactory__NewOwnerAddressCannotBeZero();
    error HackathonFactory__HackathonAlreadyExists(string name);
    error HackathonFactory__HackathonDoesNotExist(string name);
    error HackathonFactory__IndexOutOfBounds(uint256 index);

    // Events
    event HackathonCreated(string name, address escrowContract, address organizer);
    event HackathonOrganizerUpdated(string name, address oldOrganizer, address newOrganizer);
    event OwnershipTransferred(address oldOwner, address newOwner);

    constructor() {
        factoryOwner = msg.sender;
    }

    // Modifiers
    modifier onlyFactoryOwner() {
        if (msg.sender != factoryOwner) revert HackathonFactory__OnlyFactoryOwnerCanAccess();
        _;
    }

    modifier onlyOrganizer(string memory _name) {
        address escrowAddress = hackathonRegistry[_name];
        if (escrowAddress == address(0)) revert HackathonFactory__HackathonDoesNotExist(_name);
        Hackathon memory hackathon = _getHackathonByName(_name);
        if (msg.sender != hackathon.organizer) revert HackathonFactory__OnlyOrganizerCanAccess();
        _;
    }

    // Create a new Hackathon
    function createHackathon(string memory _name, address _organizer) external onlyFactoryOwner returns (address) {
        if (bytes(_name).length == 0) {
            revert HackathonFactory__HackathonNameCannotBeEmpty();
        }
        if (_organizer == address(0)) {
            revert HackathonFactory__OrganizerAddressCannotBeZero();
        }
        if (hackathonRegistry[_name] != address(0)) {
            revert HackathonFactory__HackathonAlreadyExists(_name);
        }

        HackathonEscrow escrow = new HackathonEscrow(_organizer);

        hackathons.push(Hackathon({name: _name, escrowContract: address(escrow), organizer: _organizer}));
        hackathonRegistry[_name] = address(escrow);

        emit HackathonCreated(_name, address(escrow), _organizer);
        return address(escrow);
    }

    // Get all Hackathons
    function getHackathons() external view returns (Hackathon[] memory) {
        return hackathons;
    }

    // Get Hackathon by name
    function getHackathonByName(string memory _name) external view returns (Hackathon memory) {
        return _getHackathonByName(_name);
    }

    // Get Hackathon by index
    function getHackathonByIndex(uint256 _index) external view returns (Hackathon memory) {
        if (_index >= hackathons.length) revert HackathonFactory__IndexOutOfBounds(_index);
        return hackathons[_index];
    }

    // Update Hackathon organizer
    function updateHackathonOrganizer(string memory _name, address _newOrganizer) external onlyOrganizer(_name) {
        if (_newOrganizer == address(0)) {
            revert HackathonFactory__NewOrganizerAddressCannotBeZero();
        }

        Hackathon storage hackathon = _getHackathonByNameStorage(_name);
        address oldOrganizer = hackathon.organizer;
        hackathon.organizer = _newOrganizer;

        emit HackathonOrganizerUpdated(_name, oldOrganizer, _newOrganizer);
    }

    // Transfer ownership of the factory
    function transferOwnership(address _newOwner) external onlyFactoryOwner {
        if (_newOwner == address(0)) {
            revert HackathonFactory__NewOwnerAddressCannotBeZero();
        }

        address oldOwner = factoryOwner;
        factoryOwner = _newOwner;

        emit OwnershipTransferred(oldOwner, _newOwner);
    }

    // Internal function to get Hackathon by name
    function _getHackathonByName(string memory _name) internal view returns (Hackathon memory) {
        address escrowAddress = hackathonRegistry[_name];
        if (escrowAddress == address(0)) revert HackathonFactory__HackathonDoesNotExist(_name);

        uint256 length = hackathons.length;
        for (uint256 i = 0; i < length;) {
            if (keccak256(bytes(hackathons[i].name)) == keccak256(bytes(_name))) {
                return hackathons[i];
            }
            unchecked {
                ++i;
            }
        }

        revert HackathonFactory__HackathonDoesNotExist(_name);
    }

    // Internal function to get Hackathon by name (storage)
    function _getHackathonByNameStorage(string memory _name) internal view returns (Hackathon storage) {
        address escrowAddress = hackathonRegistry[_name];
        if (escrowAddress == address(0)) revert HackathonFactory__HackathonDoesNotExist(_name);

        uint256 length = hackathons.length;
        for (uint256 i = 0; i < length;) {
            if (keccak256(bytes(hackathons[i].name)) == keccak256(bytes(_name))) {
                return hackathons[i];
            }
            unchecked {
                ++i;
            }
        }

        revert HackathonFactory__HackathonDoesNotExist(_name);
    }
}
