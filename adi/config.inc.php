; <?php exit; // DO NOT DELETE?>
; DO NOT DELETE THE ABOVE LINE!!!
; Doing so will expose this configuration file through your web site!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[general]
installed = Off
base_url = "http://localhost:8080"
strict = Off
session_cookie_name = OJSSID
session_lifetime = 30
session_samesite = Lax
scheduled_tasks = On
scheduled_tasks_report_error_only = On
time_zone = "UTC"
date_format_short = "Y-m-d"
date_format_long = "F j, Y"
datetime_format_short = "Y-m-d h:i A"
datetime_format_long = "F j, Y - h:i A"
time_format = "h:i A"
allow_url_fopen = Off
restful_urls = On
trust_x_forwarded_for = On
show_upgrade_warning = On
enable_minified = On
enable_beacon = On
sitewide_privacy_statement = Off
user_validation_period = 28
sandbox = Off

[database]
driver = mysqli
host = db
username = ojs
password = ojs_password
name = ojs
port = 3306
debug = Off

[cache]
object_cache = none
memcache_hostname = localhost
memcache_port = 11211
web_cache = Off
web_cache_hours = 1

[i18n]
locale = en
connection_charset = utf8

[files]
files_dir = files
public_files_dir = public
public_user_dir_size = 5000
umask = 0022

[security]
force_ssl = Off
session_cookie_secure = Off

[email]
default = log