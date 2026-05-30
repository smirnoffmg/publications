BUILDDIR := build
LATEXMK  := latexmk
LMKFLAGS := -pdf -interaction=nonstopmode -outdir=$(BUILDDIR)

.PHONY: all clean fmt

all: | $(BUILDDIR)
	@find . -maxdepth 1 -name '*.tex' | while IFS= read -r f; do \
		$(LATEXMK) $(LMKFLAGS) "$$f"; \
	done

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)

fmt:
	tex-fmt --fail-on-change $$(find . -maxdepth 1 -name '*.tex') references.bib
