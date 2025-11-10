# mac-bootstrap

Bootstrap script for setup new Macbook.

`bootstrap.sh` does following things:

1. Installs `Xcode`, `git`, `Homebrew`
2. Setups ssh keys for Github account
3. Clones private repo with the rest setup using Ansible
4. Runs setup from private repo

## Usage

To run script paste below command in the new laptop's shell

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/wissnia/mac-bootstrap/refs/heads/main/bootstrap.sh)
```
