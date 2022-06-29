from tonclient.types import ParamsOfGetBocHash
from tonos_ts4 import ts4
from tonclient.test.helpers import sync_core_client


def cell_hash(cell: ts4.Cell) -> int:
    params = ParamsOfGetBocHash(boc=cell.raw_)
    response = sync_core_client.boc.get_boc_hash(params)
    return int(response.hash, 16)
