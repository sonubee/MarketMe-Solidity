pragma solidity ^0.4.18;
import "github.com/ethereum/dapp-bin/library/stringUtils.sol";

contract MarketMe {

    //true false only for now but accepts string, not boolean
    string question;
    mapping(address => string) answer;
    address[] answerArray;
    uint payoutQty;
    uint payoutCounter;
    uint initialFunding;

    //constructor to create question and accept eth
    function MarketMe(string _question, uint _payoutQty) payable public {
        question = _question;
        QuestionCreated(_question, this.balance);
        initialFunding = msg.value;
        payoutQty = _payoutQty;
    }

    event AnswerReceived(
        string answer,
        address answerer
    );

    event QuestionCreated(
        string question,
        uint ethReceived
    );

    function getQuestion() public constant returns (string _question){
        _question = question;
    }

    //anyone can answer question. saves answer into mapping
    function answerQuestion(string _answer) public {
        //verify same person hasn't answered question yet
        if (StringUtils.equal(answer[msg.sender], "")){
            //add answer into map and push into array and set off event
             answer[msg.sender] = _answer;
             answerArray.push(msg.sender);
             AnswerReceived(_answer, msg.sender);

             //if this is the last accepted answer, pay with all ether left (assumes gas is used sending previous ether transactions)
             if (payoutCounter == payoutQty){
                 msg.sender.transfer(this.balance);
             } else { //else send only (initial amount funded divided by payoutQty)
                 msg.sender.transfer(initialFunding/payoutQty);
                 payoutCounter++;
             }

        }
    }

    function getAnswersRemaining() public constant returns (uint answersRemaining){
        answersRemaining = payoutQty - payoutCounter;
    }

    function getPayoutForAnswer() public constant returns (uint payoutForAnswer) {
        if (payoutCounter == payoutQty) { payoutForAnswer = this.balance; }
        else { payoutForAnswer = (initialFunding/payoutQty); }
    }
}
