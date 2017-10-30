
package classes.Scenes.Areas.Forest
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Scenes.API.Encounter;
	import classes.Scenes.API.Encounters;
	import classes.display.SpriteDb;

import coc.xxc.BoundStory;

// TODO @aimozg Missing: Manor dungeon
// TODO @aimozg Missing: Counter Perk
// TODO @aimozg Missing: DullahanHorse Monster: not attackable unless within reach
// TODO @aimozg Missing: Dullahan Monster
// TODO @aimozg Missing: Dullahan Scythe item
// TODO @aimozg Missing: Power-up B.Sword if she is killed

public class DullahanScene extends BaseContent implements Encounter
	{
		public var lust:Number;
		
		public var hasMet:Boolean    = false; //Met the dullahan
		public var wasRude:int       = 0;     //You were rude to the dullahan. No more nice Gan Caenn.
		public var timesWonSpar:int  = 0; //how many times the player has beaten the dullahan while sparring. Used to award the "Counter" ability, and unlock the Manor dungeon.
		public var questStage:int    = 0;//Dullahan has made her request. 0 = not made. 1 = made, accepted, 2 = made, not accepted. 3 = accepted, quest complete, took scythe. 4 = accepted, quest complete, didn't take scythe (inventory was full)
		
		public function save(saveto:*):void{
			saveto.dullahan = {
				hasMet:hasMet,
				wasRude:wasRude,
				timesWonSpar:timesWonSpar,
				questStage:questStage
			}
		}
		public function reset():void {
			hasMet = false;
			wasRude = 0;
			timesWonSpar = 0;
			questStage = 0;
		}
		public function load(loadfrom:*):void{
			if (loadfrom == undefined || loadfrom.dullahan == undefined) {
				reset();
			} else {
				hasMet       = loadfrom.dullahan.hasMet;
				wasRude      = loadfrom.dullahan.wasRude;
				timesWonSpar = loadfrom.dullahan.timesWonSpar;
				questStage   = loadfrom.dullahan.questStage;
			}
		}
		private function hasSlainNecromancer():Boolean {
			return false; // TODO
		}
		private function hasReadEpharimJournalFull():Boolean {
			return false; // TODO
		}
		private function hasReadEpharimJournalPage(page:int):Boolean {
			return false; // TODO
		}
	
	public function encounterName():String {
		return "dullahan";
	}

	public function encounterChance():Number {
		return model.time.hours>=19 && wasRude != 2 ? Encounters.ALWAYS : 0;
	}

	public function execEncounter():void {
		if (wasRude == 1){
			dullahanIntroRude();
		} else if (!hasMet){
			dullahanIntro();
		}else{
			dullahanIntro2();
		}
	}

		public function dullahanIntro():void {
			clearOutput();
			story.display("scenes/intro/first");
			startCombat(new DullahanHorse());
		}
		
		public function dullahanIntroRude():void {
			clearOutput();
			story.display("scenes/intro/rude");
			startCombat(new DullahanHorse());
		}
		
		public function dullahanIntro2():void {
			spriteSelect(SpriteDb.dullsprite);
			clearOutput();
			lust = rand(100);
			story.display("scenes/intro/second",{$scene:this});
			if(timesWonSpar >= 3 && questStage == 0){
				clearOutput();
				story.display("scenes/quest/offer");
				menu();
				addButton(0, "Accept", manorChoice, 1).hint("Accept her request and go to the manor. You can leave before you're done, but you <b>may want to save before accepting anyway.</b>").disable("Not implemented yet, sorry!"); // TODO manor
				addButton(1, "No", manorChoice, 2).hint("Tell her you're not prepared for that right now.");
				return;
			}
			dullMenu();
	
		}
		
		public function manorChoice(choice:int):void{
			spriteSelect(SpriteDb.dullsprite);
			clearOutput();
			switch (choice) {
				case 1:
					story.display("scenes/quest/accept");
					questStage = 1;
					doNext(manorIntro);
					break;
				case 2:
					story.display("scenes/quest/reject");
					questStage = 2;
					dullMenu();
					break;
				case 3:
					story.display("scenes/quest/completed");
//					awardAchievement("A Little Hope", kACHIEVEMENTS.DUNGEON_A_LITTLE_HOPE); TODO
					questStage = 3;
					doNext(dullahanGift);
					break;
				case 4:
					story.display("scenes/quest/nogift");
					questStage = 4;
					dullMenu();
					break;
				case 5:
					questStage = 3;
					dullMenu();
					break;
			}
		}
		
		public function dullahanGift(postponed:Boolean = false):void{
			clearOutput();
			if(!postponed) story.display("scenes/quest/gift");
			if(postponed) questStage = 3;
			// TODO
//			inventory.takeItem(weapons.DULLSC, dullMenu, curry(manorChoice, 4));
			doNext(dullMenu);
		}
		
		public function manorIntro():void{
			clearOutput();
			outputText("\"<i>You will arrive along an old, decrepit road. The path towards the manor twists along and up a jagged hill, where most life has withered away, fleeing from the corruption seeping in the soil. A horrifying sight, but merely a prelude to things to come.\n\n"
			+ "There is a place beneath those ancient ruins overlooking the valley, where nightmare takes shape. He resides there, performing unspeakable transgressions on life and nature. He must be stopped. You must stop him. I’m sorry to ask this from you, [name], but someone must brave through to this abhorrent place and finish this once and for all.\"</i>");
			// doNext(getGame().dungeons.manor.enterDungeon); TODO manor dungeon
			doNext(camp.returnToCampUseOneHour);
		}
		
		public function dullMenu():void {
			menu();
			addButton(0, "About spooking", askAboutDullSpooks).hint("Ask why she tries to spook everyone she sees.");
			addButton(1, "Sex?", askDullSex)
					.hint("Ask for sex. Being forward never hurt you before.")
					.disableIf(player.lust < 33, "You're not aroused enough to bother with sex.");
			addButton(2, "Story?", askAboutDullStory).hint("Exchange life stories.");
			addButton(3, "Spar", sparDull)
					.hint("Ask her if she's interested in sparring.")
					.disableIf(player.HP <= 1, "You're in no shape to fight her!");
			if (questStage == 2) addButton(4, "Manor", manorChoice, 1).hint("Accept her request and go to the Manor.");
			if (hasSlainNecromancer() && questStage != 3) addButton(4, "Necromancer", manorChoice, 3).hint("Tell her you've slain the Necromancer.");
			if (questStage == 4) addButton(4, "Scythe", dullahanGift, true).hint("Take the Dullahan's Scythe.");
			if (hasReadEpharimJournalFull() && questStage == 3){
				addButton(5, "Future", dullahanFuture).hint("Ask her about her plans, now that the Necromancer is dead.");
				addButton(6, "Curse", dullahanCurse).hint("Ask her about her curse, how she acquired it, and how to remove it.");
			}
			if (timesWonSpar >= 3) addButtonDisabled(6, "Her skills", "Ask her about her unique fighting stance.\n\n<b>Sorry, not yet in game!</b>");
			// if (timesWonSpar >= 3 && !player.hasPerk(PerkLib.CounterAB)) addButton(6, "Her skills", learnSkill).hint("Ask her about her unique fighting stance."); TODO
			addButton(13, "Leave", dullLeave).hint("Say goodbye and leave.");
		}
		
		
		public function learnSkill():void{
			clearOutput();
			story.display("scenes/talk/skill-intro");
			if (player.spe < 90){
				story.display("scenes/talk/skill-tooslow");
				dullMenu();
			}else{
				player.fatigue -= 40;
//				player.createPerk(PerkLib.CounterAB, 0, 0, 0,0); TODO
				story.display("scenes/talk/skill-teach");
				doNext(camp.returnToCampUseFourHours);
			}
		}
		
		public function sparDull():void {
			clearOutput();
			story.display("scenes/talk/spar-offer");
			startCombat(new Dullahan());
			monster.createStatusEffect(StatusEffects.Spar,0,0,0,0);
			monster.gems = 0;
		}
		
		public function askDullSex():void {
			var canrape:Boolean = player.hasCock() && player.cor + player.corruptionTolerance() > 60;
			clearOutput();
			menu();
			if (lust >= 33 && player.lust > 33 && questStage == 3) {
				if (!player.isTaur()) {
					story.display("scenes/sex/accept", {$knows: hasReadEpharimJournalPage(2)});
					addButton(0, "Thighjob", dullThighjob)
							.hint("Thigh-highs and toned legs. You can make that work.")
							.disableIf(!player.hasCock());
					addButton(1, "Blowjob", dullBlowjobTease)
							.hint("Blowjob? Can't go wrong with the classics.")
							.disableIf(!player.hasCock());
					addButton(2, "Cunnilingus", dullahanCunnilingus2)
							.hint("That's an unnecessary warning for you.")
							.disableIf(!player.hasVagina());
					addButton(3, "Strap-on", dullahanStrapOn)
							.hint("She can't take, but maybe she can give?")
							.disableIf(!player.hasKeyItem("Demonic Strap-On"));
					addButton(4, "Tentacle Fun", dullTentacleFun)
							.hint("Have some tentacle fun with her.")
							.disableIf(player.countCocksOfType(CockTypesEnum.TENTACLE) >= 4);
				} else {
					addButton(0, "Tentacle Fun", dullTentacleFun)
							.hint("Have some tentacle fun with her.");
					if (player.countCocksOfType(CockTypesEnum.TENTACLE) < 4) {
						button(0).disable();
						story.display("scenes/sex/notaur");
					}
					addButton(1, "Rape", dullOhYouFuckedUp)
							.hint("You're not getting out of here without sex.")
							.disableIf(!canrape);
					addButton(2, "Nah.", dullSexRefused).hint("Well, time to head back to camp, then.", null);
				}
			} else {
				story.display("scenes/sex/decline", {$canrape: canrape});
				addButton(2, "...Nah", dullMenu)
						.hint("You just can't be bothered right now.");
				addButton(5, "Rape", dullOhYouFuckedUp)
						.hint("Take her by force. <b>This is a bad idea.</b>")
						.disableIf(!canrape);
			}
			flushOutputTextToGUI();
		}
		
		public function dullOhYouFuckedUp():void {//she fucks your soul out. Then the rest of you too.
			clearOutput();
			story.display("scenes/sex/rape");
			doNext(dullOhYouFuckedUpPT2);
		}
		

		public function dullOhYouFuckedUpPT2():void {
			clearOutput();
			if (player.lib + player.tou >= 250 && player.HP > 7000){
				story.display("scenes/sex/rape-survived");
				outputText("");
				dynStats("str", -45, "tou", -45, "spe", -45);
				player.takeDamage(7000);
				wasRude = 2;
				doNext(camp.returnToCampUseFourHours);
			} else{
				story.display("scenes/sex/rape-gameover");
				outputText("");
				getGame().gameOver();
			}
		}
		
		public function dullahanCurse():void{
			clearOutput();
			story.display("scenes/talk/curse");
			menu();
			addButton(0, "Cure", dullCurseCure).hint("Tell her you're fine with her past. You just want to find a cure.");
			addButton(1, "Justice", dullCurseJustice).hint("She's definitely not completely innocent. She must pay for her crimes.<b>Be ready for a fight to the death.</b>");
		}
		
		public function dullCurseCure():void{
			clearOutput();
			story.display("scenes/talk/curse-cure");
			dullMenu();
		}
		
		public function dullCurseJustice():void{
			clearOutput();
			story.display("scenes/talk/curse-justice");
			wasRude = 2;
			startCombat(new Dullahan());
		}
		
		public function dullahanFinishesYouOff():void{
			clearOutput();
			story.display("scenes/talk/curse-victory");
			cleanupAfterCombat();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function defeatedDullahanFinishHerOff(hpVictory:Boolean = false):void{
			clearOutput();
			story.display("scenes/talk/curse-defeated");
			//power up beautiful sword, if you're holding it!
			/*if (player.weapon == weapons.B_SWORD){
				flags[kFLAGS.BEAUTIFUL_SWORD_LEVEL] += 1;
			}*/
			cleanupAfterCombat();
			doNext(camp.returnToCampUseOneHour);
		}
		
		public function dullahanFuture():void{
			clearOutput();
			story.display("scenes/talk/future");
			menu();
			addButton(0, "Back to Ingnam", dullahanFutureAnswer, 0, null, null, "You'll probably just head back to Ingnam and rest.");
			addButton(1, "Stay here", dullahanFutureAnswer, 1, null, null, "You've grown fond of Mareth. You'll likely stick around and continue adventuring.");
			if (flags[kFLAGS.FACTORY_SHUTDOWN] > 0) addButton(2, "Revenge", dullahanFutureAnswer, 2, null, null, "There's a few Elders in Ingnam that deserve some payback for their lies.");
			else addButtonDisabled(2, "???", "Perhaps continuing your quest would change your mind about your plans for the future.");
			addButton(3, "Rule Mareth", dullahanFutureAnswer, 3, null, null, "What a silly question. You'll rule over Mareth!");
		}
		
		public function dullahanFutureAnswer(answer:int = 0):void{
			clearOutput();
			story.display("scenes/talk/future-answer",{$answer:answer});
			dullMenu();
		}
		
		public function askAboutDullSpooks():void{
			clearOutput();
			story.display("scenes/talk/spooks");
			dullMenu();
		}
		
		public function askAboutDullStory():void{
			clearOutput();
			story.display("scenes/talk/story");
			menu();
			addButton(0, "Yes", dullStory1, true, null, null, "Yeah... you do.");
			addButton(1, "No", dullStory1, false, null, null, "Not really.");
		}
		
		public function dullStory1(miss:Boolean):void {
			story.display("scenes/talk/story2",{$miss:miss});
			dullMenu();
		}
		
		public function dullLeave():void{
			clearOutput();
			story.display("scenes/talk/leave");
			doNext(camp.returnToCampUseOneHour);
		}
		
		public function dullahanPt2():void {
			clearOutput();
			story.display("combat/phase2");
			startCombat(new Dullahan());
		}
	
		public function defeatedDullahan(hpVictory:Boolean = false):void{
			clearOutput();
			hasMet = true;
			if (wasRude == 1){
				story.display("scenes/defeated/postRude");
				wasRude = 2;
				doNext(camp.returnToCampUseOneHour);
				return;
			}
			if (hpVictory){
				story.display("scenes/defeated/hp");
				menu();
				addButton(0, "Stay", listentoDull).hint("Stay a while, and listen.", "");
				addButton(1, "Leave", dontlistentoDull).hint("Leave her to her ramblings.", "");
				if (!player.isNaga() && player.str >= 60) addButton(3, "Kick!",kicktheHead).hint("Kick her head away!", "");
			}else{
				story.display("scenes/defeated/lust");
				menu();
				if (player.hasCock() && !player.isTaur() && player.lust >= 33) addButton(0, "Blowjob?", dullahanBlowjob).hint("Maybe she'd be willing to help your erection in this state.", null);//Taurs wouldn't be able to use her head anyway.
				if (player.hasVagina() && !player.isTaur() && player.lust >= 33) addButton(1, "Cunnilingus?", dullahanCunnilingus).hint("Maybe she'd be willing to help you in this state.", null);
				addButton(2, "Wait it out", waitoutDull,null, null, null, "Just wait for her to finish.", null);
				addButton(3, "Leave", dontlistentoDull).hint("Leave her to her business.", "");
				if (!player.isNaga() && player.str >= 60) addButton(4, "Kick!",kicktheHead).hint("Kick her head away!", "");
			}
		}
		
		public function dullahanCunnilingus():void {
			clearOutput();
			story.display("scenes/sex/victory-cunnilingus");
			player.orgasm();
			cleanupAfterCombat();
			doNext(camp.returnToCampUseFourHours);
		}
		
		public function waitoutDull():void {
			clearOutput();
			story.display("scenes/defeated/wait",{$hp:false});
			cleanupAfterCombat();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function dullahanBlowjob():void{
			clearOutput();
			var x:Number = player.shortestCockIndex();
			story.display("scenes/defeated/victory-blowjob",{$x:x});
			player.orgasm();
			cleanupAfterCombat();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function dontlistentoDull():void{
			clearOutput();
			story.display("scenes/defeated/leave");
			cleanupAfterCombat();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function kicktheHead():void{
			clearOutput();
			story.display("scenes/defeated/kick");
			wasRude = 1; //That's so rude! She'll never talk to you again.
			cleanupAfterCombat();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function dullahanVictory():void{
			clearOutput();
			story.display("scenes/victory/part1");
			doNext(dullahanVictorypt2);
		}
			
		public function dullahanVictorypt2():void{
			clearOutput();
			story.display("scenes/victory/part2");
			doNext(dullahanVictorypt3);
		}
		
		public function dullahanVictorypt3():void{
			clearOutput();
			if (wasRude == 1){
				story.display("scenes/victory/part3a");
				getGame().gameOver();
				return;
			}
			story.display("scenes/victory/part3b");
			cleanupAfterCombat();
			doNext(camp.returnToCampUseFourHours);
		}
		
		public function defeatedDullahanFriendly(hpVictory:Boolean = false):void
		{
			cleanupAfterCombat();
			clearOutput();
			timesWonSpar++;
			if (hpVictory){
				story.display("scenes/defeated/spar-hp",{$scene:this});
				dynStats("spe", 2);
				dullMenu();
				return;
			}else{
				story.display("scenes/defeated/spar-lust");
				menu();
				if (player.lust > 33)
				{
					if(!player.isTaur()){
						story.display("scenes/defeated/spar-lust-offer");
						if (player.hasCock()) addButton(0, "Thighjob", dullThighjob).hint("Thigh-highs and toned legs. You can make that work.");
						if (player.hasVagina()) addButton(1, "Cunnilingus", dullahanCunnilingus2).hint("That's an unnecessary warning for you.");
						if (player.hasKeyItem("Demonic Strap-On")) addButton(2, "Strap-on", dullahanStrapOn).hint("She can't take, but maybe she can give?");
					}else{
						story.display("scenes/defeated/spar-lust-notaurs");
						if (player.cor + player.corruptionTolerance() > 60 && player.hasCock()) addButton(0, "Rape", dullOhYouFuckedUp).hint("You're not getting out of here without sex.");
						addButton(1, "Leave", dullSexRefused).hint("Well, time to head back to camp, then.", null);
						
					}
					
				}
				addButton(2, "...Nah", dullMenu).hint("You just can't be bothered right now.");
			}
		}
		
		
		public function dullahanStrapOn():void{
			clearOutput();
			story.display("scenes/sex/strapon",{$anal:!player.hasVagina()});
			player.orgasm();
			doNext(camp.returnToCampUseTwoHours);
			
		}
		public function dullSexRefused():void{
			clearOutput();
			story.display("scenes/sex/leave");
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function dullTentacleFun():void{
			clearOutput();
			story.display("scenes/sex/tentacles",{$count:player.countCocksOfType(CockTypesEnum.TENTACLE)});
			player.orgasm();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function dullBlowjobTease():void{
			clearOutput();
			story.display("scenes/sex/blowjob-tease1");
			doNext(dullBlowjobTease2);
		}
		
		public function dullBlowjobTease2():void{
			clearOutput();
			story.display("scenes/sex/blowjob-tease2");
			doNext(dullBlowjobTease3);
		}
			
		public function dullBlowjobTease3():void{
			clearOutput();
			story.display("scenes/sex/blowjob-tease3");
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function dullThighjob():void{
			clearOutput();
			story.display("scenes/sex/thighjob",{
				$longCock:player.longestCockLength() >= 10
			});
			cleanupAfterCombat();
			player.orgasm();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public function dullahanCunnilingus2():void {
			clearOutput();
			story.display("scenes/sex/cunnilingus");
			player.orgasm();
			cleanupAfterCombat();
			doNext(camp.returnToCampUseFourHours);
		}
		public function defeatedDullahanVictoryFriendly():void
		{
			clearOutput();
			story.display("scenes/victory/spar");
			cleanupAfterCombat();
			dullMenu();
		}
		
		public function listentoDull():void{
			clearOutput();
			story.display("scenes/defeated/wait",{$hp:true});
			cleanupAfterCombat();
			doNext(camp.returnToCampUseTwoHours);
		}
		
		public var story:BoundStory;
		public function DullahanScene() 
		{
			onGameInit(init);
		}
		private function init():void {
			story = getGame().createStory("forest","dullahan").bind(kGAMECLASS.context);
		}
		
	}

}
