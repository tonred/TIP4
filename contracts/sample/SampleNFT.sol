pragma ton-solidity >= 0.58.0;

import "../implementation/4_3/NFTBase4_3.sol";
import "../implementation/4_4/NFTBase4_4.sol";
import "./interfaces/IMintCallback.sol";
import "./utils/ErrorCodes.sol";
import "./utils/Gas.sol";


contract SampleNFT is NFTBase4_3, NFTBase4_4 {

    uint256 static _id;
    address static _collection;


    constructor(address owner, address manager, TvmCell indexCode, address creator) public {
        _onInit4_3(owner, manager, indexCode);
        _onInit4_4(owner, manager);
        IMintCallback(msg.sender).onMint{
            value: Gas.ON_MINT_VALUE,
            flag: 1,
            bounce: false
        }(_id, _owner, _manager, creator);
    }


    function onStorageFillComplete(address gasReceiver) public override {

    }

    function getStorage() public view responsible override returns (address addr) {
        return {value: 0, flag: 64, bounce: false} address(0);  // todo
    }

    function supportsInterface(bytes4 interfaceID) public view responsible override(NFTBase4_3, NFTBase4_4) returns (bool) {
        return {value: 0, flag: 64, bounce: false} (
            NFTBase4_3.supportsInterface(interfaceID) ||
            NFTBase4_4.supportsInterface(interfaceID)
        );
    }


    function burn(address gasReceiver_) public view responsible returns (uint256 id, address owner, address manager, address gasReceiver) {
        require(msg.sender == _collection, ErrorCodes.IS_NOT_COLLECTION);
        return {value: 0, flag: 128 + 2, bounce: false} (_getId(), _owner, _manager, gasReceiver_);
    }


    function _getId() internal view override returns (uint256) {
        return _id;
    }

    function _getCollection() internal view override(NFTBase4_1, NFTBase4_3) returns (address) {
        return _collection;
    }

}
