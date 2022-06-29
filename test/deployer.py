from tonos_ts4 import ts4

from config import BUILD_ARTIFACTS_PATH, VERBOSE
from contracts.collection import Collection
from contracts.nft import NFT
from contracts.utils.wallet import Wallet


class Deployer:

    def __init__(self):
        ts4.reset_all()
        ts4.init(BUILD_ARTIFACTS_PATH, verbose=VERBOSE)
        self.admin = self.create_wallet()
        self.collection = Collection(self.admin)

    def mint(self, name: str) -> NFT:
        wallet = self.create_wallet()
        return self.collection.mint(name, wallet, wallet)

    @staticmethod
    def create_wallet(**kwargs) -> Wallet:
        return Wallet(**kwargs)
