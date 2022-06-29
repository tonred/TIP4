from tonos_ts4 import ts4

from contracts.nft import NFT
from contracts.utils.wallet import Wallet
from utils.options import Options
from utils.solidity_function import solidity_function, solidity_getter
from utils.utils import random_address


class Collection(ts4.BaseContract):

    def __init__(self, admin: Wallet):
        nft_code = ts4.load_code_cell('SampleFullNFT')
        index_basis_code = ts4.load_code_cell('IndexBasis')
        index_code = ts4.load_code_cell('Index')
        sample_storage_code = ts4.load_code_cell('SampleFullStorage')
        super().__init__(
            'SampleFullCollection',
            ctor_params={
                'nftCode': nft_code,
                'indexBasisCode': index_basis_code,
                'indexCode': index_code,
                'storageCode': sample_storage_code,
                'admin': admin.address,
            },
            nickname='Collection',
            override_address=random_address(),
        )
        self.admin = admin

    # TIP6
    @solidity_getter(responsible=True)
    def supports_interface(self, interface_i_d: int) -> bool:
        pass

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
