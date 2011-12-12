FXAA Post Process Injection Tool
Based on NVIDIA FXAA
Credits at bottom of this file!

Check @ assembla.com for source code, updates, info, bug submission and feature requests.

http://www.assembla.com/spaces/fxaa-pp-inject/



This version is for Directx 9

May be incompatible with any other form of antialiasing! 
Can be combined with downsampling!

-----------------------------
WARNING: 
-----------------------------
	Do not use this tool while playing on anti cheat enabled servers (may be detected as a cheating measure)!

-----------------------------
Install: 
	If the game uses DirectX 9, put all files and folders into the directory containing the games executable.

-----------------------------
Uninstall: 
-----------------------------
	Delete the files.

-----------------------------
Important:
-----------------------------
	Install the latest DirectX runtime.

----------------------------- 
How to adjust:
-----------------------------
	Start FXAA_Tool.exe and you are good to go.

-----------------------------
Troubleshooting:
-----------------------------
	A "log.log" file is created to log behaviour/ bugs. Look inside to get additional information.
	If the "log.log" file is not created then you are using the wrong "*.dll" or you put it into the wrong directory.
	If the "log.log" is created but the game crashes or FXAA is disabled, look where the "log.log" is created.
	Usually the shader files and folders go into that particular directory.
	Try to put the files and folders into different directories before saying it doesn't work.
 
 	In some games (e.g. Portal 1 or Halo 1) refuse to accept the alpha channel. 
	A general workaround (lower quality) for those is to add the following line at the beginning of shader.fx : #define FXAA_GREEN_AS_LUMA 1
 	There is a way to experiment with sharpening/custom shaders. 
	I added an example. To activate additional sharpening filter change edit the line "//Replace this line with #include "Sharpen.h" to add a sharpening pass" in shader.fx.
	Note that right now sharpening is only an example that it can be done. 
	I more-or-less copypasted a random sharpen filter to show how my mod can be modded.
	Compilerlogs for custom shaders are written to "log.log".

-----------------------------
Keys:
-----------------------------
 PAUSE : Enable/Disable all shaders
 PRINT SCREEN : Screenshot 
 (Usage of an external application for screenshots is recommended, a lot of games have Print Screen hardcoded, and that will not deliver a post processed result)



*********************************************
NVIDIA FXAA 3.11 is created by TIMOTHY LOTTES
*********************************************


Injection mod orignates from www.3dcenter.org

Forum thread: http://www.forum-3dcenter.org/vbulletin/showthread.php?t=510658

-----------------------------
Injection method provided by: 

[some dude]

-----------------------------
Code added and aranged by:

[some dude]

BeetleatWar1977

[DKT70]

Violator

fpedace

----------------------------
Thanks to all the people testing and giving feedback on this. :)