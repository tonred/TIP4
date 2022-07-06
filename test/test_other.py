import unittest

from tonos_ts4 import ts4

from config import NFT_NAME
from contracts.index import Index
from contracts.storage import Storage
from deployer import Deployer
from utils.utils import ZERO_ADDRESS

CALLBACK_VALUE = ts4.GRAM


class TestOther(unittest.TestCase):

    def setUp(self):
        self.deployer = Deployer()
        self.admin = self.deployer.admin
        self.collection = self.deployer.collection

    def test_mint(self):
        balance_admin_before = self.admin.balance
        nft, _ = self.deployer.mint(NFT_NAME)
        self.assertEqual(self.collection.total_supply(), 1, 'Wrong total supply')
        balance_admin_after = self.admin.balance
        balance_admin_delta = balance_admin_before - balance_admin_after
        balance_admin_delta_expected = int((0.5 + 1.6 - 0.2) * ts4.GRAM)  # storage + mint - onMint
        self.assertEqual(balance_admin_delta, balance_admin_delta_expected, 'Wrong admin balance delta')
        nft_balance_expected = int((1.6 - 0.2 - 2 * 0.2) * ts4.GRAM)  # mint - onMint - 2 indexes
        self.assertEqual(nft.balance, nft_balance_expected, 'Wrong nft balance')
        storage_address = self.collection.resolve_storage(nft)
        storage = Storage(storage_address)
        self.assertEqual(storage.balance, ts4.GRAM // 2, 'Wrong storage balance')

    def test_burn(self):
        nft, nft_owner = self.deployer.mint(NFT_NAME)
        index_1_address = nft.resolve_index(ZERO_ADDRESS, nft_owner)
        index_1 = Index(index_1_address)
        index_2_address = nft.resolve_index(self.collection, nft_owner)
        index_2 = Index(index_2_address)
        nft_owner_balance_before = nft_owner.balance
        nft_balance_before = nft.balance
        self.collection.burn(NFT_NAME, nft_owner)
        self.assertEqual(self.collection.total_supply(), 0, 'Wrong total supply')
        self.assertEqual(nft.balance, None, 'NFT is not destroyed')
        self.assertEqual(index_1.balance, None, 'Index (1) is not destroyed')
        self.assertEqual(index_2.balance, None, 'Index (2) is not destroyed')
        nft_owner_balance_after = nft_owner.balance
        nft_owner_balance_delta = nft_owner_balance_after - nft_owner_balance_before
        nft_owner_balance_delta_expected = nft_balance_before + 2 * int(0.2 * ts4.GRAM)  # nft + 2 indexes
        self.assertEqual(nft_owner_balance_delta, nft_owner_balance_delta_expected, 'Wrong balance delta')

    def test_mint_twice(self):
        nft, _ = self.deployer.mint(NFT_NAME)
        self.assertEqual(self.collection.total_supply(), 1, 'Wrong total supply')
        nft, _ = self.deployer.mint(NFT_NAME)
        self.assertEqual(self.collection.total_supply(), 1, 'Wrong total supply')
