# Active Directory User Creation Script
# ======================================
# This PowerShell script automates the creation of user accounts in Active Directory (AD).
# It reads user details from a CSV file and creates accounts with the specified attributes.
#
# Prerequisites:
# - The Active Directory PowerShell module must be installed.
# - The executing user must have permissions to create accounts in AD.
# - A properly formatted CSV file (example provided below).
#
# CSV File Format:
# FirstName,LastName,Username,Password,OU
# John,Doe,jdoe,Password123,OU=Users,DC=example,DC=com
# Jane,Smith,jsmith,Password123,OU=Admins,DC=example,DC=com
#
# Usage:
# 1. Modify the `$csvPath` variable to point to your CSV file.
# 2. Run this script in PowerShell as an administrator.
#
# License:
# MIT License (Feel free to use, modify, and share this script).
#
# Author: [Your Name or GitHub Username]
# Repository: [GitHub Repo Link]

# Import Active Directory module
Import-Module ActiveDirectory

# Path to the CSV file containing user details
$csvPath = "C:\UsersToCreate.csv"

# Import user data from the CSV file
# Ensure the CSV has headers: FirstName, LastName, Username, Password, OU
$users = Import-Csv -Path $csvPath

# Iterate through each user in the CSV
foreach ($user in $users) {
    try {
        # Define user properties
        $firstName = $user.FirstName
        $lastName = $user.LastName
        $username = $user.Username
        $password = (ConvertTo-SecureString $user.Password -AsPlainText -Force)
        $ou = $user.OU

        # Construct the user's full name
        $fullName = "$firstName $lastName"

        # Set the user principal name (UPN)
        $upn = "$username@yourdomain.com"  # Replace 'yourdomain.com' with your actual domain

        # Create the user in Active Directory
        New-ADUser -GivenName $firstName -Surname $lastName -Name $fullName -SamAccountName $username -UserPrincipalName $upn `
                    -AccountPassword $password -Path $ou -Enabled $true

        Write-Host "User $fullName created successfully."
    } catch {
        Write-Error "Failed to create user $($user.Username): $_"
    }
}
