# From scratch

```bash
# Make sure im me
useradd -m morgan
passwd morgan
echo "morgan ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/morgan
su morgan

# Get the general config
sudo apt update -y && \
sudo apt install -y git && \
git clone https://github.com/mjdall/zsh.git ~/.morgan_zsh; \
sudo -E ~/.morgan_zsh/script/bootstrap && \
~/.morgan_zsh/script/install && \
~/.morgan_zsh/script/test

# Get tylers stuff
# install-tyler
```
