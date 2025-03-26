$byond_major_version = '509'
$byond_patch_version = '1301'
$byond_url = "http://www.byond.com/download/build/${byond_major_version}/${byond_major_version}.${byond_patch_version}_byond_linux.zip"
$devtools = ['autoconf', 'automake', 'bison', 'byacc', 'crash', 'cscope',
  'ctags', 'cvs', 'diffstat', 'doxygen', 'elfutils', 'flex', 'gcc', 'gcc-c++',
  'gcc-gfortran', 'gdb', 'gettext', 'git', 'indent', 'intltool', 'kexec-tools',
  'latrace', 'libtool', 'ltrace', 'patch', 'patchutils', 'rcs', 'rpm-build',
  'strace', 'subversion', 'swig', 'system-rpm-config', 'systemtap',
  'systemtap-runtime', 'texinfo', 'valgrind']

package { $devtools:
  ensure => installed,
} ->
package { ['glibc.i686', 'libstdc++48.i686']:
  ensure => installed,
} ->
exec { 'download byond':
  command => "/usr/bin/wget ${byond_url}",
  cwd     => '/home/bamboo',
  creates => "/home/bamboo/${byond_major_version}.${byond_patch_version}_byond_linux.zip"
} ->
exec { 'unpack byond':
  command => "/usr/bin/unzip -o ${byond_major_version}.${byond_patch_version}_byond_linux.zip",
  cwd     => '/home/bamboo',
} ->
exec { 'compile byond':
  command => '/usr/bin/make install',
  cwd     => '/home/bamboo/byond',
}
