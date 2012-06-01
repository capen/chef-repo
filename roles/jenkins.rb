name 'jenkins'
description 'Single Jenkins Box'
run_list 'recipe[intu-baseline-tweaks]', 'recipe[iptables]', 
         'recipe[jenkins]', 'recipe[jenkins::proxy_apache2]'

override_attributes(
  "iptables" => {
    "enabled" => false
  }
)
