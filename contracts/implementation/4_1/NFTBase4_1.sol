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
        emit NftCreated(_getId(), _owner, _manager, _getCollection());  // todo emit once only
    }


    function getInfo() public view responsible override returns(uint256 id, address owner, address manager, address collection) {
        return {value: 0, flag: 64, bounce: false} (_getId(), _owner, _manager, _getCollection());
    }

    function changeOwner(address newOwner, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {
        _reserve();
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnerChanged(oldOwner, newOwner);

        uint32 functionId = tvm.functionId(INftChangeOwner.onNftChangeOwner);
        TvmCell baseBody = abi.encode(functionId, _getId(), _manager, oldOwner, newOwner, _getCollection(), sendGasTo);
        _sendCallbacks(sendGasTo, callbacks, baseBody);
    }

    function changeManager(address newManager, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {
        _reserve();
        address oldManager = _manager;
        _manager = newManager;
        emit ManagerChanged(oldManager, newManager);

        uint32 functionId = tvm.functionId(INftChangeManager.onNftChangeManager);
        TvmCell baseBody = abi.encode(functionId, _getId(), _owner, oldManager, newManager, _getCollection(), sendGasTo);
        _sendCallbacks(sendGasTo, callbacks, baseBody);
    }

    function transfer(address to, address sendGasTo, mapping(address => CallbackParams) callbacks) public virtual override {  // todo external ?
        _reserve();
        address oldOwner = _owner;
        address oldManager = _manager;
        _owner = _manager = to;
        emit OwnerChanged(oldOwner, to);
        emit ManagerChanged(oldManager, to);

        uint32 functionId = tvm.functionId(INftTransfer.onNftTransfer);
        TvmCell baseBody = abi.encode(functionId, _getId(), oldOwner, to, oldManager, to, _getCollection(), sendGasTo);
        _sendCallbacks(sendGasTo, callbacks, baseBody);
    }

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool) {
        return {value: 0, flag: 64, bounce: false} (
            interfaceID == bytes4(0x3204EC29) ||    // TIP6
            interfaceID == bytes4(0x78084F7E)       // TIP4.1 NFT
        );
    }


    function _getId() internal view virtual returns (uint256);

    function _getCollection() internal view virtual returns (address);

    function _reserve() internal pure {
        tvm.rawReserve(address(this).balance - msg.value, 2);  // todo storage fee reserve
    }

    function _sendCallbacks(address sendGasTo, mapping(address => CallbackParams) callbacks, TvmCell baseBody) internal pure {
        optional(TvmCell) sendGasToPayload;
        for ((address recipient, CallbackParams params) : callbacks) {
            if (recipient != sendGasTo) {
                TvmCell body = _appendToCell(baseBody, params.payload);
                recipient.transfer({value: params.value, flag: 0, bounce: false, body: body});
            } else {
                sendGasToPayload.set(params.payload);
            }
        }
        if (sendGasToPayload.hasValue()) {
            TvmCell body = _appendToCell(baseBody, sendGasToPayload.get());
            sendGasTo.transfer({value: 0, flag: 128, bounce: false, body: body});
        } else {
            sendGasTo.transfer({value: 0, flag: 128, bounce: false});
        }
    }

    function _appendToCell(TvmCell base, TvmCell last) private pure returns (TvmCell) {
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