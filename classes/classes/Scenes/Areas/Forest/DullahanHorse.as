package classes.Scenes.Areas.Forest 
{
	import classes.*;
	import classes.internals.WeightedDrop;
	
	public class DullahanHorse extends Monster
	{
	
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
		
		
		public function DullahanHorse()
		{
			this.a = "a ";
			this.short = "Dark Knight";
			this.imageName = "dullahan";
			this.long = "Racing across the battlefield on a black horse is a cloaked knight. You can't make out any of its features, though it is obviously humanoid. It wields a massive scythe which, combined with its fast steed makes for a terrifyingly effective opponent. You can't see its face, but whenever you look at where it should be, a shiver runs down your spine.";
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
