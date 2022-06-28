pragma ton-solidity >= 0.58.0;


interface TIP4_4Collection {
    function storageCode() external view responsible returns (TvmCell code);
    function storageCodeHash() external view responsible returns (uint256 codeHash);
    function resolveStorage(address nft) external view responsible returns (address addr);
}
