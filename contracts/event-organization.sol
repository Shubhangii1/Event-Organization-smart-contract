// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
contract Eventcontract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;
   function createEvent(string memory name, uint date, uint price, uint ticketcount, uint ticketRemain) external{
       require(date>block.timestamp, "You can organise event for future date");
       require(ticketcount>0,"You can organise event only if you create more than 0 tickets");
       events[nextId] = Event(msg.sender, name, date, price, ticketcount, ticketRemain);
       nextId;
   }
   function buyTicket(uint id, uint quantity) external payable{
       require(events[id].date!=0, "This event doesnot exist");
       require(events[id].date>block.timestamp, "Event has already began");
       Event storage _event = events[id];
       require(msg.value==(_event.price*quantity), "Ether is not enough");
       require(_event.ticketRemain>=quantity, "Not enough tickets");
       _event.ticketRemain-=quantity;
       tickets[msg.sender][id]+=quantity;
   }
   function transferTickets(uint id, uint quantity, address to) external{
       require(events[id].date!=0, "This event doesnot exist");
       require(events[id].date>block.timestamp, "Event has already began");
       require(tickets[msg.sender][id]>=quantity, "You don't have enough ticket");
       tickets[msg.sender][id]-=quantity;
       tickets[to][id]+=quantity;
   }

}
