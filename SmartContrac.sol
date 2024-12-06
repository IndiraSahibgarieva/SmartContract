// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    // Участники сделки
    address public payer; // Лицо, вносящее средства
    address public payee; // Лицо, получающее средства
    address public arbiter; // Арбитр (может подтвердить или отклонить выплату)
    uint public amount; // Сумма сделки

    // Статус сделки
    bool public isFundsReleased = false;

    // События
    event FundsDeposited(address indexed from, uint amount);
    event FundsReleased(address indexed to, uint amount);

    // Конструктор для создания контракта
    constructor(address _payee, address _arbiter) payable {
        require(msg.value > 0, "Must send some Ether to initialize the contract");
        payer = msg.sender;
        payee = _payee;
        arbiter = _arbiter;
        amount = msg.value;
    }

    // Функция для подтверждения арбитром
    function releaseFunds() public {
        require(msg.sender == arbiter, "Only arbiter can release funds");
        require(!isFundsReleased, "Funds already released");

        isFundsReleased = true;
        payable(payee).transfer(amount);

        emit FundsReleased(payee, amount);
    }

    // Функция для возврата средств (в случае отмены)
    function refund() public {
        require(msg.sender == arbiter, "Only arbiter can refund");
        require(!isFundsReleased, "Funds already released");

        isFundsReleased = true;
        payable(payer).transfer(amount);
    }
}
