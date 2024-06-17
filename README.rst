============================
Odoo container image
============================

Credits
=======

Build on top of the great `acsone/odoo-bedrock <https://github.com/acsone/odoo-bedrock>`
Some inspiration has been drawn from
`camptocamp/docker-odoo-project <https://github.com/camptocamp/docker-odoo-project>`_

Contributors
~~~~~~~~~~~~

* Sébastien Beau <sebastien.beau@akretion.com>
* Raphaël Reverdy <raphael.reverdy@akretion.com>


Binary tools
============

migrate
~~~~~~~

The migrate cmd line an extended version of **click-odoo-update**
It have exactly the same behaviour but with two new features

- for all modules in **odoo/local-src** migrations script inside the directory "migrations/0.0.0"
  are always run
- for the module custom_all you can add "before.sql" script and the request will be run before
  the update of module


initdb
~~~~~~~

This script is used to create a database from scratch, with cache based on click-odoo-initdb


runtests
~~~~~~~~~

This script is used to execute the custom test on the ci


To Test locally
===============

Cmd line inside of this current directory

``` docker build -f 17.0-light/Dockerfile -t try-local . ```

Now in the Docker file of your odoo project:

replace

```FROM ghcr.io/akretion/odoo-docker:17.0-light-latest as base ```

by

```FROM try-local:latest as base```
