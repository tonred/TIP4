pragma ton-solidity >= 0.58.0;


interface IMintCallback {

    function onMint(uint256 id, address owner, address manager, address creator) external;

}
