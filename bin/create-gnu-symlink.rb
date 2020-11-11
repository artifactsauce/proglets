#!/usr/bin/env ruby

command_path = '/usr/local/opt/coreutils/bin'
r = /\/usr\/local\/Cellar\/coreutils\/.+\/bin\/g(.+)/

Dir.entries(command_path).each do |file|
  path = "#{command_path}/#{file}"
  if File.symlink?(path) then
    src = File.realpath(path)
    cmd = src.slice(r, 1)
    if ! cmd.nil? then
      dst = "#{command_path}/#{cmd}"
      if File.exists?(dst) && File.symlink?(dst) then
        p File.realpath(dst)
      end
      # p "#{src} => #{dst}"
      # symlink(src, dst)
    end
  end
end
