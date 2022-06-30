pragma ton-solidity >= 0.58.0;

pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "../../implementation/4_4/StorageBase.sol";
import "../utils/ErrorCodes.sol";

import "@broxus/contracts/contracts/utils/CheckPubKey.sol";


contract SampleFullStorage is StorageBase, CheckPubKey {

    address public static _nft;
    address public static _collection;

    string public _mimeType;
    string public _contentEncoding;
    mapping(uint32 => bytes) public _content;


    constructor(string mimeType, string contentEncoding) public {
        require(msg.sender == _collection, ErrorCodes.IS_NOT_COLLECTION);
        _mimeType = mimeType;
        _contentEncoding = contentEncoding;
    }

    function fill(uint32 id, bytes chunk, address gasReceiver) public override checkPubKey {
        tvm.accept();
        _content[id] = chunk;
        if (gasReceiver.value != 0) {  // last chunk
            _onStorageFillComplete(_nft, gasReceiver);
        }
    }

    function getInfo() public view responsible override returns (
        address nft,
        address collection,
        string mimeType,
        mapping(uint32 => bytes) content,
        string contentEncoding
    ) {
        return {value: 0, flag: 64, bounce: false} (_nft, _collection, _mimeType, _content, _contentEncoding);
    }

}
