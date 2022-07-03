import os

from tonos_ts4 import ts4

BUILD_ARTIFACTS_PATH = os.path.dirname(os.path.realpath(__file__)) + '/../build/'
VERBOSE = os.getenv('TS4_VERBOSE', 'False').lower() == 'true'

EMPTY_CELL = ts4.Cell(ts4.EMPTY_CELL)

COLLECTION_JSON = '{"type":"Basic Collection","name":"Test Collection"}'
NFT_JSON = '{"type":"Basic NFT","name":"Test NFT"}'

NFT_NAME = 'test'
NFT_NAME_ID = 6731602802397666770938180957532378413873005850435560510872903601091507294727
STORAGE_MIME_TYPE = 'image/png'
STORAGE_CONTENT_ENCODING = 'zstd'

INDEX_BASIS_CODE_HASH = 0x2359f897c9527073b1c95140c670089aa5ab825f5fd1bd453db803fbab47def2
INDEX_CODE_HASH = 0x61e5f39a693dc133ea8faf3e80fac069250161b0bced3790c20ae234ce6fd866
