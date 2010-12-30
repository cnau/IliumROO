This file is part of Ilium MUD.

Ilium MUD is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ilium MUD is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ilium MUD.  If not, see <http://www.gnu.org/licenses/>.

IliumROO has been running on ruby-head (1.9.3x).  Using RVM you can
install ruby-head with a gemset for IliumROO composed of the gems
below.

Some of these gems will be installed as part of the installation of
other gems.  Start installing from the top and work your way down.
Gems required:
cassandra (0.8.2)
eventmachine (0.12.10)
json (1.4.6)
log4r (1.1.9)
mocha (0.9.10)
rake (0.8.7)
rspec (2.2.0)
simple_uuid (0.1.1)
archive-tar-minitar (0.5.2)
columnize (0.3.2)
diff-lcs (1.1.2)
rspec-core (2.2.1)
rspec-expectations (2.2.0)
rspec-mocks (2.2.0)
ruby_core_source (0.1.4)
thrift (0.2.0.4)
thrift_client (0.5.0)

Cassandra can be run at the command line using the gem itself, or
freshly built from the source.  I'd recommend building from the 
source, since that will pull in all of Cassandra's requirements.

In Cassandra's storage-conf.xml file, add the following lines into
the <Keyspaces> tag and restart Cassandra:

<Keyspace Name="IliumROO">
    <ColumnFamily CompareWith="UTF8Type" Name="objects"/>
	<ColumnFamily ColumnType="Super" CompareWith="UTF8Type"
			CompareSubcolumnsWith="UTF8Type" Name="object_tags"/>
	<ColumnFamily ColumnType="Super" CompareWith="TimeUUIDType"
			CompareSubcolumnsWith="UTF8Type" Name="log"/>
	<ReplicaPlacementStrategy>org.apache.cassandra.locator.RackUnawareStrategy</ReplicaPlacementStrategy>
	<ReplicationFactor>1</ReplicationFactor>
	<EndPointSnitch>org.apache.cassandra.locator.EndPointSnitch</EndPointSnitch>
</Keyspace>