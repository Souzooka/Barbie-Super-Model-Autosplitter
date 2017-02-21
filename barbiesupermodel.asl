state("snes9x")
{
	
}

init
{
	vars.sceneIdCurrent = 0; 
}

update
{
	vars.sceneIdOld = vars.sceneIdCurrent;
	vars.sceneIdCurrent = memory.ReadValue<int>((IntPtr)0x02BF2C50);
}

start
{
	return vars.sceneIdCurrent == 2 && vars.sceneIdOld != 2;
}

split
{
	return vars.sceneIdCurrent == 7 && vars.sceneIdOld == 3;
}

