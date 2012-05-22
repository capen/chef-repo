name 'image-and-runtime'
description 'Image and Runtime Configuration'
run_list 'recipe[base::umask]', 'recipe[git]', 'recipe[aws::cfn-bootstrap]', 'recipe[build-essential]'
