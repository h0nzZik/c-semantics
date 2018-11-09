
# Docker

Build with:
```bash
docker build -t h0nzzik/kframework-fedora -f ./docker/k-fedora/Dockerfile .
```

Run with:
```
docker run -it h0nzzik/k-framework bash
```

# Vagrant

1. Edit `config.sh`.

2. Choose your system.

3. Run `vagrant up`

Once installed, load `env.sh` to add K to your path.

```bash
source ~/env.sh
```



