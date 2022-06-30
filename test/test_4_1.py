import random
import string
import unittest
from typing import Union, Callable

from tonclient.test.helpers import sync_core_client
from tonclient.types import ParamsOfAbiEncodeBoc, AbiParam
from tonos_ts4 import ts4

from config import NFT_NAME, NFT_NAME_ID
from contracts.collection import Collection
from contracts.nft import NFT
from contracts.utils.callback_wallet import CallbackWallet
from contracts.utils.wallet import Wallet
from deployer import Deployer
from utils.cell_hash import cell_hash
from utils.utils import random_address, ZERO_ADDRESS

CALLBACK_VALUE = ts4.GRAM


class Test41(unittest.TestCase):

    def setUp(self):
        self.deployer = Deployer()
        self.collection = self.deployer.collection
        self.nft, _ = self.deployer.mint(NFT_NAME)

    def test_tip6(self):
        self._test_tip6(self.collection, [0x3204EC29, 0x1217AAAB, 0x4387BBFB, 0x6302A6F8])
        self._test_tip6(self.nft, [0x3204EC29, 0x78084F7E, 0x4DF6250B, 0x009DC09A])

    def test_collection(self):
        # total supply
        total_supply = self.collection.total_supply()
        self.assertEqual(total_supply, 1, 'Wrong total supply')
        # nft code + nft code hash
        nft_code = self.collection.nft_code()
        nft_code_hash = self.collection.nft_code_hash()
        self._check_code_and_hash(nft_code, nft_code_hash, 'SampleFullNFT')
        # nft address
        nft_address = self.collection.nft_address(NFT_NAME_ID)
        self.assertEqual(nft_address, self.nft.address, 'Wrong nft address')

    def test_nft(self):
        # get info
        info = self.nft.get_info()
        expected_info = {
            'id': NFT_NAME_ID,
            'owner': self.nft.owner.address,
            'manager': self.nft.manager.address,
            'collection': self.collection.address,
        }
        self.assertEqual(info, tuple(expected_info.values()), 'Wrong get info')
        # change owner
        info, new_owner = self._test_callback(self.nft.change_owner, 'onNftChangeOwner')
        expected_info = {
            'id': NFT_NAME_ID,
            'owner': ZERO_ADDRESS,
            'manager': self.nft.manager.address,
            'collection': self.collection.address,
            'sendGasTo': new_owner.address,
            'oldOwner': self.nft.owner.address,
            'newOwner': new_owner.address,
            'oldManager': ZERO_ADDRESS,
            'newManager': ZERO_ADDRESS,
        }
        self.assertEqual(info, tuple(expected_info.values()), 'Wrong change owner callback data')
        self.nft.owner = new_owner
        # change manager
        info, new_manager = self._test_callback(self.nft.change_manager, 'onNftChangeManager')
        expected_info = {
            'id': NFT_NAME_ID,
            'owner': self.nft.owner.address,
            'manager': ZERO_ADDRESS,
            'collection': self.collection.address,
            'sendGasTo': new_manager.address,
            'oldOwner': ZERO_ADDRESS,
            'newOwner': ZERO_ADDRESS,
            'oldManager': self.nft.manager.address,
            'newManager': new_manager.address,
        }
        self.assertEqual(info, tuple(expected_info.values()), 'Wrong change manager callback data')
        self.nft.manager = new_manager
        # transfer
        info, to = self._test_callback(self.nft.transfer, 'onNftTransfer')
        expected_info = {
            'id': NFT_NAME_ID,
            'owner': ZERO_ADDRESS,
            'manager': ZERO_ADDRESS,
            'collection': self.collection.address,
            'sendGasTo': to.address,
            'oldOwner': self.nft.owner.address,
            'newOwner': to.address,
            'oldManager': self.nft.manager.address,
            'newManager': to.address,
        }
        self.assertEqual(info, tuple(expected_info.values()), 'Wrong transfer callback data')
        self.nft.owner = self.nft.manager = to

    def _test_callback(self, function: Callable, callback_function: str) -> (dict, Wallet):
        new_wallet = self.deployer.create_wallet()
        callback_wallet = CallbackWallet()
        value_1 = random.randint(0, 2 ** 256 - 1)
        value_2 = random_address()
        value_3 = ''.join(random.choices(string.ascii_uppercase, k=1234))
        encode_boc_params = ParamsOfAbiEncodeBoc([
            AbiParam(name='value1', type='uint256'),
            AbiParam(name='value2', type='address'),
            AbiParam(name='value3', type='string'),
        ], {
            'value1': str(value_1),
            'value2': value_2.str(),
            'value3': value_3,
        })
        payload = sync_core_client.abi.encode_boc(encode_boc_params).boc
        function(new_wallet, send_gas_to=new_wallet, callbacks={
            callback_wallet.address.str(): {'value': CALLBACK_VALUE, 'payload': payload}
        })
        info_header = callback_wallet.get_info_header()
        expected_info_header = {
            'sender': self.nft.address,
            'value': CALLBACK_VALUE,
            'name': callback_function,
        }
        self.assertEqual(info_header, tuple(expected_info_header.values()), 'Headers are different')
        info_payload = callback_wallet.get_info_payload().raw_
        self.assertEqual(payload, info_payload, 'Payloads are different')
        return callback_wallet.get_info_base(), new_wallet

    def _test_tip6(self, contract: Union[Collection, NFT], interfaces_ok: list):
        for interface_id in interfaces_ok:
            supports = contract.supports_interface(interface_id)
            self.assertEqual(supports, True, f'Interface {interface_id} must be supported for {contract.name_}')
        interfaces_bad = [0xFFFFFFFF, 0x12345678]  # corner case and random case
        for interface_id in interfaces_bad:
            supports = contract.supports_interface(interface_id)
            self.assertEqual(supports, False, f'Interface {interface_id} must not be supported for {contract.name_}')

    def _check_code_and_hash(self, code: ts4.Cell, code_hash: int, contract_filename: str):
        # code
        expected_code = ts4.load_code_cell(contract_filename)
        self.assertEqual(code, expected_code, f'Wrong code for "{contract_filename}"')
        # code hash
        expected_code_hash = cell_hash(expected_code)
        self.assertEqual(code_hash, expected_code_hash, f'Wrong code hash for "{contract_filename}"')
