# attributes/default.rb
#
# Author: Simple Finance <ops@simple.com>
# License: Apache License, Version 2.0
#
# Copyright 2013 Simple Finance Technology Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Attributes for proxy cookbook

default[:proxy][:host]                     = 'localhost'
default[:proxy][:databag]                  = 'clients'
default[:proxy][:environment]              = 'dev'

default[:proxy][:global][:user]            = 'haproxy'
default[:proxy][:global][:group]           = 'haproxy'
default[:proxy][:global][:syslog_host]     = 'localhost'
default[:proxy][:global][:syslog_facility] = 'local1'

default[:proxy][:defaults][:maxconn]       = 20000
default[:proxy][:defaults][:contimeout]    = 5000
default[:proxy][:defaults][:clitimeout]    = 50000
default[:proxy][:defaults][:srvtimeout]    = 50000
default[:proxy][:defaults][:stats_uri]     = '/stats'
default[:proxy][:defaults][:stats_realm]   = 'haproxy'
default[:proxy][:defaults][:stats_auth]    = 'admin:secret'
 
default[:proxy][:backend][:interval]       = 2000
default[:proxy][:backend][:rise]           = 2
default[:proxy][:backend][:fall]           = 5
default[:proxy][:backend][:ssl]            = false

