from typing import Dict

from tonos_ts4 import ts4

from contracts.utils.wallet import Wallet
from utils.base_contract import BaseContract
from utils.options import Options
from utils.solidity_function import solidity_function, solidity_getter


class NFT(BaseContract):

    def __init__(self, address: ts4.Address, owner: Wallet, manager: Wallet):
        super().__init__(address, abi_name='SampleFullNFT')
        self.owner = owner
        self.manager = manager

    # TIP6
    @solidity_getter(responsible=True)
    def supports_interface(self, interface_i_d: bytes) -> bool:
        pass

    # TIP4.1
    @solidity_getter(responsible=True)
    def get_info(self) -> tuple:
        pass

    # TIP4.1
    @solidity_function(send_as='manager')
    def change_owner(
            self,
            new_owner: ts4.Address,
            send_gas_to: ts4.Address,
            callbacks: Dict[ts4.Address, dict],
            options: Options = Options(3),
    ):
        pass

    # TIP4.1
    @solidity_function(send_as='manager')
    def change_manager(
            self,
            new_manager: ts4.Address,
            send_gas_to: ts4.Address,
            callbacks: Dict[ts4.Address, dict],
            options: Options = Options(3),
    ):
        pass

    # TIP4.1
    @solidity_function(send_as='manager')
    def transfer(
            self,
            to: ts4.Address,
            send_gas_to: ts4.Address,
            callbacks: Dict[ts4.Address, dict],
            options: Options = Options(3),
    ):
        pass

    # TIP4.3
    @solidity_getter(responsible=True)
    def index_code(self) -> ts4.Cell:
        pass

    # TIP4.3
    @solidity_getter(responsible=True)
    def index_code_hash(self) -> int:
        pass

    # TIP4.3
    @solidity_getter(responsible=True)
    def resolve_index(self, collection: ts4.Address, owner: ts4.Address) -> ts4.Address:
        pass

    # TIP4.4
    @solidity_getter(responsible=True)
    def get_storage(self) -> ts4.Address:
        pass
