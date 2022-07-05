pragma ton-solidity >= 0.58.0;

import "../4_1/NFTBase4_1.sol";
import "../../standard/4_3/TIP4_3NFT.sol";
import "../../standard/4_3/Index.sol";


abstract contract NFTBase4_3 is NFTBase4_1, TIP4_3NFT {
    uint128 constant DEPLOY_INDEX_VALUE = 0.2 ton;
    uint128 constant DESTROY_INDEX_VALUE = 0.1 ton;

    TvmCell public _indexCode;


    function _onInit4_3(address owner, address manager, TvmCell indexCode) internal {
        _onInit4_1(owner, manager);
        _indexCode = indexCode;
        _deployIndexes(_owner);
    }


    function indexCode() public view responsible override returns (TvmCell code) {
        return {value: 0, flag: 64, bounce: false} _indexCode;
    }

    function indexCodeHash() public view responsible override returns (uint256 hash) {
        return {value: 0, flag: 64, bounce: false} tvm.hash(_indexCode);
    }

    function resolveIndex(address collection, address owner) public view responsible override returns (address index) {
        TvmCell stateInit = _buildIndexStateInit(collection, owner);
        return {value: 0, flag: 64, bounce: false} address(tvm.hash(stateInit));
    }

    function changeOwner(address newOwner, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {
        _updateIndexes(_owner, newOwner, sendGasTo);
        super.changeOwner(newOwner, sendGasTo, callbacks);
    }

    function transfer(address to, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {
        _updateIndexes(_owner, to, sendGasTo);
        super.transfer(to, sendGasTo, callbacks);
    }

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool support) {
        bytes4 tip43ID = (
            bytes4(tvm.functionId(this.indexCode)) ^
            bytes4(tvm.functionId(this.indexCodeHash)) ^
            bytes4(tvm.functionId(this.resolveIndex))
        );
        return {value: 0, flag: 64, bounce: false} super.supportsInterface(interfaceID) || interfaceID == tip43ID;
    }


    function _getCollection() internal view virtual override returns (address);

    function _onBurn(address gasReceiver) internal virtual override {
        _destroyIndexes(_owner, gasReceiver);
        super._onBurn(gasReceiver);
    }

    function _updateIndexes(address oldOwner, address newOwner, address gasReceiver) internal view {
        if (oldOwner == newOwner) {
            return;
        }
        _deployIndexes(newOwner);
        _destroyIndexes(oldOwner, gasReceiver);
    }

    function _deployIndexes(address owner) internal view {
        _deployIndex(address.makeAddrStd(0, 0), owner);
        _deployIndex(_getCollection(), owner);
    }

    function _destroyIndexes(address owner, address gasReceiver) internal view {
        _destroyIndex(address.makeAddrStd(0, 0), owner, gasReceiver);
        _destroyIndex(_getCollection(), owner, gasReceiver);
    }

    function _deployIndex(address collectionSalt, address owner) private view {
        TvmCell stateInit = _buildIndexStateInit(collectionSalt, owner);
        new Index{
            stateInit: stateInit,
            value: DEPLOY_INDEX_VALUE,
            flag: 1,
            bounce: true
        }(_getCollection());
    }

    function _destroyIndex(address collection, address owner, address gasReceiver) private view {
        TvmCell stateInit = _buildIndexStateInit(collection, owner);
        address index = address(tvm.hash(stateInit));
        IIndex(index).destruct{
            value: DESTROY_INDEX_VALUE,
            flag: 1,
            bounce: true
        }(gasReceiver);
    }

    function _buildIndexStateInit(address collection, address owner) private view returns (TvmCell) {
        string stamp = "nft";
        TvmBuilder salt;
        salt.store(stamp, collection, owner);
        TvmCell code = tvm.setCodeSalt(_indexCode, salt.toCell());
        return tvm.buildStateInit({
            contr: Index,
            varInit: {_nft: address(this)},
            code: code
        });
    }

}
