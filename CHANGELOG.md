# Version 0.1.4
* Added indifferent access to #custom\_attributes's output. *Warning: if you store this in hstore be sure to call output #to_hash, otherwise you may get warnings.*
* Allowed initializing input to have strings as keys.

# Version 0.1.3
* Fixed bug that was preseting :en as default language in applications using this gem.

# Version 0.1.2
* Fixed bug where I18n load path was being entirely replaced, causing errors if there are other gems depending on I18n in the application.

# Version 0.1.1
* New option to GoogleStaticMap#href: `:direction`.
* Added way to customize generated `<img>` html attributes.
* Fixed missing translation.

# Version 0.1.0
* Initial commit, first version.