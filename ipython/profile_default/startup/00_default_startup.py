print(f"Loading IPython profile from {__file__} ... ", end="")
import datetime as dt
import re


EPSILON = 1e-8


try:
    import pandas as pd  # type: ignore
except ModuleNotFoundError:
    print("pandas not found")
else:
    pd.set_option("display.max_rows", None)
    pd.set_option("display.max_columns", None)
    pd.set_option("display.width", None)

try:
    import sympy as sp  # type: ignore
except ModuleNotFoundError:
    print("sympy not found")

try:
    import numpy as np  # type: ignore
except ModuleNotFoundError:
    print("numpy not found")


def from_ms(msts: int) -> dt.datetime:
    return dt.datetime.fromtimestamp(msts / 1000)


def to_ms(*args) -> int:
    if len(args) == 1 and isinstance(args[0], dt.datetime):
        x = args[0]
    else:
        x = dt.datetime(*args)
    return int(x.timestamp() * 1000)


def from_us(msts: int) -> dt.datetime:
    return dt.datetime.fromtimestamp(msts / 1_000_000)


def to_us(*args) -> int:
    if len(args) == 1 and isinstance(args[0], dt.datetime):
        x = args[0]
    else:
        x = dt.datetime(*args)
    return int(x.timestamp() * 1_000_000)


def mid_diff_spread(bid: float, ask: float) -> tuple[float, float, float]:
    mid = 0.5 * (bid + ask)
    diff = ask - bid
    spread = diff / mid if mid else 0.0
    return mid, diff, spread


def slugify(text: str) -> str:
    return re.sub(r"[^a-zA-Z0-9]+", "-", text.lower()).strip("-")


print("Done")
