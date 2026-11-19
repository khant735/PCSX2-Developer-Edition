#!/usr/bin/env bash
set -euo pipefail
MODE="${1:-snapshot}"
ARCHIVE="${2:?Provide the frozen environment archive}"
BASE=/mnt/data/pcsx2_batch25_rebuild
[[ "$MODE" == snapshot || "$MODE" == repository ]] || { echo 'Invalid source mode' >&2; exit 2; }
sudo mkdir -p /mnt/data
sudo tar --use-compress-program=zstd -xf "$ARCHIVE" -C /mnt/data
sudo chown -R "$(id -u):$(id -g)" "$BASE" /mnt/data/pcsx2_gcc16_fullbuild /mnt/data/pcsx2_gcc16_probe
if [[ "$MODE" == repository ]]; then
  : "${GITHUB_WORKSPACE:?}"
  grep -q IsGameListLoggingEnabled "$GITHUB_WORKSPACE/pcsx2/GameList.cpp" || {
    echo 'Batch 25 GameList logging patch missing from developer branch' >&2; exit 4;
  }
  rsync -a --delete --exclude=.git "$GITHUB_WORKSPACE/" "$BASE/source/"
fi
export PATH=/mnt/data/pcsx2_gcc16_probe/llvm-mingw-20260826-ucrt-ubuntu-22.04-x86_64/bin:$PATH
export LD_LIBRARY_PATH="$BASE/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
"$BASE/host-uic" --version
cmake -S "$BASE/source" -B "$BASE/build" -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="$BASE/build-notes/gcc16-toolchain.cmake" \
  -DCMAKE_PREFIX_PATH=/mnt/data/pcsx2_gcc16_fullbuild/deps \
  -DPCSX2_FORCE_DEVBUILD=ON -DENABLE_QT_UI=ON -DENABLE_GSRUNNER=OFF \
  -DCMAKE_BUILD_TYPE=Release
cmake --build "$BASE/build" --parallel "${BUILD_JOBS:-2}" --target pcsx2-qt updater
test -s "$BASE/build/pcsx2-qt/pcsx2-qt.exe"
mkdir -p "$GITHUB_WORKSPACE/dist"
python3 "$GITHUB_WORKSPACE/scripts/package-batch25.py" "$BASE" "$GITHUB_WORKSPACE/dist/PCSX2_Developer_Windows_x64.zip"
(cd "$GITHUB_WORKSPACE/dist" && sha256sum PCSX2_Developer_Windows_x64.zip > SHA256SUMS.txt)
