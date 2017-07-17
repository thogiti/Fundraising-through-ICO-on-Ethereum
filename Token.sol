pragma solidity 0.4.11;

contract admined {
	address public admin;

	function admined(){
		admin = msg.sender;
	}

  //Only Admin can access
	modifier onlyAdmin(){
		if(msg.sender != admin) throw;
		_;
	}

  //Only Admin can transfer membership to someone
	function transferAdminship(address newAdmin) onlyAdmin {
		admin = newAdmin;
	}

}

contract Token {
  /// ERC 20 tokens
  /// Token smart contract to exchange ETH to tokens


  /// from The address of the sender
  /// to The address of the recipient
  /// value The amount of token to be transferred


	mapping (address => uint256) public balanceOf;

	string public name; ///token name
	string public symbol; ///token symbol
	uint8 public decimal;
	uint256 public totalSupply; /// total amount of tokens
	event Transfer(address indexed from, address indexed to, uint256 value);


	function Token(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits){
		balanceOf[msg.sender] = initialSupply;
		totalSupply = initialSupply;
		decimal = decimalUnits;
		symbol = tokenSymbol;
		name = tokenName;
	}

	function transfer(address _to, uint256 _value){
    //Validate the funds available for Transfer

		if(balanceOf[msg.sender] < _value) throw;
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;

		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
		Transfer(msg.sender, _to, _value);
	}

}

contract EITOToken is admined, Token{
  //Create EITO Asset Token contract for initial minting of tokens
  //extends Token contract

	string public name = 'EITO Token'; ///token name
	string public symbol = '8ET'; ///token symbol

	function EITOToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralAdmin) Token (0, tokenName, tokenSymbol, decimalUnits ){
    //Initialize the token supply

  	totalSupply = initialSupply;
		if(centralAdmin != 0)
			admin = centralAdmin;
		else
			admin = msg.sender;
		balanceOf[admin] = initialSupply;
		totalSupply = initialSupply;
	}

	function mintToken(address target, uint256 mintedAmount) onlyAdmin{
    //mint the tokens

		balanceOf[target] += mintedAmount;
		totalSupply += mintedAmount;
		Transfer(0, this, mintedAmount);
		Transfer(this, target, mintedAmount);
	}

	function transfer(address _to, uint256 _value){
    //Validate the funds available for transfer

		if(balanceOf[msg.sender] <= 0) throw;
		if(balanceOf[msg.sender] < _value) throw;
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;

		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
		Transfer(msg.sender, _to, _value);
	}

}
