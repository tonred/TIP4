//pragma ton-solidity >= 0.58.0;
//
//pragma AbiHeader time;
//pragma AbiHeader expire;
//pragma AbiHeader pubkey;
//
//import "../../implementation/4_3/NFTBase4_3.sol";
//import "../interfaces/ISampleFullCollection.sol";
//import "../utils/ErrorCodes.sol";
//import "../utils/Gas.sol";
//
//
//contract SampleNFT is NFTBase4_3 {
//
//    uint256 public static _id;
//    address public static _collection;
//
//    bool public _ready;
//
//
//    modifier onlyManager() {
//        require(msg.sender == _manager, ErrorCodes.IS_NOT_MANAGER);
//        _;
//    }
//
//    constructor(address owner, address manager, TvmCell indexCode, address creator) public {
//        require(msg.sender == _collection, ErrorCodes.IS_NOT_COLLECTION);
//        _onInit4_3(owner, manager, indexCode);
//        ISampleFullCollection(msg.sender).onMint{
//            value: Gas.ON_MINT_VALUE,
//            flag: 1,
//            bounce: false
//        }(_id, _owner, _manager, creator);
//    }
//
//    function changeOwner(address newOwner, address sendGasTo, mapping(address => CallbackParams) callbacks) public override onlyManager {
//        super.changeOwner(newOwner, sendGasTo, callbacks);
//    }
//
//    function changeManager(address newManager, address sendGasTo, mapping(address => CallbackParams) callbacks) public override onlyManager {
//        super.changeManager(newManager, sendGasTo, callbacks);
//    }
//
//    function transfer(address to, address sendGasTo, mapping(address => CallbackParams) callbacks) public override onlyManager {
//        super.transfer(to, sendGasTo, callbacks);
//    }
//
//    function burn(address gasReceiver) public responsible returns (uint256 id, address owner, address manager) {
//        require(msg.sender == _collection, ErrorCodes.IS_NOT_COLLECTION);
//        _destroyIndexes(_owner, gasReceiver);
//        selfdestruct(gasReceiver);
//        return {value: 0, flag: 128 + 32, bounce: false} (_getId(), _owner, _manager);
//    }
//
//
//    function _getId() internal view override returns (uint256) {
//        return _id;
//    }
//
//    function _getCollection() internal view override returns (address) {
//        return _collection;
//    }
//
//}
