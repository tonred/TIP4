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

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool) {
        return {value: 0, flag: 64, bounce: false} (
            interfaceID == bytes4(0x3204EC29) ||    // TIP6
            interfaceID == bytes4(0x1217AAAB) ||    // TIP4.1 Collection
            interfaceID == bytes4(0x6302A6F8)       // TIP4.4 Collection
        );
    }

}
