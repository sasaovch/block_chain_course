pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Wallet {
    address addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public owner;
    uint public balance;
    constructor() {
        owner = msg.sender;
    }
    function depositEther() external payable {
        takeCommission(msg.sender, msg.value, 10);
        balance += msg.value;
    }
    function withdrawEther(uint amount) external {
        require(msg.sender == owner, "Only owner can call this function");
        require(amount <= balance, "Amount exceeds balance");
        balance -= amount;
        payable(owner).transfer(amount);
    }
    function transferERC20(IERC20 token, address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw funds"); 
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");
        token.transfer(to, amount);
    }
    function getERC20(IERC20 token, address from, uint256 amount) external {
        token.transferFrom(from, owner, amount);
    }    
    function setAllowance(IERC20 token, address to, uint256 amount) external {
        token.approve(to, amount);
        
    }
    function takeCommission(address seller, uint256 amountPaid, uint256 commissionPercentage) private {
    uint256 platformFee = (amountPaid  * commissionPercentage) / 100;
    payable(seller).transfer(platformFee);
    }
}