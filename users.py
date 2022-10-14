from sys import stdin
import subprocess as sp
from datetime import datetime
import os

# This script requires two files in the same directory:
# admins (which contains all authorized administrators), and
# users (which has all authorized REGULAR users on the system, not including admins).
# The script automatically creates a file that has both.
# ***In both admins and users, ensure that the users are separated LINE-BY-LINE.
# create combined file of admins and users


def combine_files():
    combined = open("./combined", "w", encoding="utf-8")
    users = open("./users", "r", encoding="utf-8")
    for user in users:
        combined.write(user + "\n")
    users.close()
    admins = open("./admins", "r", encoding="utf-8")
    for admin in admins:
        combined.write(admin + "\n")
    admins.close()
    combined.close()

# create a list of current users


def userlist():
    passwd = open("/etc/passwd", "r", encoding="utf-8")
    ul = []
    for line in passwd:
        templist = line.split(":")
        if int(templist[2]) >= 1000 and "/bin/bash" in templist[6]:
            ul.append(templist[0])
    passwd.close()
    return ul



def remove_unauth(): # remove unauthorized users
    c = open('./combined', 'r')
    combined = [line.rstrip('\n') for line in c]
    
    for user in userlist():
        if user not in comb_list:
            sp.run(["sudo", "userdel", user])
            log.write("Removed user " + user + "\n")
    combined.close()
    log.close()

# add authorized users present in the combined list (all auth users) but not on the system.
# add_authed() is meant to be called after remove_unauth()


def add_authed():
    combined = open("/home/" + user_current + "/combined", "r")
    comb_list = [line.rstrip('\n') for line in combined]
    log = open("/home/" + user_current + "/Script.log", "a")
    for user in comb_list:
        if user == "" or user == "\n":
            continue
        if user not in userlist():
            user = user.strip()
            sp.run(["sudo", "useradd", user])
            log.write("Added user " + user + "\n")
    log.close()


# Changing all user passwords
def change_all_passwords():
    print("Changing passwords for all authorized users, including the current, to Cyb3RP@tr!0t.")
    log = open("/home/" + user_current + "/Script.log", "a")
    for user in userlist():
        sp.run(["sudo", "echo", "Cyb3RP@tr!0t", "|", "passwd", "--stdin", user])
        log.write("Changed password for " + user + "\n")
    log.close()

# Change all shells of authorized users to /bin/bash


def change_shell():
    combined = open("/home/" + user_current + "/combined", "r")
    comb_list = [line.rstrip('\n') for line in combined]

    for auth_user in comb_list:
        if auth_user == "" or auth_user == "\n":
            continue
        auth_user = auth_user.strip()
        sp.run(["sudo", "chsh", "--shell", "/bin/bash", auth_user.strip()])

# get people into the right groups


def groups():
    admins = open("/home/" + user_current + "/admins", "r")
    group = open("/etc/group", "r")
    for line in group:
        line_current = line.split(":")
        if line_current[0] == "sudo":
            sudolist = line_current[3].split(",")
    for sudo in sudolist:
        if sudo not in admins:
            if sudo == "" or admin == "\n":
                continue
            sudo = sudo.strip()
            sp.run(["sudo", "deluser", sudo])
    for admin in admins:
        if admin == "" or admin == "\n":
            continue
        admin = admin.strip()
        if admin not in sudolist:
            if admin in userlist():
                sp.run(["sudo", "usermod", "-a", "-G", "sudo", admin])
            else:
                sp.run(["sudo", "useradd", admin])
                sp.run(["sudo", "usermod", "-a", "-G", "sudo", admin])


# Calling functions
combine_files()
remove_unauth()
add_authed()
change_all_passwords()
change_shell()
groups()