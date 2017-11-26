mkdir All_compiled
mkdir All_compiled\JAR
mkdir All_compiled\APK
for /D %%f in (*) do copy  %%f\dist\*.apk  All_compiled\APK
for /D %%f in (*) do copy  %%f\dist\*.jar  All_compiled\JAR