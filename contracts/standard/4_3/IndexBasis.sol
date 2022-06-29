// Compiled by TVMCompiler v0.58.2 and TVM-linker v0.14.51
// Hash code without salting is 2359f897c9527073b1c95140c670089aa5ab825f5fd1bd453db803fbab47def2

pragma ton-solidity >= 0.58.0;

import 'IIndexBasis.sol';


/**
 * Errors
 *   101 - Method for collection only
 **/
contract IndexBasis is IIndexBasis {
    address static _collection;

    modifier onlyCollection() {
        require(msg.sender == _collection, 101, "Method for collection only");
        tvm.accept();
        _;
    }

    constructor() public onlyCollection {}

    function getInfo() override public view responsible returns (address collection) {
        return {value: 0, flag: 64} _collection;
    }

    function destruct(address gasReceiver) override public onlyCollection {
        selfdestruct(gasReceiver);
    }

}
