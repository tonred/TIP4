pragma ton-solidity >= 0.58.0;

import "../../standard/4_2/TIP4_2JSON_Metadata.sol";
import "../../standard/6/TIP6.sol";


abstract contract JSONMetadataDynamicBase is TIP4_2JSON_Metadata, TIP6 {

    function getJson() public view responsible virtual override returns (string json);

    function supportsInterface(bytes4 interfaceID) public view responsible virtual override returns (bool support) {
        return {value: 0, flag: 64, bounce: false} interfaceID == bytes4(tvm.functionId(this.getJson));
    }

}
