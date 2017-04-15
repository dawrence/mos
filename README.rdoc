## Welcome to MOS

Hi you fucking developer. If you're seeing this without being a part of the
exclusive family of 4-sector. you'll be prosecuted, hunted and tortured to death.
Otherwise, welcome home aboard :)


## Getting Started

This version of MOS is built on rails 3.2, and it needs ruby 1.9.3 to run. We highly recommend for *nix based OS to use RVM as the ruby engine for version management.

It also uses postgreSQL as database engine. This version is dependant on the DB engine, so you must use postgreSQL on any environment you might want to run it.

We use Devise as user authentication system, so you might need bcrypt running on your machine. This might be a headache for windows users but should be easily knocked out if you use the locked version on Gemfile.lock.

All new features developed for this repo should be merge requested and tagged on any dev lead for code review. Its highly important to just merge into master and not on any onther branch. Deployment will be managed for any dev lead and in a soon future by CI and CD tools by gitlab.

Join the team on slack 4-sector.slack.com for questions, story planning and anything else you might need from dev-leads and/or product-managers.


To setup a database you need to run the next rake commands :


```
rake db:setup
```

seed the initial data with

```
rake db:seed
```

now create an user. this could be the one

```
User.create(email:"admin@example.com", password:"12345678".password_confirmation:"12345678", id_number:"00000000", role:0)
```

run the following rake tasks in this order:

```
rake roles:new
```

```
rake users:setup
```

```
rake kitchens:initialize
```

```
rake views:queue_products
```

```
rake views:paid_products
```

```
rake views:inventories
```
