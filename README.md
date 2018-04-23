# Vagrnat LAMP for xtCommerce 5.0.xx

This is a LAMP development environment for xtCommerve 5.0.xx that uses Vagrant. Because of some issues in xtCommerce with mysql 5.7 this environment uses mysql 5.6 this issue should be fixed with xtCommerce 5.1.xx

## Installation

First you need xtCommerce 5.0.xx on your local machine. Then place the `Vagrant` file and the `bootstrap.sh` in the root directory of xtCommerce. After that open your terminal and run the following command.

```bash
$ vagrant up
``` 

That's it now you can use xtCommerce with localhost:8000