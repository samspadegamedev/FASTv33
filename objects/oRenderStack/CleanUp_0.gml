var _id;

var _i = 0; repeat( ds_list_size( objects ) ) {
	_id	= objects[| _i++ ];
	
	if ( instance_exists( _id ) ) {
		_id.visible	= true;
		
	}
	
}
ds_list_destroy( objects );
surface.free();
