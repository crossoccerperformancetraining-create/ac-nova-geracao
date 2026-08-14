#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1
( command -v xdg-open >/dev/null && xdg-open http://localhost:8080/index.html ) || ( command -v open >/dev/null && open http://localhost:8080/index.html ) || true
python3 -m http.server 8080
