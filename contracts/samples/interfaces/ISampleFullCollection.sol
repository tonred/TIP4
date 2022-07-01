pragma ton-solidity >= 0.58.0;


interface ISampleFullCollection {
    function onMint(uint256 id, address owner, address manager, address creator) external;
    function onBurn(uint256 id, address owner, address manager) external;
}
