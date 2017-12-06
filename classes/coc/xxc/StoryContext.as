/**
 * Coded by aimozg on 28.08.2017.
 */
package coc.xxc {
import classes.Appearance;
import classes.BaseContent;
import classes.BodyParts.Skin;
import classes.CockTypesEnum;
import classes.GlobalFlags.kFLAGS;
import classes.CoC;
import classes.Scenes.SceneLib;

import coc.view.ButtonDataList;

import coc.xlogic.ExecContext;
import coc.xlogic.Statement;

public class StoryContext extends ExecContext{
	public var currentButtons:ButtonDataList = new ButtonDataList();
	public var game:CoC;
	public function StoryContext(game:CoC) {
		super([
			game,
			CoC,
			{
				Appearance:Appearance,
				CockTypesEnum:CockTypesEnum,
				kFLAGS:kFLAGS,
				kGAMECLASS:CoC.instance,
				Math:Math,
				SceneLib:SceneLib,
				Skin:Skin
			}
		]);
		this.game = game;
	}
	private var _storyStack:/*Story*/Array = [];
	override public function execute(stmt:Statement):void {
		if (stmt is Story) _storyStack.unshift(stmt);
		stmt.execute(this);
		if (stmt is Story) _storyStack.shift();
	}
	public function forceExecute(stmt:Statement):void {
		if (stmt is Story) {
			_storyStack.unshift(stmt);
			(stmt as Story).forceExecute(this);
			_storyStack.shift();
		} else {
			stmt.execute(this);
		}
	}
	public function locate(ref:String):Story {
		var story:Story = _storyStack[0];
		return story ? story.locate(ref) : null;
	}
	public function display(ref:String):void {
		execute(locate(ref));
	}
	
	override public function clone():ExecContext {
		var sc:StoryContext = new StoryContext(game);
		// If we have 5 scopes [a,b,c,d,e] and sc has 3 scopes [c,d,e] we should start with (5-3)-1
		for (var i:int=this.scopes.length-sc.scopes.length-1; i>=0; i--){
			sc.pushScope(this.scopes[i]);
		}
		sc._storyStack = _storyStack.slice();
		return sc;
	}
}
}
