pragma solidity ^0.4.18;
import 'strings.sol';

contract MarketMe {

    //true false only for now but accepts string, not boolean
    string question;
    mapping(address => string) answer;

    //constructor to create question and accept eth
    function MarketMe(string _question) payable public {
        question = _question;
        this.balance += msg.value;
        QuestionCreated(_question, this.balance);
    }

    event AnswerReceived(
        string answer,
        address answerer
    );

    event QuestionCreated(
        string question,
        uint ethSent
    );

    //anyone can answer question. saves answer into mapping
    function answerQuestion(string _answer) public {
        if (StringUtils.equal(answer[msg.sender], "")){
             answer[msg.sender] = _answer;
             AnswerReceived(_answer, msg.sender);
        }
    }
}
