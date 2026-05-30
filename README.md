# Publications

LaTeX papers and bibliographies for scientific publications.

## Build

```bash
make        # compile all root-level .tex files to build/
make clean  # remove build artifacts
```

Every root-level `*.tex` file is compiled to a matching PDF under `build/`.

## CI and releases

GitHub Actions (`.github/workflows/latex.yml`) runs on pushes and pull requests to `main`:

- On each push to `main`, compiles only root-level `.tex` files changed in that push
- Rebuilds all papers when `references.bib` or the `Makefile` changes (shared bibliography)
- Skips the LaTeX job when the push touches neither sources nor the bibliography
- Tag pushes and manual runs compile every root-level `.tex` file
- Uploads resulting `build/*.pdf` files as workflow artifacts

To publish PDFs as a [GitHub Release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository), push a version tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Tags must match `v*` (for example `v1.0.0`). The release job attaches every PDF from `build/` to the release. You can also trigger a build manually from the Actions tab (**Run workflow**).

## Development

### Formatting

Sources are formatted with [tex-fmt](https://github.com/WGUNDERWOOD/tex-fmt). A [pre-commit](https://pre-commit.com) hook runs on every commit: it auto-formats staged `.tex` and `.bib` files and aborts if you need to re-stage changes.

**Install tools (once per machine):**

```bash
brew install tex-fmt pre-commit
# or: cargo install tex-fmt && pip install pre-commit
```

**Enable the git hook (once per clone):**

```bash
pre-commit install
```

**Manual formatting:**

```bash
make fmt
# or:
pre-commit run --all-files
```

If a commit fails because files were reformatted, stage the changes and commit again.
