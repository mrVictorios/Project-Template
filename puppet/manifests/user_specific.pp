### User Spefic
#
#   Description configure youre own machine
#

### Paths
Exec { path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin" ] }

### stages
stage { 'prepare': before => Stage['update'] }
stage { 'update' : before => Stage['main'] }
