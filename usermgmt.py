import subprocess as sp
log = open("/var/log/script.log", "a") #open log file

def gen_current_users():
    passwd = open("/etc/passwd", "r")
    current_users = []
    for line in passwd:
        lst = line.split(":")
        if lst[6] != "/bin/bash": continue
        current_users.append(lst[0])

    passwd.close()
    return current_users

def gen_users_needed():
    userlist = open("./userlist", "r")
    users_needed = []
    for line in userlist:
        users_needed.append(line.strip())
    userlist.close()
    return users_needed

def add_authed():
    for user in gen_users_needed:
        if user not in gen_current_users():
            sp.run(["sudo", "useradd", user])
            log.write(f"User {user} added".format(user))


def remove_unauth():
    for user in gen_current_users():
        if user not in gen_users_needed():
            sp.run(["sudo", "userdel", user])
            log.write(f"User {user} removed".format(user))

def change_pass():
    for user in gen_users_needed():
        sp.run(["sudo", "echo", "123qwe!@#QWE", "|", "passwd", "--stdin", user])
        log.write(f"Password changed for {user}".format(user))
def groups():
  admins = open("admins", "r")
  adminlist = []
  for admin in admins:
    if admin == "" or admin == "\n":
      continue
    adminlist.append(admin)
  group = open("/etc/group", "r")
  for line in group:
      line_current = line.split(":")
      if line_current[0] == "sudo":
          sudolist = line_current[3].split(",")
          break
  for sudo in sudolist:
    if i == "" or i == "\n":
      sudolist.remove(i)
    if sudo not in adminlist:
      sp.run(["deluser", sudo, "sudo"])
      
  for admin in adminlist:
      admin = admin.strip()
      if admin not in sudolist:
          sp.run(["sudo", "useradd", admin])
          sp.run(["sudo", "usermod", "-a", "-G", "sudo", admin])
      
        

add_authed()
remove_unauthed()
change_pass()
groups()