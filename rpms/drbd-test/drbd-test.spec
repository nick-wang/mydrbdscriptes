#
# spec file for package drbd-test
#
# Copyright (c) 2016 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

# needssslcertforbuild

Name:           drbd-test
Version:        0.0.0+git.d32163e
Release:        0
Summary:        Test suite for version 9 of DRBD
License:        GPL-3.0
Group:          Productivity/Clustering/HA
Url:            http://git.drbd.org/drbd-test.git/
Source:         %{name}-%{version}.tar.bz2
Patch0:         fix-resync-never-connected.KNOWN.patch
BuildArchitectures: noarch

Requires:       exxe
Requires:       logscan

BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
This mainly is a test suite for version 9 of DRBD.
The test scripts themselves are relatively simple shell scripts,
with additional utilities for running commands remotely and for
scanning log files for events.

%prep
%setup -q -n %{name}-%{version}
%patch0 -p1

%build
cd target
make

%install
make install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%dir /usr/share/drbd-test/
/usr/share/drbd-test/*

%changelog
