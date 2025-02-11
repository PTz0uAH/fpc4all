{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses {$ifdef unix}cthreads,{$endif} fpmkunit;

Var
  P : TPackage;
  T : TTarget;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}

    P:=AddPackage('opencl');
    P.ShortName := 'ocl';
{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}
    P.Version:='3.3.1';
    P.Author := ' Dmitry "skalogryz" Boyarintsev; Kronos group';
    P.License := 'Library: modified BSD, header: LGPL with modification, ';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := '';
    P.Description := 'A OpenCL header';
    P.NeedLibC:= true;
    P.OSes:=[android,linux,win64,win32,darwin];
    P.CPUs:=[aarch64,arm,i386,x86_64];

    P.Dependencies.Add('opengl');

    P.SourcePath.Add('src');
    P.IncludePath.Add('src');

    T:=P.Targets.AddUnit('cl.pp');
    T:=P.Targets.AddUnit('cl_gl.pp');


    P.NamespaceMap:='namespaces.lst';

{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif ALLPACKAGES}
