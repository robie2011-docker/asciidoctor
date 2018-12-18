# AsciiDoctor Docs Generator
this image is intented to be used in CI enviroment for generating HTML/PDF documents and transfer it via SSH to a document publishing server.

## Installed components
* Node, YARN
* Asciidoctor
* Asciidoctor-Pdf
* Code Highlighter: pygments.rb
* Asciidoctor Diagram
    * mermaid.cli
    

## Example

### Rendering simple ascii doc
Generate Html from `test.doc`, which is located in current working directory.
```bash
docker run -w /data --rm -it -v$(pwd):/data robie2011/asciidoctor asciidoctor -bhtml5 test.adoc
```

### Rendering ascii doc with mermaid diagrams

```bash
docker run -w /data --rm -it -v$(pwd):/data robie2011/asciidoctor asciidoctor -v -r asciidoctor-diagram -a data-uri -b xhtml5 index.adoc
```

### Using build script
```bash
# note: make sure sample_build.sh can be found in /data folder
docker run -w /data --rm -it -v$(pwd):/data robie2011/asciidoctor bash sample_build.sh
```

## Known Issues

https://github.com/prawnpdf/ttfunk/pull/41