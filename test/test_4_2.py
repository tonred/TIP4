import unittest

from config import NFT_NAME, COLLECTION_JSON, NFT_JSON
from contracts.utils.tip42 import TIP42
from deployer import Deployer


class Test42(unittest.TestCase):

    def setUp(self):
        self.deployer = Deployer()
        self.collection = self.deployer.collection
        self.nft, _ = self.deployer.mint(NFT_NAME)

    def test_collection(self):
        self._test_tip4_2(self.collection, COLLECTION_JSON)

    def test_nft(self):
        self._test_tip4_2(self.nft, NFT_JSON)

    def _test_tip4_2(self, contract: TIP42, expected_json: str):
        json = contract.get_json()
        self.assertEqual(json, expected_json, f'Wrong JSON metadata (TIP4.2) for contract "{contract.name_}"')
