from tonos_ts4 import ts4

from utils.base_contract import BaseContract
from utils.solidity_function import solidity_getter


class Index(BaseContract):

    def __init__(self, address: ts4.Address):
        super().__init__(address)

    @solidity_getter(responsible=True)
    def get_info(self) -> tuple:
        pass
