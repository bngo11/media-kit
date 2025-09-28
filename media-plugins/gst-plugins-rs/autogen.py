#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	gitlabid = 1400
	gitlaburl = 'gitlab.freedesktop.org'
	json_data = await hub.pkgtools.fetch.get_page(f"https://{gitlaburl}/api/v4/projects/{gitlabid}/repository/tags", is_json=True)
	version = None

	for item in json_data:
		try:
			version = item['name']
			verlist = version.split(".")
			list(map(int, verlist))
			if len(verlist) > 1:
				if int(verlist[1]) >= 89 and int(verlist[0]) != 0:
					continue
			break

		except (IndexError, ValueError, KeyError):
			continue
	else:
		version = None

	if version:
		url = f'https://{gitlaburl}/gstreamer/gst-plugins-rs/-/archive/{version}/gst-plugins-rs-{version}.tar.gz'
		pkginfo['version'] = version
		final_name = f'{pkginfo["name"]}-{version}.{".".join(url.split(".")[-2:])}'
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)]
		)
		ebuild.push()
# vim: ts=4 sw=4 noet
