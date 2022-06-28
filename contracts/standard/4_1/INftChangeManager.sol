pragma ton-solidity >= 0.58.0;


interface INftChangeManager {

    /// @notice change owner callback processing
    /// @param id Unique NFT id
    /// @param owner Address of NFT owner
    /// @param oldManager Address of NFT manager before manager changed
    /// @param newManager Address of new NFT manager
    /// @param collection Address of collection smart contract that mint the NFT
    /// @param sendGasTo - Address to send remaining gas
    /// @param payload - Custom payload
    function onNftChangeManager(
        uint256 id,
        address owner,
        address oldManager,
        address newManager,
        address collection,
        address sendGasTo,
        TvmCell payload
    ) external;

}
