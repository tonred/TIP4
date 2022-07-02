pragma ton-solidity >= 0.58.0;


interface ISampleCollection {
    function onMint(uint256 id, address owner, address manager, address creator) external;
    function onBurn(uint256 id, address owner, address manager) external;
}
