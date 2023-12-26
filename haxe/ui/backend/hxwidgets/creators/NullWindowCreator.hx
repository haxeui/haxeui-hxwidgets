package haxe.ui.backend.hxwidgets.creators;

// we just want to create a null window
// technically we could just use haxe.ui.backend.hxwidgets.creators.Creator since
// its 'createWindow' returns null, but NullWindowCreator is semantically more obvious
class NullWindowCreator extends Creator {
    
}