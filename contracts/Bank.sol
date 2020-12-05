pragma solidity ^0.5.8;

import "browser/ERC20.sol";
import "browser/ZUTtoken.sol";

contract Bank is ZUTtoken {
    address _owner;
    uint256 private loansCount = 0;
    uint256 private guaranteesCount = 0;
    mapping(uint256 => Loan) private loans;
    mapping(uint256 => Guarantee) private guarantees;
    mapping(uint256 => address payable) private lenders;

    constructor() public {
        _owner = msg.sender;
    }

    struct Loan {
        address payable loanee;
        uint256 etherBorrow;
        uint256 index;
        uint256 payBackDate;
        uint256 etherInterest;
        bool _isGuaranteeProvided;
        bool _isLoanProvided;
        bool _isLoanExist;
    }

    struct Guarantee {
        address payable guarantor;
        uint256 etherInterest;
        uint256 loanIndex;
        bool _isWaitingForHandling;
        bool _isGuaranteeExist;
    }

    function _giveZUTtokenTo(address _account) public {
        require(
            _owner == msg.sender,
            "Only owner of the smart contract can call this function"
        );
        require(balanceOf(msg.sender) != 0, "Tokens are over");

        approve(_account, 1);
        transfer(_account, 1);
    }

    function _giveApproveTo(address _account, uint256 amount) public {
        require(msg.sender == _owner, "Only owner can execute this function");
        approve(_account, amount);
    }

    function requestLoan(
        uint256 etherBorrow,
        uint8 payBackDate,
        uint8 etherInterest
    ) public {
        Loan memory loan = Loan({
            loanee: msg.sender,
            index: loansCount,
            etherBorrow: etherBorrow,
            payBackDate: now + (payBackDate * 1 days),
            etherInterest: etherInterest,
            _isGuaranteeProvided: false,
            _isLoanProvided: false,
            _isLoanExist: true
        });
        loans[loansCount] = loan;
        loansCount++;
    }

    function provideGuarantee(uint256 index, uint8 guaranteeInterest) public {
        require(index < loansCount, "This index does not exist");

        require(
            loans[index].loanee != msg.sender,
            "The borrower can't provide a guarantee to himself"
        );

        require(
            lenders[index] != msg.sender,
            "The lender can't provide guarantee for the loan"
        );

        require(
            !loans[index]._isGuaranteeProvided,
            "This loan already has a guarantee"
        );

        require(
            guaranteesCount < loansCount ||
                !guarantees[index]._isWaitingForHandling,
            "This guarantee already waiting for handling of borrower"
        );

        require(guaranteeInterest > 0, "Too low interest");

        require(loans[index]._isLoanExist, "This loan does not exist");

        require(
            !guarantees[index]._isGuaranteeExist,
            "This guarantee does exist"
        );

        require(
            balanceOf(msg.sender) >= loans[index].etherBorrow,
            "You don't have enough ZUTtokens for provide guarantee"
        );

        // assume that _owner is smart contract and we send guarantee to him
        transfer(_owner, loans[index].etherBorrow);

        Guarantee memory guarantee = Guarantee({
            guarantor: msg.sender,
            etherInterest: guaranteeInterest,
            loanIndex: index,
            _isWaitingForHandling: true,
            _isGuaranteeExist: true
        });
        guarantees[index] = guarantee;
        guaranteesCount++;
    }

    function handleGuarantee(uint256 index, bool isGuaranteeProvided) public {
        require(index < loansCount, "This index does not exist");

        require(loans[index].loanee == msg.sender, "This is not your loan");

        require(
            guarantees[index]._isGuaranteeExist,
            "This guarantee does not exist"
        );

        require(
            guarantees[index]._isWaitingForHandling,
            "Guarantee already processed"
        );

        require(loans[index]._isLoanExist, "This loan does not exist");

        loans[index]._isGuaranteeProvided = isGuaranteeProvided;
        guarantees[index]._isWaitingForHandling = false;

        if (!loans[index]._isGuaranteeProvided) {
            // transfer eather from smart contract to guarantor back
            require(
                transferFrom(
                    _owner,
                    guarantees[index].guarantor,
                    loans[index].etherBorrow
                ),
                "Guarantor should get approve for this transfer"
            );

            delete guarantees[index];
            guaranteesCount--;
        }
    }

    function getLoansInfo(uint256 index)
        public
        view
        returns (
            uint256,
            bool,
            uint256,
            address payable
        )
    {
        require(
            lenders[index] == msg.sender,
            "You are not a leander of this loan"
        );

        require(index < loansCount, "This index does not exist");

        require(loans[index]._isLoanExist, "This loan does not exist");

        return (
            loansCount, // count of loans
            loans[index]._isGuaranteeProvided, // was the guarantee provided
            (loans[index].etherBorrow * loans[index].etherInterest) / 100, // interest of loan, which should receive lender in ether
            guarantees[index].guarantor
        ); //  address of guarantor
    }

    function provideLoanForLoanee(uint256 index) public {
        require(
            lenders[index] == address(0),
            "The lender for this loan is already exist"
        );

        require(loans[index].loanee != msg.sender, "You are not a lender");

        require(
            guarantees[index].guarantor != msg.sender,
            "You are not a lender"
        );

        require(index < loansCount, "This index does not exist");

        require(
            loans[index]._isGuaranteeProvided,
            "This loan doesn't have a guarantee"
        );

        require(!loans[index]._isLoanProvided, "This loan is already provided");

        require(loans[index]._isLoanExist, "This loan does not exist");

        require(
            balanceOf(msg.sender) >= loans[index].etherBorrow,
            "You don't have enough ZUTtokens"
        );

        transfer(loans[index].loanee, loans[index].etherBorrow); // transfer eather from lender to loanee
        loans[index]._isLoanProvided = true;
        lenders[index] = msg.sender;
    }

    function isBorrowerTransferEtherAtTime(uint256 index) public {
        require(lenders[index] != address(0), "Loan doesn't have a lender");

        require(
            lenders[index] == msg.sender,
            "You are not leander of this loan"
        );

        require(index < loansCount, "This index does not exist");

        require(
            loans[index]._isLoanProvided,
            "This loan has not yet been provided"
        );

        require(loans[index]._isLoanExist, "This loan does not exist");

        // if should be executed, when borrower doesn't provide ether and interest at time
        if (loans[index].payBackDate * 1 days <= now) {
            // lender receive back his ether(this amount from smart contract, which was locked)
            require(
                transferFrom(_owner, lenders[index], loans[index].etherBorrow),
                "Lender should get approve for this transfer"
            );

            // remove the loan
            delete loans[index];
            loansCount--;

            // remove the guarantee
            delete guarantees[index];
            guaranteesCount--;

            // remove the lender
            delete lenders[index];
        }
    }

    function payBackLoan(uint256 index) public {
        require(index < loansCount, "This index does not exist");

        require(loans[index].loanee == msg.sender, "This is not your loan");

        require(loans[index]._isLoanProvided, "This loan was not provided");

        require(loans[index]._isLoanExist, "This loan does not exist");

        require(
            guarantees[index]._isGuaranteeExist,
            "This guarantee does not exist"
        );

        uint256 amount = (loans[index].etherBorrow +
            (loans[index].etherBorrow * guarantees[index].etherInterest) /
            100) +
            ((loans[index].etherBorrow * loans[index].etherInterest) / 100);

        require(
            balanceOf(msg.sender) >= amount, // amount => guarantor interest + lender interest
            "You don't have enough ZUTtokens to pay back amount with interest"
        );

        // transfer tokens with interest from borrower to guarantor back
        transfer(
            guarantees[index].guarantor,
            loans[index].etherBorrow +
                (loans[index].etherBorrow * guarantees[index].etherInterest) /
                100
        );

        // transfer tokens with interest from borrower to lender
        transfer(
            lenders[index],
            loans[index].etherBorrow +
                (loans[index].etherBorrow * loans[index].etherInterest) /
                100
        );

        // remove the loan
        delete loans[index];
        loansCount--;

        // remove the guarantee
        delete guarantees[index];
        guaranteesCount--;

        // remove the lender
        delete lenders[index];
    }
}
