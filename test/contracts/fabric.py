from tonos_ts4 import ts4

from config import COLLECTION_JSON
from contracts.collection import Collection
from contracts.utils.wallet import Wallet
from utils.options import Options
from utils.solidity_function import solidity_function, solidity_getter
from utils.utils import random_address


class Fabric(ts4.BaseContract):

    def __init__(self):
        collection_code = ts4.load_code_cell('SampleFullCollection')
        super().__init__(
            'SampleFullCollectionFabric',
            ctor_params={
                'collectionCode': collection_code,
            },
            nickname='Fabric',
            override_address=random_address(),
        )

    @solidity_getter()
    def _collection(self) -> ts4.Address:
        pass

    @solidity_function(send_as='sender')
    def create_collection(
            self,
            sender: Wallet,
            nft_code: ts4.Cell,
            index_basis_code: ts4.Cell,
            index_code: ts4.Cell,
            storage_code: ts4.Cell,
            json: str,
            admin: Wallet,
            pubkey: str,
            options: Options = Options(5),
    ) -> Collection:
        address = self._collection()
        return Collection(address, admin)

    def default_collection(self, admin: Wallet) -> Collection:
        nft_code = ts4.load_code_cell('SampleFullNFT')
        index_basis_code = ts4.load_code_cell('IndexBasis')
        index_code = ts4.load_code_cell('Index')
        storage_code = ts4.load_code_cell('SampleFullStorage')
        return self.create_collection(
            admin, nft_code, index_basis_code, index_code, storage_code, COLLECTION_JSON, admin, admin.public_key_
        )
