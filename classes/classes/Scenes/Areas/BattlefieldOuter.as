/**
 * @author Ormael
 * Area with lvl 6-42 group enemies. Good for PC focused on group fights.
 * Currently a Work in Progress
 */
package classes.Scenes.Areas 
{
import classes.*;
import classes.GlobalFlags.kFLAGS;
import classes.CoC;
import classes.Scenes.Areas.Battlefield.*;
import classes.Scenes.SceneLib;

use namespace CoC;
	
	public class BattlefieldOuter extends BaseContent
	{
		
		public function BattlefieldOuter() 
		{
		}
		
		public function exploreOuterBattlefield():void {
			flags[kFLAGS.DISCOVERED_OUTER_BATTLEFIELD]++;
			//Twin Grakaturd
			if (player.hasStatusEffect(StatusEffects.TelAdreTripxiGuns6) && player.statusEffectv1(StatusEffects.TelAdreTripxiGuns6) == 0 && player.statusEffectv2(StatusEffects.TelAdreTripxi) == 1 && rand(2) == 0) {
				partsofTwinGrakaturd();
				return;
			}
			//Helia monogamy fucks
			if (flags[kFLAGS.PC_PROMISED_HEL_MONOGAMY_FUCKS] == 1 && flags[kFLAGS.HEL_RAPED_TODAY] == 0 && rand(10) == 0 && player.gender > 0 && !SceneLib.helFollower.followerHel()) {
				SceneLib.helScene.helSexualAmbush();
				return;
			}
			//Etna
			if (flags[kFLAGS.ETNA_FOLLOWER] < 1 && flags[kFLAGS.ETNA_TALKED_ABOUT_HER] == 2 && !player.hasStatusEffect(StatusEffects.EtnaOff) && rand(5) == 0 && (player.level >= 20)) {
				SceneLib.etnaScene.repeatYandereEnc();
				return;
			}
			//Diana
			if (flags[kFLAGS.DIANA_FOLLOWER] < 6 && player.statusEffectv4(StatusEffects.CampSparingNpcsTimers2) < 1 && !player.hasStatusEffect(StatusEffects.DianaOff) && rand(10) == 0) {
				SceneLib.dianaScene.repeatLakeEnc();
				return;
			}
			//Ted
			if (flags[kFLAGS.TED_LVL_UP] >= 1 && flags[kFLAGS.TED_LVL_UP] < 4 && player.statusEffectv1(StatusEffects.CampSparingNpcsTimers4) < 1 && rand(10) == 0) {
				SceneLib.tedScene.introPostHiddenCave();
				return;
			}
			
			var choice:Array = [];
			var select:int;
			
			//Build choice list!
			choice[choice.length] = 0; //Golem group enemies
			choice[choice.length] = 1; //Golem group enemies
			choice[choice.length] = 2; //Golem group enemies
			choice[choice.length] = 3; //Goblin/Imp group enemies
			choice[choice.length] = 4; //Goblin/Imp group enemies
			choice[choice.length] = 5; //Items
			choice[choice.length] = 6; //Items
			choice[choice.length] = 7; //Find nothing!
			
			select = choice[rand(choice.length)];
			switch(select) {
				case 0:
				case 1:
				case 2:
					SceneLib.exploration.genericGolemsEncounters1();
					break;
				case 3:
				case 4:
					SceneLib.exploration.genericGobImpEncounters1();
					break;
				case 5:
					clearOutput();
					outputText("You spot something on the ground among various items remains. Taking a closer look, it's ");
					if (rand(2) == 0) {
						if (player.level >= 24 && rand(3) == 0) {
							outputText("a mid-grade Soulforce Recovery Pill. ");
							inventory.takeItem(consumables.MG_SFRP, camp.returnToCampUseOneHour);
						}
						else {
							outputText("a low-grade Soulforce Recovery Pill. ");
							inventory.takeItem(consumables.LG_SFRP, camp.returnToCampUseOneHour);
						}
					}
					else {
						if (player.level >= 24 && rand(3) == 0) {
							outputText("a diluted Arcane Regen Concotion. ");
							inventory.takeItem(consumables.D_ARCON, camp.returnToCampUseOneHour);
						}
						else {
							outputText("a very diluted Arcane Regen Concotion. ");
							inventory.takeItem(consumables.VDARCON, camp.returnToCampUseOneHour);
						}
					}
					break;
				case 6:
					clearOutput();
					outputText("While exploring the battlefield you find the remains of some metal scraps. At first you think you won't find anything useful there but a metal plate draws your attention, it could be useful later. You put the item in your backpack and head back to camp.\n\n");
					outputText("<b>You found a metal plate.</b>");
					flags[kFLAGS.CAMP_CABIN_METAL_PIECES_RESOURCES]++;
					break;
				default:
					clearOutput();
					outputText("You spend one hour exploring this deserted battlefield but you don't manage to find anything interesting. Yet this trip made you become a little bit more wise.");
					dynStats("wis", .5);
					doNext(camp.returnToCampUseOneHour);
			}
		}
		
		public function partsofTwinGrakaturd():void {
			clearOutput();
			outputText("As you explore the (outer) battlefield you run into what appears to be the half buried remains of some old contraption. Wait this might just be what that gun vendor was talking about! You proceed to dig up the items releasing this to indeed be the remains of a broken firearm.\n\n");
			outputText("You carefully put the pieces of the Twin Grakaturd in your back and head back to your camp.\n\n");
			player.addStatusValue(StatusEffects.TelAdreTripxiGuns6, 1, 1);
			player.addStatusValue(StatusEffects.TelAdreTripxi, 2, 1);
			player.createKeyItem("Twin Grakaturd", 0, 0, 0, 0);
			doNext(camp.returnToCampUseOneHour);
		}
	}
}