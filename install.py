#!/bin/python3

import json
from pathlib import Path
import shutil
import subprocess

cwd = Path.cwd()
homedir = Path.home()

with Path("setup.json").open("r") as f:
    setup = json.load(f)

print("\033[94m==> Copying files...\033[0m")

for s, d in setup["files"].items():
    src = cwd / s
    dst = homedir / d
    print(f"{Path(s)} -> {dst}")
    shutil.copy2(src, dst)

for s, d in setup["dirs"].items():
    src = cwd / s
    dst = homedir / d
    print(f"{Path(s)} -> {dst}")
    shutil.copytree(src, dst, dirs_exist_ok=True)

print("\033[94m==> Setting up weechat...\033[0m")

weechat_commands = ";".join(setup["weechat"]) + ";/quit"
subprocess.run(["weechat", "--run", weechat_commands])
