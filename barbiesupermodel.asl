state("snes9x")
{
	
}

init
{
	vars.sceneIdCurrent = 0;
	vars.sceneIdAddr = IntPtr.Zero;

	vars.sceneIdTarget = new SigScanTarget(0x150,
	"00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 5D 13 A0 50 00 00 00 80 EC 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 62 13 A0 50 00 00 00 80 F1 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 67 13 A0 50 00 00 00 80"
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
				print("sceneIdAddr:" + vars.sceneIdAddr.ToString("X"));

				break;
			}
		}
 	}


	vars.sceneIdOld = vars.sceneIdCurrent;
	vars.sceneIdCurrent = memory.ReadValue<int>((IntPtr)vars.sceneIdAddr);
}

start
{
	return vars.sceneIdCurrent == 2 && vars.sceneIdOld != 2;
}

split
{
	return vars.sceneIdCurrent == 7 && vars.sceneIdOld == 3;
}

