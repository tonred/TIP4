// see https://github.com/broxus/ton-contracts/blob/master/contracts/utils/CheckPubKey.sol

pragma ton-solidity >= 0.58.0;

import "ErrorCodes.sol";


abstract contract CheckPubKey {
    modifier checkPubKey() {
        require(msg.pubkey() == tvm.pubkey(), ErrorCodes.DIFFERENT_PUB_KEYS);
        _;
    }
}
