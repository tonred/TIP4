// Compiled by TVMCompiler v0.58.2 and TVM-linker v0.14.51
// Hash code without salting is 61e5f39a693dc133ea8faf3e80fac069250161b0bced3790c20ae234ce6fd866
// IMPORTANT! Method `getInfo` has "bounce: true" in order to be compiled with new compiler version!
//            Remove it to get code as in standard and get right hash code

pragma ton-solidity >= 0.58.0;

import 'IIndex.sol';


/**
 * Errors
 *   101 - Method for NFT only
 *   102 - Salt doesn't contain any value
 **/
contract Index is IIndex {
    address static _nft;

    address _collection;
    address _owner;

    constructor(address collection) public {
        optional(TvmCell) salt = tvm.codeSalt(tvm.code());
        require(salt.hasValue(), 102, "Salt doesn't contain any value");
        (, address collection_, address owner) = salt
            .get()
            .toSlice()
            .decode(string, address, address);
        require(msg.sender == _nft);
        tvm.accept();
        _collection = collection_;
        _owner = owner;
        if (collection_.value == 0) {
            _collection = collection;
        }
    }

    function getInfo() override public view responsible returns (
        address collection,
        address owner,
        address nft
    ) {
        return {value: 0, flag: 64, bounce: true} (
            _collection,
            _owner,
            _nft
        );
    }

    function destruct(address gasReceiver) override public {
        require(msg.sender == _nft, 101, "Method for NFT only");
        selfdestruct(gasReceiver);
    }

}
