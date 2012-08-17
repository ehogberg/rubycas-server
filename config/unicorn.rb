# Sample configuration file for Unicorn (not Rack)
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
SINATRA_ROOT = `pwd`.strip

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 3

preload_app true

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory SINATRA_ROOT # available in 0.94.0+

