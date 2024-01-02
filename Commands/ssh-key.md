# ssh-key generation

## Create ssh-key on your machine
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

best to uuse ed25519, but if your machine only supports RSA, use the following command

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Also, get a new machine

## Get public key

This will get all the public keys on your machine 

```bash
ls ~/.ssh/*.pub
```

One you get the exact location of your ssh key whatever path to the key you want, you should copy that only for github or other places that need the public key registered.

```bash
cat '/path/to/your/.ssh/sshkey_name.pub'
```