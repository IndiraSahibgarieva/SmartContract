// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ClinicFundingEscrow {
    // Участники сделки
    address public investor; // Лицо, вносящее средства (инвестор)
    address public clinicRecipient; // Клиника, получающая средства
    address public fundingArbiter; // Арбитр, проверяющий условия сделки
    uint public tokenAmount; // Количество токенов для сделки
    uint public tokenPrice; // Стоимость одного токена в wei
    uint public fundingDeadline; // Дедлайн для завершения сделки

    // Сумма сделки в wei
    uint public totalAmount;
    
    // Статус сделки
    bool public isFundingReleased = false;

    // События
    event TokensDeposited(address indexed from, uint amount);
    event TokensReleased(address indexed to, uint amount);
    event TokensRefunded(address indexed to, uint amount);

    // Конструктор для создания контракта
    constructor(address _clinicRecipient, address _fundingArbiter, uint _fundingDeadline, uint _tokenAmount, uint _tokenPrice) {
        require(_tokenAmount > 0, "Token amount must be greater than zero");
        require(_tokenPrice > 0, "Token price must be greater than zero");
        require(_fundingDeadline > block.timestamp, "Deadline must be in the future");

        investor = msg.sender;
        clinicRecipient = _clinicRecipient;
        fundingArbiter = _fundingArbiter;
        tokenAmount = _tokenAmount;
        tokenPrice = _tokenPrice;
        totalAmount = tokenAmount * tokenPrice;
        fundingDeadline = _fundingDeadline;
    }

    // Функция для подтверждения арбитром
    function releaseTokens() public {
        require(msg.sender == fundingArbiter, "Only arbiter can release tokens");
        require(!isFundingReleased, "Tokens already released");
        require(block.timestamp <= fundingDeadline, "Cannot release tokens after the deadline");

        isFundingReleased = true;
        emit TokensReleased(clinicRecipient, tokenAmount);
    }

    // Функция для возврата токенов до дедлайна
    function refundBeforeDeadline() public {
        require(msg.sender == fundingArbiter, "Only arbiter can refund");
        require(!isFundingReleased, "Tokens already released");
        require(block.timestamp <= fundingDeadline, "Deadline has passed");

        isFundingReleased = true;
        emit TokensRefunded(investor, tokenAmount);
    }

    // Функция для возврата токенов после дедлайна
    function refundAfterDeadline() public {
        require(msg.sender == fundingArbiter || msg.sender == investor, "Only arbiter or investor can refund after deadline");
        require(!isFundingReleased, "Tokens already released");
        require(block.timestamp > fundingDeadline, "Deadline has not passed yet");

        isFundingReleased = true;
        emit TokensRefunded(investor, tokenAmount);
    }
}
