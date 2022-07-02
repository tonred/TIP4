from utils.base_contract import BaseContract
from utils.solidity_function import solidity_getter


class TIP6(BaseContract):
    @solidity_getter(responsible=True)
    def supports_interface(self, interface_i_d: int) -> bool:
        pass
