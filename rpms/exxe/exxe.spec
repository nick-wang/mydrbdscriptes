#
# spec file for package exxe
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

Name:           exxe
Version:        0.8.1+git.7781be1
Release:        0
Summary:        Execute commands indirectly for DRBD
License:        GPL-3.0
Group:          Productivity/Clustering/HA
Url:            http://git.drbd.org/exxe.git/
Source:         %{name}-%{version}.tar.bz2
BuildRequires:  gcc
BuildRequires:  python

BuildRequires:  autoconf
BuildRequires:  automake
%if %{with test}
BuildRequires:  bc
%endif

BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
A shell-like utility that executes arbitrary commands read from standard
input and reports the results of those commands on standard output.

%prep
%setup -q -n %{name}-%{version}

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
    cat tests/test-suite.log || true
    exit 1
fi
%endif

%install
make install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
/usr/bin/exxe
%{py_sitedir}/exxe.py*

%changelog
