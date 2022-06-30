import unittest
from typing import Union

from tonos_ts4 import ts4

from config import NFT_NAME, INDEX_BASIS_CODE_HASH, INDEX_CODE_HASH
from contracts.collection import Collection
from contracts.index import Index
from contracts.index_basis import IndexBasis
from contracts.nft import NFT
from deployer import Deployer
from utils.cell_hash import cell_hash
from utils.utils import ZERO_ADDRESS

CALLBACK_VALUE = ts4.GRAM


class Test43(unittest.TestCase):

    def setUp(self):
        self.deployer = Deployer()
        self.collection = self.deployer.collection
        self.nft, self.nft_owner = self.deployer.mint(NFT_NAME)

    def test_collection(self):
        # index basis code + index basis code hash
        index_basis_code = self.collection.index_basis_code()
        index_basis_code_hash = self.collection.index_basis_code_hash()
        self._check_code_and_hash(index_basis_code, index_basis_code_hash, 'IndexBasis')
        self.assertEqual(index_basis_code_hash, INDEX_BASIS_CODE_HASH, 'Wrong "IndexBasis" code hash')
        # index code + index code hash
        self._check_index_code_and_hash(self.collection)
        # resolve index basis
        index_basis_address = self.collection.resolve_index_basis()
        index_basis = IndexBasis(index_basis_address)
        self.assertGreater(index_basis.balance, 0, 'Index Basis is not exists')

    def test_nft(self):
        # index code + index code hash
        self._check_index_code_and_hash(self.nft)
        # resolve index (two indexes)
        index_1_address = self.nft.resolve_index(ZERO_ADDRESS, self.nft_owner)
        index_1 = Index(index_1_address)
        self.assertGreater(index_1.balance, 0, 'Index (1) is not exists')
        index_2_address = self.nft.resolve_index(self.collection, self.nft_owner)
        index_2 = Index(index_2_address)
        self.assertGreater(index_2.balance, 0, 'Index (2) is not exists')

    def test_index_basis(self):
        index_basis_address = self.collection.resolve_index_basis()
        index_basis = IndexBasis(index_basis_address)
        info = index_basis.get_info()
        self.assertEqual(info, self.collection.address, 'Wrong IndexBasis info')

    def test_index(self):
        expected_info = (self.collection.address, self.nft_owner.address, self.nft.address)
        # first index (collection = '0:000...0')
        index_1_address = self.nft.resolve_index(ZERO_ADDRESS, self.nft_owner)
        index_1 = Index(index_1_address)
        self.assertEqual(index_1.get_info(), expected_info, 'Wrong Index (1) info')
        # second index (collection = Collection address)
        index_2_address = self.nft.resolve_index(self.collection, self.nft_owner)
        index_2 = Index(index_2_address)
        self.assertEqual(index_2.get_info(), expected_info, 'Wrong Index (2) info')

    def _check_index_code_and_hash(self, contract: Union[Collection, NFT]):
        index_code = getattr(contract, 'index_code')()
        index_code_hash = getattr(contract, 'index_code_hash')()
        self._check_code_and_hash(index_code, index_code_hash, 'Index')
        self.assertEqual(index_code_hash, INDEX_CODE_HASH, 'Wrong "Index" code hash')

    def _check_code_and_hash(self, code: ts4.Cell, code_hash: int, contract_filename: str):
        # code
        expected_code = ts4.load_code_cell(contract_filename)
        self.assertEqual(code, expected_code, f'Wrong code for "{contract_filename}"')
        # code hash
        expected_code_hash = cell_hash(expected_code)
        self.assertEqual(code_hash, expected_code_hash, f'Wrong code hash for "{contract_filename}"')
