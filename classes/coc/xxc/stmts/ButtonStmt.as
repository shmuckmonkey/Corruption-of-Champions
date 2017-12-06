/**
 * Coded by aimozg on 06.12.2017.
 */
package coc.xxc.stmts {
import classes.EngineCore;
import classes.Scenes.SceneLib;
import classes.internals.Utils;

import coc.script.Eval;
import coc.view.ButtonData;
import coc.view.MainView;
import coc.xlogic.ExecContext;
import coc.xlogic.Statement;
import coc.xxc.StoryContext;
import coc.xxc.StoryContext;

public class ButtonStmt extends Statement{
	
	public var label:String;
	public var enableIf:Eval;
	public var disableIf:Eval;
	public var call:Eval;
	public var goto_ref:String;
	public var body:/*Statement*/Array = [];
	public var pos:int = -1;
	
	public function ButtonStmt() {
	}
	private function onclick(context: StoryContext):void {
		if (call) {
			call.vcall(context.scopes);
		} else {
			EngineCore.clearOutput();
			EngineCore.menu();
			if (goto_ref) {
				context.display(goto_ref);
			} else {
				context.executeAll(body);
			}
			context.game.flushOutputTextToGUI();
		}
		for (var i:int = 0; i<MainView.BOTTOM_BUTTON_COUNT; i++) {
			if (EngineCore.button(i).enabled && EngineCore.button(i).visible) return;
		}
		EngineCore.outputText("/!\\ BUG No next button configured - defaulting to returnToCampUseOneHour");
		EngineCore.doNext(SceneLib.camp.returnToCampUseOneHour);
	}
	override public function execute(context:ExecContext):void {
		// We need to clone the context to capture the scopes - after exiting BoundStory.display() the original context will lose locals
		var ctx2:ExecContext = context.clone();
		var bd:ButtonData = (context as StoryContext).currentButtons.add(
				this.label,
				Utils.curry(onclick,ctx2)
		);
		if (this.enableIf) {
			bd.enabled = this.enableIf.vcall(context.scopes);
		}
		if (this.disableIf) {
			bd.enabled = !this.disableIf.vcall(context.scopes);
		}
		if (this.pos >= 0) bd.pos = this.pos;
		if (!bd.enabled) {
			// TODO @aimozg disableText ?
		}
	}
}
}
