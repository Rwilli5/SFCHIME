"""design pattern via https://youtu.be/S_ipdVNSFlo?t=2153,
modified such that validators are _callable_

NAME: COVID-19 CHIME MODELS
AUTHORS: quinn-dougherty
SOURCE: https://github.com/CodeForPhilly/chime/blob/develop/src/penn_chime/validators/base.py
DATE ACCESSED: 2020-04-03

"""

from abc import ABC, abstractmethod

class Validator(ABC):
    def __set_name__(self, owner, name):
        self.private_name = f"_{name}"

    def __call__(self, *, value):
        self.validate(value)
        return value

    @abstractmethod
    def validate(self, value):
        pass
