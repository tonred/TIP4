pragma ton-solidity >= 0.58.0;


interface TIP4_2JSON_Metadata {

    /// @notice metadata in JSON format
    /// @return json The JSON string with metadata
    function getJson() external view responsible returns (string json);

}
