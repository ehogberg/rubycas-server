# RubyCAS-Server ![http://stillmaintained.com/rubycas/rubycas-server](http://stillmaintained.com/rubycas/rubycas-server.png)

## Quickstart

1.  Clone the project.

2.  bundle install

3.  Rename .env.example to .env, and adjust variable values accordingly.

4.  Run foreman start from the project root directory.

5.  Browser to http://localhost:5000 to (hopefully) see the OLab login screen.

## Editing JavaScript and CSS

JavaScript is written with CoffeeScript. The CSS is written with Sass and
Compass. Guard is used to automatically build these assets (run `bundle exec guard`). It'll
watch for changes, then create the rendered js and css in public.

Unlike Rails on the Heroku Cedar stack, we do not have the option of compiling
assets during slug compilation. Meaning, if you make changes to the Sass or
Coffee files, you must build the assets locally with Guard.

## Copyright

Portions contributed by Matt Zukowski are copyright (c) 2011 Urbacon Ltd.
Other portions are copyright of their respective authors.

## Authors

See http://github.com/gunark/rubycas-server/commits/

## Installation

See http://code.google.com/p/rubycas-server

## License

RubyCAS-Server is licensed for use under the terms of the MIT License.
See the LICENSE file bundled with the official RubyCAS-Server distribution for details.
