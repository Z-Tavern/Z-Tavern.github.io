#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	println("replacefunc call for the mod");
	replaceFunc(clientscripts\mp\zombies\_zm_ai_brutus::brutusfootstepcbfunc, scripts\zm\replaced\_zm_ai_brutus::brutusfootstepcbfunc);
}