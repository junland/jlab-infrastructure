# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: Apache Log Analyzer
Name: goaccess
Version: 1.3
Release: 1%{?dist}
License: GPLv2+
Group: Applications/Utilities
URL: http://goaccess.io 
SOURCE0 : %{name}-%{version}.tar.gz

%description
An open source real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems. It provides fast and valuable HTTP statistics for system administrators that require a visual server report on the fly.

%prep
%autosetup
# Prevent flags being overridden again and again.
#sed -i 's|-pthread|$CFLAGS \0|' configure.ac
sed -i '/-pthread/d' configure.ac

%build
autoreconf -fiv
%configure --enable-geoip --enable-utf8 --with-getline --with-openssl

%make_build

%install
	
%make_install
	
%find_lang %{name}

%files -f %{name}.lang
%license COPYING
%config(noreplace) %{_sysconfdir}/%{name}/%{name}.conf
%config(noreplace) %{_sysconfdir}/%{name}/browsers.list
%{_bindir}/%{name}
%{_mandir}/man1/%{name}.1*

%changelog
* Sat Apr 18 2020  John Unland <unlandj@jlab.space> 1.3-1
- First Build