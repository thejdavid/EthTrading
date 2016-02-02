contract daBank {
    struct Account {
    mapping (uint => uint) balances;
    mapping ( address => uint) withdrawers;
    }

    mapping ( address => Account ) accounts;
    event CoinSent(address indexed from, uint256 value, address indexed to);

    function daBank() {
      accounts[msg.sender].balances[0] = 1000000;
      accounts[msg.sender].balances[1] = 1000000;
      accounts[msg.sender].balances[2] = 1000000;
      accounts[msg.sender].balances[3] = 1000000;
      accounts[msg.sender].balances[4] = 1000000;
    }

    function sendCoin(uint _value, address _to,uint coin) returns (bool _success) {
        if (accounts[msg.sender].balances[coin] >= _value && _value < 340282366920938463463374607431768211456) {
            accounts[msg.sender].balances[coin] -= _value;
            accounts[_to].balances[coin] += _value;
            CoinSent(msg.sender, _value, _to);
            _success = true;
        }
        else _success = false;
    }
    function sendCoinFrom(address _from, uint _value, address _to, uint coin) returns (bool _success) {
        uint auth = accounts[_from].withdrawers[msg.sender];
        if (accounts[_from].balances[coin] >= _value && auth >= _value && _value < 340282366920938463463374607431768211456) {
            accounts[_from].withdrawers[msg.sender] -= _value;
            accounts[_from].balances[coin] -= _value;
            accounts[_to].balances[coin] += _value;
            CoinSent(_from, _value, _to);
            _success = true;
            _success = true;
        }
        else _success = false;
    }

    function coinBalance(uint coin) constant returns (uint _r) {
        _r = accounts[msg.sender].balances[coin];
    }

    function coinBalanceOf(address _addr, uint coin) constant returns (uint _r) {
        _r = accounts[_addr].balances[coin];
    }
  function approve(address _addr) {
        accounts[msg.sender].withdrawers[_addr] = 340282366920938463463374607431768211456;
    }
  function tamere(address _addr)returns(uint x){
    return accounts[msg.sender].withdrawers[_addr];
  }
}
contract coinExchange{

  struct transaction {
    uint timeStamp;
    uint currency1;
    uint currency2;
    uint price;
    address client;
    address trader;
    bytes32 typee;        
  }
  struct sellOrder {
    uint timeStamp;
    uint currency1;
    uint currency2;
    uint price;
    address trader;
  }
   struct buyOrder {
    uint timeStamp;
    uint currency1;
    uint currency2;
    uint price;
    address trader;
  }
   
  mapping(uint => transaction) public transactions;
  mapping(uint => buyOrder) public buyorders;
  mapping(uint => sellOrder) public sellorders;


  uint lastTransactionId;
  uint lastBOrderId;
  uint lastSOrderId;
  address owner;
  address centralBankContract;

  function coinExchange(address _baddress){
    centralBankContract = _baddress;
    owner = msg.sender;
    lastTransactionId = 1;
    lastBOrderId = 1;
    lastSOrderId = 1;
  }
  function setCentralBank(address _address){
    if (msg.sender == owner){
      centralBankContract = _address;
    }
  }

  function newTransaction(uint amount,uint price,address origin_address,bytes32 typee){
    uint transac = lastTransactionId + 1;
    transactions[transac].timeStamp = block.timestamp;
    transactions[transac].typee = typee;
    transactions[transac].currency1 = amount;
    transactions[transac].currency2 = price * amount;
    transactions[transac].price = price;
    transactions[transac].client = msg.sender;
    transactions[transac].trader = origin_address;
    lastTransactionId = transac; 
  }

  function newBuyOrder(uint amount,uint price,uint currency) {
      uint order = lastBOrderId + 1;
      buyorders[order].timeStamp = block.timestamp;
      buyorders[order].currency1 = amount;
      buyorders[order].currency2 = price * amount;
      buyorders[order].price = price;
      buyorders[order].trader = msg.sender;
      lastBOrderId = order;
  }

  function newSellOrder(uint amount,uint price,uint currency) {
      uint order = lastSOrderId + 1; 
      sellorders[order].timeStamp = block.timestamp;
      sellorders[order].currency1 = amount;
      sellorders[order].currency2 = price * amount;
      sellorders[order].price = price;
      sellorders[order].trader = msg.sender;
      lastSOrderId = order;
  }

  function buy(uint amount, uint price, uint currency1, uint currency2) {
    daBank centralBankLink = daBank(centralBankContract);
    uint _amountLeftToBuy = amount;
    uint idCounter = lastSOrderId;

    if (centralBankLink.coinBalanceOf(msg.sender,currency1) >= amount && amount > 0 ){
      while (_amountLeftToBuy > 0){
        if (sellorders[idCounter].price <= price && sellorders[idCounter].currency1 > amount) {
          sellorders[idCounter].currency1 = sellorders[idCounter].currency1 - amount; 
          newTransaction(amount,sellorders[idCounter].price,sellorders[idCounter].trader,"buy");
          centralBankLink.sendCoin(amount*sellorders[idCounter].price,msg.sender,currency2);
          centralBankLink.sendCoinFrom(this,amount,msg.sender,currency1);
          _amountLeftToBuy = 0;
        }
        else if (sellorders[idCounter].price <= price && sellorders[idCounter].currency1 < amount) {
          _amountLeftToBuy =  amount - sellorders[idCounter].currency1;
          newTransaction(_amountLeftToBuy,sellorders[idCounter].price,sellorders[idCounter].trader,"buy");
          centralBankLink.sendCoin(sellorders[idCounter].currency1 * sellorders[idCounter].price,msg.sender,currency2);
          centralBankLink.sendCoinFrom(this,sellorders[idCounter].currency1,msg.sender,currency1);
          idCounter--; 
        }
        else if (sellorders[idCounter].price > price){
          centralBankLink.sendCoin(_amountLeftToBuy,msg.sender,currency2);
          newBuyOrder(_amountLeftToBuy,price,currency2);
          _amountLeftToBuy = 0;
        }
      }   
    }
    else {
      return;
    }
  }
    function sell(uint amount, uint price, uint currency1, uint currency2){
    daBank centralBankLink = daBank(centralBankContract);
    uint _amountLeftToSell = amount;
    uint idCounter = lastBOrderId;
    if (centralBankLink.coinBalanceOf(msg.sender,currency1) >= amount && amount > 0 ){
      while (_amountLeftToSell > 0){
        if (buyorders[idCounter].price >= price && buyorders[idCounter].currency1 > amount) {
          buyorders[idCounter].currency1 = buyorders[idCounter].currency1 - amount; 
          newTransaction(amount,buyorders[idCounter].price,buyorders[idCounter].trader,"sell");
          centralBankLink.sendCoin(amount,msg.sender,currency1);
          centralBankLink.sendCoinFrom(this,amount*buyorders[idCounter].price,msg.sender,currency2);
          _amountLeftToSell = 0;
        }
        else if (buyorders[idCounter].price >= price && buyorders[idCounter].currency1 < amount) {
          _amountLeftToSell =  amount - buyorders[idCounter].currency1;
          newTransaction(_amountLeftToSell,buyorders[idCounter].price,buyorders[idCounter].trader,"sell");
          centralBankLink.sendCoin(buyorders[idCounter].currency1,msg.sender,currency1);
          centralBankLink.sendCoinFrom(this,buyorders[idCounter].currency2,msg.sender,currency2);
          idCounter--; 
        }
        else if (buyorders[idCounter].price > price){
          newSellOrder(_amountLeftToSell,price,currency1);
          _amountLeftToSell = 0;
        }
      }   
    }
    else {
      return;
    }
  }
}