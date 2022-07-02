pragma ton-solidity >= 0.58.0;

pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "../../implementation/4_2/JSONMetadataBase.sol";
import "../../implementation/4_3/NFTBase4_3.sol";
import "../interfaces/ISampleCollection.sol";
import "../utils/ErrorCodes.sol";
import "../utils/Gas.sol";


contract SampleNFT is NFTBase4_3, JSONMetadataBase {

    uint256 public static _id;
    address public static _collection;


    modifier onlyManager() {
        require(msg.sender == _manager, ErrorCodes.IS_NOT_MANAGER);
        _;
    }

    constructor(address owner, address manager, TvmCell indexCode, string json, address creator) public {
        require(msg.sender == _collection, ErrorCodes.IS_NOT_COLLECTION);
        _onInit4_3(owner, manager, indexCode);
        _onInit4_2(json);
        ISampleCollection(msg.sender).onMint{
            value: Gas.ON_MINT_VALUE,
            flag: 1,
            bounce: false
        }(_id, _owner, _manager, creator);
    }


    function changeOwner(address newOwner, address sendGasTo, mapping(address => CallbackParams) callbacks) public override onlyManager {
        super.changeOwner(newOwner, sendGasTo, callbacks);
    }

    function changeManager(address newManager, address sendGasTo, mapping(address => CallbackParams) callbacks) public override onlyManager {
        super.changeManager(newManager, sendGasTo, callbacks);
    }

    function transfer(address to, address sendGasTo, mapping(address => CallbackParams) callbacks) public override onlyManager {
        super.transfer(to, sendGasTo, callbacks);
    }

    function supportsInterface(
        bytes4 interfaceID
    ) public view responsible override(NFTBase4_3, JSONMetadataBase) returns (bool support) {
        return {value: 0, flag: 64, bounce: false} (
            NFTBase4_3.supportsInterface(interfaceID) ||
            JSONMetadataBase.supportsInterface(interfaceID)
        );
    }

    function burn(address gasReceiver) public {
        require(msg.sender == _collection, ErrorCodes.IS_NOT_COLLECTION);
        ISampleCollection(msg.sender).onBurn{
            value: 0,
            flag: 64,
            bounce: false
        }(_id, _owner, _manager);
        _onBurn(gasReceiver);
    }


    function _getId() internal view override returns (uint256) {
        return _id;
    }

    function _getCollection() internal view override returns (address) {
        return _collection;
    }

}
