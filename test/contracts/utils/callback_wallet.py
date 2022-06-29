from tonos_ts4 import ts4

from utils.solidity_function import solidity_getter
from utils.utils import random_address


class CallbackWallet(ts4.BaseContract):

    def __init__(self, nickname: str = 'CallbackWallet', balance: int = 1 * ts4.GRAM):
        super().__init__(
            'SampleCallbackWallet',
            {},
            nickname='CallbackWallet',
            override_address=random_address(),
            keypair=ts4.make_keypair(),
            balance=balance,
        )

    @solidity_getter(responsible=True)
    def get_info_header(self) -> dict:
        pass

    @solidity_getter(responsible=True)
    def get_info_payload(self) -> ts4.Cell:
        pass

    @solidity_getter(responsible=True)
    def get_info_base(self) -> dict:
        pass
