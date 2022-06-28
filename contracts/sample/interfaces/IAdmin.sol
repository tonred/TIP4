pragma ton-solidity >= 0.58.0;


interface IAdmin {
    function onMint(uint256 id, address nft, address owner, address manager, address creator) external;
    function onBurn(uint256 id, address nft, address owner, address manager) external;
}
