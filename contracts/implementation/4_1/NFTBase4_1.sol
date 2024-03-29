pragma ton-solidity >= 0.58.0;

import "../../standard/4_1/TIP4_1NFT.sol";
import "../../standard/4_1/INftChangeManager.sol";
import "../../standard/4_1/INftChangeOwner.sol";
import "../../standard/4_1/INftTransfer.sol";
import "../../standard/6/TIP6.sol";


abstract contract NFTBase4_1 is TIP4_1NFT, TIP6 {

    // _id          implement as static or common variable
    // _collection  implement as static or common variable
    address public _owner;
    address public _manager;


    function _onInit4_1(address owner, address manager) internal {
        _owner = owner;
        _manager = manager;
        emit NftCreated(_getId(), _owner, _manager, _getCollection());
    }


    function getInfo() public view responsible override returns(uint256 id, address owner, address manager, address collection) {
        return {value: 0, flag: 64, bounce: false} (_getId(), _owner, _manager, _getCollection());
    }

    function changeOwner(address newOwner, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {
        _reserve();
        address oldOwner = _owner;
        _changeOwner(newOwner);

        if (!callbacks.empty()) {
            uint32 functionId = tvm.functionId(INftChangeOwner.onNftChangeOwner);
            TvmCell baseBody = abi.encode(functionId, _getId(), _manager, oldOwner, newOwner, _getCollection(), sendGasTo);
            _sendCallbacks(callbacks, baseBody);
        }
        sendGasTo.transfer({value: 0, flag: 128, bounce: false});
    }

    function changeManager(address newManager, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {
        _reserve();
        address oldManager = _manager;
        _changeManager(newManager);

        if (!callbacks.empty()) {
            uint32 functionId = tvm.functionId(INftChangeManager.onNftChangeManager);
            TvmCell baseBody = abi.encode(functionId, _getId(), _owner, oldManager, newManager, _getCollection(), sendGasTo);
            _sendCallbacks(callbacks, baseBody);
        }
        sendGasTo.transfer({value: 0, flag: 128, bounce: false});
    }

    function transfer(address to, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {
        _reserve();
        address oldOwner = _owner;
        address oldManager = _manager;
        _transfer(to);

        if (!callbacks.empty()) {
            uint32 functionId = tvm.functionId(INftTransfer.onNftTransfer);
            TvmCell baseBody = abi.encode(functionId, _getId(), oldOwner, to, oldManager, to, _getCollection(), sendGasTo);
            _sendCallbacks(callbacks, baseBody);
        }
        sendGasTo.transfer({value: 0, flag: 128, bounce: false});
    }

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool support) {
        bytes4 tip6ID = bytes4(tvm.functionId(TIP6.supportsInterface));
        bytes4 tip41ID = (
            bytes4(tvm.functionId(this.getInfo)) ^
            bytes4(tvm.functionId(this.changeOwner)) ^
            bytes4(tvm.functionId(this.changeManager)) ^
            bytes4(tvm.functionId(this.transfer))
        );
        return {value: 0, flag: 64, bounce: false} interfaceID == tip6ID || interfaceID == tip41ID;
    }


    function _getId() internal view virtual returns (uint256);

    function _getCollection() internal view virtual returns (address);

    function _changeOwner(address newOwner) internal virtual {
        emit OwnerChanged(_owner, newOwner);
        _owner = newOwner;
    }

    function _changeManager(address newManager) internal virtual {
        emit ManagerChanged(_manager, newManager);
        _manager = newManager;
    }

    function _transfer(address to) internal virtual {
        _changeOwner(to);
        _changeManager(to);
    }

    function _onBurn(address gasReceiver) internal virtual {
        emit NftBurned(_getId(), _owner, _manager, _getCollection());
        selfdestruct(gasReceiver);
    }

    function _reserve() internal view virtual {
        // This function is `view` in order to compile with compiler v0.58.2
        // Moreover, user can change implementation and relay on contract's variable in reserve
        _owner;  // in order ignore "Function state mutability can be restricted to pure" warning
        tvm.rawReserve(0, 4);  // todo storage fee reserve
    }

    function _sendCallbacks(mapping(address => CallbackParams) callbacks, TvmCell baseBody) internal pure {
        for ((address recipient, CallbackParams params) : callbacks) {
            TvmCell body = _appendToCell(baseBody, params.payload);
            recipient.transfer({value: params.value, flag: 1, bounce: false, body: body});
        }
    }

    function _appendToCell(TvmCell base, TvmCell last) internal pure returns (TvmCell) {
        TvmSlice slice = base.toSlice();
        TvmBuilder builder;
        if (base.depth() == 0) {
            builder.store(slice, last);
        } else {
            TvmSlice current = slice.loadSlice(slice.bits());
            TvmCell next = _appendToCell(slice.loadRef(), last);
            builder.store(current, next);
        }
        return builder.toCell();
    }

}
