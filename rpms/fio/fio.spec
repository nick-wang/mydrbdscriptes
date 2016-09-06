#
# spec file for package fio
#
# Copyright (c) 2016 SUSE LINUX GmbH, Nuernberg, Germany.
# Copyright (c) 2012 Pascal Bleser <pascal.bleser@opensuse.org>
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


Name:           fio
Version:        2.13
Release:        0
Summary:        Flexible I/O Tester/benchmarker
License:        GPL-2.0
Group:          System/Benchmark
Url:            http://freshmeat.net/projects/fio/
Source:         http://brick.kernel.dk/snaps/fio-%{version}.tar.bz2
BuildRequires:  gtk2-devel
BuildRequires:  libaio-devel
BuildRequires:  librdmacm-devel
BuildRequires:  pkgconfig
BuildRequires:  zlib-devel
Suggests:       gfio
Suggests:       gnuplot
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
%if 0%{?suse_version} > 1320
BuildRequires:  glusterfs-devel
BuildRequires:  libnuma-devel
%endif
%if 0%{?suse_version} >= 1330
%ifarch x86_64
BuildRequires:  librbd-devel
%endif
%endif

%description
fio is an I/O tool meant to be used both for benchmark and stress/hardware
verification. It has support for 4 different types of I/O engines (sync,
mmap, libaio, posixaio), I/O priorities (for newer Linux kernels), rate I/O,
forked or threaded jobs, and much more. It can work on block devices as
well as files. fio accepts job descriptions in a simple-to-understand text
format. Several example job files are included. fio displays all sorts of
I/O performance information, such as completion and submission latencies
(avg/mean/deviation), bandwidth stats, cpu and disk utilization, and more.

%package -n gfio
Summary:        Graphical front end for fio
Group:          System/Benchmark

%description -n gfio
gfio is a gtk based graphical front-end for fio.  It is often installed on the
testers workstation whereas fio would be installed on the server.

%prep
%setup -q

%build
# Not autotools configure
./configure \
  --enable-gfio
make \
  %{?_smp_mflags} \
  V=1 \
  OPTFLAGS="%{optflags}" \
  CC="cc" \
  prefix="%{_prefix}" \
  libdir="%{_libdir}/fio" \
  mandir="%{_mandir}"

%install
make \
  %{?_smp_mflags} \
  V=1 \
  DESTDIR=%{buildroot} \
  prefix="%{_prefix}" \
  bindir="%{_bindir}" \
  libdir="%{_libdir}/fio" \
  mandir="%{_mandir}" \
  install

%files
%defattr(-,root,root)
%doc COPYING README examples
%doc HOWTO
%{_bindir}/fio
%{_bindir}/fiologparser.py
%{_bindir}/fio_generate_plots
%{_bindir}/genfio
%{_bindir}/fio2gnuplot
%{_bindir}/fio-btrace2fio
%{_bindir}/fio-dedupe
%{_bindir}/fio-genzipf
%{_bindir}/fio-verify-state
%{_bindir}/fio_latency2csv.py
%{_datadir}/fio
%{_mandir}/man1/fio.1%{ext_man}
%{_mandir}/man1/fio_generate_plots.1%{ext_man}
%{_mandir}/man1/fio2gnuplot.1%{ext_man}

%files -n gfio
%defattr(-,root,root)
%doc COPYING README GFIO-TODO
%{_bindir}/gfio

%changelog
