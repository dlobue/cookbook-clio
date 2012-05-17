
package "python-virtualenv"
package "python-pip"
package "libevent-dev"


user "clio" do
    shell "/bin/false"
    system true
end

git node.clio.dist_dir do
    repository node.clio.git_repo
    revision node.clio.dist_tag
    action [:checkout, :sync]
    notifies :run, "script[install clio deps]"
end

execute "setup clio virtualenv" do
    command 'virtualenv --no-site-packages --distribute --prompt="(clio)" deps'
    creates node.clio.deps_dir
    cwd node.clio.dist_dir
    notifies :run, "script[install clio deps]", :immediately
end

script "install clio deps" do
    action :nothing
    interpreter "bash"
    cwd node.clio.dist_dir
    code <<-EOH
    . deps/bin/activate
    python setup.py egg_info
    pip install -r clio.egg-info/requires.txt
    pip install gevent
    EOH
end


directory node.clio.conf_dir

template node.clio.conf.upstart do
    source "clio_upstart.conf.erb"
    mode "0644"
    owner 'root'
    group 'root'
    variables(
    )
    notifies :stop, 'service[clio]', :immediately
end

template node.clio.conf.gunicorn do
    source "gunicorn.conf.erb"
    mode "0644"
    owner 'root'
    group 'root'
    variables(
    )
    notifies :stop, 'service[clio]', :immediately
end

template node.clio.conf.logger do
    source "logger.conf.erb"
    mode "0644"
    owner 'root'
    group 'root'
    variables(
    )
    notifies :stop, 'service[clio]', :immediately
end

template '/etc/logrotate.d/clio' do
    source 'logrotated.erb'
    mode "0644"
    owner 'root'
    group 'root'
    variables(
    )
end



service "clio" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action :start
    subscribes :reload, "git[#{node.clio.dist_dir}]"
end

