/// @func ScriptEngine
/// @param name
/// @param filepath
/// @param *debug?
function ScriptEngine( _name, _filepath, _debug ) constructor {
	// converts the given string into a statement that is then executed
	static execute_string	= function( _expression ) {
		return new ScriptStatement( _expression ).execute( self, {} );
		
	}
	// runs a script as part of the engine
	static run_script	= function( _name ) {
		var _script	= scripts[? _name ];
		var _result;
		
		var _i = 1; repeat( argument_count - 1 ) {
			stack.push( argument[ _i++ ] );
			
		}
		if ( _script == undefined ) {
			log( "ScriptEngine.execute", "Script \"", _name, "\" does not exist. Skipped!" );
			
			return false;
			
		}
		executionStack.push( { local : {}, last : undefined, depth : -1 } );
		
		_script.execute( self );
		
	}
	static run_function	= function( _name ) {
		var _script	= funcs[? _name ];
		
		if ( _script == undefined ) {
			log( "ScriptEngine.execute", "Function \"", _name, "\" does not exist. Skipped!" );
			
			return false;
			
		}
		var _args	= {};
		var _arg;
		
		var _i = 1; repeat( array_length( _script.args ) ) {
			_arg	= ( _i < argument_count ? argument[ _i ] : undefined );
			
			variable_struct_set( _args, _script.args[ _i++ - 1 ], _arg );
			
		}
		executionStack.push( { local : _args, last : undefined, depth : -1 } );
		
		_script.execute( self );
		
	}
	static load_async	= function( _filename, _reload, _period ) {
		var _load, _found;
		
		if ( filename_name( _filename ) != "" ) {
			_load	= new DsStack( _filename );
			
		} else {
			_load	= file_get_directory( _filename );
			
		}
		_found	= _load.size();
		
		if ( _found == 0 ) { return; }
		
		wait	= new Event( FAST.STEP, 0, { load : _load, reload : _reload, period : _period, funcs: 0, scripts : 0, total : _load.size() }, function( _package ) {
			var _time	= get_timer();
			
			do {
				var _script	= script_file_load( _package.load.dequeue() );
				
				switch ( _script.isFunction ) {
					case true	: _package.funcs += 1; funcs[? _script.name ]	= _script; break;
					default		: _package.scripts+=1; scripts[? _script.name ]= _script; break;
					
				}
				
			} until ( _package.load.empty() || get_timer() - _time > _package.period );
			
			if ( _package.load.empty() == true ) {
				log( "ScriptEngine.load", _package.total, " files(s) discovered, ", _package.scripts, " script(s) and ", _package.funcs, " functions loaded." );
				
				wait.discard();
				
				wait	= undefined;
				
			}
			
		});
		
	}
	static load		= function( _filename, _reload ) {
		var _scripts	= 0;
		var _funcs		= 0;
		var _load, _found;
		
		if ( filename_name( _filename ) != "" ) {
			_load	= new DsStack( _filename );
			
		} else {
			_load	= file_get_directory( _filename );
			
		}
		_found	= _load.size();
		
		while ( _load.empty() == false ) {
			var _script	= script_file_load( _load.dequeue() );
			
			switch ( _script.isFunction ) {
				case true	: _funcs += 1; funcs[? _script.name ]	= _script; break;
				default		: _scripts+=1; scripts[? _script.name ]= _script; break;
				
			}
			
		}
		log( "ScriptEngine.load", _found, " files(s) discovered, ", _scripts, " script(s) and ", _funcs, " functions loaded." );
		
	}
	static log	= function( _event ) {
		static logger	= ScriptManager().logger;
		static system	= ScriptManager().system;
		
		if ( debug ) {
			var _string	= name + " [" + _event + "] ";
			
			var _i = 1; repeat( argument_count - 1 ) {
				_string	+= string( argument[ _i++ ] );
				
			}
			logger.write( _string );
			system.write( _string );
			
		}
		
	}
	//static log_low	= function( _event ) {
	//	static logger	= ScriptManager().logger;
		
	//	if ( debug ) {
	//		var _string	= name + " [" + _event + "] ";
			
	//		var _i = 1; repeat( argument_count - 1 ) {
	//			_string	+= string( argument[ _i++ ] );
				
	//		}
	//		logger.write( _string );
			
	//	}
		
	//}
	static get_value	= function( _key ) {
		return ds_map_find_value( values, _key );
		
	}
	static set_value	= function( _key, _value ) {
		ds_map_replace( values, _key, _value );
		
	}
	//static proceed	= function() {
	//	if ( wait == true ) { wait = undefined; }
		
	//	execute( queue.dequeue() );
		
	//}
	//static enqueue	= function( _source ) {
	//	var _target	= ( is_string( _source ) ? scripts[? _source ] : _source );
		
	//	if ( _target == undefined || instanceof( _target ) != "Script" ) {
	//		log( "enqueue", "Script ", _source, " was not a valid script. Ignored!" );
			
	//		return;
			
	//	}
	//	queue.enqueue( _target );
		
	//}
	//static parse		= function( _string ) {
	//	if ( parser.has_next() == false ) {
	//		parser.parse( _string );
			
	//	} else {
	//		toParse.enqueue( _string );
			
	//	}
		
	//}
	//static has_next	= function() {
	//	return toParse.empty() == false;
		
	//}
	//static next		= function() {
	//	if ( has_next() ) {
	//		parser.parse( toParse.dequeue() );
			
	//	}
		
	//}
	//static push		= function() {
	//	var _i = 0; repeat( argument_count ) {
	//		stack.push( argument[ _i++ ] );
			
	//	}
		
	//}
	//static pop		= function() {
	//	return stack.pop();
		
	//}
	static is_running	= function() {
		return queue.size() > 0;
		
	}
	static is_waiting	= function() {
		return wait != undefined;
		
	}
	static is		= function( _data_type ) {
		return _data_type == ScriptEngine;
		
	}
	static toString	= function() {
		return "ScriptEngine(" + name + ") : Scripts in queue(" + string( queue.size() ) + ") : Wait(" + ( wait == undefined ? "false" : "true" ) + ")";
		
	}
	static manager	= ScriptManager();
	
	event	= new Event( FAST.STEP, 0, undefined, function() {
		executionStop	= false;
		
		while ( wait == undefined && queue.empty() == false ) {
			executionStack.push( { local : {}, last : undefined, depth : -1 } );
			
			queue.dequeue().execute( self );
			
			if ( executionStop ) { break; }
			
		}
		
	});
	//parser	= new Parser();
	//toParse	= new DsQueue();
	executionStack	= new DsStack();
	executionStop	= false;
	
	parseQueue		= new DsQueue();
	
	values	= ds_map_create();
	funcs	= ds_map_create();
	scripts	= ds_map_create();
	errors	= new DsStack();
	queue	= new DsQueue();
	stack	= new DsStack();
	wait	= undefined;
	debug	= _debug == true;
	name	= _name;
	loading	= 0;
	
	var _next = ds_map_find_first( ScriptManager().funcs ); repeat( ds_map_size( ScriptManager().funcs ) ) {
		ds_map_add( funcs, _next, method( self, ScriptManager().funcs[? _next ] ) );
		
		_next	= ds_map_find_next( ScriptManager().funcs, _next );
		
	}
	if ( _filepath != undefined ) {
		load( _filepath, false );
		
	}
	
}
