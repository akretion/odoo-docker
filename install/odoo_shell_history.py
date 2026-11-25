import os
import sys

if len(sys.argv) > 1 and sys.argv[1] == "shell" and sys.stdin.isatty():
    _history = os.environ.get("PYTHON_HISTORY")
    if _history:
        import atexit
        import readline

        try:
            readline.read_history_file(_history)
        except OSError:
            pass
        atexit.register(readline.write_history_file, _history)
