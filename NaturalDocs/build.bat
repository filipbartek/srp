setlocal

rem Expects:
rem Environment variable NATURALDOCS points to NaturalDocs directory.
rem Directory %INPUT_REL% exists.

set INPUT_REL=..\src
set OUTPUT_REL=output
set PROJECT_REL=project

pushd %INPUT_REL%
set INPUT_ABS=%CD%
popd

mkdir %OUTPUT_REL%
pushd %OUTPUT_REL%
set OUTPUT_ABS=%CD%
popd

mkdir %PROJECT_REL%
pushd %PROJECT_REL%
set PROJECT_ABS=%CD%
popd

pushd %NATURALDOCS%
NaturalDocs^
 --input "%INPUT_ABS%"^
 --output HTML "%OUTPUT_ABS%"^
 --project "%PROJECT_ABS%"^
 --tab-length 2
popd

endlocal
