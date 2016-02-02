web3.setProvider(new web3.providers.HttpProvider('http://localhost:8101'));web3.eth.defaultAccount = web3.eth.accounts[0];daBankAbi = [{"constant":true,"inputs":[{"name":"coin","type":"uint256"}],"name":"coinBalance","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"},{"name":"_to","type":"address"},{"name":"coin","type":"uint256"}],"name":"sendCoin","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"},{"name":"_to","type":"address"},{"name":"coin","type":"uint256"}],"name":"sendCoinFrom","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"},{"name":"coin","type":"uint256"}],"name":"coinBalanceOf","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"approve","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"tamere","outputs":[{"name":"x","type":"uint256"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":false,"name":"value","type":"uint256"},{"indexed":true,"name":"to","type":"address"}],"name":"CoinSent","type":"event"}];daBankContract = web3.eth.contract(daBankAbi);daBank = daBankContract.at('0xd281e90514859a0879fcdb9f92659d52b9c331e3');coinExchangeAbi = [{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"price","type":"uint256"},{"name":"currency1","type":"uint256"},{"name":"currency2","type":"uint256"}],"name":"buy","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"price","type":"uint256"},{"name":"origin_address","type":"address"},{"name":"typee","type":"bytes32"}],"name":"newTransaction","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"sellorders","outputs":[{"name":"timeStamp","type":"uint256"},{"name":"currency1","type":"uint256"},{"name":"currency2","type":"uint256"},{"name":"price","type":"uint256"},{"name":"trader","type":"address"}],"type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"price","type":"uint256"},{"name":"currency1","type":"uint256"},{"name":"currency2","type":"uint256"}],"name":"sell","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"buyorders","outputs":[{"name":"timeStamp","type":"uint256"},{"name":"currency1","type":"uint256"},{"name":"currency2","type":"uint256"},{"name":"price","type":"uint256"},{"name":"trader","type":"address"}],"type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"price","type":"uint256"},{"name":"currency","type":"uint256"}],"name":"newBuyOrder","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"transactions","outputs":[{"name":"timeStamp","type":"uint256"},{"name":"currency1","type":"uint256"},{"name":"currency2","type":"uint256"},{"name":"price","type":"uint256"},{"name":"client","type":"address"},{"name":"trader","type":"address"},{"name":"typee","type":"bytes32"}],"type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"price","type":"uint256"},{"name":"currency","type":"uint256"}],"name":"newSellOrder","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setCentralBank","outputs":[],"type":"function"},{"inputs":[{"name":"_baddress","type":"address"}],"type":"constructor"}];coinExchangeContract = web3.eth.contract(coinExchangeAbi);coinExchange = coinExchangeContract.at('0x1cc1eec1535b1064e8185a64b90666f39cc6499e');