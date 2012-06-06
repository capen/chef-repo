name 'baseline'
description 'Prepare chef and apply Intuit tweaks'
run_list 'recipe[intu-baseline-tweaks]'

override_attributes(
  "iptables" => {
    "enabled" => false
  }
)
