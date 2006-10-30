#access to attribute=userPassword
#        by dn="cn=admin,@basedn@" write
#        by anonymous auth
#        by self write
#        by * none

#access to *
#        by dn="cn=admin,@basedn@" write
#	by self write
#        by * read

access to dn.base="" by * read
access to dn.base="cn=Subschema" by * read

# protect the userPassword attribute
access to attr=userPassword
  by self =w
  by anonymous auth

# global address book
access to dn.subtree="o=AddressBook,ou=OxObjects,@basedn@"
  by group.exact="cn=AddressAdmins,o=AddressBook,ou=OxObjects,@basedn@" write
  by users read

# personal address book
access to dn.regex="^ou=addr,(uid=([^,]+),ou=Users,ou=OxObjects,@basedn@)$" attrs=children
  by dn.exact,expand="$1" write
access to dn.regex="^uid=([^,]+),ou=addr,(uid=([^,]+),ou=Users,ou=OxObjects,@basedn@)$" attrs=entry
  by dn.exact,expand="$2" write

# default rule allowing users full access to their own entries
access to attrs=cn,description,gecos,givenName,initials,l,labeledURI,mobile,o,OXAppointmentDays,OXTaskDays,OXTimeZone,postalCode,preferredLanguage,sn,st,street,title,userCountry
    by self write
    by users read

index uid,mailEnabled,cn,sn,givenname,lnetMailAccess,alias,loginDestination eq,sub
