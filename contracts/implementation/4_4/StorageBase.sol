pragma ton-solidity >= 0.58.0;

import "../../standard/4_4/TIP4_4Storage.sol";
import "NFTBase4_4.sol";


abstract contract StorageBase is TIP4_4Storage, TIP6 {

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool support) {
        bytes4 tip6ID = bytes4(tvm.functionId(TIP6.supportsInterface));
        bytes4 tip44ID = (
            bytes4(tvm.functionId(this.fill)) ^
            bytes4(tvm.functionId(this.getInfo))
        );
        return {value: 0, flag: 64, bounce: false} interfaceID == tip6ID || interfaceID == tip44ID;
    }

    function _onStorageFillComplete(address nft, address gasReceiver) internal pure {
        NFTBase4_4(nft).onStorageFillComplete{
            value: 0,
            flag: 128,
            bounce: false
        }(gasReceiver);
    }
}
