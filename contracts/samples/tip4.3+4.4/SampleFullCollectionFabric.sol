pragma ton-solidity >= 0.58.0;

pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "SampleFullCollection.sol";


contract SampleFullCollectionFabric is RandomNonce {

    TvmCell public _collectionCode;
    address public _collection;

    constructor(TvmCell collectionCode) public {
        tvm.accept();
        _collectionCode = collectionCode;
    }

    function createCollection(
        TvmCell nftCode,
        TvmCell indexBasisCode,
        TvmCell indexCode,
        TvmCell storageCode,
        address admin,
        uint256 pubkey
    ) public {
        TvmCell stateInit = _buildCollectionStateInit(pubkey);
        _collection = new SampleFullCollection{
            stateInit: stateInit,
            value: 0,
            flag: 64,
            bounce: false
        }(nftCode, indexBasisCode, indexCode, storageCode, admin);
    }

    function _buildCollectionStateInit(uint256 pubkey) private view returns (TvmCell) {
        return tvm.buildStateInit({
            contr: SampleFullCollection,
            varInit: {_randomNonce: now},
            code: _collectionCode,
            pubkey: pubkey
        });
    }

}
