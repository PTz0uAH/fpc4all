{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses {$ifdef unix}cthreads,{$endif} fpmkunit;

Var
  T : TTarget;
  P : TPackage;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}
    P:=AddPackage('libvlc');
    P.ShortName := 'lvlc';
{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}
    P.OSes := [android,win32, win64, linux, freebsd];
    P.Dependencies.Add('fcl-base');
    P.Version:='3.3.1';
    P.License := 'LGPL with modification';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := 'michael@freepascal.org';
    P.Description := 'VLC library (version 2 or higher) interface and component.';
    T:=P.Targets.AddUnit('src/libvlc.pp',[android,linux,win32,win64]);
    T:=P.Targets.AddUnit('src/vlc.pp',[android,linux,win32,win64]);
    with T.Dependencies do
      begin
      AddUnit('libvlc');
      end;

    P.NamespaceMap:='namespaces.lst';

{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif}
