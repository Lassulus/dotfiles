import subprocess
from typing import Optional


class BitwardenPassword:
    def __init__(self, name: str):
        self.password: Optional[str] = None
        self.name = name

    def get(self) -> str:
        if not self.password:
            cmd = ["bw", "get", "password", self.name]
            res = subprocess.run(cmd, check=True, capture_output=True)
            self.password = res.stdout.decode("utf-8")
        return self.password
