# node.jsonの設定項目
# host_user = ARGV[6]
host_user = node[:group][:adm][:members][1]
host_root = "/home/#{host_user}"
puts host_user
puts host_root
puts node[:platform]
# update & upgrade
if node[:platform] == 'ubuntu' && node[:platform_version] == '18.04'
    execute 'apt-get update'
    execute 'apt-get upgrade -y'

    # 所有権を変更する，Rオプションでディレクトリごと変更
    execute "sudo chown -R #{host_user} ."

    # git
    package "git"
    git "thirdfis_ssd" do
        repository "https://i_nishiyama@bitbucket.org/i_nishiyama/aws.git"
        user "#{host_user}"
        cwd "#{host_root}"
    end

    # 必要なパッケージをapt-get
    package "build-essential"
    package "cmake"
    package "unzip"
    package "zip"
    package "gcc"
    package "make"
    package "openssl"
    package "libssl-dev"
    package "libbz2-dev"
    package "libreadline-dev"
    package "libsqlite3-dev"
    package "python-dev"
    package "python3-dev"
    package "python-pip"
    package "python3-pip"
else
    puts node[:platform]
    puts node[:platform_version]
end