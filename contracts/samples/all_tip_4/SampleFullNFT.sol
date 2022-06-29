pragma ton-solidity >= 0.58.0;

import "../../implementation/4_3/NFTBase4_3.sol";
import "../../implementation/4_4/NFTBase4_4.sol";
import "../interfaces/IMintCallback.sol";
import "../utils/ErrorCodes.sol";
import "../utils/Gas.sol";


contract SampleFullNFT is NFTBase4_3, NFTBase4_4 {

    uint256 public static _id;
    address public static _collection;

    bool public _ready;


    constructor(address owner, address manager, TvmCell indexCode, address creator, address storage_) public {
        _onInit4_3(owner, manager, indexCode);
        _onInit4_4(owner, manager, storage_);
        IMintCallback(msg.sender).onMint{
            value: Gas.ON_MINT_VALUE,
            flag: 1,
            bounce: false
        }(_id, _owner, _manager, creator);
    }


    function onStorageFillComplete(address gasReceiver) public override {
        _ready = true;
        gasReceiver.transfer({value: 0, flag: 64, bounce: false});
    }

    function changeOwner(address newOwner, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override(NFTBase4_1, NFTBase4_3) {
        NFTBase4_3.changeOwner(newOwner, sendGasTo, callbacks);
    }

    function transfer(address to, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override(NFTBase4_1, NFTBase4_3) {
        NFTBase4_3.transfer(to, sendGasTo, callbacks);
    }

    function supportsInterface(bytes4 interfaceID) public view responsible override(NFTBase4_3, NFTBase4_4) returns (bool support) {
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
