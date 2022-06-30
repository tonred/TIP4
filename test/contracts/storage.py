from tonos_ts4 import ts4

from contracts.utils.tip6 import TIP6
from utils.base_contract import BaseContract
from utils.solidity_function import solidity_getter


class Storage(BaseContract, TIP6):

    def __init__(self, address: ts4.Address):
        super().__init__(address, abi_name='SampleFullStorage')

    @solidity_getter(responsible=True)
    def get_info(self) -> tuple:
        pass
