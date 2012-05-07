name 'base'
description 'Base Configuration'
run_list 'recipe[base::umask]', 'recipe[git]', 'recipe[aws::cfn-bootstrap]', 'recipe[build-essential]'
