pragma ton-solidity >= 0.58.0;

import "../4_1/NFTBase4_1.sol";
import "../../standard/4_4/TIP4_4NFT.sol";


abstract contract NFTBase4_4 is NFTBase4_1, TIP4_4NFT {

    function _onInit4_4(address owner, address manager) internal {
        _onInit4_1(owner, manager);
    }


    function onStorageFillComplete(address gasReceiver) public virtual override;

    function getStorage() public view responsible virtual override returns (address addr);

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool) {
        return {value: 0, flag: 64, bounce: false} (
            interfaceID == bytes4(0x3204EC29) ||    // TIP6
            interfaceID == bytes4(0x78084F7E) ||    // TIP4.1 NFT
            interfaceID == bytes4(0x009DC09A)       // TIP4.4 NFT
        );
    }

}
