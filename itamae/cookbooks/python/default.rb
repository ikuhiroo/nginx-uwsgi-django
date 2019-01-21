# node.jsonの設定項目
# host_user = ARGV[6]
host_user = node[:group][:adm][:members][1]
host_root = "/home/#{host_user}"
githubProject = node["git-env"]["project"]
pyenv_root = "#{host_root}/.pyenv"
pyenv_versions = node["pyenv"]["version"]
pyenv_global = node["pyenv"]["global"]
pip_list = node["pyenv"]["pip_list"]

if node[:platform] == 'ubuntu' && node[:platform_version] == '18.04'
    # pyenvのclone
    git ".pyenv" do
        repository "https://github.com/yyuu/pyenv.git"
        cwd "#{host_root}"
    end

    # .profileの作成
    file "#{host_root}/.profile" do
      action :create
      content ""
    end
    file "#{host_root}/.profile" do
        action :edit
        block do |content|
            appendix = <<~EOS
                export PYENV_ROOT="#{pyenv_root}"
                export PATH="#{pyenv_root}/shims:#{pyenv_root}/bin:$PATH"
                eval "$(pyenv init -)"
            EOS
            content << appendix
        end
    end
    execute ". #{host_root}/.profile"

    # pythonのインストール
    execute "Install anaconda" do
      cwd "#{pyenv_root}"
      command "#{pyenv_root}/bin/pyenv install #{pyenv_versions}"
      not_if  "#{pyenv_root}/bin/pyenv versions | grep #{pyenv_versions}"
    end

    # pythonのglobal設定
    execute "Set global" do
      cwd "#{pyenv_root}"
      command "#{pyenv_root}/bin/pyenv global #{pyenv_global}"
      not_if  "#{pyenv_root}/bin/pyenv version | grep #{pyenv_global}"
    end

    # pipのライブラリのインストール
    execute "#{pyenv_root}/shims/pip install --upgrade pip"
    execute "#{pyenv_root}/shims/pip install -r #{host_root}/#{githubProject}/#{pip_list}.txt"
else
    puts node[:platform]
    puts node[:platform_version]
end