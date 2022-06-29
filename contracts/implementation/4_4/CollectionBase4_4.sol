pragma ton-solidity >= 0.58.0;

import "../4_1/CollectionBase4_1.sol";
import "../../standard/4_4/TIP4_4Collection.sol";


abstract contract CollectionBase4_4 is CollectionBase4_1, TIP4_4Collection {

    TvmCell public _storageCode;


    function _onInit4_4(TvmCell nftCode, TvmCell storageCode) internal {
        _onInit4_1(nftCode);
        _storageCode = storageCode;
    }


    function storageCode() public view responsible override returns (TvmCell code) {
        return {value: 0, flag: 64, bounce: false} _storageCode;
    }

    function storageCodeHash() public view responsible override returns (uint256 codeHash) {
        return {value: 0, flag: 64, bounce: false} tvm.hash(_storageCode);
    }

    function resolveStorage(address nft) public view responsible virtual override returns (address addr);

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool support) {
        bytes4 tip44ID = (
            bytes4(tvm.functionId(TIP4_4Collection.storageCode)) ^
            bytes4(tvm.functionId(TIP4_4Collection.storageCodeHash)) ^
            bytes4(tvm.functionId(TIP4_4Collection.resolveStorage))
        );
        return {value: 0, flag: 64, bounce: false} super.supportsInterface(interfaceID) || interfaceID == tip44ID;
    }

}
