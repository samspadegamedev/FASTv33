syslog( "FAST is shutting down..." );

fast.call_events( fast.GAME_END );

syslog( "Complete." );
