pragma ton-solidity >= 0.58.0;

import "../../standard/4_1/TIP4_1Collection.sol";
import "../../standard/6/TIP6.sol";


abstract contract CollectionBase4_1 is TIP4_1Collection, TIP6 {

    uint128 public _totalSupply;
    TvmCell public _nftCode;


    function _onInit4_1(TvmCell nftCode) internal {
        _nftCode = nftCode;
    }


    function totalSupply() public view responsible override returns (uint128 count) {
        return {value: 0, flag: 64, bounce: false} _totalSupply;
    }

    function nftCode() public view responsible override returns (TvmCell code) {
        return {value: 0, flag: 64, bounce: false} _nftCode;
    }

    function nftCodeHash() public view responsible override returns (uint256 codeHash) {
        return {value: 0, flag: 64, bounce: false} tvm.hash(_nftCode);
    }

    function nftAddress(uint256 id) public view responsible virtual override returns (address nft);

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool) {
        return {value: 0, flag: 64, bounce: false} (
            interfaceID == bytes4(0x3204EC29) ||    // TIP6
            interfaceID == bytes4(0x1217AAAB)       // TIP4.1 Collection
        );
    }


    function _onMint(uint256 id, address nft, address owner, address manager, address creator) internal {
        _totalSupply++;
        emit NftCreated(id, nft, owner, manager, creator);
    }

    function _onBurn(uint256 id, address nft, address owner, address manager) internal {
        _totalSupply--;
        emit NftBurned(id, nft, owner, manager);
    }

}
