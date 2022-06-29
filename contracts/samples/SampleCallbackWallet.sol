pragma ton-solidity >= 0.58.0;

import "../standard/4_1/INftChangeOwner.sol";
import "../standard/4_1/INftChangeManager.sol";
import "../standard/4_1/INftTransfer.sol";


contract SampleCallbackWallet is INftChangeOwner, INftChangeManager, INftTransfer {

    address public _sender;
    uint128 public _value;
    string public _name;

    uint256 public _id;
    address public _owner;
    address public _manager;
    address public _collection;
    address public _sendGasTo;
    address public _oldOwner;
    address public _newOwner;
    address public _oldManager;
    address public _newManager;

    TvmCell public _payload;


    constructor() public {
        tvm.accept();
    }

    function getInfoHeader() public view responsible returns (address sender, uint128 value, string name) {
        return {value: 0, flag: 64, bounce: false} (_sender, _value, _name);
    }

    function getInfoPayload() public view responsible returns (TvmCell payload) {
        return {value: 0, flag: 64, bounce: false} _payload;
    }

    function getInfoBase() public view responsible returns (
        uint256 id,
        address owner,
        address manager,
        address collection,
        address sendGasTo,
        address oldOwner,
        address newOwner,
        address oldManager,
        address newManager
    ) {
        return {value: 0, flag: 64, bounce: false} (
            _id,
            _owner,
            _manager,
            _collection,
            _sendGasTo,
            _oldOwner,
            _newOwner,
            _oldManager,
            _newManager
        );
    }

    function onNftChangeOwner(
        uint256 id,
        address manager,
        address oldOwner,
        address newOwner,
        address collection,
        address sendGasTo,
        TvmCell payload
    ) public override {
        _sender = msg.sender;
        _value = msg.value;
        _name = "onNftChangeOwner";

        _id = id;
        _owner = address(0);
        _manager = manager;
        _collection = collection;
        _sendGasTo = sendGasTo;
        _oldOwner = oldOwner;
        _newOwner = newOwner;
        _oldManager = address(0);
        _newManager = address(0);
        _payload = payload;
    }

    function onNftChangeManager(
        uint256 id,
        address owner,
        address oldManager,
        address newManager,
        address collection,
        address sendGasTo,
        TvmCell payload
    ) public override {
        _sender = msg.sender;
        _value = msg.value;
        _name = "onNftChangeManager";

        _id = id;
        _owner = owner;
        _manager = address(0);
        _collection = collection;
        _sendGasTo = sendGasTo;
        _oldOwner = address(0);
        _newOwner = address(0);
        _oldManager = oldManager;
        _newManager = newManager;
        _payload = payload;
    }

    function onNftTransfer(
        uint256 id,
        address oldOwner,
        address newOwner,
        address oldManager,
        address newManager,
        address collection,
        address sendGasTo,
        TvmCell payload
    ) public override {
        _sender = msg.sender;
        _value = msg.value;
        _name = "onNftTransfer";

        _id = id;
        _owner = address(0);
        _manager = address(0);
        _collection = collection;
        _sendGasTo = sendGasTo;
        _oldOwner = oldOwner;
        _newOwner = newOwner;
        _oldManager = oldManager;
        _newManager = newManager;
        _payload = payload;
    }

}
