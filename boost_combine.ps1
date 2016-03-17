
$boost_dir = "C:\Boost"
$boost_lib_dir = $boost_dir + "\lib"
$boost_debug_dir = $boost_lib_dir + '\' + "debug"
$boost_release_dir = $boost_lib_dir + '\' + "release"
$boost_lib_filename = "boost.lib"
$boost_debug_path = $boost_debug_dir + '\' + $boost_lib_filename
$boost_release_path = $boost_release_dir + '\' + $boost_lib_filename
$boost_debug_output_path = $env:APPVEYOR_BUILD_FOLDER + "\release\" + $boost_lib_filename
$boost_release_output_path = $env:APPVEYOR_BUILD_FOLDER + "\debug\" + $boost_lib_filename

# Original batch file converted to Powershell:
# call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86_amd64
# cd .\lib
# IF not exist release (mkdir release)
# IF not exist debug (mkdir debug)
# lib.exe /OUT:release\boost.lib *mt-1_*.lib
# lib.exe /OUT:debug\boost.lib *mt-gd-1_*.lib
# PAUSE

#Set environment variables for Visual Studio Command Prompt
# From http://evandontje.com/2013/06/06/emulate-the-visual-studio-command-prompt-in-powershell/
pushd 'C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC'
cmd /c "vcvarsall.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
write-host "`nVisual Studio Command Prompt variables set." -ForegroundColor Yellow

# Debug path
# echo ($env:Path).Replace(';',"`n")

# Set-Location $boost_lib_dir
pushd $boost_lib_dir

# md $release_dir
New-Item -Force -ItemType directory -Path $boost_debug_dir
# md $boost_debug_dir
New-Item -Force -ItemType directory -Path $boost_release_dir

& lib.exe /OUT:debug\boost.lib *mt-gd-1_*.lib
& lib.exe /OUT:release\boost.lib *mt-1_*.lib

# md $debug_output_path
New-Item -Force -ItemType directory -Path $debug_output_path
# md $release_output_path
New-Item -Force -ItemType directory -Path $release_output_path

Copy-Item -Path $boost_debug_path -Destination $boost_debug_output_path
Copy-Item -Path $boost_release_path -Destination $boost_release_output_path

popd