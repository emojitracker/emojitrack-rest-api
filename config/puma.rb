workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['PUMA_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'
quiet       ENV['QUIET']    || false

# on_worker_boot do
# end
