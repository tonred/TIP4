from utils.solidity_function import solidity_getter


class TIP6:
    @solidity_getter(responsible=True)
    def supports_interface(self, interface_i_d: int) -> bool:
        pass
