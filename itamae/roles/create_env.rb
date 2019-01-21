# command : 
# itamae ssh -j node.json -h aws-kadai -u ec2-user roles/create_env.rb
include_recipe '../cookbooks/apt/default.rb'
# Python	Python 3.6.0 :: Anaconda 4.3.1 (64-bit)
include_recipe '../cookbooks/python/default.rb'
# # docker docker-compose
# include_recipe '../cookbooks/docker/default.rb'