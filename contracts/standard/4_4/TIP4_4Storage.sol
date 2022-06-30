pragma ton-solidity >= 0.58.0;


interface TIP4_4Storage {
    function fill(uint32 id, bytes chunk, address gasReceiver) external;
    function getInfo() external view responsible returns (
        address nft,
        address collection,
        string mimeType,
        mapping(uint32 => bytes) content,
        string contentEncoding
    );
}
