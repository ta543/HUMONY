
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IPaymaster {
    function deposit() external payable;
    function withdraw() external;
}

contract StorageContract is Pausable, Ownable, IPaymaster {
    struct File {
        string hash; // IPFS hash
        uint256 timestamp; // Timestamp of the last proof of retention
    }

    mapping(address => File[]) public storageNodes;
    mapping(address => uint256) public deposits;

    event FileStored(address indexed node, string hash);
    event FileRetrieved(address indexed node, string hash, uint256 timestamp);
    event ProofVerified(address indexed node, string hash);

    function deposit() public payable override {
        deposits[msg.sender] += msg.value;
    }

    function withdraw() public override {
        require(deposits[msg.sender] > 0, "No deposit to withdraw");
        uint256 amount = deposits[msg.sender];
        deposits[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function storeFile(string memory _hash, address _node) public {
        require(deposits[_node] > 0, "Node must have a deposit");
        storageNodes[_node].push(File(_hash, block.timestamp));
        emit FileStored(_node, _hash);
    }

    function retrieveFile(address _node, uint index) public view returns (string memory, uint256) {
        File memory file = storageNodes[_node][index];
        emit FileRetrieved(_node, file.hash, file.timestamp);
        return (file.hash, file.timestamp);
    }

    function verifyProof(address _node, uint index) public returns (bool) {
        File storage file = storageNodes[_node][index];
        file.timestamp = block.timestamp; // Simulating proof of retention update
        emit ProofVerified(_node, file.hash);
        return true;
    }
}

