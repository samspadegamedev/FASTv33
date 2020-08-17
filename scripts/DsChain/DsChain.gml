/// @func DsChain()
function DsChain() constructor {
	static ChainLink	= function( _value ) constructor {
		value	= _value;
		chain	= undefined;
		
	}
	static clear	= function() {
		chain	= undefined;
		links	= 0;
		
	}
	static empty	= function() {
		return links == 0;
		
	}
	static size		= function() {
		return links;
		
	}
	static toArray	= function() {
		var _array	= array_create( links );
		var _next	= chain;
		
		var _i = 0; repeat( links ) {
			_array[ _i++ ]	= _next.value;
			
			_next	= _next.chain;
			
		}
		return _array;
		
	}
	static toString	= function() {
		return string( toArray() );
		
	}
	chain	= undefined;
	links	= 0;
	
}
