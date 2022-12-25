print(f"Loading IPython profile from {__file__}")
from datetime import datetime

try:
    import pandas as pd
except ModuleNotFoundError:
    pass
else:
    pd.set_option("display.max_rows", 50)
    pd.set_option("display.max_columns", 50)
    pd.set_option("display.width", 160)


def from_ms(msts: int) -> "datetime":
    return datetime.fromtimestamp(msts / 1000)


def from_dt(*args) -> int:
    if len(args) == 1 and isinstance(args[0], datetime):
        dt = args[0]
    else:
        dt = datetime(*args)
    return int(dt.timestamp() * 1000)

print(f"Done load IPython profile from {__file__}")
