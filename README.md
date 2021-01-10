# Bank smart contract with ERC20 token named ZUTToken

![Project Image](https://i.ibb.co/zX4y5Wf/photo-2020-10-22-00-17-03.jpg)

> This is a contract functionality.

---

### Table of Contents
You're sections headers will be used to reference location of destination.

- [Description](#description)
- [How To Use](#how-to-use)
- [References](#references)
- [License](#license)
- [Author Info](#author-info)

---

## Description

It is the same smart contract as [Bank smart contract](https://github.com/taranchik/solidity-bank-contract/blob/main/README.md#bank-smart-contract), but extended with ERC20 token named ZUTToken.

It is becoming increasingly harder for younger and low income individuals to get loans from banks. At the
same time current interest rates on savings are low, and many would like to be able to invest in areas that
provide higher returns (which would also entail higher risk). Decentralised lending to anonymous individuals
is very risky. A company wants to implement a Peer-to-Peer (P2P) lending system which allows for trusted
third parties to provide guarantees for specific borrowers in exchange for a cut of the interest paid back by
the borrower.

The following functionality encoded within:

• Individuals looking for loans can make a request for a loan by inputting the following details: the amount of Ether they would like to borrow, the date by which they promise to pay back the full amount, and the interest in Ether they promise to pay back upon paying back the full amount.

• Third-party guarantors can choose to provide a guarantee that the amount being requested by the borrower will be paid back to the lender by sending the amount of Ether being requested by the borrower. This amount is to be sent into the smart contract after individuals have made a request for loans, and before borrowers have granted a loan. The guarantor must also specify the amount of interest in Ether they will keep from the amount to be paid by the borrower. Once a guarantee is placed, the borrower must accept or reject the guarantee. Rejecting the guarantee will result in the guarantor’s money being returned to the guarantor.

• Lenders should be able to view: (i) the current requests for loans; (ii) whether a guarantee has been placed on a specific request; (iii) the guarantor’s address (this address could then be translated into
a third party’s identity off-chain); and (iv) the amount of interest in Ether that the lender will make once the full amount is paid (i.e. the full interest amount less the amount of interest that the guarantor
will keep).

• A lender can then chose to provide the loan by sending the appropriate Ether along with identification of the specific loan request they are sending funds for. The funds should be sent to the borrower at this point.

• If a lender does not receive the full loan amount and the expected interest by the date agreed upon, then the lender can withdrawn the guarantee placed by the guarantor.

• If the borrower pays back the full loan amount and the full interest amount then: (i) the guarantor’s funds should immediately be sent back to the guarantor along with the interest amount to be sent to
the guarantor; and (ii) the lender should receive the full loan amount along with the amount of interest due to the lender.

The contract stipulates that users cannot abuse the functionality in any way.

[Back To The Top](#bank-smart-contract-with-erc20-token-named-zuttoken)

---

## How To Use

#### Installation

1. Open link with the [REMIX IDE](https://remix.ethereum.org/).

2. Create the following files: Bank.sol, ERC20.sol, ZUTtoken.sol.

3. Copy code from the files in the repository and paste it in the files on the [REMIX IDE](https://remix.ethereum.org/) that you created before.

4. Go to the Solidity compiler section, open the Bank.sol file and click Compile Bank.sol, the same operation repeat for the ZUTToken.sol file.

![Solidity compiler image](https://i.ibb.co/RQTt1Tz/photo-2020-10-22-00-04-39.jpg)

5. Go to the Deploy & run transactions section,

![Deploy & run transactions image](https://i.ibb.co/r6WmXwM/photo-2020-10-22-00-04-59.jpg)

but before deploying Bank.sol, is necessary to copy and paste the ZUTToken contract address.

![deploy at address](https://i.ibb.co/MNjrBYc/2021-01-10-0ph-Kleki.png)

6. Now you can use the smart contract functionality described in the [Description](#description) section.

![Contracts functionality Image](https://i.ibb.co/zX4y5Wf/photo-2020-10-22-00-17-03.jpg)

There are also additional methods from ERC20 directly in the Bank smart contract.

![ERC20 methods](https://i.ibb.co/RN53cPR/Screenshot-from-2021-01-10-15-19-37.png)

[Back To The Top](#bank-smart-contract-with-erc20-token-named-zuttoken)

---

## References

[Solidity programming language](https://solidity.readthedocs.io/en/v0.7.4/)

[ERC-20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)

[REMIX IDE](https://remix.ethereum.org/)

[Back To The Top](#bank-smart-contract-with-erc20-token-named-zuttoken)

---

## License

MIT License

Copyright (c) [2020] [Viacheslav Taranushenko]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Back To The Top](#bank-smart-contract-with-erc20-token-named-zuttoken)

---

## Author Info

- LinkedIn - [Viacheslav Taranushenko](https://www.linkedin.com/in/viacheslav-taranushenko-727466187/)
- GitHub - [@taranchik](https://github.com/taranchik)
- GitLab - [@taranchik](https://gitlab.com/taranchik)
- Twitter - [@viataranushenko](https://twitter.com/viataranushenko)

[Back To The Top](#bank-smart-contract-with-erc20-token-named-zuttoken)
