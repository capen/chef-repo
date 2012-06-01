name 'jenkins'
description 'Single Jenkins Box'
run_list 'recipe[intu-baseline-tweaks]', 'recipe[jenkins]',
         'recipe[jenkins::proxy_apache2]', 'recipe[iptables]'

override_attributes(
  "iptables" => {
    "enabled" => false
  }
)
