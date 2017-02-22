state("snes9x")
{
	uint someValue : "snes9x.exe", 0x303818;
}

init
{

}

update
{

}

exit
{

}

start
{
	return current.someValue == 10 && old.someValue == 0;
}

split
{
	return current.someValue == 8200 && old.someValue == 0;
}
