#
# Cookbook Name:: testcookbook
# Recipe:: chef-gluster
#
# Setup file system for brick dir (instead of using lvm)

include_recipe 'parted::default'

parted_disk '/dev/sdb' do
  label_type "gpt"

  action :mklabel
end

parted_disk "/dev/sdb" do
  part_type   "primary" # logical or extended
  file_system "ext4"

  action :mkpart
end

parted_disk "/dev/sdb1" do
  file_system "ext4"
  part_start  "1"
  part_end    "-1"

  action :mkfs
end

directory node['gluster']['server']['brick_mount_path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

mount node['gluster']['server']['brick_mount_path'] do
  device '/dev/sdb1'
  fstype 'ext4'
  action [:mount, :enable]
end
