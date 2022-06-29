pragma ton-solidity >= 0.58.0;

import "../4_1/NFTBase4_1.sol";
import "../../standard/4_4/TIP4_4NFT.sol";


abstract contract NFTBase4_4 is NFTBase4_1, TIP4_4NFT {

    address public _storage;


    function _onInit4_4(address owner, address manager, address storage_) internal {
        _onInit4_1(owner, manager);
        _storage = storage_;
    }


    function onStorageFillComplete(address gasReceiver) public virtual override;

    function getStorage() public view responsible virtual override returns (address addr) {
        return {value: 0, flag: 64, bounce: false} _storage;
    }

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool support) {
        bytes4 tip44ID = (
            bytes4(tvm.functionId(TIP4_4NFT.onStorageFillComplete)) ^
            bytes4(tvm.functionId(TIP4_4NFT.getStorage))
        );
        return {value: 0, flag: 64, bounce: false} super.supportsInterface(interfaceID) || interfaceID == tip44ID;
    }

}
