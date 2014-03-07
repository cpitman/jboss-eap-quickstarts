notify { "Puppet Running":
	message => "Puppet is running!"
}

package { "java-1.7.0-openjdk-devel":
	ensure => latest
}
-> class { "jboss":
	install => source,
	version => 7,
	bindaddr => "0.0.0.0",
	bindaddr_admin_console => "0.0.0.0"
}
-> file { "/opt/jboss/standalone/configuration/mgmt-users.properties":
	ensure => present,
	content => "admin=e61d4e732bbcbd2234553cc024cbb092",
	owner => jboss
}

class { "maven::maven": }

$repositories = [{
	id => "jboss-ga-repository",
	url => "http://maven.repository.redhat.com/techpreview/all",
	releases => {enabled => true},
	snapshots => {enabled => false}
},
{
	id => "jboss-earlyaccess-repository",
	url => "http://maven.repository.redhat.com/earlyaccess/all/",
	releases => {enabled => true},
	snapshots => {enabled => false}
}]

maven::settings { 'maven-user-settings' :
  repos => $repositories,
  user    => 'vagrant'
}