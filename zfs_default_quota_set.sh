#!/bin/bash

pushd $(dirname "$0") > /dev/null
source ./zfs_utils.conf

while IFS= read -r line; do
	IFS=" " read -r username block_quota obj_quota <<< "${line}"
	if [ "${block_quota}" != "${def_ublock_quota}" ] || [ "${obj_quota}" != "${def_uobj_quota}" ]; then
		## Quota not set right
		if ! printf '%s\0' "${users_exempt[@]}" | grep -Fxqz ${username}; then
			## User is not exempt from quota enforcement
			/usr/sbin/zfs set userquota@${username}=${def_ublock_quota} ${dataset_path}
			/usr/sbin/zfs set userobjquota@${username}=${def_uobj_quota} ${dataset_path}
			echo "Set default quotas for user ${username} at $(date +%Y-%m-%d_%H-%M-%S)" >> "${zfs_log}"
		fi
	fi
done < <(/usr/sbin/zfs userspace -H ${dataset_path} | awk '{print $3" "$5" "$7}')


while IFS= read -r line; do
        IFS=" " read -r groupname block_quota obj_quota <<< "${line}"
        if [ "${block_quota}" != "${def_gblock_quota}" ] || [ "${obj_quota}" != "${def_gobj_quota}" ]; then
                ## Quota not set right
                if ! printf '%s\0' "${groups_exempt[@]}" | grep -Fxqz ${groupname}; then
                        ## Group is not exempt from quota enforcement
                        /usr/sbin/zfs set groupquota@${groupname}=${def_gblock_quota} ${dataset_path}
                        /usr/sbin/zfs set groupobjquota@${groupname}=${def_gobj_quota} ${dataset_path}
			echo "Set default quotas for group ${groupname} at $(date +%Y-%m-%d_%H-%M-%S)" >> "${zfs_log}"
                fi
        fi
done < <(/usr/sbin/zfs groupspace -H ${dataset_path} | awk '{print $3" "$5" "$7}')
