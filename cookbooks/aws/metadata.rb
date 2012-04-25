maintainer       "Intuit Inc"
maintainer_email "brett_weaver@intuit.com"
license          "All rights reserved"
description      "AWS Cookbook"
version          "0.1.0"
depends          "python"

%w{ redhat }.each do |os|
    supports os
end
