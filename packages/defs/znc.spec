# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: An advanced IRC bouncer
Name: znc
Version: 1.7.5
Release: 1%{?dist}
License: ASL 2.0
Group: Applications/Utilities
URL: http://goaccess.io 
SOURCE0 : %{name}-%{version}.tar.gz

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
ZNC is an IRC bouncer with many advanced features like detaching, multiple users, per channel playback buffer, SSL, IPv6, transparent DCC bouncing, Perl and C++ module support to name a few.

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}
cp -a * %{buildroot}

%pre
getent group znc >/dev/null || groupadd -r znc
getent passwd znc >/dev/null || useradd -r -g znc -d /var/lib/znc -s /sbin/nologin -c "Account for ZNC to run as" znc

%post
%systemd_post znc.service

%postun
%systemd_postun_with_restart znc.service

%preun
%systemd_preun znc.service

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
/

%changelog
* Sat Apr 18 2020  John Unland <unlandj@jlab.space> 1.3-1
- First Build