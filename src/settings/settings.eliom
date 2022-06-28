[%%import "settings_profile.mlh"]

[%%if (profile = "dev")]
include Settings_dev
[%%elif (profile = "beta")]
include Settings_beta
[%%elif (profile = "prod")]
include Settings_prod
[%%else]
[%%error "Invalid settings profile. Valid values are dev, beta or prod."]
[%%endif]
