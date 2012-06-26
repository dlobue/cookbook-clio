
default.clio.root_dir = Promise.new { attribute?("root_dir") ? root_dir : "/opt" }

default.clio.dist_tag = '0.2.5'
default.clio.dist_dir = Promise.new { File.join(clio.root_dir, 'clio') }
default.clio.deps_dir = Promise.new { File.join(clio.dist_dir, 'deps') }
default.clio.conf_dir = '/etc/clio'

default.clio.git_repo = 'git://github.com/dlobue/clio.git'

default.clio.port = 64000
default.clio.max_requests = 100

default.clio.conf.gunicorn = File.join(clio.conf_dir, 'gunicorn.conf')
default.clio.conf.logger = File.join(clio.conf_dir, 'logger.conf')

default.clio.conf.upstart = '/etc/init/clio.conf'

