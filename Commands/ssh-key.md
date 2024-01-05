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

Once you get the exact location of your ssh key whatever path to the key you want, you should copy that only for github or other places that need the public key registered.

```bash
cat '/path/to/your/.ssh/sshkey_name.pub'
```

This will print and copy your public key to the clipboard.

# Add to github

To add the ssh key to github for access, you need to enter github through the web (I couldn't find a way to do this via Github application)

On the top right side of the corner click your profile icon > Setting > SSH and GPG key. You will be able to "Add new SSH Key." Click on it, set the type as "Authentication Key" and paste your key in. Lastly, at the title, list what device you are registering the key for so you can remember what to deactivate or recreate when the key is exposed.