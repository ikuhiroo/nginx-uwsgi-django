if node[:platform] == 'ubuntu' && node[:platform_version] == '18.04'
    # Docker インストール
    package "apt-transport-https"
    package "ca-certificates"
    package "curl"
    package "software-properties-common"
    execute "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
    execute 'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable test edge"'
    execute 'apt-get update'
    package 'docker-ce'
    # Docker デーモンを起動
    execute 'sudo systemctl enable docker'
    # Docker sudo 無しでdocker
    execute "sudo gpasswd -a $USER docker"
    execute "sudo chmod 666 /var/run/docker.sock"

    # docker-compose のインストール
    execute 'sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
    execute "sudo chmod +x /usr/local/bin/docker-compose"

    # システムの再起動
    execute "sudo /sbin/reboot"
else
    puts node[:platform]
    puts node[:platform_version]
end