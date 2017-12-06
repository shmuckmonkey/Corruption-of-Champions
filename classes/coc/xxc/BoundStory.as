/**
 * Coded by aimozg on 01.09.2017.
 */
package coc.xxc {
import coc.xlogic.ExecContext;

public class BoundStory {
	private var story:Story;
	private var context:StoryContext;
	public function BoundStory(story:Story, context:StoryContext) {
		this.story = story;
		this.context = context;
	}
	public function execute():void {
		context.execute(story);
	}
	public function display(ref:String,locals:Object=null):void {
		var obj:Story = story.locate(ref);
		if (!obj) {
			context.error(story,"Cannot dereference "+ref);
			return;
		}
		context.pushScope(locals||{});
		context.forceExecute(obj);
		context.popScope();
	}
	public function locate(ref:String):BoundStory {
		var obj:Story = story.locate(ref);
		if (!obj) {
			context.error(story,"Cannot dereference "+ref);
			return null;
		}
		return new BoundStory(obj,context);
	}
}
}
