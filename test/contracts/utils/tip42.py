from contracts.utils.tip6 import TIP6
from utils.solidity_function import solidity_getter


class TIP42(TIP6):
    @solidity_getter(responsible=True)
    def get_json(self) -> str:
        pass
