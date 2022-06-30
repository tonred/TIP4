pragma ton-solidity >= 0.58.0;

import "../../implementation/4_4/StorageBase.sol";

import "@broxus/contracts/contracts/utils/CheckPubKey.sol";


contract SampleFullStorage is StorageBase, CheckPubKey {

    address public static _nft;
    address public static _collection;

    string _mimeType;
    mapping(uint8 => bytes) _content;


    constructor(string mimeType) public checkPubKey {
        tvm.accept();
        _mimeType = mimeType;
    }

    function fill(uint32 id, bytes chunk, address gasReceiver) public override checkPubKey {
        tvm.accept();
        _content[uint8(id)] = chunk;
        if (gasReceiver.value != 0) {
            // last chunk
            _onStorageFillComplete(_nft, gasReceiver);
        }
    }

    function getInfo() public view responsible override returns (
        address nft,
        address collection,
        string mimeType,
        mapping(uint8 => bytes) content
    ) {
        return {value: 0, flag: 64, bounce: false} (_nft, _collection, _mimeType, _content);
    }

}
