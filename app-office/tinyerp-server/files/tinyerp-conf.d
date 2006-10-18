# The database name
# Default is 'terp'
SERVER_DB=terp

# The user for the database
# Default is the same as the database name (terp)
SERVER_USER=${SERVER_DB}


# ------------------------------------------------------
# If you run the database on localhost and
# have trust set in your pg_hba.conf (the default),
# you do not need to change anything below.
# ------------------------------------------------------

# The password for the database user
# Default is commented out (no password authentication)
#SERVER_PW=

# The database host to use
# Default is commented out (localhost)
#SERVER_HOST=

# The database port number to use
# Default is commented out (well-known port)
#SERVER_PORT=

# Additional parameters on the command line
#SERVER_OPTS=""
