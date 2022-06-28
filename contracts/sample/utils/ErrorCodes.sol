pragma ton-solidity >= 0.58.0;


library ErrorCodes {
    uint16 constant DIFFERENT_PUB_KEYS      = 1103;  // see https://github.com/broxus/ton-contracts/blob/master/contracts/utils/CheckPubKey.sol

    uint16 constant IS_NOT_ADMIN            = 4001;
    uint16 constant IS_NOT_COLLECTION       = 4002;
    uint16 constant IS_NOT_NFT              = 4003;
}
