#
# spec file for package logscan
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

%bcond_without test

Name:           logscan
Version:        1.5.2+git.e72f5f5
Release:        0
Summary:        Check for patterns in log files for DRBD
License:        GPL-3.0
Group:          Productivity/Clustering/HA
Url:            http://git.drbd.org/logscan.git/
Source:         %{name}-%{version}.tar.bz2
Patch0:          Fix-make-check-error.patch
BuildRequires:  gcc

BuildRequires:  autoconf
BuildRequires:  automake
%if %{with test}
BuildRequires:  pcre-devel
%endif

BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
Watch one or more logfiles, and check for regular expression patterns.

%prep
%setup -q -n %{name}-%{version}
%patch0 -p1

%build
./bootstrap

%configure \
%if ! %{with test}
    --without-test
%endif

make
%if %{with test}
%check
if ! make check
then
    cat tests/all.log || true
    exit 1
fi
%endif

%install
make install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
/usr/bin/logscan

%changelog
