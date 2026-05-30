BUILDDIR := build
LATEXMK  := latexmk
LMKFLAGS := -pdf -interaction=nonstopmode -outdir=$(BUILDDIR)

TEX_LIST ?=

.PHONY: all build-list clean fmt

all: | $(BUILDDIR)
	@find . -maxdepth 1 -name '*.tex' | while IFS= read -r f; do \
		$(LATEXMK) $(LMKFLAGS) "$$f"; \
	done

# Build only root-level .tex files listed in TEX_LIST (one path per line).
build-list: | $(BUILDDIR)
	@test -n "$(TEX_LIST)" && test -s "$(TEX_LIST)"
	@while IFS= read -r f; do \
		[ -n "$$f" ] || continue; \
		$(LATEXMK) $(LMKFLAGS) "$$f"; \
	done < "$(TEX_LIST)"

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

fmt:
	tex-fmt --fail-on-change $$(find . -maxdepth 1 -name '*.tex') references.bib
