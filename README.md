# AsciiDoctor Docs Generator
this image is intented to be used in CI enviroment for generating HTML/PDF documents and transfer it via SSH to a document publishing server.

## Installed components
* Node, YARN
* Asciidoctor
* Asciidoctor-Pdf
* Asciidoctor Diagram
    * mermaid.cli
    

## Example
Generate Html from `test.doc`, which is located in current working directory.
```bash
docker run -w /data --rm -it -v$(pwd):/data robie2011/asciidoctor asciidoctor -bhtml5 test.adoc
```
