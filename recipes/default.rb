# Copyright (c) 2016 SUSE
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

############################### Note from SUSE #################################
# The goal of this cookbook is to allow customizing templates shipped by SUSE
# in other cookbooks, by "patching" them. For this, we actually override the
# template after it has been defined. To have this work, we need a couple of
# things:
#
#  - Include the update templates in the templates/default/ directory of this
#    cookbook and modify the recipe to make sure that the resources for the
#    template are using the right source (see examples below). You can also
#    change variables passed to the templates, to change the template based on
#    logic in this recipe or inside the template.
#
#  - Re-upload the cookbook with this command:
#        knife cookbook upload -o /opt/dell/chef/cookbooks localoverride
#
#  - Edit the nodes for which you want to override things so that they use this
#    recipe. You can do this on all nodes if desired, and use code in the
#    recipe to do actions only if relevant on that node (see examples below).
#    To achieve this, run "knife node edit $node", go at the bottom, and add at
#    the end of the run_list the following (keep the quotes):
#        "recipe[localoverride::default]"
#
# WARNING WARNING WARNING
#
# If you use as a basis templates from the existing cookbooks, it is critical
# to keep them in sync with the source. So when an update is out, you must
# check that your overriding template is up-to-date with the updated template
# from the original cookbook.
#
# WARNING WARNING WARNING WARNING WARNING WARNING
#
# Everything that you put in this cookbook (this recipe, but also templates and
# more) might be captured in supportconfigs. So please be careful about secrets
# such as passwords, keys, etc.
################################################################################

Chef::Log.info("Using localoverride recipe...")

## Example for changing a template on all nodes
# resource_nova_all = resources(template: "/etc/nova/nova.conf")
# Chef::Log.info("Overriding nova.conf!")
# resource_nova_all.cookbook("localoverride")
# resource_nova_all.source("nova.conf.erb")

## Example for changing a template on nodes with a specific role
# if node.roles.include? "neutron-server"
#   resource_neutron_server = resources(template: "/etc/neutron/neutron.conf")
#   Chef::Log.info("Overriding neutron.conf!")
#   resource_neutron_server.cookbook("localoverride")
#   resource_neutron_server.source("neutron.conf.erb")
# end

## Example for changing a template on nodes where the template is used
# begin
#   resource_haproxy = resources(template: "/etc/haproxy/haproxy.conf")
#   Chef::Log.info("Overriding haproxy.conf!")
#   resource_haproxy.cookbook("localoverride")
#   resource_haproxy.source("haproxy.conf.erb")
# rescue Chef::Exceptions::ResourceNotFound
#   Chef::Log.info("Ignoring haproxy.conf override...")
# end

## Example for changing variables used in a template, without changing the
## template
# resource_keystone = resources(template: "/etc/keystone/keystone.conf")
# Chef::Log.info("Overriding variables for keystone.conf!")
# keystone_variables = resource_keystone.variables
# keystone_variables[:sql_connection] = "postgresql://user:password@10.0.0.1/keystone"
# resource_keystone.variables(keystone_variables)

## Example for changing the template and changing/adding variables used in the
## template
# resource_cinder = resources(template: "/etc/cinder/cinder.conf")
# Chef::Log.info("Overriding cinder.conf!")
# resource_cinder.cookbook("localoverride")
# resource_cinder.source("cinder.conf.erb")
# cinder_variables = resource_cinder.variables
# cinder_variables[:sql_connection] = "postgresql://user:password@10.0.0.1/cinder"
# cinder_variables[:new_option] = "value"
# resource_cinder.variables(cinder_variables)
