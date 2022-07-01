pragma ton-solidity >= 0.58.0;

pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "../../implementation/4_3/CollectionBase4_3.sol";
import "../interfaces/IAdmin.sol";
import "SampleNFT.sol";

import "@broxus/contracts/contracts/utils/CheckPubKey.sol";
import "@broxus/contracts/contracts/utils/RandomNonce.sol";


contract SampleCollection is CollectionBase4_3, ISampleFullCollection, CheckPubKey, RandomNonce {

    address public _admin;


    modifier onlyAdmin() {
        require(msg.sender == _admin, ErrorCodes.IS_NOT_ADMIN);
        _;
    }

    modifier onlyNFT(uint256 id) {
        require(msg.sender == _nftAddress(id), ErrorCodes.IS_NOT_NFT);
        _;
    }

    constructor(TvmCell nftCode, TvmCell indexBasisCode, TvmCell indexCode, address admin) public checkPubKey {
        tvm.accept();
        _onInit4_3(nftCode, indexBasisCode, indexCode);
        _admin = admin;
    }


    function nftAddress(uint256 id) public view responsible override returns (address nft) {
        return {value: 0, flag: 64, bounce: false} _nftAddress(id);
    }

    function nftAddressByName(string name) public view responsible returns (address nft) {
        return {value: 0, flag: 64, bounce: false} _nftAddress(tvm.hash(name));
    }

    function mint(string name, address owner, address manager) public view onlyAdmin {
        _reserve();
        uint256 id = tvm.hash(name);
        _mint(id, owner, manager, msg.sender);
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
        SampleNFT(nft).burn{value: 0, flag: 64, bounce: true}(gasReceiver);
    }

    function onBurn(uint256 id, address owner, address manager) public override onlyNFT(id) {
        _reserve();
        _onBurn(id, msg.sender, owner, manager);
        IAdmin(_admin).onBurn{
            value: 0,
            flag: 128,
            bounce: false
        }(id, msg.sender, owner, manager);
    }


    function _reserve() internal view {
        tvm.rawReserve(0, 4);  // todo storage fee reserve
    }

    function _mint(uint256 id, address owner, address manager, address creator) private view {
        TvmCell stateInit = _buildNFTStateInit(id);
        new SampleNFT{
            stateInit: stateInit,
            value: Gas.DEPLOY_NFT_VALUE,
            flag: 1,
            bounce: true
        }(owner, manager, _indexCode, creator);
    }

    function _nftAddress(uint256 id) private view returns (address) {
        TvmCell stateInit = _buildNFTStateInit(id);
        return address(tvm.hash(stateInit));
    }

    function _buildNFTStateInit(uint256 id) private view returns (TvmCell) {
        return tvm.buildStateInit({
            contr: SampleNFT,
            varInit: {
                _id: id,
                _collection: address(this)
            },
            code: _nftCode
        });
    }

}
