from tonos_ts4 import ts4

from config import BUILD_ARTIFACTS_PATH, VERBOSE
from contracts.fabric import Fabric
from contracts.nft import NFT
from contracts.utils.wallet import Wallet


class Deployer:

    def __init__(self):
        ts4.reset_all()
        ts4.init(BUILD_ARTIFACTS_PATH, verbose=VERBOSE)
        self.fabric = Fabric()
        self.admin = self.create_wallet()
        self.collection = self.fabric.default_collection(self.admin)

    def mint(self, name: str) -> (NFT, Wallet):
        owner = self.create_wallet()
        nft = self.collection.mint(name, owner, owner)
        return nft, owner

    @staticmethod
    def create_wallet(**kwargs) -> Wallet:
        return Wallet(**kwargs)
