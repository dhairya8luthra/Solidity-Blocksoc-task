// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

contract ZestMoney {
    struct User {
        string username;
        string password;
        address userKey;
        bool isRegistered;
    }

    mapping(address => User) public users;

    event UserRegistered(string username, address userKey);
    event EtherTransferred(address from, address to, uint256 amount);

    function registerUser(
        string memory _username,
        string memory _password,
        address _userKey
    ) public {
        require(!users[_userKey].isRegistered, "User already registered");

        users[_userKey] = User({
            username: _username,
            password: _password,
            userKey: _userKey,
            isRegistered: true
        });

        emit UserRegistered(_username, _userKey);
    }

    function transferEther(
        string memory _username,
        string memory _password,
        address payable _to,
        uint256 _amount
    ) public payable {
        User memory user = users[msg.sender];

        require(user.isRegistered, "User not registered");
        require(keccak256(abi.encodePacked(_username)) == keccak256(abi.encodePacked(user.username)), "Incorrect username");
        require(keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(user.password)), "Incorrect password");
        require(msg.value == _amount, "Incorrect amount sent");
        require(address(this).balance >= _amount, "Insufficient contract balance");

        _to.transfer(_amount);
        emit EtherTransferred(msg.sender, _to, _amount);
    }

}
