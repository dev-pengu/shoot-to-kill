package utilities;

import haxe.Constraints;

class DelegateEvent {
    private var funcs:Array<Function>;

    public function new() {
        funcs = new Array<Function>();
    }

    public function add(func:Function) {
        funcs.push(func);
    }

    public function invoke() {
        for (i in 0...funcs.length) {
            funcs[i]();
        }
    }

    public function remove(func:Function) {
        funcs.remove(func);
    }
}