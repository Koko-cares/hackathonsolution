# Hackathon Solution Contracts

This repository contains two Solidity smart contracts designed for managing hackathons in a decentralized manner: **HackathonFactory** and **HackathonEscrow**. Together, they provide a framework for creating, organizing, and managing hackathons on the blockchain, including features for distributing funds securely.

---

## Contracts Overview

### 1. **HackathonFactory**
The `HackathonFactory` contract serves as the central hub for creating and managing hackathons. It allows organizers to deploy individual `HackathonEscrow` contracts for their events and provides a registry for all hackathons.

#### Features
- **Create Hackathons**: Deploys a new `HackathonEscrow` contract and associates it with the organizer and hackathon name.
- **List Hackathons**: Allows retrieval of all hackathons or specific hackathons by name or index.
- **Update Organizer**: Enables the hackathon organizer to transfer the organizer role to another address.
- **Factory Ownership**: Provides administrative control over the factory, including transferring ownership.

---

### 2. **HackathonEscrow**
The `HackathonEscrow` contract is responsible for securely managing the funds and operations of a specific hackathon. It supports adding challenges, distributing funds to winners, and ensures only authorized users (organizer or sponsor) can modify the hackathon’s state.

#### Features
- **Add Challenges**: Organizers or sponsors can define challenges with prize funds and a sponsor name.
- **Distribute Funds**: Handles payouts to challenge winners.
- **Challenge Validation**: Ensures stricter rules for challenge creation and winner assignment.
- **Restricted Access**: Only the organizer or sponsor can manage challenges and winners.

---

## Contract Details

### HackathonFactory.sol

#### State Variables
1. **`Hackathon[] hackathons`**: Stores an array of all hackathons.
2. **`mapping(string => address) hackathonRegistry`**: Maps hackathon names to their respective `HackathonEscrow` contract addresses.
3. **`address factoryOwner`**: The owner of the factory contract, responsible for administrative actions.

#### Functions
1. **`createHackathon(string memory _name, address _organizer)`**
   - Deploys a new `HackathonEscrow` contract.
   - Registers the hackathon in the registry.
   - Emits the `HackathonCreated` event.
   - *Validation*: Ensures the hackathon name is unique and the organizer's address is valid.

2. **`getHackathons()`**
   - Returns an array of all hackathons.

3. **`getHackathonByName(string memory _name)`**
   - Fetches a hackathon's details by its name.
   - *Reverts*: If the hackathon does not exist.

4. **`getHackathonByIndex(uint256 _index)`**
   - Returns the hackathon at the specified index.
   - *Reverts*: If the index is out of bounds.

5. **`updateHackathonOrganizer(string memory _name, address _newOrganizer)`**
   - Updates the organizer for a specific hackathon.
   - Restricted to the current organizer of the hackathon.

6. **`removeHackathon(string memory _name)`**
   - Removes a hackathon from the registry.
   - Restricted to the organizer.

7. **`transferOwnership(address _newOwner)`**
   - Transfers ownership of the factory to another address.
   - Restricted to the current factory owner.

#### Events
- **`HackathonCreated(string name, address escrowContract, address organizer)`**
  - Emitted when a new hackathon is created.
- **`HackathonOrganizerUpdated(string name, address oldOrganizer, address newOrganizer)`**
  - Emitted when a hackathon's organizer is updated.
- **`HackathonRemoved(string name, address escrowContract)`**
  - Emitted when a hackathon is removed.
- **`OwnershipTransferred(address oldOwner, address newOwner)`**
  - Emitted when the factory ownership changes.

---

### HackathonEscrow.sol

#### State Variables
1. **`address public organizer`**: Address of the hackathon organizer.
2. **`Challenge[] public challenges`**: Array of challenges for the hackathon.
3. **`mapping(uint256 => address[]) public winners`**: Maps challenge IDs to their respective winners.
4. **`uint256 public totalFunds`**: Total funds deposited in the contract.

#### Structs
- **Challenge**
  - `string description`: Description of the challenge.
  - `uint256 prize`: Prize amount for the challenge.
  - `address sponsor`: Address of the challenge sponsor.
  - `string sponsorName`: Name of the challenge sponsor.

#### Functions
1. **`addChallenge(string memory _description, uint256 _prize, string memory _sponsorName)`**
   - Adds a new challenge to the hackathon.
   - Restricted to the organizer or a sponsor.
   - *Validation*: Ensures sufficient funds are available for the prize.

2. **`addWinners(uint256 _challengeId, address[] memory _winners)`**
   - Assigns winners to a challenge.
   - Restricted to the organizer.
   - *Validation*: Checks that winners are unique and the challenge exists.

3. **`distributeFunds(uint256 _challengeId)`**
   - Distributes prize funds to the winners of a challenge.
   - Restricted to the organizer.
   - *Validation*: Ensures funds are available and winners are set.

4. **`depositFunds()`**
   - Allows anyone to deposit funds into the contract.

5. **`getChallenges()`**
   - Returns all challenges for the hackathon.

6. **`getWinners(uint256 _challengeId)`**
   - Returns the winners for a specific challenge.

#### Events
- **`ChallengeAdded(string description, uint256 prize, address sponsor)`**
  - Emitted when a new challenge is added.
- **`WinnersAssigned(uint256 challengeId, address[] winners)`**
  - Emitted when winners are assigned to a challenge.
- **`FundsDistributed(uint256 challengeId, uint256 totalPrize)`**
  - Emitted when funds are distributed for a challenge.

---

## Security

1. **Restricted Access**:
   - Only organizers or sponsors can manage challenges.
   - Only organizers can assign winners and distribute funds.
2. **Validation**:
   - Stricter checks to prevent duplicate hackathons, invalid winners, and insufficient funds.
3. **Escrow**:
   - Funds are securely held in the `HackathonEscrow` contract until distributed.

