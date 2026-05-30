# Publications

LaTeX papers and bibliographies for scientific publications.

## Build

```bash
make        # compile all root-level .tex files to build/
make clean  # remove build artifacts
```

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
