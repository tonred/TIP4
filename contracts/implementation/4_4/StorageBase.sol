pragma ton-solidity >= 0.58.0;

import "../../standard/4_4/TIP4_4Storage.sol";
import "NFTBase4_4.sol";


abstract contract StorageBase is TIP4_4Storage {
    function _onStorageFillComplete(address nft, address gasReceiver) internal pure {
        NFTBase4_4(nft).onStorageFillComplete{
            value: 0,
            flag: 128,
            bounce: false
        }(gasReceiver);
    }
}
