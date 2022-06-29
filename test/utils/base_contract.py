import typing

from tonos_ts4 import ts4


class BaseContract(ts4.BaseContract):

    def __init__(self, address: ts4.Address, abi_name: str = None):
        name = abi_name or self.__class__.__name__
        super().__init__(name, {}, nickname=name, address=address)

    def call_responsible(self, method: str, params: dict = None) -> typing.Any:
        if params is None:
            params = dict()
        params['answerId'] = 0
        return self.call_getter(method, params)
