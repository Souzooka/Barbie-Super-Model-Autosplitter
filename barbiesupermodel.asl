state("snes9x")
{
	uint someValue : "snes9x.exe", 0x303818;

}

init 
{
	Action<string> rescan = (text) => {
		var module = modules.First();
		var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);

		vars.someValueCodeAddr = scanner.Scan(vars.someValueCodeTarget);
		vars.someValueAddr = memory.ReadValue<int>((IntPtr)vars.someValueCodeAddr) + 0x204;
		print(vars.someValueAddr.ToString("X"));
	};
	vars.rescan = rescan;

	vars.someValueAddr = (IntPtr)0x204;

	vars.someValueCodeTarget = new SigScanTarget(2,
	"88 9E ?? ?? ?? ??",
	"83 E6 1F",
	"8B C6",
	"8D 04 40",
	"C1 E0 04"
	);

	vars.someValueCurrent = 0;

}

update
{
	if ((IntPtr)vars.someValueAddr == (IntPtr)0x204) {
		vars.rescan("ok alrite");
	}

	vars.someValueOld = vars.someValueCurrent;
	vars.someValueCurrent = memory.ReadValue<int>((IntPtr)vars.someValueAddr);

}

start
{
	return vars.someValueCurrent == 10 && vars.someValueOld == 0;
}

split
{
	return vars.someValueCurrent == 8200 && vars.someValueOld == 0;
}
