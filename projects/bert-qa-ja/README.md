# bert-qa-ja

Finetune and test a Japanese BERT model for question answering tasks.

## How to dev

Build `bert-qa-ja-base` image, start a container attached with the source code, 
and attach to the container to continue the development.

### Prerequisites

- Docker

### Init

```
# cd to this directory
$ ./build-dev.sh  # build the image and start a container
# Attach to the container from bash, vscode, etc.
```

### Resume

```
$ docker start bert-qa-ja-dev
```