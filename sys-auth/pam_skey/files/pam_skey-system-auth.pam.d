#%PAM-1.0

auth       required	pam_env.so
auth       [success=done ignore=ignore auth_err=die default=bad] pam_skey.so
auth       sufficient	pam_unix.so likeauth nullok try_first_pass
auth       required	pam_deny.so

account    required	pam_unix.so

password   required	pam_cracklib.so difok=2 minlen=8 dcredit=2 ocredit=2 retry=3
password   sufficient	pam_unix.so nullok md5 shadow use_authtok
password   required	pam_deny.so

session    required	pam_limits.so
session    required	pam_unix.so
