// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {

    struct Option {
        string name;
        uint voteCount;
    }

    struct VotingSession {
        string topic;
        Option[] options;
        mapping(address => uint) votes;
    }

    VotingSession[] public votingSessions;

    // Добавление опции в массив options
    function addOption(VotingSession storage sessionDetails, string memory optionName) internal {
        sessionDetails.options.push(Option({name: optionName, voteCount: 0}));
    }

    // Создание новой сессии голосования
    function createVotingSession(string memory _topic, string[] memory _options) public {
        VotingSession storage newSession = votingSessions.push();
        newSession.topic = _topic;

        for (uint i = 0; i < _options.length; i++) {
            addOption(newSession, _options[i]);
        }
    }

    // Голосование за определенный вариант
    function vote(uint sessionId, uint optionId) public {
        require(sessionId < votingSessions.length, "Invalid session ID");
        VotingSession storage session = votingSessions[sessionId];
        require(optionId < session.options.length, "Invalid option ID");
        require(session.votes[msg.sender] == 0, "You have already voted");

        session.votes[msg.sender] = optionId + 1; // +1, чтобы избежать 0 в качестве дефолтного значения

        // Увеличение счетчика голосов для выбранной опции
        session.options[optionId].voteCount++;
    }


    // Получение списка всех тем сессий голосования
    function getAllVotingSessionTopics() public view returns (string[] memory) {
        string[] memory sessionTopics = new string[](votingSessions.length);
        for (uint i = 0; i < votingSessions.length; i++) {
            sessionTopics[i] = votingSessions[i].topic;
        }
        return sessionTopics;
    }

    // Получение результатов конкретной сессии голосования
    function getSessionResults(uint sessionId) public view returns (Option[] memory) {
        require(sessionId < votingSessions.length, "Invalid session ID");
        return votingSessions[sessionId].options;
    }

    // Получение деталей конкретной сессии голосования (темы и опций)
    function getVotingSessionDetails(uint sessionId) public view returns (string memory, Option[] memory) {
        require(sessionId < votingSessions.length, "Invalid session ID");
        VotingSession storage session = votingSessions[sessionId];
        return (session.topic, session.options);
    }
}
