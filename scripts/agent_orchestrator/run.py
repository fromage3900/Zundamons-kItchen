#!/usr/bin/env python
import sys, os
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
from orchestrator import main

if __name__ == "__main__":
    main()
