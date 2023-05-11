# ActiveDirectory-LDAP (PYTHON)
Active Directory (AD) &amp; Lightweight Directory Access Protocol (LDAP) 
import ldap

# Set the AD server details
ad_server = "your_ad_server"
ad_username = "your_username"
ad_password = "your_password"

# Establish a connection to AD
ldap_connection = ldap.initialize("ldap://" + ad_server)
ldap_connection.set_option(ldap.OPT_REFERRALS, 0)
ldap_connection.simple_bind_s(ad_username, ad_password)

# Example 1: Creating a new AD user
user_dn = "CN=new_user,CN=Users,DC=your_domain,DC=com"
user_attributes = [
    ("objectClass", [b"top", b"person", b"organizationalPerson", b"user"]),
    ("cn", [b"new_user"]),
    ("givenName", [b"John"]),
    ("sn", [b"Doe"]),
    ("displayName", [b"John Doe"]),
    ("sAMAccountName", [b"new_user"]),
    ("userPrincipalName", [b"new_user@your_domain.com"]),
    ("userPassword", [b"new_password"]),
    ("description", [b"Example user"]),
    ("userAccountControl", [str(512).encode()])  # 512 sets the user as Enabled
]
ldap_connection.add_s(user_dn, user_attributes)

# Example 2: Querying AD users using LDAP search
base_dn = "CN=Users,DC=your_domain,DC=com"
search_filter = "(objectClass=user)"
search_attributes = ["sAMAccountName", "cn"]
result = ldap_connection.search_s(base_dn, ldap.SCOPE_SUBTREE, search_filter, search_attributes)
for entry in result:
    username = entry[1]["sAMAccountName"][0].decode()
    common_name = entry[1]["cn"][0].decode()
    print("Username: {}, Common Name: {}".format(username, common_name))

# Example 3: Modifying an existing user's attributes
user_dn = "CN=existing_user,CN=Users,DC=your_domain,DC=com"
new_attributes = [
    (ldap.MOD_REPLACE, "givenName", [b"Jane"]),
    (ldap.MOD_REPLACE, "sn", [b"Smith"]),
    (ldap.MOD_REPLACE, "displayName", [b"Jane Smith"]),
    (ldap.MOD_REPLACE, "description", [b"Updated user"]),
]
ldap_connection.modify_s(user_dn, new_attributes)

# Example 4: Deleting an existing user
user_dn = "CN=existing_user,CN=Users,DC=your_domain,DC=com"
ldap_connection.delete_s(user_dn)

# Close the LDAP connection
ldap_connection.unbind_s()
