state("snes9x")
{
	
}

init
{
	vars.sceneIdCurrent = 0;
	vars.sceneIdAddr = IntPtr.Zero;

	vars.sceneIdTarget = new SigScanTarget(-0x0,
	"0B 00 00 00 00 55 55 FF FF 01 00 00 20 00 1C 00 AC 01 55 0A 55 55 55 55 0E 55 55 55 55 55 AC 01 55 55 55 55 55 55 55 55 20 00 55 55 55 55 55 55 55 55 1C 00 55 55 55 55 55 55 55 55 9B FC 55 55 55 55 55 55 55 55 F3 FF"
	);
}

update
{

	if (vars.sceneIdAddr == IntPtr.Zero) {
 		foreach (var page in memory.MemoryPages()) {
			var bytes = memory.ReadBytes(page.BaseAddress, (int)page.RegionSize);
			if (bytes == null) {
				continue;
			}
			var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
			vars.sceneIdAddr = scanner.Scan(vars.sceneIdTarget); 
		


			if (vars.sceneIdAddr != IntPtr.Zero) {
				print("sceneIdAddr:" + vars.sceneIdAddr.ToString("X8"));

				break;
			}
		}
 	}

	vars.sceneIdOld = vars.sceneIdCurrent;
	vars.sceneIdCurrent = memory.ReadValue<int>((IntPtr)vars.sceneIdAddr);
}

exit
{
	vars.sceneIdAddr = IntPtr.Zero;
}

start
{
	return vars.sceneIdCurrent == 2 && vars.sceneIdOld != 2;
}

split
{
	return vars.sceneIdCurrent == 7 && vars.sceneIdOld == 3;
}