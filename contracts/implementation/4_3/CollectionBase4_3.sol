pragma ton-solidity >= 0.58.0;

import "../4_1/CollectionBase4_1.sol";
import "../../standard/4_3/TIP4_3Collection.sol";
import "../../standard/4_3/IndexBasis.sol";


abstract contract CollectionBase4_3 is CollectionBase4_1, TIP4_3Collection {
    uint128 constant DEPLOY_INDEX_BASIS_VALUE = 0.2 ton;

    TvmCell public _indexBasisCode;
    TvmCell public _indexCode;


    function _onInit4_3(TvmCell nftCode, TvmCell indexBasisCode, TvmCell indexCode) internal {
        _onInit4_1(nftCode);
        _indexBasisCode = indexBasisCode;
        _indexCode = indexCode;
        _deployIndexBasis();
    }


    function indexBasisCode() public view responsible override returns (TvmCell code) {
        return {value: 0, flag: 64, bounce: false} _indexBasisCode;
    }

    function indexBasisCodeHash() public view responsible override returns (uint256 hash) {
        return {value: 0, flag: 64, bounce: false} tvm.hash(_indexBasisCode);
    }

    function indexCode() public view responsible override returns (TvmCell code) {
        return {value: 0, flag: 64, bounce: false} _indexCode;
    }

    function indexCodeHash() public view responsible override returns (uint256 hash) {
        return {value: 0, flag: 64, bounce: false} tvm.hash(_indexCode);
    }

    function resolveIndexBasis() public view responsible override returns (address indexBasis) {
        TvmCell stateInit = _buildIndexBasisStateInit();
        return {value: 0, flag: 64, bounce: false} address(tvm.hash(stateInit));
    }

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool support) {
        bytes4 tip43ID = (
            bytes4(tvm.functionId(TIP4_3Collection.indexBasisCode)) ^
            bytes4(tvm.functionId(TIP4_3Collection.indexBasisCodeHash)) ^
            bytes4(tvm.functionId(TIP4_3Collection.indexCode)) ^
            bytes4(tvm.functionId(TIP4_3Collection.indexCodeHash)) ^
            bytes4(tvm.functionId(TIP4_3Collection.resolveIndexBasis))
        );
        return {value: 0, flag: 64, bounce: false} super.supportsInterface(interfaceID) || interfaceID == tip43ID;
    }


    function _deployIndexBasis() private view {
        TvmCell stateInit = _buildIndexBasisStateInit();
        new IndexBasis{
            stateInit: stateInit,
            value: DEPLOY_INDEX_BASIS_VALUE,
            flag: 1,
            bounce: true
        }();
    }

    function _buildIndexBasisStateInit() private view returns (TvmCell) {
        string stamp = "nft";
        TvmCell salt = abi.encode(stamp);
        TvmCell code = tvm.setCodeSalt(_indexBasisCode, salt);
        return tvm.buildStateInit({
            contr: IndexBasis,
            varInit: {_collection: address(this)},
            code: code
        });
    }

}
