package classes.Scenes.Areas.Forest 
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.internals.WeightedDrop;

	import coc.xxc.BoundStory;

	public class DullahanHorse extends Monster
	{
		private var story:BoundStory;
		
		protected function knightCharge():void {
			if (!hasStatusEffect(StatusEffects.Uber)) {
				story.display("moves/charge/start");
				createStatusEffect(StatusEffects.Uber, 0, 0, 0, 0);
			} else {
				//(Next Round)
				switch(statusEffectv1(StatusEffects.Uber)){
					case 0:
						addStatusValue(StatusEffects.Uber, 1, 1);
						story.display("moves/charge/approach");
						break;
					case 1:
						if (flags[kFLAGS.IN_COMBAT_USE_PLAYER_WAITED_FLAG] == 0) {
							story.display("moves/charge/attack");
							var result:Object = combatAvoidDamage(true,false,false);
							if (result.dodge == EVASION_EVADE) {
								story.display("moves/charge/evade");
								removeStatusEffect(StatusEffects.Uber);
								return;
							} else if (result.dodge == EVASION_FLEXIBILITY) {
								story.display("moves/charge/flexibility");
								removeStatusEffect(StatusEffects.Uber);
								return;
							} else if (result.dodge == EVASION_MISDIRECTION) {
								story.display("moves/charge/misdirection");
								removeStatusEffect(StatusEffects.Uber);
								return;
							} else if (hasStatusEffect(StatusEffects.Blind) && rand(100)<33) {
								story.display("moves/charge/blind");
								removeStatusEffect(StatusEffects.Uber);
								return;
							} else if (result.dodge == EVASION_SPEED || result.dodge != null) {
								story.display("moves/charge/miss");
								removeStatusEffect(StatusEffects.Uber);
								return;
							} else {
								story.display("moves/charge/hit");
								removeStatusEffect(StatusEffects.Uber);
								var damage:int = 0;
								damage = ((str)*3 + rand(80));
								damage = player.reduceDamage(damage);
							}
							player.takeDamage(damage, true);
							
						} else {
							story.display("moves/charge/waited");
							player.takeDamage(10 + rand(10), true);
							removeStatusEffect(StatusEffects.Uber);
						}
						break;
				}
			}
			combatRoundOver();
		}
	
		override protected function handleStun():Boolean
		{
			removeStatusEffect(StatusEffects.Uber);
			return super.handleStun();
		}
		
		override public function defeated(hpVictory:Boolean):void
		{
			game.forest.dullahanScene.dullahanPt2();
		}
		
		override public function won(hpVictory:Boolean,pcCameWorms:Boolean):void {
			game.forest.dullahanScene.dullahanVictory();
		}
		
		
		override protected function performCombatAction():void {
			knightCharge();
		}
		public function DullahanHorse()
		{
			this.story = game.forest.dullahanScene.story.locate("combat");
			this.a = "a ";
			this.short = "Dark Knight";
			this.imageName = "dullahan";
			this.long = this.story.render("battleDescript1");
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
			initStrTouSpeInte(85, 70, 100, 60);
			initLibSensCor(40, 50, 15);
			this.weaponName = "rapier";
			this.weaponVerb="lunge";
			this.weaponAttack = 14;
			this.armorName = "black and gold armor";
			this.armorDef = 17;
			this.bonusHP = 380;
			this.lust = 25 + rand(15);
			this.lustVuln = 0;
			this.temperment = TEMPERMENT_LUSTY_GRAPPLES;
			this.level = 18;
			this.gems = 30;
			this.drop = new WeightedDrop();
			checkMonster();
		}
		
	}
}
