from tonos_ts4 import ts4

from contracts.nft import NFT
from contracts.utils.tip6 import TIP6
from contracts.utils.wallet import Wallet
from utils.base_contract import BaseContract
from utils.options import Options
from utils.solidity_function import solidity_function, solidity_getter


class Collection(BaseContract, TIP6):

    def __init__(self, address: ts4.Address, admin: Wallet):
        super().__init__(address, abi_name='SampleFullCollection')
        self.admin = admin

    # TIP4.1
    @solidity_getter(responsible=True)
    def total_supply(self) -> int:
        pass

    # TIP4.1
    @solidity_getter(responsible=True)
    def nft_code(self) -> ts4.Cell:
        pass

    # TIP4.1
    @solidity_getter(responsible=True)
    def nft_code_hash(self) -> int:
        pass

    # TIP4.1
    @solidity_getter(responsible=True)
    def nft_address(self, id: int) -> ts4.Address:
        pass

    # TIP4.3
    @solidity_getter(responsible=True)
    def index_basis_code(self) -> ts4.Cell:
        pass

    # TIP4.3
    @solidity_getter(responsible=True)
    def index_basis_code_hash(self) -> int:
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
    def resolve_index_basis(self) -> ts4.Address:
        pass

    # TIP4.4
    @solidity_getter(responsible=True)
    def storage_code(self) -> ts4.Cell:
        pass

    # TIP4.4
    @solidity_getter(responsible=True)
    def storage_code_hash(self) -> int:
        pass

    # TIP4.4
    @solidity_getter(responsible=True)
    def resolve_storage(self, nft: ts4.Address) -> ts4.Address:
        pass

    @solidity_getter(responsible=True)
    def nft_address_by_name(self, name: str) -> ts4.Address:
        pass

    @solidity_function(send_as='admin')
    def mint(self, name: str, owner: Wallet, manager: Wallet, options: Options = Options(5)) -> NFT:
        nft_address = self.nft_address_by_name(name)
        return NFT(nft_address, owner, manager)

    @solidity_function(send_as='admin')
    def burn(self, name: str, options: Options = Options(5)):
        pass
