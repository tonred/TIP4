pragma ton-solidity >= 0.58.0;

import "../../implementation/4_3/CollectionBase4_3.sol";
import "../../implementation/4_4/CollectionBase4_4.sol";
import "../interfaces/IAdmin.sol";
import "SampleFullNFT.sol";
import "SampleFullStorage.sol";

import "@broxus/contracts/contracts/utils/RandomNonce.sol";


contract SampleFullCollection is CollectionBase4_3, CollectionBase4_4, IMintCallback, CheckPubKey, RandomNonce {
    string constant STORAGE_MIME_TYPE = "image/png";

    address public _admin;


    modifier onlyAdmin() {
        require(msg.sender == _admin, ErrorCodes.IS_NOT_ADMIN);
        _;
    }

    modifier onlyNFT(uint256 id) {
        require(msg.sender == _nftAddress(id), ErrorCodes.IS_NOT_NFT);
        _;
    }

    constructor(TvmCell nftCode, TvmCell indexBasisCode, TvmCell indexCode, TvmCell storageCode, address admin) public checkPubKey {
        tvm.accept();
        _onInit4_3(nftCode, indexBasisCode, indexCode);
        _onInit4_4(nftCode, storageCode);
        _admin = admin;
    }


    function nftAddress(uint256 id) public view responsible override returns (address nft) {
        return {value: 0, flag: 64, bounce: false} _nftAddress(id);
    }

    function resolveStorage(address nft) public view responsible override returns (address addr) {
        TvmCell stateInit = _buildStorageStateInit(nft);
        return {value: 0, flag: 64, bounce: false} address(tvm.hash(stateInit));
    }

    function supportsInterface(bytes4 interfaceID) public view responsible override(CollectionBase4_3, CollectionBase4_4) returns (bool support) {
        return {value: 0, flag: 64, bounce: false} (
            CollectionBase4_3.supportsInterface(interfaceID) ||
            CollectionBase4_4.supportsInterface(interfaceID)
        );
    }


    function nftAddressByName(string name) public view responsible returns (address nft) {
        return {value: 0, flag: 64, bounce: false} _nftAddress(tvm.hash(name));
    }

    function mint(string name, address owner, address manager) public view onlyAdmin {
        _reserve();
        uint256 id = tvm.hash(name);
        address nft = _nftAddress(id);
        address storage_ = _deployStorage(nft);
        _mint(id, owner, manager, msg.sender, storage_);
        msg.sender.transfer({value: 0, flag: 128, bounce: false});
    }

    function onMint(uint256 id, address owner, address manager, address creator) public override onlyNFT(id) {
        _reserve();
        _onMint(id, msg.sender, owner, manager, creator);
        IAdmin(creator).onMint{
            value: 0,
            flag: 128,
            bounce: false
        }(id, msg.sender, owner, manager, creator);
    }

    function burn(string name, address gasReceiver) public view onlyAdmin {
        uint256 id = tvm.hash(name);
        address nft = _nftAddress(id);
        SampleFullNFT(nft).burn{value: 0, flag: 64, bounce: true, callback: onBurn}(gasReceiver);
    }

    function onBurn(uint256 id, address owner, address manager, address gasReceiver) public onlyNFT(id) {
        _reserve();
        _onBurn(id, msg.sender, owner, manager);
        IAdmin(gasReceiver).onBurn{
            value: 0,
            flag: 128,
            bounce: false
        }(id, msg.sender, owner, manager);
    }


    function _reserve() internal view {
        tvm.rawReserve(address(this).balance - msg.value, 2);  // todo storage fee reserve
    }

    function _mint(uint256 id, address owner, address manager, address creator, address storage_) private view {
        TvmCell stateInit = _buildNFTStateInit(id);
        new SampleFullNFT{
            stateInit: stateInit,
            value: Gas.DEPLOY_NFT_VALUE,
            flag: 1,
            bounce: true
        }(owner, manager, _indexCode, creator, storage_);
    }

    function _deployStorage(address nft) private view returns (address) {
        TvmCell stateInit = _buildStorageStateInit(nft);
        return new SampleFullStorage{
            stateInit: stateInit,
            value: Gas.DEPLOY_STORAGE_VALUE,
            flag: 1,
            bounce: true
        }(STORAGE_MIME_TYPE);
    }

    function _nftAddress(uint256 id) private view returns (address) {
        TvmCell stateInit = _buildNFTStateInit(id);
        return address(tvm.hash(stateInit));
    }

    function _buildNFTStateInit(uint256 id) private view returns (TvmCell) {
        return tvm.buildStateInit({
            contr: SampleFullNFT,
            varInit: {
                _id: id,
                _collection: address(this)
            },
            code: _nftCode
        });
    }

    function _buildStorageStateInit(address nft) private view returns (TvmCell) {
        return tvm.buildStateInit({
            contr: SampleFullStorage,
            varInit: {_nft: nft},
            code: _storageCode
        });
    }

}