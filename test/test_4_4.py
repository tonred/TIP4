import unittest

from tonos_ts4 import ts4

from config import NFT_NAME, STORAGE_MIME_TYPE, STORAGE_CONTENT_ENCODING
from contracts.storage import Storage
from deployer import Deployer
from utils.cell_hash import cell_hash
from utils.utils import ZERO_ADDRESS


class Test44(unittest.TestCase):

    def setUp(self):
        self.deployer = Deployer()
        self.admin = self.deployer.admin
        self.collection = self.deployer.collection
        self.nft, _ = self.deployer.mint(NFT_NAME)

    def test_collection(self):
        # storage code + storage code hash
        storage_code = self.collection.storage_code()
        storage_code_hash = self.collection.storage_code_hash()
        self._check_code_and_hash(storage_code, storage_code_hash, 'SampleFullStorage')
        # resolve storage
        storage_address = self.collection.resolve_storage(self.nft)
        storage = Storage(storage_address)
        self.assertGreater(storage.balance, 0, 'Storage is not exists')

    def test_nft(self):
        # get storage
        storage_address = self.nft.get_storage()
        storage = Storage(storage_address)
        self.assertGreater(storage.balance, 0, 'Storage is not exists')

    def test_storage(self):
        storage_address = self.nft.get_storage()
        storage = Storage(storage_address)
        # fill + onStorageFillComplete
        self.assertEqual(self.nft._is_storage_ready(), False, 'Wrong ready status before filling complete')
        self._fill_storage(storage, 0, 'chunk0', ZERO_ADDRESS)
        self._fill_storage(storage, 1, 'chunk1', ZERO_ADDRESS)
        self._fill_storage(storage, 2, 'chunk2', self.admin.address)
        self.assertEqual(self.nft._is_storage_ready(), True, 'Wrong ready status after filling complete')
        # get info
        info = storage.get_info()
        expected_content = {i: f'chunk{i}' for i in range(3)}
        expected_info = (
            self.nft.address, self.collection.address, STORAGE_MIME_TYPE, expected_content, STORAGE_CONTENT_ENCODING
        )
        self.assertEqual(info, expected_info, 'Wrong storage info')
        self.assertEqual(storage.balance, 0, 'Wrong storage balance')

    def _fill_storage(self, storage: Storage, id: int, chunk: str, gas_receiver: ts4.Address):
        storage.call_method('fill', {
            'id': id,
            'chunk': chunk,
            'gasReceiver': gas_receiver,
        }, private_key=self.admin.private_key_)
        ts4.dispatch_messages()

    def _check_code_and_hash(self, code: ts4.Cell, code_hash: int, contract_filename: str):
        # code
        expected_code = ts4.load_code_cell(contract_filename)
        self.assertEqual(code, expected_code, f'Wrong code for "{contract_filename}"')
        # code hash
        expected_code_hash = cell_hash(expected_code)
        self.assertEqual(code_hash, expected_code_hash, f'Wrong code hash for "{contract_filename}"')
