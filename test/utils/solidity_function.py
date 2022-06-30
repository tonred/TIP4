import inspect
from typing import Callable

import stringcase
from decohints import decohints
from tonos_ts4 import ts4

from contracts.utils.wallet import Wallet
from utils.options import Options

ANSWER_ID_KEY = 'answerId'


def _camelcase_dict(data: dict) -> dict:
    return {
        stringcase.camelcase(key): value
        for key, value in data.items()
    }


def _process_function_args(function: Callable, args: tuple, kwargs: dict, ignore: tuple = tuple()) -> (dict, Options):
    params = dict()
    # default values
    parameters = inspect.signature(function).parameters
    for parameter in parameters.values():
        if parameter.default is not inspect.Parameter.empty:
            params[parameter.name] = parameter.default
    # kwargs values
    params.update(kwargs)
    # args values
    args_names = function.__code__.co_varnames[1:]  # skip self
    for name, arg in zip(args_names, args):
        params[name] = arg
    # pop options
    options = params.pop('options', None)
    # pop ignores
    for key in ignore:
        params.pop(key)
    # key names to camelcase
    params = _camelcase_dict(params)
    return params, options


def _find_sender(self: ts4.BaseContract, send_as: str, kwargs: dict) -> Wallet:
    if hasattr(self, send_as):
        return getattr(self, send_as)
    return kwargs.pop(send_as)


def _base_contracts_to_address(params: dict):
    for key, value in params.items():
        if isinstance(value, ts4.BaseContract):
            params[key] = value.address


@decohints
def solidity_function(send_as: str = 'owner', ignore: tuple = ()):
    def decorator(function: Callable):
        def wrapper(self: ts4.BaseContract, *args, **kwargs):
            method = stringcase.camelcase(function.__name__)
            params, options = _process_function_args(function, args, kwargs, ignore)
            sender = _find_sender(self, send_as, params)
            _base_contracts_to_address(params)
            sender.run_target(self, options=options, method=method, params=params)
            return function(self, *args, **kwargs)

        return wrapper

    return decorator


@decohints
def solidity_getter(responsible: bool = False):
    def decorator(function: Callable):
        def wrapper(self: ts4.BaseContract, *args, **kwargs):
            method = stringcase.camelcase(function.__name__)
            params, _ = _process_function_args(function, args, kwargs)
            _base_contracts_to_address(params)
            if responsible:
                params[ANSWER_ID_KEY] = 0
            return self.call_getter(method, params)

        return wrapper

    return decorator
