//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract EventContract {
    struct Event {
        address organizer;
        string name;
        string description;
        uint256 date;
        uint256 price;
        uint256 ticketCount;
        uint256 ticketRemaining;
        uint256 id;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextId;

    event EventCreated(Event _event);
    event TicketSold(Event _event, uint256 quantity, address to);
    event TicketTransfered(
        Event _event,
        uint256 quantity,
        address from,
        address to
    );

    function createEvent(
        string memory name,
        string memory description,
        uint256 date,
        uint256 price,
        uint256 ticketCount
    ) external {
        require(
            bytes(name).length != 0,
            "Event name must be more than 0 character"
        );
        require(date > block.timestamp, "Event date should be of future");
        require(
            ticketCount > 0,
            "You should have atleast 1 ticket for any event!"
        );

        events[nextId] = Event(
            msg.sender,
            name,
            description,
            date,
            price,
            ticketCount,
            ticketCount,
            nextId
        );
        nextId++;

        emit EventCreated(events[nextId - 1]);
    }

    function buyTicket(uint256 eventId, uint256 quantity) external payable {
        Event storage _event = events[eventId];

        require(_event.date != 0, "Event doesn't exist!");
        require(_event.date > block.timestamp, "Event already over!");
        require(_event.ticketRemaining >= quantity, "Not enough tickets");

        uint256 requiredAmount = _event.price * quantity;
        require(requiredAmount <= msg.value, "Ether is not enough!");

        _event.ticketRemaining -= quantity;
        tickets[msg.sender][eventId] += quantity;

        uint256 amount = msg.value;

        if (amount > requiredAmount) {
            (bool _sent, bytes memory _data) = payable(msg.sender).call{
                value: (amount - requiredAmount)
            }("");
            require(_sent, "Failed to send Ether");
        }

        (bool sent, bytes memory data) = payable(_event.organizer).call{
            value: requiredAmount
        }("");
        require(sent, "Failed to send Ether");

        emit TicketSold(_event, quantity, msg.sender);
    }

    function transferTicket(
        uint256 eventId,
        uint256 quantity,
        address to
    ) external {
        Event storage _event = events[eventId];

        require(_event.date != 0, "Event doesn't exist!");
        require(_event.date > block.timestamp, "Event already over!");
        require(
            tickets[msg.sender][eventId] >= quantity,
            "Not enough tickets to transfer!"
        );

        tickets[msg.sender][eventId] -= quantity;
        tickets[to][eventId] += quantity;

        emit TicketTransfered(_event, quantity, msg.sender, to);
    }
}
