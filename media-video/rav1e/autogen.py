#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page(f"https://api.github.com/repos/xiph/rav1e/releases?per_page=50", is_json=True)
	version = None
	url = None

	for item in json_data:
		try:
			if item["prerelease"]:
				continue

			version = item["tag_name"].strip("v")
			list(map(int, version.split(".")))
			url = item["tarball_url"]
			break

		except (KeyError, AttributeError, ValueError):
			continue

	if version and url:
		final_name = f"rav1e-{version}.tar.gz"
		src_artifact = hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)
		artifacts = await hub.pkgtools.rust.generate_crates_from_artifact(src_artifact)
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			crates=artifacts['crates'],
			artifacts=[
				src_artifact,
				*artifacts['crates_artifacts'],
			],
		)

		ebuild.push()
