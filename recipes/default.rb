require "tmpdir"

filename = "raptor2-#{node.raptor.version}"
td = Dir.tmpdir
local_tarball = File.join(td, "#{filename}.tar.gz")
tarball_dir = File.join(td, "#{filename}")

remote_file(local_tarball) do
  source "http://download.librdf.org/source/#{filename}.tar.gz"
  not_if {File.exists?("/usr/local/lib/libraptor2.so")}
end

bash "extract, make, and install #{local_tarball}" do
  user "root"
  cwd "/tmp"
  code <<-EOS
    tar xzf #{local_tarball}
    cd #{tarball_dir}
    ./configure
    make
    make install
    cd ..
    rm -rf #{tarball_dir}
    rm #{local_tarball}
    ldconfig
  EOS

  creates "/usr/local/lib/libraptor2.so"
end

