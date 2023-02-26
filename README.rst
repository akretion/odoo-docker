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
