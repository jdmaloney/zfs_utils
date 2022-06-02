#!/bin/bash

## Config Block
def_ublock_quota=""
def_uobj_quota=""
def_gblock_quota=""
def_gobj_quota=""
dataset_path=""
users_exempt=()
groups_exempt=()

while IFS= read -r line; do
	IFS=" " read -r username block_quota obj_quota <<< "${line}"
	if [ "${block_quota}" != "${def_ublock_quota}" ] || [ "${obj_quota}" != "${def_uobj_quota}" ]; then
		## Quota not set right
		if ! printf '%s\0' "${users_exempt[@]}" | grep -Fxqz ${username}; then
			## User is not exempt from quota enforcement
			/usr/sbin/zfs set userquota@${username}=${def_block_quota} ${dataset_path}
			/usr/sbin/zfs set userobjquota@${username}=${def_obj_quota} ${dataset_path}
		fi
	fi
done < <(/usr/sbin/zfs userspace ${dataset_path} | tail -n +2 | awk '{print $3" "$5" "$7}')


while IFS= read -r line; do
        IFS=" " read -r groupname block_quota obj_quota <<< "${line}"
        if [ "${block_quota}" != "${def_gblock_quota}" ] || [ "${obj_quota}" != "${def_gobj_quota}" ]; then
                ## Quota not set right
                if ! printf '%s\0' "${groups_exempt[@]}" | grep -Fxqz ${groupname}; then
                        ## Group is not exempt from quota enforcement
                        /usr/sbin/zfs set groupquota@${groupname}=${def_block_quota} ${dataset_path}
                        /usr/sbin/zfs set groupobjquota@${groupname}=${def_obj_quota} ${dataset_path}
                fi
        fi
done < <(/usr/sbin/zfs groupspace ${dataset_path} | tail -n +2 | awk '{print $3" "$5" "$7}')
