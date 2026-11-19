# Known issues and migration prerequisites

- Original Batch 25 customized source is **not yet committed** to `developer`. Repository mode must fail until Game List Logging code is present.
- Frozen 1,271,129,235-byte build environment archive must be published as a GitHub Release asset with its SHA-256 sidecar; do not commit it to Git.
- The imported upstream revision may differ from the revision used by the Batch 25 snapshot. Compare before transplanting changes.
- Build uses absolute paths restored under `/mnt/data` and precompiled objects; GitHub runner compatibility and clean rebuild are unverified.
- Windows executable has not been launched or smoke-tested on Windows.
- Qt SVG plugins and other runtime DLLs must be included in the final distribution.
