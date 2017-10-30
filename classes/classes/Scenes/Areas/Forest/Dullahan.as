package classes.Scenes.Areas.Forest 
{
	import classes.*;
	import classes.internals.WeightedDrop;

import coc.xxc.BoundStory;

public class Dullahan extends Monster
	{
		private var scene:DullahanScene = game.forest.dullahanScene;
		public var determined:Number = 0;
		private var story:BoundStory;
		
		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void {
			if (scene.wasRude == 2) scene.dullahanFinishesYouOff();
			else if (hasStatusEffect(StatusEffects.Spar)) scene.defeatedDullahanVictoryFriendly();
			else scene.dullahanVictory();
		}
		
		override public function handleCombatLossText(inDungeon:Boolean, gemsLost:int):int
		{
			if (hasStatusEffect(StatusEffects.Spar)){
				if (player.HP <= 0) player.HP = 1;
				return 1;
			}
			return super.handleCombatLossText(false,10);
		}
		
		override public function defeated(hpVictory:Boolean):void
		{
			if (scene.wasRude == 2) game.forest.dullahanScene.defeatedDullahanFinishHerOff(hpVictory);
			else if (hasStatusEffect(StatusEffects.Spar)) game.forest.dullahanScene.defeatedDullahanFriendly(hpVictory);
			else game.forest.dullahanScene.defeatedDullahan(hpVictory);

		}
		
		
		
		public function Dullahan() 
		{
			this.story = game.forest.dullahanScene.story.locate("combat");
			this.a = "a ";
			this.short = "Dullahan";
			this.imageName = "dullahan";
			this.long = this.story.render("battleDescript2");
			// this.plural = false;
			this.createVagina(false, 1, 1);
			createBreastRow(Appearance.breastCupInverse("E"));
			this.ass.analLooseness = ANAL_LOOSENESS_TIGHT;
			this.ass.analWetness = ANAL_WETNESS_NORMAL;
			this.tallness = 60;
			this.hipRating = HIP_RATING_SLENDER;
			this.buttRating = BUTT_RATING_TIGHT;
			this.skinTone = "pale blue";
			this.skinType = SKIN_TYPE_PLAIN;
			//this.skinDesc = Appearance.Appearance.DEFAULT_SKIN_DESCS[SKIN_TYPE_FUR];
			this.hairColor = "white";
			this.hairLength = 20;
			initStrTouSpeInte(85, 70, 80, 60);
			initLibSensCor(40, 50, 15);
			this.weaponName = "saber";
			this.weaponVerb = "slash";
			this.fatigue = 0;
			this.weaponAttack = ((scene.wasRude == 2) ? 50 : 20);
			this.armorName = "black and gold armor";
			this.armorDef = 30;
			this.bonusHP = ((scene.wasRude == 2) ? 1500 : 380);
			this.lust = 5 + rand(15);
			this.lustVuln = ((scene.wasRude == 2) ? 0 : 0.46);
			
			this.temperment = TEMPERMENT_LUSTY_GRAPPLES;
			this.level = ((scene.wasRude == 2) ? 25 : 18);
			this.gems = 30;
			this.drop = new WeightedDrop();
			checkMonster();			
		}
		
	}

}
