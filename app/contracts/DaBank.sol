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
}