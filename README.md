# AutoBuild-OpenWrt (ImageBuilder edition)

This repo builds x86_64 ImmortalWrt 24.10 images using **ImageBuilder** (fast) plus an optional **SDK ipk feed** for third‑party packages.

## Why
- Avoid GitHub Actions 6h timeouts (no toolchain/kernel rebuild)
- Keep your "select packages + default config + third-party plugins" workflow

## Pipeline
### 1) packages feed (optional but recommended)
Builds `.ipk` packages with ImmortalWrt SDK and publishes an opkg feed (Packages.gz).

### 2) image build (ImageBuilder)
Downloads ImageBuilder tarball and runs:

```sh
make image PROFILE="generic" PACKAGES="..." FILES="./files"
```

`FILES` injects defaults (uci-defaults, sysctl, openclash core/UI assets, etc.).

## Inputs to set
- `IB_URL`: ImmortalWrt 24.10 x86_64 ImageBuilder tarball URL
- `SDK_URL`: ImmortalWrt 24.10 x86_64 SDK tarball URL

You can pin exact release versions for reproducibility.

## Notes
- UI/menu/text patches must be shipped as your own ipk (via SDK feed). ImageBuilder cannot patch and rebuild source.
- OpenClash core/UI files are injected via `files/` (see `scripts/preset-clash-core.sh`).
